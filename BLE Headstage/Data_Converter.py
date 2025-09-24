import os
import time
import csv
import numpy as np
from threading import Thread


class DataConverter():
    def __init__(self, queue_raw_data, queue_ephys_data, p_channels, p_buffer_size, p_buffer_factor):
        self.queue_raw_data = queue_raw_data
        self.queue_ephys_data = queue_ephys_data
        self.channel_list = p_channels
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
        converted_array_Ephys = {i: [0] * self.buffer_size for i in self.channel_list}
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

        DATA_COUNTER_SENDING = self.buffer_size * self.num_channels

        data_counter = 0
        channel_value_index = {channel_number: 0 for channel_number in self.channel_list}
        # Data conversion loop
        while True:
            item = self.queue_raw_data.get()
            if item is None:
                time.sleep(0.001)
            else:
                channel_number = item[0]
                channel_data = item[1]


                # Perform the conversion for each data point in channel_data
                converted_data = [converting_value * value + OpenEphysOffset for value in channel_data]

                # Get the index for where this data should be placed
                index_of_channel = channel_value_index[channel_number]

                first_part = converted_array_Ephys[channel_number][:index_of_channel]
                last_part = converted_array_Ephys[channel_number][index_of_channel + len(converted_data):]

                temp_list = first_part + converted_data + last_part

                # Update the converted_array_Ephys with the new concatenated data
                converted_array_Ephys[channel_number] = temp_list

                # Update the data counter and channel index
                data_counter += len(converted_data)
                channel_value_index[channel_number] += len(converted_data)
                if data_counter >= DATA_COUNTER_SENDING:
                    sorted_dict_values = np.array([converted_array_Ephys[channel_number] for channel_number in sorted(converted_array_Ephys.keys())])
                    np_conv = np.array(sorted_dict_values, np.int16).flatten().tobytes()
                    self.queue_ephys_data.put(np_conv)
                    for ch_number in self.channel_list:
                        channel_value_index[ch_number] = 0
                        np.array(converted_array_Ephys[ch_number]).fill(0)  # Clear the array for the next batch
                    sorted_dict_values.fill(0)
                    data_counter = 0  # Reset data counter
                    sin_counter = 0  # Reset sine wave counter

