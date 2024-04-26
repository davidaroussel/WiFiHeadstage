# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 13/03/2023

import time
import csv
import numpy as np
from threading import Thread


class DataConverter():
    def __init__(self, queue_raw_data, queue_ephys_data, queue_csv_data, p_channels, p_buffer_size, p_buffer_factor):
        self.queue_raw_data = queue_raw_data
        self.queue_ephys_data = queue_ephys_data
        self.queue_csv_data = queue_csv_data
        self.num_channels = len(p_channels)
        self.buffer_size = p_buffer_size
        self.buffer_factor = p_buffer_factor
        self.m_dataConversionTread = Thread(target=self.convertData)


    def startThread(self):
        self.m_dataConversionTread.start()

    def stopThread(self):
        self.m_dataConversionTread.join()

    def convertData(self):
        print("---STARTING DATA_CONVERSION THREAD---")
        converted_array_mV = [[[] for j in range(self.buffer_size)] for i in range(self.num_channels)]
        converted_array_Ephys = [[[] for j in range(self.buffer_size)] for i in range(self.num_channels)]
        QUEUE_STACK = [[],[]]
        counter = 0
        sin_counter = 0
        OpenEphysOffset = 32768
        SIN_WAVE_DATA = np.sin(np.linspace(np.pi, -np.pi, int(self.buffer_size/4)))
        for i in range(5):
            SIN_WAVE_DATA = np.concatenate((SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA), axis=None)
        OpenEphysFactor = round(32768*0.195)-1 #16 bits for 5mV to -5mV, so 10mV to 10000uV
        value_per_uV = 1 / (0.005 / OpenEphysFactor)
        maxOpenEphysValue = 0.005 #5mV is the max value for the Intan chip
        BUFFER_SIZE = self.buffer_size * self.buffer_factor
        converting_value = (0.000000195/maxOpenEphysValue)*OpenEphysOffset
        TEMP_STACK  = []
        maxData = self.buffer_size*self.num_channels
        while 1:
            item = self.queue_raw_data.get()
            if item is None:
                time.sleep(0.001)
            else:
                if TEMP_STACK != []:
                    item = TEMP_STACK + item
                    TEMP_STACK = []

                item_size = len(item)
                rest_item_size = item_size % BUFFER_SIZE
                rest_index = self.buffer_size*(rest_item_size//self.buffer_size)
                if len(item) >= BUFFER_SIZE:
                    TEMP_STACK += item[BUFFER_SIZE:]
                item = item[0 : BUFFER_SIZE + rest_index]
                TEMP_STACK = TEMP_STACK[rest_index:]

                #CONVERT EACH VALUE AND SPLIT IT INTO EACH CHANNELS
                dataCounter = 0
                for i in range(0, len(item), 2):
                    converted_data = int.from_bytes([item[i+1], item[i]], byteorder='big', signed=True)
                    LSB_FLAG = int(hex(converted_data), 16) & 0x01

                    dataNumber = dataCounter // self.num_channels
                    channelNumber = dataCounter % self.num_channels

                    if LSB_FLAG == 1:
                        #print("LSB FLAG from CH", channelNumber)
                        if channelNumber == 0:
                            pass
                        else:
                            print("OUT OF SYNC !!", "dataCounter", dataNumber)
                            diff_ch = self.num_channels - channelNumber
                            dataCounter += diff_ch

                            dataNumber = dataCounter // self.num_channels
                            channelNumber = dataCounter % self.num_channels
                            print("NOW ON", dataNumber, "with", channelNumber)


                    if channelNumber == None:
                        # converted_array_Ephys[channelNumber][dataNumber] = OpenEphysOffset + ((SIN_WAVE_DATA[sin_counter]*10 / 1000) * value_per_uV) # now in mV
                        # sin_counter += 1
                        converted_array_Ephys[channelNumber].append(converted_array_Ephys[channelNumber-2][dataNumber])
                    else:
                        mV_value = OpenEphysOffset + (converted_data * converting_value)  # now in mV
                        if dataNumber < self.buffer_size:
                            converted_array_Ephys[channelNumber][dataNumber] = mV_value #now in mV
                            converted_array_mV[channelNumber][dataNumber] = converted_data  # raw data
                        else:
                            converted_array_Ephys[channelNumber].append(mV_value) #now in mV
                            converted_array_mV[channelNumber].append(converted_data)   # raw dat
                    dataCounter = dataCounter + 1

                    if dataCounter > 0:
                        if (dataCounter % (self.buffer_size*self.num_channels)) == 0:
                            np_conv = np.array(converted_array_Ephys, np.int16).flatten().tobytes()
                            self.queue_ephys_data.put(np_conv)
                            self.queue_csv_data.put(converted_array_mV)
                            sin_counter = 0
                            dataCounter = 0


            # CSV_HEADER = ["RAW DATA", "CONV DATA"]
            # QUEUE_STACK[0].append(self.queue_raw_data.qsize())
            # QUEUE_STACK[1].append(self.queue_ephys_data.qsize())

            # print("RAW  QUEUE : ", self.queue_raw_data.qsize())
            # print("CONV QUEUE : ", self.queue_ephys_data.qsize())
            # print("------------------")

    def convertDataV2(self):
            print("---STARTING DATA_CONVERSION THREAD---")
            converted_array_mV = [[None for i in range(int(self.buffer_size*500/self.num_channels))] for i in range(self.num_channels)]
            #converted_array_OpenEphys = np.zeros((self.num_channels, self.buffer_size))
            QUEUE_STACK = [[],[]]
            counter = 0
            OpenEphysOffset = 32768
            SIN_WAVE_DATA = np.sin(np.linspace(np.pi, -np.pi, int(self.buffer_size*500/4)))
            SIN_WAVE_DATA = np.concatenate((SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA), axis=None)
            SIN_WAVE_DATA = np.concatenate((SIN_WAVE_DATA, SIN_WAVE_DATA), axis=None)
            max_value = 0
            OpenEphysFactor = round(32768*0.195)-1 #16 bits for 5mV to -5mV, so 10mV to 10000uV
            value_per_uV = 1 / (0.005 / OpenEphysFactor)

            maxOpenEphysValue = 0.005 #5mV is the max value for the Intan chip
            BUFFER_SIZE = self.buffer_size * self.buffer_factor
            sin_counter = 0
            while 1:
                item = self.queue_raw_data.get()
                print(len(item))
                item = item[0:BUFFER_SIZE]
                if item is None:
                    time.sleep(0.001)
                else:
                    #CONVERT EACH VALUE AND SPLIT IT INTO EACH CHANNELS
                    dataCounter = 0
                    for i in range(0, len(item), 2):
                        converted_data = int.from_bytes([item[i+1], item[i]], byteorder='big', signed=True)
                        dataNumber = dataCounter // self.num_channels
                        channelNumber = dataCounter % self.num_channels
                        # if channelNumber == 7:
                        #     converted_array_mV[channelNumber][dataNumber] = OpenEphysOffset + ((SIN_WAVE_DATA[sin_counter]*10 / 1000) * value_per_uV) # now in mV
                        #     sin_counter += 1
                        # else:
                        #     converted_array_mV[channelNumber][dataNumber] = OpenEphysOffset + (((converted_data * 0.000000195)/maxOpenEphysValue)*OpenEphysOffset) #now in V
                        converted_array_mV[channelNumber][dataNumber] = OpenEphysOffset + (((converted_data * 0.000000195)/maxOpenEphysValue)*OpenEphysOffset) #now in V

                        dataCounter += 1

                        # if dataCounter >= self.buffer_size*self.num_channels:
                        #     np_conv = np.array(converted_array_mV, np.int16).flatten().tobytes()
                        #     self.queue_ephys_data.put(np_conv)
                    dataCounter = 0
                    sin_counter = 0
                    self.queue_ephys_data.put(converted_array_mV)
