# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 13/03/2023

import os
import time
import csv
import numpy as np
from threading import Thread
from socket import *


class DataConverterV2:
    def __init__(self, queue_raw_data, queue_csv_data, p_channels, p_frequency, p_buffer_size, p_port, p_host_addr=""):
        self.openEphys_Socket = None
        self.tcpClient = None
        self.port = p_port
        self.ip_address = p_host_addr
        self.tcp_connected = False

        self.queue_raw_data = queue_raw_data
        self.queue_csv_data = queue_csv_data
        self.num_channels = len(p_channels)
        self.frequency = p_frequency
        self.headstage_buffer_size = p_buffer_size
        self.openephys_buffer_size = 128

        self.m_dataConversionTread = Thread(target=self.convertData)


    def startThread(self):
        self.m_dataConversionTread.start()

    def stopThread(self):
        self.m_dataConversionTread.join()

    def connect_TCP(self):
        numChannels = self.num_channels  # number of channels to send
        numSamples = self.openephys_buffer_size  # size of the data buffer
        Freq = self.frequency  # sample rate of the signal
        offset = 0  # Offset of bytes in this packet; only used for buffers > ~64 kB
        dataType = 2  # Enumeration value based on OpenCV.Mat data types
        elementSize = 2  # Number of bytes per element. elementSize = 2 for U16

        bytesPerBuffer = numChannels * numSamples * elementSize
        self.header = np.array([offset, bytesPerBuffer], dtype='i4').tobytes() + \
                 np.array([dataType], dtype='i2').tobytes() + \
                 np.array([elementSize, numChannels, numSamples], dtype='i4').tobytes()

        buffersPerSecond = Freq / numSamples
        bufferInterval = 1 / buffersPerSecond

        openEphys_AddrPort = ("localhost", self.port)
        try:
            self.openEphys_Socket = socket(family=AF_INET, type=SOCK_STREAM)
            self.openEphys_Socket.bind(openEphys_AddrPort)
            self.openEphys_Socket.listen(3)
            print("Waiting for OpenEphys TCP connection...")
            (self.tcpClient, self.address) = self.openEphys_Socket.accept()
            print("OpenEphys Socket Plugin Connected !!!")
            self.tcp_connected = True

        except Exception as e:
            print("Error connecting to OpenEphys:", e)
            return

    def convertData(self):
        import numpy as np

        # ============================
        # CONSTANTS
        # ============================
        OpenEphysOffset = 32768
        maxOpenEphysValue = 0.005
        scale = (0.000000195 / maxOpenEphysValue) * OpenEphysOffset

        START_CAPS = b'\xAA\x55'
        FRAME_SIZE = 8196
        PAYLOAD_SIZE = 8192
        CAPS_SIZE = 2

        # ============================
        # DC SQUARE WAVE CONFIG
        # ============================
        dc_enabled = True
        dc_channel = 6

        dc_high_uV = 5000.0
        dc_low_uV = -5000.0

        fs = 25000
        dc_period_sec = 1.0

        samples_per_period = int(fs * dc_period_sec)
        half_period = samples_per_period // 2

        dc_high_raw = (dc_high_uV * 1e-6 / maxOpenEphysValue) * OpenEphysOffset
        dc_low_raw = (dc_low_uV * 1e-6 / maxOpenEphysValue) * OpenEphysOffset

        dc_high_val = np.int16(np.clip(OpenEphysOffset + dc_high_raw, 0, 65535))
        dc_low_val = np.int16(np.clip(OpenEphysOffset + dc_low_raw, 0, 65535))

        dc_sample_counter = 0  # phase accumulator
        counter = 0
        # ============================
        # BUFFERS
        # ============================
        converted_array_Ephys = np.empty(
            (self.num_channels, self.openephys_buffer_size),
            dtype=np.int16
        )

        data_buffer = bytearray()

        # ============================
        # TCP
        # ============================
        self.connect_TCP()
        print("--- STARTING SEND_OPENEPHYS THREAD ---")

        # ============================
        # MAIN LOOP
        # ============================
        while True:
            chunk = self.queue_raw_data.get()
            data_buffer.extend(chunk)

            while len(data_buffer) >= FRAME_SIZE:
                if data_buffer[:2] != START_CAPS:
                    del data_buffer[0]
                    continue

                payload = data_buffer[CAPS_SIZE:CAPS_SIZE + PAYLOAD_SIZE]
                del data_buffer[:FRAME_SIZE]

                raw = np.frombuffer(payload, dtype='>i2')
                raw_reshape = raw.reshape(-1, self.num_channels).T
                raw_clipped = np.clip(raw_reshape, 0, 65535)

                converted_array_Ephys[:] = (raw_clipped * scale) + OpenEphysOffset
                converted_array_Ephys = converted_array_Ephys.astype(np.uint16)

                # DC wave injection
                if dc_enabled:
                    n = self.openephys_buffer_size
                    idx = (dc_sample_counter + np.arange(n)) % samples_per_period
                    dc_wave = np.where(idx < half_period, dc_high_val, dc_low_val)
                    converted_array_Ephys[dc_channel, :] = dc_wave
                    dc_sample_counter = (dc_sample_counter + n) % samples_per_period

                np_conv = converted_array_Ephys.ravel().tobytes()

                # ===========================
                # TCP SEND WITH RECONNECT
                # ===========================
                while True:
                    try:
                        if not self.tcp_connected or self.tcpClient is None:
                            self.connect_TCP()
                        self.tcpClient.sendall(self.header + np_conv)
                        break  # success
                    except (ConnectionResetError, ConnectionAbortedError, BrokenPipeError):
                        print("\nClient reconnected. Resetting TCP connection...")
                        self.tcp_connected = False
                        if self.tcpClient:
                            try:
                                self.tcpClient.close()
                            except:
                                pass
                        self.tcpClient = None
                        time.sleep(0.5)  # wait a bit before reconnect
