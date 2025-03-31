# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 13/03/2023

import os
import time
import csv
import numpy as np
from threading import Thread


class DataConverter:
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
        # converted_array_mV = [[[] for j in range(self.buffer_size)] for i in range(self.num_channels)]
        # converted_array_Ephys = [[[] for j in range(self.buffer_size)] for i in range(self.num_channels)]
        converted_array_mV = np.zeros((self.num_channels, self.buffer_size), dtype=np.int16)
        converted_array_Ephys = np.zeros((self.num_channels, self.buffer_size), dtype=np.int16)
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
        sync_counter = 0

        formating_list = np.zeros((self.num_channels * self.buffer_size * 2), dtype=np.int16)
        formating_list_counter = 0
        try:
            while 1:
                item = self.queue_raw_data.get()
                dataCounter = 0
                if item is None:
                    time.sleep(0.001)
                else:
                    if TEMP_STACK != []:
                        item = TEMP_STACK + item
                        TEMP_STACK = []

                    item_size = len(item)
                    rest_item_size = item_size % BUFFER_SIZE
                    packets_count = item_size // BUFFER_SIZE
                    if packets_count > 1:
                        extra_data = formating_list_counter + item_size - self.num_channels * self.buffer_size * 2
                        if extra_data > 0:
                            formating_list[formating_list_counter: formating_list_counter + item_size] = item[:extra_data]
                            formating_list_counter += item_size
                            TEMP_STACK = item[extra_data:]
                        else:
                            formating_list[formating_list_counter: formating_list_counter + item_size] = item
                            formating_list_counter += item_size
                    else:
                        rest_index = self.buffer_size*(rest_item_size//self.buffer_size)
                        if len(item) >= BUFFER_SIZE:
                            TEMP_STACK += item[BUFFER_SIZE:]
                        item = item[0: BUFFER_SIZE]
                        TEMP_STACK = TEMP_STACK[rest_index:]
                        formating_list[formating_list_counter: formating_list_counter+self.buffer_size] = item
                        formating_list_counter += self.buffer_size

                    print(len(TEMP_STACK))
                    if formating_list_counter == self.buffer_size * self.num_channels * 2:
                        for i in range(0, len(formating_list), 2):
                            converted_data = int.from_bytes([formating_list[i+1], formating_list[i]], byteorder='big', signed=True)
                            LSB_FLAG = int(hex(converted_data), 16) & 0x01

                            dataNumber = dataCounter // self.num_channels
                            channelNumber = dataCounter % self.num_channels

                            if LSB_FLAG == 1:
                                #print("LSB FLAG from CH", channelNumber)
                                activeSampling = True
                                if channelNumber == 0:
                                    pass
                                else:
                                    diff_ch = self.num_channels - channelNumber
                                    dataCounter += diff_ch

                                    dataNumber = dataCounter // self.num_channels
                                    channelNumber = dataCounter % self.num_channels
                                    sync_counter += 1
                                    if sync_counter%10 == 0:
                                        # print(f"OutofSync {sync_counter}")
                                        # print("Oups")
                                        pass
                                    # print("OUT OF SYNC !!", "dataCounter", dataNumber)
                                    # print("NOW ON", dataNumber, "with", channelNumber)

                            if channelNumber is None:
                                converted_value = OpenEphysOffset + ((SIN_WAVE_DATA[sin_counter] * 10 / 1000) * value_per_uV)
                                converted_value = np.clip(converted_value, 0, 65535)  # Ensure within int16 range
                                converted_array_Ephys[channelNumber][dataNumber] = converted_value
                            else:
                                mV_value = OpenEphysOffset + (converted_data * converting_value)

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
                            # if dataCounter % 4096 == 0:
                                # print((dataCounter % ((self.buffer_size * self.num_channels))))
                            if dataCounter > 0 and (dataCounter % (self.buffer_size * self.num_channels)) == 0:
                                np_conv = np.array(converted_array_Ephys, np.int16).flatten().tobytes()
                                # print("Pushing ", len(np_conv), " bytes")
                                self.queue_ephys_data.put(np_conv)
                                # self.queue_csv_data.put(converted_array_mV)
                                sin_counter = 0
                                dataCounter = 0
                                formating_list_counter = 0


                # CSV_HEADER = ["RAW DATA", "CONV DATA"]
                # QUEUE_STACK[0].append(self.queue_raw_data.qsize())
                # QUEUE_STACK[1].append(self.queue_ephys_data.qsize())

                # print("RAW  QUEUE : ", self.queue_raw_data.qsize())
                # print("CONV QUEUE : ", self.queue_ephys_data.qsize())
                # print("------------------")
        except ValueError:
            print("Here")