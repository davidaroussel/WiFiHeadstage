# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 13/03/2023

import os
import time
import csv
import numpy as np
from threading import Thread


class DataConverter():
    def __init__(self, queue_raw_data, queue_ephys_data, p_channels, p_buffer_size, p_buffer_factor):
        self.queue_raw_data = queue_raw_data
        self.queue_ephys_data = queue_ephys_data
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

        # Arrays to hold the converted data for each channel
        converted_array_mV = np.zeros((self.num_channels, self.buffer_size), dtype=np.int16)
        converted_array_Ephys = np.zeros((self.num_channels, self.buffer_size), dtype=np.int16)
        TEMP_STACK = []

        OpenEphysOffset = 32768
        SIN_WAVE_DATA = np.sin(np.linspace(np.pi, -np.pi, int(self.buffer_size / 4)))
        SIN_WAVE_DATA = np.concatenate(
            (SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA, SIN_WAVE_DATA), axis=None)
        OpenEphysFactor = round(32768 * 0.195) - 1
        value_per_uV = 1 / (0.005 / OpenEphysFactor)
        maxOpenEphysValue = 0.005
        converting_value = (0.000000195 / maxOpenEphysValue) * OpenEphysOffset

        sync_counter = 0
        dataCounter = 0

        while True:
            item = self.queue_raw_data.get()
            if item is None:
                time.sleep(0.001)
                continue

            channel_number = item[0]
            channel_data = item[1]

            # Merge TEMP_STACK if it's not empty
            if TEMP_STACK:
                channel_data = TEMP_STACK + channel_data
                TEMP_STACK = []

            item_size = len(channel_data)
            rest_item_size = item_size % self.buffer_size
            rest_index = self.buffer_size * (rest_item_size // self.buffer_size)

            # If the channel_data exceeds the buffer size, the excess goes into TEMP_STACK
            if item_size >= self.buffer_size:
                TEMP_STACK = channel_data[self.buffer_size:]
            channel_data = channel_data[:self.buffer_size + rest_index]

            # Store any leftover data in TEMP_STACK
            TEMP_STACK = TEMP_STACK[rest_item_size:]

            # Ensure channel_number is valid
            if channel_number is None or not (0 <= channel_number < self.num_channels):
                print(f"Invalid channel_number: {channel_number}, skipping this batch")
                continue

            # Convert data and fill the corresponding channel buffer
            for idx, data in enumerate(channel_data):
                dataNumber = dataCounter // self.num_channels

                # Inject sinusoidal data into selected channels
                if channel_number % 2 == 0:  # For example, inject sine wave on even channels
                    mV_value = OpenEphysOffset + (SIN_WAVE_DATA[dataNumber % len(SIN_WAVE_DATA)] * converting_value)
                else:
                    mV_value = OpenEphysOffset + (data * converting_value)  # Normal conversion

                # Ensure data fits within the buffer size range
                if 0 <= dataNumber < self.buffer_size:
                    converted_array_Ephys[channel_number][dataNumber] = mV_value
                else:
                    print(f"Invalid dataNumber: {dataNumber} for channel {channel_number}, skipping value")

                dataCounter += 1

                # Check if the buffer is filled and ready to be sent to the queue
                if dataCounter > 0 and (dataCounter % (self.buffer_size * self.num_channels)) == 0:
                    # Flatten and send the converted data to the queue
                    np_conv = converted_array_Ephys.flatten().tobytes()  # Flatten and convert to bytes
                    self.queue_ephys_data.put(np_conv)
                    dataCounter = 0  # Reset counter after sending data

            # CSV_HEADER = ["RAW DATA", "CONV DATA"]
            # QUEUE_STACK[0].append(self.queue_raw_data.qsize())
            # QUEUE_STACK[1].append(self.queue_ephys_data.qsize())

            # print("RAW  QUEUE : ", self.queue_raw_data.qsize())
            # print("CONV QUEUE : ", self.queue_ephys_data.qsize())
            # print("------------------")

