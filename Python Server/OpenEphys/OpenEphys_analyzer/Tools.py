import os
os.environ["OMP_NUM_THREADS"] = "1"
import csv
from scipy.signal import butter, filtfilt
import numpy as np

#TRICK TO DISPLAY PLT FIGURE ON GUI
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

from sklearn.cluster import KMeans, DBSCAN
from sklearn.metrics import davies_bouldin_score


def rms(signal):
    return np.sqrt(np.mean(signal ** 2))

def bandpass_filter(data, lowcut, highcut, fs):
    nyquist = 0.5 * fs
    low = lowcut / nyquist
    high = highcut / nyquist
    b, a = butter(N=4, Wn=[low, high], btype='band')
    padlen = 3 * max(len(a), len(b))
    if len(data) < padlen:
        raise ValueError("The length of the input vector x must be greater than padlen.")
    filtered_data = filtfilt(b, a, data, padlen=padlen)
    return filtered_data


def detect_spikes(data, threshold_factor=4, window_size=15):
    # Calculate the threshold
    threshold = threshold_factor * np.std(data)

    # Find potential spike indices where data exceeds the threshold
    potential_spike_indices = np.where(data > threshold)[0]

    # Initialize an empty list to store the final spike times
    spike_times = []

    # Ensure the window size is valid
    half_window = window_size // 2

    # Iterate over potential spike indices
    for idx in potential_spike_indices:
        # Define the window boundaries
        start_idx = max(0, idx - half_window)
        end_idx = min(len(data), idx + half_window)

        # Extract the windowed segment
        window_segment = data[start_idx:end_idx]

        # Find the index of the maximum value within the window
        max_idx_within_window = start_idx + np.argmax(window_segment)

        # Add the max index to the spike times if it's not already included
        if max_idx_within_window not in spike_times:
            spike_times.append(max_idx_within_window)

    return np.array(spike_times)


def find_optimal_clusters(spike_waveforms, max_clusters=10):
    n_samples = len(spike_waveforms)

    if n_samples < 2:
        return 1

    max_clusters = min(max_clusters, n_samples - 1)

    davies_bouldin_indices = []
    for n_clusters in range(2, max_clusters + 1):
        kmeans = KMeans(n_clusters=n_clusters, random_state=0)
        labels = kmeans.fit_predict(spike_waveforms)
        db_index = davies_bouldin_score(spike_waveforms, labels)
        davies_bouldin_indices.append(db_index)

    # Find the optimal number of clusters (lowest Davies-Bouldin score)
    optimal_clusters = davies_bouldin_indices.index(min(davies_bouldin_indices)) + 2  # +2 to match the range
    if optimal_clusters:
        return optimal_clusters
    else:
        print("No optimal clusters")
        return 1


def extract_spikes(data, spike_times, window_size=15):
    spikes = []
    for t in spike_times:
        if t > window_size and t < len(data) - window_size:
            spikes.append(data[t - window_size:t + window_size])
    return np.array(spikes)


def extract_noise(data, spike_times, window_size=30, noise_duration=1000):
    noise_segments = []
    last_spike = 0
    for t in spike_times:
        if t - last_spike > noise_duration:
            noise_segment = data[last_spike + window_size:t - window_size]
            noise_segments.append(noise_segment)
        last_spike = t
    if noise_segments:
        noise_segments = np.concatenate(noise_segments)
        return noise_segments
    else:
        return np.array([])


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
