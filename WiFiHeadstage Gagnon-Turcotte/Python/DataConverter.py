# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 13/03/2023

import time
import csv
import numpy as np
from threading import Thread

class DataConverter():
    def __init__(self, queue_raw_data, queue_conv_data, p_channels, p_buffer_size):
        self.queue_raw_data = queue_raw_data
        self.queue_conv_data = queue_conv_data
        self.num_channels = len(p_channels)
        self.buffer_size = p_buffer_size
        self.m_dataConversionTread = Thread(target=self.convertData)

    def startThread(self):
        self.m_dataConversionTread.start()

    def stopThread(self):
        self.m_dataConversionTread.join()

    def convertData(self):
        print("---STARTING DATA_CONVERSION THREAD---")
        converted_array_mV = [[None for i in range(self.buffer_size)] for i in range(self.num_channels)]
        converted_array_OpenEphys = np.zeros((self.num_channels, self.buffer_size))
        QUEUE_STACK = [[],[]]
        counter = 0
        OpenEphysOffset = 32768
        SIN_WAVE_DATA = np.sin(np.linspace(np.pi, -np.pi, self.buffer_size))
        max_value = 0
        OpenEphysFactor = round(32768*0.195)-1 #16 bits for 5mV to -5mV, so 10mV to 10000uV
        value_per_uV = 1 / (0.005 / OpenEphysFactor)

        maxOpenEphysValue = 0.005 #5mV is the max value for the Intan chip
        while 1:
            item = self.queue_raw_data.get()
            if item is None:
                time.sleep(0.001)
            else:
                #CONVERT EACH VALUE AND SPLIT IT INTO EACH CHANNELS
                channelID = 0
                for i in range(0, len(item), 2):
                    converted_data = int.from_bytes([item[i+1], item[i]], byteorder='big', signed=True)
                    converted_array_mV[channelID%self.num_channels][channelID//self.num_channels] = OpenEphysOffset + (((converted_data * 0.000000195)/maxOpenEphysValue)*OpenEphysOffset) #now in mV
                    converted_array_OpenEphys[channelID%self.num_channels][channelID//self.num_channels] = OpenEphysOffset + (((converted_data * 0.000000195)/maxOpenEphysValue)*OpenEphysOffset)

                    if channelID == 2:
                        if abs(converted_data) > abs(max_value):
                            max_value = converted_data
                    channelID = channelID + 1


                max_value *= 0.000000195
                for i in range(0, len(converted_array_mV[0])):
                    converted_array_mV[1][i] = OpenEphysOffset + ((SIN_WAVE_DATA[i]*10 / 1000) * value_per_uV)


                np_conv = converted_array_OpenEphys.flatten().tobytes()
                np_conv = np.array(converted_array_mV, np.int16).flatten().tobytes()
                self.queue_conv_data.put(np_conv)

            CSV_HEADER = ["RAW DATA", "CONV DATA"]
            QUEUE_STACK[0].append(self.queue_raw_data.qsize())
            QUEUE_STACK[1].append(self.queue_conv_data.qsize())

            # print("RAW  QUEUE : ", self.queue_raw_data.qsize())
            # print("CONV QUEUE : ", self.queue_conv_data.qsize())
            # print("------------------")

