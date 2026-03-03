# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 13/03/2023

import os
import time
import csv
import numpy as np
from threading import Thread
from socket import *
from datetime import datetime
from queue import Queue


class DataConverterV2:
    def __init__(self, queue_raw_data, queue_csv_data, p_channels, p_frequency, p_buffer_size, p_dual_chip_mode, p_port, p_host_addr=""):
        self.openEphys_Socket = None
        self.tcpClient = None
        self.port = p_port
        self.ip_address = p_host_addr
        self.tcp_connected = False

        self.tcpClient_neuro = None
        self.tcpClient_emg = None
        self.tcp_connected_neuro = False
        self.tcp_connected_emg = False

        self.port_neuro = self.port
        self.port_emg = self.port + 1  # second socket

        self.queue_raw_data = queue_raw_data
        self.queue_csv_data = queue_csv_data
        self.num_channels = len(p_channels)
        self.frequency = p_frequency
        self.headstage_buffer_size = p_buffer_size
        self.openephys_buffer_size = int(p_buffer_size / (self.num_channels * 2))

        self.m_dataConversionTread = Thread(target=self.convertData)
        self.thread_neuro_sender = Thread(target=self.neuroSender)
        self.thread_emg_sender = Thread(target=self.emgSender)
        self.queue_neuro_out = Queue()
        self.queue_emg_out = Queue()

        self.dual_chip_mode = p_dual_chip_mode
    def startThread(self):
        self.m_dataConversionTread.start()
    def startEMGThread(self):
        self.thread_emg_sender.start()
    def startNeuroThread(self):
        self.thread_neuro_sender.start()

    def stopThread(self):
        self.m_dataConversionTread.join()

    def connect_TCP(self, port, stream_type="neuro"):
        numChannels = self.num_channels
        numSamples = self.openephys_buffer_size
        offset = 0
        dataType = 2
        elementSize = 2  # uint16
        bytesPerBuffer = numChannels * numSamples * elementSize
        self.header = (
                np.array([offset, bytesPerBuffer], dtype='i4').tobytes() +
                np.array([dataType], dtype='i2').tobytes() +
                np.array([elementSize, numChannels, numSamples], dtype='i4').tobytes()
        )
        openEphys_AddrPort = ("localhost", port)

        try:
            server_socket = socket(family=AF_INET, type=SOCK_STREAM)
            server_socket.bind(openEphys_AddrPort)
            server_socket.listen(1)

            print(f"[OPENEPHYS-{stream_type.upper()}] Waiting for connection on port {port}...")
            client, addr = server_socket.accept()
            print(f"[OPENEPHYS-{stream_type.upper()}] Connected!")

            if stream_type == "neuro":
                self.tcpClient_neuro = client
                self.tcp_connected_neuro = True
            else:
                self.tcpClient_emg = client
                self.tcp_connected_emg = True

        except Exception as e:
            print(f"[OPENEPHYS-{stream_type.upper()}] Connection error:", e)

    def convertData(self):

        OpenEphysOffset = 32768
        maxOpenEphysValue = 0.005
        scale = (0.000000195 / maxOpenEphysValue) * OpenEphysOffset

        START_CAPS = b'\xAA\x54'
        FRAME_SIZE = 8192
        PAYLOAD_SIZE = 8192

        # ===== TARGET SIZES =====
        TARGET_NEURO_SAMPLES = 4096  # 256 samples × 16 channels
        TARGET_EMG_SAMPLES = 4096  # change as needed

        # ===== Accumulators =====
        neuro_accumulator = np.empty(0, dtype='>i2')
        emg_accumulator = np.empty(0, dtype='>i2')

        data_buffer = bytearray()

        # ===== Connect both sockets =====
        self.connect_TCP(self.port_neuro, "neuro")
        self.connect_TCP(self.port_emg, "emg")

        print("--- STARTING DUAL STREAM THREAD ---")

        while True:
            chunk = self.queue_raw_data.get()
            data_buffer.extend(chunk)

            while len(data_buffer) >= FRAME_SIZE:

                # if data_buffer[:2] != START_CAPS:
                #     del data_buffer[0]
                #     continue

                payload = data_buffer[:PAYLOAD_SIZE]
                del data_buffer[:FRAME_SIZE]

                raw = np.frombuffer(payload, dtype='>i2')
                block_size = 32

                # Only full blocks
                num_blocks = raw.size // block_size
                raw_blocks = raw[:num_blocks * block_size].reshape(num_blocks, block_size)

                # -----------------------------
                # Determine valid rows
                # -----------------------------
                emg_mask = np.all((raw_blocks & 0x0001) == 1, axis=1)  # EMG valid rows
                neuro_mask = np.all((raw_blocks & 0x0001) == 0, axis=1)  # Neuro valid rows

                # Rows that are valid for either
                valid_rows_mask = emg_mask | neuro_mask
                deleted_rows = num_blocks - valid_rows_mask.sum()

                # -----------------------------
                # Append only valid rows to accumulators
                # -----------------------------
                if emg_mask.any():
                    emg_accumulator = np.concatenate((emg_accumulator, raw_blocks[emg_mask].ravel()))
                if neuro_mask.any():
                    neuro_accumulator = np.concatenate((neuro_accumulator, raw_blocks[neuro_mask].ravel()))

                # -----------------------------
                # Print alert
                # -----------------------------
                if deleted_rows > 0:
                    print(f"[ALERT] {deleted_rows} invalid 32-value rows skipped in this 8192-sample buffer")
                # =============================
                # PROCESS ONLY WHEN READY
                # =============================
                # EMG
                while emg_accumulator.size >= TARGET_EMG_SAMPLES:
                    emg_chunk = emg_accumulator[:TARGET_EMG_SAMPLES]
                    emg_accumulator = emg_accumulator[TARGET_EMG_SAMPLES:]

                    # Reshape, clip, convert
                    emg_reshaped = emg_chunk.reshape(-1, self.num_channels).T
                    emg_clipped = np.clip(emg_reshaped, -32768, 32768)
                    emg_converted = (emg_clipped * scale + OpenEphysOffset).astype(np.uint16)

                    self.queue_emg_out.put(emg_converted.ravel().tobytes())

                # Neuro
                while neuro_accumulator.size >= TARGET_NEURO_SAMPLES:
                    neuro_chunk = neuro_accumulator[:TARGET_NEURO_SAMPLES]
                    neuro_accumulator = neuro_accumulator[TARGET_NEURO_SAMPLES:]

                    # Reshape, clip, convert
                    neuro_reshaped = neuro_chunk.reshape(-1, self.num_channels).T
                    neuro_clipped = np.clip(neuro_reshaped, -32768, 32768)
                    neuro_converted = (neuro_clipped * scale + OpenEphysOffset).astype(np.uint16)

                    self.queue_neuro_out.put(neuro_converted.ravel().tobytes())

    def neuroSender(self):
        while True:
            packet = self.queue_neuro_out.get()
            while True:
                try:
                    if not self.tcp_connected_neuro or self.tcpClient_neuro is None:
                        self.connect_TCP(self.port_neuro, "neuro")
                    self.tcpClient_neuro.sendall(self.header + packet)
                    break
                except:
                    self.tcp_connected_neuro = False
                    if self.tcpClient_neuro:
                        try:
                            self.tcpClient_neuro.close()
                        except:
                            pass
                    self.tcpClient_neuro = None
                    time.sleep(0.5)

    def emgSender(self):
        while True:
            packet = self.queue_emg_out.get()
            while True:
                try:
                    if not self.tcp_connected_emg or self.tcpClient_emg is None:
                        self.connect_TCP(self.port_emg, "emg")
                    self.tcpClient_emg.sendall(self.header + packet)
                    break
                except:
                    self.tcp_connected_emg = False
                    if self.tcpClient_emg:
                        try:
                            self.tcpClient_emg.close()
                        except:
                            pass
                    self.tcpClient_emg = None
                    time.sleep(0.5)