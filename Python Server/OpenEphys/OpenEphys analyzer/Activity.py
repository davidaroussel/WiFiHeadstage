import csv
import os
os.environ["OMP_NUM_THREADS"] = "1"
from datetime import datetime
import numpy as np

from scipy.interpolate import make_interp_spline
from open_ephys.analysis import Session

#TRICK TO DISPLAY PLT FIGURE ON GUI
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

from Tools import *


# Function to plot neural activity based on spike count per time period
def plot_neural_activity(data, num_channels, fs, time_period=1, threshold_factor=4):

    # Calculate the number of samples per time period
    samples_per_period = int(time_period * fs)

    # Calculate the number of periods
    num_periods = data.shape[0] // samples_per_period

    # Prepare figure for subplots
    num_cols = int(np.ceil(np.sqrt(num_channels)))
    num_rows = int(np.ceil(num_channels / num_cols))

    fig, axs = plt.subplots(num_rows, num_cols, figsize=(15, 10))
    fig.suptitle(f'Neural Activity: Number of Spikes per {time_period} Second Period')

    fig2, axs2 = plt.subplots(figsize=(15, 10))
    fig2.suptitle(f'Neural Activity: Number of Spikes per {time_period} Second Period')

    # Generate a color map with distinct colors for each channel
    color_map = plt.get_cmap('tab20', num_channels)  # You can change 'tab20' to another colormap if desired

    for channel_index in range(num_channels):
        # Get the data for the current channel
        data_channel = data[:, channel_index]

        # Detect spikes for the entire data of the current channel
        spike_times = detect_spikes(data_channel, threshold_factor=threshold_factor)

        # Initialize an array to store the spike counts for each period
        spike_counts_per_period = np.zeros(num_periods)

        # Loop through each period and count the spikes within that time window
        for period_index in range(num_periods):
            start_idx = period_index * samples_per_period
            end_idx = start_idx + samples_per_period

            # Count the number of spikes in this time period
            spikes_in_period = np.sum((spike_times >= start_idx) & (spike_times < end_idx))
            spike_counts_per_period[period_index] = spikes_in_period

        # Smoothing the spike counts
        x_smooth = np.linspace(0, num_periods - 1, 300)
        spline = make_interp_spline(np.arange(num_periods), spike_counts_per_period, k=3)
        spike_counts_smooth = spline(x_smooth)

        channel_color = color_map.colors[channel_index]

        # Plot the spike counts for this channel
        row = channel_index // num_cols
        col = channel_index % num_cols
        axs[row, col].plot(x_smooth, spike_counts_smooth, color=channel_color)
        axs[row, col].set_title(f'Channel {channel_index + 1}')
        axs[row, col].set_xlabel('Time Period')
        axs[row, col].set_ylabel(f'Spike Count per {time_period}sec')

        axs2.plot(x_smooth, spike_counts_smooth, color=channel_color)
        axs2.set_xlabel('Time Period')
        axs2.set_ylabel(f'Spike Count per {time_period}sec')

    for i in range(num_channels, num_rows * num_cols):
        row = i // num_cols
        col = i % num_cols
        fig.delaxes(axs[row, col])

    # Adjust layout and show plot
    plt.show()


def plot_neural_activity_with_raw(data, num_channels, fs, time_period=1, threshold_factor=4, start_point=0, window_length=None):
    # Calculate the number of samples per time period
    samples_per_period = int(time_period * fs)

    # Determine the end point for the window
    start_sample = int(start_point * fs)
    if window_length is not None:
        end_sample = min(start_sample + int(window_length * fs), data.shape[0])
    else:
        end_sample = data.shape[0]

    # Limit data to the specified window
    data_window = data[start_sample:end_sample]

    for channel_index in range(num_channels):
        # Create a new figure with two subplots
        fig, axs = plt.subplots(2, 1, figsize=(15, 10))
        fig.suptitle(f'Channel {channel_index + 1} Neural Activity and Raw Signal\n'
<<<<<<< HEAD:WiFiHeadstage V1/Python/OpenEphys/OpenEphys analyzer/Activity.py
                     f'(Start: {start_point}s, Window Length: {window_length}s, Time Period: {time_period}, Threshold: {threshold_factor})')
=======
                     f'(Sequence Length: {window_length}s, Time Period: {time_period})',
                     fontsize=18, fontweight='bold')
>>>>>>> 84418e0d4bc2f894c7f7ec520b18aa74e4cf84ab:Python Server/OpenEphys/OpenEphys analyzer/Activity.py

        # Get the data for the current channel within the specified window
        data_channel = data_window[:, channel_index]

        # Detect spikes for the entire data of the current channel
        spike_times = detect_spikes(data_channel, threshold_factor=threshold_factor)

        # Initialize an array to store the spike counts for each period
        num_periods_window = data_window.shape[0] // samples_per_period
        spike_counts_per_period = np.zeros(num_periods_window)

        # Loop through each period and count the spikes within that time window
        for period_index in range(num_periods_window):
            start_idx = period_index * samples_per_period
            end_idx = start_idx + samples_per_period

            # Count the number of spikes in this time period
            spikes_in_period = np.sum((spike_times >= start_idx) & (spike_times < end_idx))
            spike_counts_per_period[period_index] = spikes_in_period

        # Smoothing the spike counts
        x_smooth = np.linspace(0, num_periods_window - 1, 300)
        spline = make_interp_spline(np.arange(num_periods_window), spike_counts_per_period, k=3)
        spike_counts_smooth = spline(x_smooth)

        # Plot the spike counts for this channel
        time_axis_counts = np.arange(num_periods_window) * time_period + start_point  # Convert to time in seconds
        axs[0].plot(x_smooth * time_period + start_point, spike_counts_smooth, color="black")
<<<<<<< HEAD:WiFiHeadstage V1/Python/OpenEphys/OpenEphys analyzer/Activity.py
        axs[0].set_title(f'Channel {channel_index + 1} - Spike Counts')
        axs[0].set_xlabel('Time (seconds)')
        axs[0].set_ylabel(f'Spike Count per {time_period} sec')
=======
        axs[0].set_title(f'Channel {channel_index + 1} - Spike Per Seconds')
        axs[0].set_xlabel('Time (seconds)')
        axs[0].set_ylabel(f'Spike Count per {time_period} sec', fontweight='bold', fontsize=12)
>>>>>>> 84418e0d4bc2f894c7f7ec520b18aa74e4cf84ab:Python Server/OpenEphys/OpenEphys analyzer/Activity.py

        # Plot the raw signal for the same channel
        time_axis_raw = np.arange(data_channel.size) / fs + start_point  # Convert samples to time in seconds
        axs[1].plot(time_axis_raw, data_channel, color="black")
<<<<<<< HEAD:WiFiHeadstage V1/Python/OpenEphys/OpenEphys analyzer/Activity.py
        axs[1].set_title(f'Raw Signal Channel {channel_index + 1}')
        axs[1].set_xlabel('Time (seconds)')
        axs[1].set_ylabel('Amplitude')
=======
        axs[1].set_title(f'Channel {channel_index + 1} - Raw Signal Channel')
        axs[1].set_xlabel('Time (seconds)')
        axs[1].set_ylabel('Amplitude (uV)', fontweight='bold', fontsize=12)
>>>>>>> 84418e0d4bc2f894c7f7ec520b18aa74e4cf84ab:Python Server/OpenEphys/OpenEphys analyzer/Activity.py

        # Adjust layout and show plot
        plt.tight_layout(rect=[0, 0.03, 1, 0.95])  # Adjust for the main title
        plt.show()


<<<<<<< HEAD:WiFiHeadstage V1/Python/OpenEphys/OpenEphys analyzer/Activity.py



=======
>>>>>>> 84418e0d4bc2f894c7f7ec520b18aa74e4cf84ab:Python Server/OpenEphys/OpenEphys analyzer/Activity.py
if __name__ == '__main__':
    src_directory = r'../../analysis_results/'
    base_directory = r'C:\Users\david\OneDrive\Ph.D G. ELECTRIQUE\Wi-Fi Headstage\SCOPE\2024-04-25\GOOD\New folder'
    # Get current date and time with second precision
    current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    # Define the save directory with the current date and time
    save_directory = os.path.join(src_directory, current_time)
    if not os.path.exists(save_directory):
        os.makedirs(save_directory)
    experiment_directories = [os.path.join(base_directory, directory) for directory in os.listdir(base_directory) if
                              os.path.isdir(os.path.join(base_directory, directory))]
    lowcut = 180.0
    highcut = 3000.0

    # Dictionary to store SNR and Vrms values for each experiment
    experiment_data = {}
    for experiment_directory in experiment_directories:
        directory_name = os.path.basename(experiment_directory)
        print(f"\nProcessing Experiment Directory: {directory_name}")
        session = Session(experiment_directory)
        recordnode = session.recordnodes[0]
        recording = recordnode.recordings[0]
        continuous = recording.continuous[0]
        start_sample_index = 0
        # Get the length of the continuous data
        num_samples_continuous = continuous.samples.shape[0]
        print(f"{num_samples_continuous} of samples")

        # data = continuous.get_samples(10000, 30000)
        data = continuous.get_samples(start_sample_index, num_samples_continuous)
        num_samples, num_channels = data.shape
        fs = continuous.metadata['sample_rate']
        print(fs)

        # plot_neural_activity(data, num_channels, fs)
        plot_neural_activity_with_raw(data, num_channels, fs, time_period=0.1, threshold_factor=4, start_point=5, window_length=55)
