import socket
import struct
import threading
import time
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.animation import FuncAnimation
from queue import Queue

from BioMLServer.Headstage_Driver import HeadstageDriver
import sys
import time
from queue import Queue
from OpenEphys.WiFiHeadstageReceiver import WiFiHeadstageReceiver
from OpenEphys.DataConverter import DataConverter
from OpenEphys.CSVWriter import CSVWriter
from OpenEphys.OpenEphysSender import OpenEphysSender

class WiFiHeadstageSimulator:
    def __init__(self, p_queue_raw_data, p_channels, p_buffer_size, p_frequency, p_buffer_factor):
        self.channels = p_channels
        self.num_channels = len(p_channels)
        self.queue_raw_data = p_queue_raw_data
        self.buffer_size = p_buffer_size
        self.buffer_factor = p_buffer_factor
        self.frequency = p_frequency
        self.wave_generators = {}
        self.sample_period = 1 / self.frequency
        self.HeadstageDriver = HeadstageDriver()

    def init_wave(self, channel_ids, wave_type="sine", amplitude=32767, frequency=10):
        """
        Initialize the specified channels with the given wave type.
        wave_type can be 'sine', 'square', 'triangle', or 'dc'.
        """
        # Constrain amplitude to signed 16-bit integer limits
        max_amplitude = 32767
        amplitude = min(amplitude, max_amplitude)

        for channel_id in channel_ids:
            self.wave_generators[channel_id] = {
                "wave_type": wave_type,
                "amplitude": amplitude,
                "frequency": frequency,
                "time": 0
            }

    def _generate_wave(self, channel_id, time_point):
        wave_gen = self.wave_generators[channel_id]
        wave_type = wave_gen["wave_type"]
        frequency = wave_gen["frequency"]
        amplitude = wave_gen["amplitude"]

        if wave_type == "sine":
            # Generate a sine wave between -32768 and 32767
            return int(amplitude * np.sin(2 * np.pi * frequency * time_point))  # Mapping to -32768 to 32767
        elif wave_type == "square":
            # Generate a square wave: alternating between -32768 and 32767
            return int(amplitude if np.sin(2 * np.pi * frequency * time_point) >= 0 else -amplitude)
        elif wave_type == "triangle":
            # Generate a triangle wave between -32768 and 32767
            return int((amplitude * 2 / np.pi) * np.arcsin(np.sin(2 * np.pi * frequency * time_point)))  # Mapping to -32768 to 32767
        elif wave_type == "dc":
            # DC value is constant and mapped to signed range
            return int(amplitude)  # DC wave has a constant value

    def _generate_data_packet(self):
        packet_size = 227
        packet = bytearray(packet_size)

        for channel_id in self.channels:
            channel_data = []
            for i in range(3, len(packet), 2): # 2 bytes per sample
                wave_value = self._generate_wave(channel_id, self.wave_generators[channel_id]["time"])
                channel_data.append(wave_value)
                self.wave_generators[channel_id]["time"] += self.sample_period

            self.queue_raw_data.put((channel_id, channel_data))

    def continuedDataSimulator(self):
        BUFFER_SIZE = self.buffer_size * self.buffer_factor
        NUM_CHANNEL = self.num_channels

        # Create an array to hold data for each channel, indexed by channel index
        data = [[0 for _ in range(BUFFER_SIZE // self.num_channels)] for _ in range(NUM_CHANNEL)]

        for channel_index, channel in enumerate(self.channels):
            wave_values = []  # Will store the waveform for this channel
            time_point = 0

            # Generate waveform for each channel
            for _ in range(BUFFER_SIZE // self.num_channels):  # Each sample is two 8-bit words
                sample_value = self._generate_wave(channel, time_point)  # Get waveform value
                lsb = 1 if channel == 0 else 0  # Set LSB to 1 for the first channel, 0 otherwise

                # Pack sample_value into two 8-bit words (little-endian)
                wave_values.append((sample_value >> 8) & 0xFF)  # MSB
                wave_values.append((sample_value & 0xFF) | (lsb << 0))  # LSB + 7th bit
                time_point += self.sample_period  # Move to the next time point

            # Flatten the 2D array for the channel into a 1D list
            data[channel_index] = wave_values  # Assign the pre-generated waveform to the data array at channel index

        # Flatten the data from 2D to 1D to get the full sequence of all channels
        flattened_data = []
        for channel in range(NUM_CHANNEL):
            flattened_data.extend(data[channel])

        # Send data in the correct order (CH0, CH1, CH2, ...)
        sample_index = 0
        while 1:
            # Send the data packet
            self.queue_raw_data.put(flattened_data)

            # Adjust sleep to maintain the proper frequency
            time.sleep(1 / self.frequency)

    def startThread(self):
        self.continuedDataSimulator_thread = threading.Thread(target=self.continuedDataSimulator)
        self.continuedDataSimulator_thread.start()

    def stopThread(self):
        self.continuedDataSimulator_thread.join()




if __name__ == "__main__":
    # MODES
    CSV_WRITING = False
    OPENEPHYS_SENDING = True

    # GLOBAL VARIABLES
    HOST_ADDR      = ""
    HEADSTAGE_PORT = 5000
    OPENEPHYS_PORT = 10001

    # HEADSTAGE CONFIGS
    # 8 CHANNELS CONFIGURATION
    CHANNELS_LIST = [[0, 1, 2, 3, 4, 5, 6, 7],
                     [8, 9, 10, 11, 12, 13, 14, 15],
                     [16, 17, 18, 19, 20, 21, 22, 23],
                     [24, 25, 26, 27, 28, 29, 30, 31]]
    CHANNELS = CHANNELS_LIST[0]

    # 32 CHANNELS CONFIGURATION
    # CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7,
    #              8, 9, 10, 11, 12, 13, 14, 15,
    #              16, 17, 18, 19, 20, 21, 22, 23,
    #              24, 25, 26, 27, 28, 29, 30, 31]

    # 16 CHANNELS CONFIGURATION
    CHANNELS_LIST = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
                     [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]]
    # CHANNELS = CHANNELS_LIST[0]


    # 12 CHANNELS CONFIGURATION
    BUFFER_SOCKET_FACTOR = 100
    BUFFER_SIZE = 1024
    FREQUENCY   = 12000

    CHANNELS_LIST = [[0, 1, 2, 3],
                     [4, 5, 6, 7],
                     [8, 9, 10, 11],
                     [12, 13, 14, 15],
                     [16, 17, 18, 19],
                     [20, 21, 22, 23],
                     [24, 25, 26, 27],
                     [28, 29, 30, 31]]
    # CHANNELS = CHANNELS_LIST[0]

    # CONSTRUCTORS
    QUEUE_RAW_DATA   = Queue()
    QUEUE_EPHYS_DATA = Queue()
    QUEUE_CSV_DATA   = Queue()

    TASK_HeadstageSimulator = WiFiHeadstageSimulator(QUEUE_RAW_DATA, CHANNELS, BUFFER_SIZE, FREQUENCY, BUFFER_SOCKET_FACTOR)
    TASK_DataConverter = DataConverter(QUEUE_RAW_DATA, QUEUE_EPHYS_DATA, QUEUE_CSV_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR)
    TASK_OpenEphysSender = OpenEphysSender(QUEUE_EPHYS_DATA, BUFFER_SIZE, BUFFER_SOCKET_FACTOR, FREQUENCY, p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)
    TASK_CSVWriter = CSVWriter(QUEUE_CSV_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR)



    # Start other threads
    if CSV_WRITING:
        TASK_CSVWriter.startThread()
    if OPENEPHYS_SENDING:
        TASK_OpenEphysSender.startThread()
    TASK_DataConverter.startThread()

    for CHANNEL in CHANNELS:
        if CHANNEL % 2 == 0:
            TASK_HeadstageSimulator.init_wave([CHANNEL], wave_type="dc", amplitude=12000, frequency=50)  # Max amplitude for signed 16-bit
        else:
            TASK_HeadstageSimulator.init_wave([CHANNEL], wave_type="dc", amplitude=8000, frequency=130)  # Square wave for channel 1
    TASK_HeadstageSimulator.startThread()

    # Continuous loop until "stop" is entered
    user_input = input("\n Enter 'stop' to disable sampling: ")
    if user_input.strip().lower() == "stop":
        TASK_HeadstageSimulator.stop()
        print("Closed Intan")
        print("Closed everything")
        sys.exit(-1)
