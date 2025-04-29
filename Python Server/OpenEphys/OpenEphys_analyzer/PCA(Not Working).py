import os
from tqdm import tqdm
os.environ["OMP_NUM_THREADS"] = "1"
import numpy as np
from datetime import datetime
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from scipy.signal import butter, filtfilt
from open_ephys.analysis import Session


def preprocess_data(data, lowcut, highcut, fs):
    nyquist = 0.5 * fs
    low = lowcut / nyquist
    high = highcut / nyquist
    b, a = butter(1, [low, high], btype='band')
    # Initialize the filtered_data array
    filtered_data = np.zeros_like(data)
    # Process each channel separately
    for i in range(data.shape[1]):
        channel_data = data[:, i]
        if len(channel_data) > len(b):  # Check if data length is greater than filter length
            filtered_data[:, i] = filtfilt(b, a, channel_data)
        else:
            print(
                f"Warning: Channel {i + 1} data length is too short for filtering. Skipping filtering for this channel.")
            filtered_data[:, i] = channel_data  # Leave the data unfiltered if it's too short

    return filtered_data

def extract_spikes(data, spike_window=40, threshold=5.0):
    spikes = []
    for i in range(data.shape[0]):
        channel_data = data[i, :]
        spike_indices = np.where(channel_data > threshold)[0]
        for idx in spike_indices:
            if idx + spike_window // 2 < len(channel_data) and idx - spike_window // 2 >= 0:
                spike_segment = channel_data[idx - spike_window // 2: idx + spike_window // 2]
                if len(spike_segment) == spike_window:
                    spikes.append(spike_segment)
    return np.array(spikes)

def perform_pca(spikes, n_components=3):
    pca = PCA(n_components=n_components)
    pca_result = pca.fit_transform(spikes)
    return pca_result

def cluster_spikes(pca_result, n_clusters=5):
    kmeans = KMeans(n_clusters=n_clusters)
    clusters = kmeans.fit_predict(pca_result)
    return clusters

def plot_pca_clusters(pca_result, clusters, channel_id, experiment_name, ax):
    scatter = ax.scatter(pca_result[:, 0], pca_result[:, 1], c=clusters, cmap='viridis')
    ax.set_xlabel('PC 1')
    ax.set_ylabel('PC 2')
    ax.set_title(f'Channel {channel_id + 1} - {experiment_name}')
    return scatter

def plot_all_channels(data, experiment_name, save_directory, spike_window=40, threshold=5.0, n_components=3, n_clusters=5):
    n_channels = data.shape[0]
    fig, axes = plt.subplots(n_channels, 1, figsize=(12, 3 * n_channels), sharex=True, sharey=True)

    if n_channels == 1:
        axes = [axes]

    # Initialize progress bar
    for channel_id in tqdm(range(n_channels), desc="Processing Channels", unit="channel"):
        spikes = extract_spikes(data[channel_id], spike_window=spike_window, threshold=threshold)
        pca_result = perform_pca(spikes, n_components=n_components)
        clusters = cluster_spikes(pca_result, n_clusters=n_clusters)
        scatter = plot_pca_clusters(pca_result, clusters, channel_id, experiment_name, axes[channel_id])

    plt.tight_layout()
    plt.savefig(os.path.join(save_directory, f'{experiment_name}_pca_clusters.png'))
    plt.show()

if __name__ == '__main__':
    src_directory = r'../../analysis_results/'
    base_directory = r'C:\Users\david\OneDrive\Ph.D G. ELECTRIQUE\Wi-Fi Headstage\SCOPE\2024-04-25\GOOD'
    current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    save_directory = os.path.join(src_directory, current_time)
    if not os.path.exists(save_directory):
        os.makedirs(save_directory)
    experiment_directories = [os.path.join(base_directory, directory) for directory in os.listdir(base_directory) if
                              os.path.isdir(os.path.join(base_directory, directory))]

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
        data = preprocess_data(data, lowcut=180.0, highcut=5000.0, fs=continuous.metadata['sample_rate'])
        plot_all_channels(data, directory_name, save_directory)