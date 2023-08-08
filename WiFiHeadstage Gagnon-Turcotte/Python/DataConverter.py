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
        converted_array = [[None for i in range(self.buffer_size)] for i in range(self.num_channels)]
        QUEUE_STACK = [[],[]]
        counter = 0

        SIN_WAVE_DATA = np.sin(np.linspace(np.pi, -np.pi, self.buffer_size))
        while 1:
            item = self.queue_raw_data.get()
            if item is None:
                time.sleep(0.001)
            else:
                #CONVERT EACH VALUE AND SPLIT IT INTO EACH CHANNELS
                channelID = 0
                for i in range(0, len(item), 2):
                    converted_data = int.from_bytes([item[i+1], item[i]], byteorder='big', signed=True)
                    converted_array[channelID%self.num_channels][channelID//self.num_channels] = (converted_data * 0.195) #REMOVED THE mV multiplier
                    channelID = channelID + 1

                for i in range(0, len(converted_array[0])):
                    converted_array[1][i] = SIN_WAVE_DATA[i]*100
                    print(SIN_WAVE_DATA[i])

                np_conv = np.array(converted_array, np.uint16).flatten().tobytes()
                self.queue_conv_data.put(np_conv)

            CSV_HEADER = ["RAW DATA", "CONV DATA"]
            QUEUE_STACK[0].append(self.queue_raw_data.qsize())
            QUEUE_STACK[1].append(self.queue_conv_data.qsize())

            # print("RAW  QUEUE : ", self.queue_raw_data.qsize())
            # print("CONV QUEUE : ", self.queue_conv_data.qsize())
            # print("------------------")

