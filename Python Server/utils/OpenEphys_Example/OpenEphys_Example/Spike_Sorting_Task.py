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
os.environ["OMP_NUM_THREADS"] = "1"
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

    def data_transmission_trask(self, data, sampling_freq):
        data_byte_size = 2
        num_samples = data.shape[1]
        num_channels = data.shape[0]

        buffers_per_second = sampling_freq / self.buffer_size
        buffer_interval = 1 / buffers_per_second
        buffer_interval_ns = buffer_interval * 1e9
        total_buffer_to_send = num_samples / self.buffer_size

        print("Starting transmission")

        buffer_index = 0
        while buffer_index < 300-1:
            t1 = time.perf_counter_ns()
            used_index = buffer_index*self.buffer_size
            data_to_send = [True, buffer_index, data[:, used_index:used_index+self.buffer_size]]
            self.raw_data.put(data_to_send)
            # print(f"Putting Data #{buffer_index}")
            t2 = time.perf_counter_ns()
            while (t2 - t1) < buffer_interval_ns:
                t2 = time.perf_counter_ns()
                time.sleep(0.0001)

            buffer_index += 1

        data_to_send = [False, buffer_index, data[:, buffer_index:buffer_index + self.buffer_size]]
        self.raw_data.put(data_to_send)


def sampling_rate_scalling_test(RAW_DATA):
    calculation_times = []
    expected_times = []
    sampling_rates = range(12000, 120000, 12000)
    for SAMPLING_FREQ in sampling_rates:
        print(f"\n=== Testing {SAMPLING_FREQ} Hz ===")

        # Recreate processing object with stop event
        SIGNAL_PROCESSING = signalProcessing(QUEUE_RAW_DATA, BUFFER_SIZE, CHANNEL_NUMBER, SAMPLING_FREQ)
        SIGNAL_PROCESSING.stop_event = threading.Event()

        # Step 2: Start transmit thread
        transmit_thread = threading.Thread(target=HEADSTAGE_SIMULATOR.data_transmission_trask,
                                           args=(RAW_DATA, SAMPLING_FREQ))

        # Step 3: Start processing thread
        print_thread = threading.Thread(target=SIGNAL_PROCESSING.spike_sorting_task)

        start_time = time.perf_counter()

        transmit_thread.start()
        print_thread.start()

        # Wait for transmission to finish
        transmit_thread.join()

        # Tell processing thread to stop
        SIGNAL_PROCESSING.stop_event.set()
        print_thread.join()

        end_time = time.perf_counter()
        total_time = end_time - start_time
        calculation_times.append(total_time)
        expected_times.append(RAW_DATA.shape[1] / SAMPLING_FREQ)

        print(f"Sampling {SAMPLING_FREQ} Hz -> Time: {total_time:.3f} s")

    # === Plot results ===
    plt.figure(figsize=(10, 8))
    plt.plot(sampling_rates, calculation_times, marker="o", linestyle="-")
    plt.plot(sampling_rates, expected_times, marker="o", linestyle="-")
    plt.xlabel("Sampling Rate (Hz)")
    plt.ylabel("Processing Time (s)")
    plt.title("Spike Sorting Time vs Sampling Rate")
    plt.grid(True)
    plt.legend()
    plt.show()

def channel_number_scaling_test(RAW_DATA):

    SAMPLING_FREQ = 25000
    FORMATTED_DATA = RAW_DATA.copy()
    calculation_times = []
    expected_times = []
    channel_counts = []

    for i in range(0, 64, 8):
        # Add 8 rows at once by cycling through RAW_DATA rows
        if i != 0:
            rows_to_add = RAW_DATA[:8, :]  # take first 8 rows each time
            FORMATTED_DATA = np.vstack([FORMATTED_DATA, rows_to_add])

        CHANNEL_NUMBER = FORMATTED_DATA.shape[0]
        channel_counts.append(CHANNEL_NUMBER)

        print(f"\n=== Testing {SAMPLING_FREQ} Hz with {CHANNEL_NUMBER} channels ===")

        SIGNAL_PROCESSING = signalProcessing(QUEUE_RAW_DATA, BUFFER_SIZE, CHANNEL_NUMBER, SAMPLING_FREQ)

        # Step 2: Start transmit thread
        transmit_thread = threading.Thread(
            target=HEADSTAGE_SIMULATOR.data_transmission_trask,
            args=(FORMATTED_DATA, SAMPLING_FREQ)
        )

        # Step 3: Start processing thread
        process_thread = threading.Thread(target=SIGNAL_PROCESSING.spike_sorting_task)

        start_time = time.perf_counter()

        transmit_thread.start()
        process_thread.start()

        transmit_thread.join()
        process_thread.join()

        end_time = time.perf_counter()
        total_time = end_time - start_time
        calculation_times.append(total_time)
        expected_times.append(FORMATTED_DATA.shape[1] / SAMPLING_FREQ)

        print(f"Channels: {CHANNEL_NUMBER}, Rate: {SAMPLING_FREQ} Hz -> Time: {total_time:.3f} s")

    # === Plot results ===
    plt.figure(figsize=(10, 8))
    plt.plot(channel_counts, calculation_times, marker="o", linestyle="-", label="Measured time")
    plt.plot(channel_counts, expected_times, marker="o", linestyle="-", label="Expected time")
    plt.xlabel("Number of Channels")
    plt.ylabel("Processing Time (s)")
    plt.title("Spike Sorting Time vs Number of Channels")
    plt.grid(True)
    plt.legend()
    plt.show()


if __name__ == "__main__":
    BUFFER_SIZE = 1024
    CHANNEL_NUMBER = 8 #TODO: MAKE THE NUMBER OF CHANNEL

    QUEUE_RAW_DATA = Queue()
    HEADSTAGE_SIMULATOR = Headstage_Simulator(QUEUE_RAW_DATA, BUFFER_SIZE)

    RAW_DATA, SAMPLING_FREQ = HEADSTAGE_SIMULATOR.open_raw_data()
    CHANNEL_NUMBER = RAW_DATA.shape[0]

    # channel_number_scaling_test(RAW_DATA)
    # sampling_rate_scalling_test(RAW_DATA)

    SAMPLING_FREQ = 25000
    SIGNAL_PROCESSING = signalProcessing(QUEUE_RAW_DATA, BUFFER_SIZE, CHANNEL_NUMBER, SAMPLING_FREQ)

    # Step 2: Start transmit thread
    transmit_thread = threading.Thread(
        target=HEADSTAGE_SIMULATOR.data_transmission_trask,
        args=(RAW_DATA, SAMPLING_FREQ)
    )

    # Step 3: Start processing thread
    process_thread = threading.Thread(target=SIGNAL_PROCESSING.convertData)

    start_time = time.perf_counter()

    transmit_thread.start()
    process_thread.start()

    transmit_thread.join()
    process_thread.join()





