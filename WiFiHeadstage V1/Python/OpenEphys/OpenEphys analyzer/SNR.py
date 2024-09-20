import os
os.environ["OMP_NUM_THREADS"] = "1"
import numpy as np
from datetime import datetime
from scipy.signal import butter, filtfilt
import numpy as np
from open_ephys.analysis import Session
import csv

#TRICK TO DISPLAY PLT FIGURE ON GUI
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

from Tools import *

# Function to write SNR and Vrms values to a CSV file
def write_csv(experiment_data, csv_filename):
    with open(csv_filename, 'w', newline='') as csvfile:
        fieldnames = ['Experiment', 'Channel', 'SNR (dB)', 'Vrms']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for experiment, data in experiment_data.items():
            for channel, (snr, vrms) in enumerate(data, start=1):
                writer.writerow({'Experiment': experiment, 'Channel': channel, 'SNR (dB)': snr, 'Vrms': vrms})
            # Insert a blank row between each project
            writer.writerow({})

def format_csv_data(num_channels):
    snr_vrms_data = []  # List to store SNR and Vrms values for each channel in this experiment
    for channel_index in range(num_channels):
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut=180.0, highcut=3000.0,
                                        fs=continuous.metadata['sample_rate'])
        spike_times = detect_spikes(filtered_data)
        spike_waveforms = extract_spikes(filtered_data, spike_times)
        if len(spike_waveforms) == 0:
            continue
        avg_spike_waveform = np.mean(spike_waveforms, axis=0)
        rms_signal = rms(avg_spike_waveform)
        noise_segments = extract_noise(filtered_data, spike_times)
        if len(noise_segments) == 0:
            rms_noise = np.nan
        else:
            rms_noise = rms(noise_segments)
        if np.isnan(rms_noise):
            snr = np.nan
        else:
            snr = 20 * np.log10(rms_signal / rms_noise)
        vrms = rms_signal
        snr_vrms_data.append((snr, vrms))
    return snr_vrms_data

def plot_snr_and_vrms(experiment_data):
    snr_values = []
    vrms_values = []

    for experiment, data in experiment_data.items():
        for snr, vrms in data:
            if not np.isnan(snr):
                snr_values.append(snr)
                vrms_values.append(vrms)

    plt.figure(figsize=(10, 6))

    # Plot SNR values
    plt.subplot(2, 1, 1)
    plt.hist(snr_values, bins=20, color='blue', alpha=0.7)
    plt.title('Distribution of SNR Values')
    plt.xlabel('SNR (dB)')
    plt.ylabel('Frequency')

    # Plot VRMS values
    plt.subplot(2, 1, 2)
    plt.hist(vrms_values, bins=20, color='green', alpha=0.7)
    plt.title('Distribution of VRMS Values')
    plt.xlabel('VRMS')
    plt.ylabel('Frequency')

    plt.tight_layout()
    plt.show()


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
        print(continuous.metadata['sample_rate'])
        snr_vrms_data = format_csv_data(num_channels)
        experiment_data[directory_name] = snr_vrms_data


    plot_snr_and_vrms(experiment_data)

    # Write SNR and Vrms values to CSV file
    csv_filename = os.path.join(save_directory, 'snr_vrms_results.csv')
    write_csv(experiment_data, csv_filename)
    print(f"CSV file saved: {csv_filename}")