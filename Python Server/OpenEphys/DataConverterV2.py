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
        self.diff_mode = 1
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
        offset = 32768
        dataType = 2
        elementSize = 2  # uint16
        bytesPerBuffer = numChannels * numSamples * elementSize
        self.header = (
                np.array([0, bytesPerBuffer], dtype='i4').tobytes() +
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

    def send_packet(self, client_attr, connected_attr, port, packet, stream_type):
        while True:
            try:
                client = getattr(self, client_attr)
                connected = getattr(self, connected_attr)

                if not connected or client is None:
                    self.connect_TCP(port, stream_type)

                    # 🔥 IMPORTANT: refresh AFTER connect
                    client = getattr(self, client_attr)
                    connected = getattr(self, connected_attr)

                    if not connected or client is None:
                        time.sleep(0.001)
                        continue

                client.sendall(self.header + packet)
                return

            except Exception as e:
                print(f"[{stream_type.upper()} SEND ERROR]", e)

                setattr(self, connected_attr, False)

                try:
                    if getattr(self, client_attr):
                        getattr(self, client_attr).close()
                except:
                    pass

                setattr(self, client_attr, None)
                time.sleep(0.001)

    def reconstruct_invalid_rows(self, raw_blocks, emg_mask, neuro_mask, invalid_indices):
        """
        Replace invalid rows with interpolated data based on the nearest
        valid rows of the same type (EMG or Neuro).
        """

        corrected_blocks = raw_blocks.copy()
        num_blocks = raw_blocks.shape[0]

        for idx in invalid_indices:

            # Determine row type from first channel LSB
            first_lsb = raw_blocks[idx, 0] & 0x0001
            is_emg = first_lsb == 1

            if is_emg:
                valid_mask = emg_mask
            else:
                valid_mask = neuro_mask

            prev_idx = None
            next_idx = None

            # Search previous valid
            for i in range(idx - 1, -1, -1):
                if valid_mask[i]:
                    prev_idx = i
                    break

            # Search next valid
            for i in range(idx + 1, num_blocks):
                if valid_mask[i]:
                    next_idx = i
                    break

            # Reconstruction logic
            if prev_idx is not None and next_idx is not None:
                corrected_blocks[idx] = (
                        (raw_blocks[prev_idx].astype(np.int32) +
                         raw_blocks[next_idx].astype(np.int32)) // 2
                ).astype(np.int16)

            elif prev_idx is not None:
                corrected_blocks[idx] = raw_blocks[prev_idx]

            elif next_idx is not None:
                corrected_blocks[idx] = raw_blocks[next_idx]

            else:
                # extremely rare fallback
                corrected_blocks[idx] = 0

        return corrected_blocks

    def convertData(self):

        OpenEphysOffset = 32768
        maxOpenEphysValue = 0.005
        scale = (0.000000195 / maxOpenEphysValue) * OpenEphysOffset

        START_CAPS = b'\xAA\x54'
        FRAME_SIZE = 8192
        PAYLOAD_SIZE = 8192

        # ===== TARGET SIZES =====
        if self.diff_mode:
            TARGET_NEURO_SAMPLES = 8192  # 256 samples × 16 channels
        else:
            TARGET_NEURO_SAMPLES = 4096
        TARGET_EMG_SAMPLES = 4096  # change as needed

        # ===== Connect both sockets =====
        if self.dual_chip_mode:
            self.connect_TCP(self.port_neuro, "neuro")
            self.connect_TCP(self.port_emg, "emg")
            print("--- STARTING DUAL STREAM THREAD ---")
        else:
            self.connect_TCP(self.port_neuro, "neuro")
            print("--- STARTING SINGLE STREAM THREAD ---")

        # =============================
        # PREALLOCATED BUFFERS (outside loop)
        # =============================
        neuro_buffer = np.empty(TARGET_NEURO_SAMPLES * 2, dtype='>i2')
        emg_buffer = np.empty(TARGET_EMG_SAMPLES * 2, dtype='>i2')

        neuro_write = 0
        emg_write = 0

        data_buffer = bytearray()
        view = memoryview(data_buffer)

        # =============================
        # MAIN LOOP
        # =============================
        data_buffer = bytearray()  # ✅ NO memoryview

        while True:
            chunk = self.queue_raw_data.get()
            data_buffer.extend(chunk)
            # print(f"Queue Size {self.queue_raw_data.qsize()}")
            while len(data_buffer) >= FRAME_SIZE:

                payload = bytes(data_buffer[:PAYLOAD_SIZE])
                del data_buffer[:FRAME_SIZE]

                raw = np.frombuffer(payload, dtype='>i2')
                # reshape once (needed for both modes)
                raw_blocks = raw.reshape(-1, 16)

                # =========================================
                # 🔥 REMOVE UNIFORM ROWS (FASTEST METHOD)
                # =========================================
                # Keep rows where at least one value differs from column 0
                valid_rows = np.any(raw_blocks != raw_blocks[:, [0]], axis=1)
                raw_blocks = raw_blocks[valid_rows]

                # If nothing left, skip immediately
                if raw_blocks.shape[0] == 0:
                    continue

                if self.dual_chip_mode:
                    # =============================
                    # 🔥 DUAL MODE (FAST LSB CHECK)
                    # =============================

                    # Only check first 2 channels
                    ch0 = raw_blocks[:, 0] & 1
                    ch1 = raw_blocks[:, 1] & 1

                    emg_rows = (ch0 == 1) & (ch1 == 1)
                    neuro_rows = (ch0 == 0) & (ch1 == 0)

                    # =========================================
                    # 🔥 REMOVE FLAT ROWS (ALL 16 VALUES SAME)
                    # =========================================
                    # Keep rows where at least one value differs
                    valid_rows = np.any(raw_blocks != raw_blocks[:, [0]], axis=1)
                    raw_blocks = raw_blocks[valid_rows]

                    # Skip if everything was garbage (very important for your case)
                    if raw_blocks.shape[0] == 0:
                        continue

                    # -------- EMG --------
                    if emg_rows.any():
                        emg_data = raw_blocks[emg_rows].ravel()
                        n = emg_data.size

                        if emg_write + n > emg_buffer.size:
                            emg_write = 0  # wrap/reset

                        emg_buffer[emg_write:emg_write + n] = emg_data
                        emg_write += n

                    # -------- NEURO --------
                    if neuro_rows.any():
                        neuro_data = raw_blocks[neuro_rows].ravel()
                        n = neuro_data.size

                        if neuro_write + n > neuro_buffer.size:
                            neuro_write = 0

                        neuro_buffer[neuro_write:neuro_write + n] = neuro_data
                        neuro_write += n

                else:
                    raw_16ch = raw_blocks[:, :]

                    first_ch_lsb = raw_16ch[:, 0] & 1
                    other_ch_lsb = raw_16ch[:, 1:] & 1
                    valid_rows = (first_ch_lsb == 1) & (other_ch_lsb.sum(axis=1) == 0)
                    if not valid_rows.any():
                        continue  # no row matches, skip

                    filtered_blocks = raw_16ch[valid_rows]

                    # Flatten and store in buffer

                    neuro_data = filtered_blocks.ravel()

                    n = neuro_data.size

                    if neuro_write + n > neuro_buffer.size:
                        neuro_write = 0  # wrap/reset

                    neuro_buffer[neuro_write:neuro_write + n] = neuro_data

                    neuro_write += n
                # =============================
                # EMG PROCESS + SEND
                # =============================
                if emg_write >= TARGET_EMG_SAMPLES:
                    chunk = emg_buffer[:TARGET_EMG_SAMPLES]

                    reshaped = chunk.reshape(-1, self.num_channels).T
                    converted = ((np.clip(reshaped, -32768, 32768) * scale)
                                 + OpenEphysOffset).astype(np.uint16)

                    self.send_packet(
                        "tcpClient_emg",
                        "tcp_connected_emg",
                        self.port_emg,
                        converted.ravel().tobytes(),
                        "emg"
                    )

                    # shift buffer (FAST)
                    emg_buffer[:emg_write - TARGET_EMG_SAMPLES] = emg_buffer[TARGET_EMG_SAMPLES:emg_write]
                    emg_write -= TARGET_EMG_SAMPLES

                # =============================
                # NEURO PROCESS + SEND
                # =============================
                if neuro_write >= TARGET_NEURO_SAMPLES:
                    chunk = neuro_buffer[:TARGET_NEURO_SAMPLES]

                    if self.diff_mode:
                        reshaped = chunk.reshape(-1, 2*self.num_channels).T  # (16 differential, samples)
                        reshaped = reshaped[0::2] - reshaped[1::2]
                    else:
                        reshaped = chunk.reshape(-1, self.num_channels).T  # (32, samples)


                    converted = (np.clip(reshaped, -32768, 32768) * scale + OpenEphysOffset).astype(np.uint16)

                    self.send_packet(
                        "tcpClient_neuro",
                        "tcp_connected_neuro",
                        self.port_neuro,
                        converted.ravel().tobytes(),
                        "neuro"
                    )

                    # ----------------------------
                    # shift buffer
                    # ----------------------------
                    neuro_buffer[:neuro_write - TARGET_NEURO_SAMPLES] = neuro_buffer[TARGET_NEURO_SAMPLES:neuro_write]
                    neuro_write -= TARGET_NEURO_SAMPLES
