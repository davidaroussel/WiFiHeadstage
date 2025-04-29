# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 13/03/2023

import os
import time
import csv
import numpy as np
from threading import Thread
from socket import *


class DataConverter:
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
        self.buffer_size = p_buffer_size
        self.m_dataConversionTread = Thread(target=self.convertData)


    def startThread(self):
        self.m_dataConversionTread.start()

    def stopThread(self):
        self.m_dataConversionTread.join()

    def connect_TCP(self):
        numChannels = self.num_channels  # number of channels to send
        numSamples = self.buffer_size  # size of the data buffer
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

        openEphys_AddrPort = (self.ip_address, self.port)
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

        converted_array_mV = np.zeros((self.num_channels, self.buffer_size), dtype=np.int16)
        converted_array_Ephys = np.zeros((self.num_channels, self.buffer_size), dtype=np.int16)
        OpenEphysOffset = 32768

        formating_list = np.zeros((self.num_channels * self.buffer_size * 2), dtype=np.int16)
        tcp_sending_stack_size = self.buffer_size * self.num_channels * 2
        data_index = 0

        sin_counter = 0
        SIN_WAVE_DATA = np.sin(np.linspace(np.pi, -np.pi, int(self.buffer_size / 4)))
        for i in range(5):
            SIN_WAVE_DATA = np.concatenate(
                (SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA), axis=None)

        self.connect_TCP()
        print("---STARTING SEND_OPENEPHYS THREAD---")
        try:
            while 1:
                item = self.queue_raw_data.get()
                dataCounter = 0
                sync_counter += 1
                # print(sync_counter)
                if item is None:
                    print("None")
                    time.sleep(0.001)
                else:
                    if TEMP_STACK != []:
                        item = TEMP_STACK + item
                        TEMP_STACK = []

                    item_size = len(item)
                    # print(item_size)
                    if data_index + item_size <= tcp_sending_stack_size:
                        formating_list[data_index:data_index + item_size] = item
                        data_index += item_size
                    else:
                        extra_data_lenght = (data_index + item_size) - tcp_sending_stack_size
                        extra_data_index = tcp_sending_stack_size - data_index
                        if extra_data_lenght != self.buffer_size:
                            formating_list[data_index:] = item[:extra_data_index]
                            TEMP_STACK = item[extra_data_index:]
                        else:
                            TEMP_STACK = item
                        data_index += extra_data_index
                        if data_index != tcp_sending_stack_size:
                            print("Threated data NOT GOOD : ", data_index)
                        data_index = 0

                        for i in range(0, len(formating_list), 2):
                            converted_data = int.from_bytes([formating_list[i+1], formating_list[i]], byteorder='big', signed=True)
                            LSB_FLAG = int(hex(converted_data), 16) & 0x01

                            dataNumber = dataCounter // self.num_channels
                            channelNumber = dataCounter % self.num_channels

                            if LSB_FLAG == 1:
                                # print("LSB FLAG from CH", channelNumber)
                                if channelNumber == 0:
                                    pass
                                else:
                                    diff_ch = self.num_channels - channelNumber
                                    dataCounter += diff_ch

                                    dataNumber = dataCounter // self.num_channels
                                    channelNumber = dataCounter % self.num_channels
                                    # if sync_counter%10 == 0:
                                    #     # print(f"OutofSync {sync_counter}")
                                    #     # print("Oups")
                                    #     pass
                                    # print("OUT OF SYNC !!", "dataCounter", dataNumber)
                                    # print("NOW ON DATA NUMBER", dataNumber, "with CHANNEL", channelNumber)

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
                                if dataNumber < self.buffer_size:
                                    converted_array_Ephys[channelNumber][dataNumber] = mV_value
                                    converted_array_mV[channelNumber][dataNumber] = converted_data
                                else:
                                    pass
                                    # print("Appending list, it actually happened")
                                    # converted_array_Ephys[channelNumber].append(mV_value)
                                    # converted_array_mV[channelNumber].append(converted_data)

                            dataCounter += 1

                        np_conv = np.array(converted_array_Ephys, np.int16).flatten().tobytes()
                        rc = self.tcpClient.sendall(self.header + np_conv)
                        if rc != None:
                            print("Bobo TCP Send !!")
                        # print("Pushing ", len(np_conv), " bytes")
                        sin_counter = 0

        except ValueError:
            print("Erreur Happened in DataConverter")