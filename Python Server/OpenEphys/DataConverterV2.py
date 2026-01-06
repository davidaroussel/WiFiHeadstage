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
        OpenEphysFactor = round(32768*0.195)-1 #16 bits for 5mV to -5mV, so 10mV to 10000uV
        value_per_uV = 1 / (0.005 / OpenEphysFactor)
        maxOpenEphysValue = 0.005 #5mV is the max value for the Intan chip
        TEMP_STACK  = []
        sync_counter = 0

        converted_array_mV = np.zeros((self.num_channels, self.openephys_buffer_size), dtype=np.int16)
        converted_array_Ephys = np.zeros((self.num_channels, self.openephys_buffer_size), dtype=np.int16)
        OpenEphysOffset = 32768

        formating_list = np.zeros((self.num_channels * self.openephys_buffer_size * 2), dtype=np.int16)
        tcp_sending_stack_size = self.openephys_buffer_size * self.num_channels * 2
        data_index = 0
        sin_counter = 0
        SIN_WAVE_DATA = np.sin(np.linspace(np.pi, -np.pi, int(self.openephys_buffer_size / 4)))
        for i in range(5):
            SIN_WAVE_DATA = np.concatenate(
                (SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA), axis=None)

        START_CAPS = b'\xAA\x55'
        BYTES_PER_SAMPLE = self.num_channels * 2  # 16-bit per channel
        FRAME_SIZE = 8196
        PAYLOAD_SIZE = 8192
        CAPS_SIZE = 2
        data_buffer = b''
        chunk_ready = False
        payload = []
        self.connect_TCP()
        print("---STARTING SEND_OPENEPHYS THREAD HERE ---")

        counter = 0

        while 1:
            chunk = self.queue_raw_data.get()
            # print(chunk)
            data_buffer += chunk
            if len(data_buffer) >= FRAME_SIZE:
                start_idx = data_buffer.find(START_CAPS)
                payload_index_start = start_idx + CAPS_SIZE
                payload_index_end = payload_index_start + PAYLOAD_SIZE
                payload = data_buffer[payload_index_start:payload_index_end]
                # print(payload)
                if len(payload) != 8192:
                    print(f"FUCK lenght :{len(payload)}")
                data_buffer_cut = start_idx+CAPS_SIZE+PAYLOAD_SIZE+CAPS_SIZE
                if data_buffer_cut != 8196:
                    print(f"FUCK cutter :{data_buffer_cut}")
                data_buffer = data_buffer[data_buffer_cut:]
                chunk_ready = True

            if chunk_ready:

                # print("chunk ready")
                chunk_ready = False
                for i in range(0, len(payload), 2):
                    converted_data = int.from_bytes([payload[i+1], payload[i]], byteorder='big', signed=True)
                    # LSB_FLAG = int(hex(converted_data), 16) & 0x01

                    dataNumber = (i // 2) // self.num_channels
                    channelNumber = (i // 2) % self.num_channels

                    if channelNumber is None:
                        converted_value = OpenEphysOffset + ((SIN_WAVE_DATA[sin_counter] * 10 / 1000) * value_per_uV)
                        converted_value = np.clip(converted_value, 0, 65535)  # Ensure within int16 range
                        converted_array_Ephys[channelNumber][dataNumber] = converted_value
                    else:
                        # mV_value = OpenEphysOffset + (converted_data * converting_value)
                        # maxOpenEphysValue = 0.005V to have the 5mV, which is the max input voltage for the Intan chip
                        # OpenEphysOffset = 32768 to have the 0V in the middle of the 32bits encoding
                        # convertedData = the actual 16 bits data returned by the Intan chip
                        mV_value = OpenEphysOffset + (converted_data * ((0.000000195/maxOpenEphysValue) * OpenEphysOffset))

                        mV_value = np.clip(mV_value, 0, 65535)  # Ensure within int16 range
                        if dataNumber < self.openephys_buffer_size:
                            converted_array_Ephys[channelNumber][dataNumber] = mV_value
                            # converted_array_mV[channelNumber][dataNumber] = converted_data
                        else:
                            pass
                            # print("Appending list, it actually happened")
                            # converted_array_Ephys[channelNumber].append(mV_value)
                            # converted_array_mV[channelNumber].append(converted_data)

                np_conv = np.array(converted_array_Ephys, np.int16).flatten().tobytes()
                if counter % 100 == 0:
                    counter = 1
                    # print(f"Sending {np_conv}")
                counter += 1
                rc = self.tcpClient.sendall(self.header + np_conv)
                if rc != None:
                    print("Bobo TCP Send !!")
                # print("Pushing ", len(np_conv), " bytes")
                sin_counter = 0

