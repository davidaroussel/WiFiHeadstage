import socket
import time
import math
import numpy as np
from queue import Queue
import threading

# TRICK TO DISPLAY PLT FIGURE ON GUI
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

import csv
import os
from datetime import datetime

from scipy.interpolate import make_interp_spline
from open_ephys.analysis import Session

from real_time import signalProcessing

class Headstage_Simulator:
    def __init__(self, output_queue, buffer_size):
        self.raw_data = output_queue
        self.buffer_size = buffer_size

    def open_raw_data(self):
        src_directory = r'analysis_results/'
        base_directory = r'../Raw Signals/DOSSIER ANALYSE'
        current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        save_directory = os.path.join(src_directory, current_time)
        if not os.path.exists(save_directory):
            os.makedirs(save_directory)

        experiment_directories = [os.path.join(base_directory, directory)
                                  for directory in os.listdir(base_directory)
                                  if os.path.isdir(os.path.join(base_directory, directory))]

        for experiment_directory in experiment_directories:
            directory_name = os.path.basename(experiment_directory)
            print(f"\nProcessing Experiment Directory: {directory_name}")
            session = Session(experiment_directory)
            recordnode = session.recordnodes[0]
            recording = recordnode.recordings[0]
            continuous = recording.continuous[0]
            start_sample_index = 0
            num_samples_continuous = continuous.samples.shape[0]
            print(f"{num_samples_continuous} of samples")
            data = continuous.get_samples(start_sample_index, num_samples_continuous)
            num_samples, num_channels = data.shape
            fs = continuous.metadata['sample_rate']
            print(f"Signal Sampling Freq : {fs}Hz")

            reformated_array = data.T
            return reformated_array, fs

    def data_transmission_task(self, data, sampling_freq):
        data_byte_size = 2
        num_samples = data.shape[1]
        num_channels = data.shape[0]

        buffers_per_second = sampling_freq / self.buffer_size
        buffer_interval = 1 / buffers_per_second
        buffer_interval_ns = buffer_interval * 1e9
        total_buffer_to_send = num_samples / self.buffer_size

        print(f"Will send {total_buffer_to_send}")

        start_time = time.perf_counter()  # Start total timer

        buffer_index = 0
        while buffer_index < total_buffer_to_send:
            t1 = time.perf_counter_ns()
            data_to_send = [buffer_index, data[:, buffer_index:buffer_index + self.buffer_size]]
            # print(SIGNAL_PROCESSING.spikeDetecting(data_to_send[1]))
            # print(f"Putting Data #{buffer_index}")
            print(buffer_index)
            t2 = time.perf_counter_ns()
            while (t2 - t1) < buffer_interval_ns:
                t2 = time.perf_counter_ns()

            buffer_index += 1

        end_time = time.perf_counter()  # End total timer
        total_duration = end_time - start_time
        print(f"Total transmission duration: {total_duration:.6f} seconds")




if __name__ == "__main__":
    BUFFER_SIZE = 1024

    QUEUE_RAW_DATA = Queue()
    HEADSTAGE_SIMULATOR = Headstage_Simulator(QUEUE_RAW_DATA, BUFFER_SIZE)

    # Step 1: Open raw data
    RAW_DATA, SAMPLING_FREQ = HEADSTAGE_SIMULATOR.open_raw_data()
    CHANNEL_NUMBER = RAW_DATA.shape[0]

    SAMPLING_FREQ = 48000

    SIGNAL_PROCESSING = signalProcessing(QUEUE_RAW_DATA, BUFFER_SIZE, CHANNEL_NUMBER, SAMPLING_FREQ)
    HEADSTAGE_SIMULATOR.data_transmission_task(RAW_DATA, SAMPLING_FREQ)

