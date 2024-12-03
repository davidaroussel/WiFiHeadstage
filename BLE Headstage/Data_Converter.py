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
        print("Starting Data Conversion Thread")

        # Arrays to hold the converted data for each channel
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
        BUFFER_SIZE = self.buffer_size * self.buffer_factor
        sin_counter = 0
        data_counter = 0

        # Data conversion loop
        while True:
            item = self.queue_raw_data.get()
            channel_number = item[0]
            channel_data = item[1]
            if item is None:
                time.sleep(0.001)
            else:
                if TEMP_STACK:
                    channel_data = TEMP_STACK + channel_data
                    TEMP_STACK = []

                item_size = len(channel_data)
                rest_item_size = item_size % BUFFER_SIZE
                rest_index = self.buffer_size * (rest_item_size // self.buffer_size)
                if len(channel_data) >= BUFFER_SIZE:
                    TEMP_STACK += channel_data[BUFFER_SIZE:]
                channel_data = channel_data[:BUFFER_SIZE + rest_index]
                TEMP_STACK = TEMP_STACK[rest_index:]

                # Loop through each data point for each channel
                for i, data in enumerate(channel_data):
                    if channel_number == 0:
                        # converted_array_Ephys[channel_number][data_counter % self.buffer_size] = OpenEphysOffset + ((SIN_WAVE_DATA[sin_counter] * 10 / 1000) * value_per_uV)  # in mV
                        # sin_counter += 1
                        converted_array_Ephys[channel_number][data_counter] = 10000
                    else:
                        converted_array_Ephys[channel_number][data_counter % self.num_channels] = 000
                        # mV_value = OpenEphysOffset + (data * converting_value)  # in mV
                        # converted_array_Ephys[channel_number][data_counter % self.buffer_size] = mV_value  # in mV


                    data_counter += 1

                    # If we've processed enough data, place it in the queue
                    if data_counter >= self.buffer_size * self.num_channels:
                        np_conv = np.array(converted_array_Ephys, np.int16).flatten().tobytes()
                        self.queue_ephys_data.put(np_conv)
                        converted_array_Ephys.fill(0)  # Clear the array for the next batch
                        data_counter = 0  # Reset data counter
                        sin_counter = 0  # Reset sine wave counter
