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

from sklearn.cluster import KMeans, DBSCAN
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

from kneed import KneeLocator

# Bandpass filter function
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

# Spike detection function
def detect_spikes(data, threshold_factor=4):
    threshold = threshold_factor * np.std(data)
    spike_times = np.where(data > threshold)[0]
    return spike_times

# Extract spike waveforms
def extract_spikes(data, spike_times, window_size=30):
    spikes = []
    for t in spike_times:
        if t > window_size and t < len(data) - window_size:
            spikes.append(data[t - window_size:t + window_size])
    return np.array(spikes)


def find_optimal_clusters(spike_waveforms, max_clusters=10):
    n_samples = len(spike_waveforms)

    if n_samples < 2:
        return 1

    max_clusters = min(max_clusters, n_samples - 1)

    inertia = []
    for n_clusters in range(2, max_clusters + 1):
        kmeans = KMeans(n_clusters=n_clusters, random_state=0)
        kmeans.fit(spike_waveforms)
        inertia.append(kmeans.inertia_)

    if not inertia:
        return 2  # Default to 2 if no inertia values are computed

    kneedle = KneeLocator(range(2, max_clusters + 1), inertia, curve='convex', direction='decreasing')
    optimal_clusters = kneedle.elbow

    return optimal_clusters if optimal_clusters else 2  # Default to 2 if no knee is found


def plot_clustered_spikes(data, num_channels, lowcut, highcut, fs, directory_name, save_directory, save_figure=False):
    # Calculate the number of rows and columns for the subplots to make them square
    num_cols = int(np.ceil(np.sqrt(num_channels)))
    num_rows = int(np.ceil(num_channels / num_cols))

    fig, axs = plt.subplots(num_rows, num_cols, figsize=(15, 15))
    fig.suptitle(f'Clusters of Spikes for Each Channel - Directory: {directory_name}')

    clusters_data = {}  # Dictionary to store clusters data for each channel

    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index + 1}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)
        spike_times = detect_spikes(filtered_data)
        spike_waveforms = extract_spikes(filtered_data, spike_times)

        if len(spike_waveforms) < 2:
            print(f"Not enough spike waveforms detected for Channel {channel_index + 1}")
            continue

        # Find the optimal number of clusters
        num_clusters = find_optimal_clusters(spike_waveforms)
        print(f"Optimal number of clusters for Channel {channel_index + 1}: {num_clusters}")

        # Perform PCA
        pca = PCA(n_components=num_clusters)
        pca_result = pca.fit_transform(spike_waveforms)

        # Perform k-means clustering
        kmeans = KMeans(n_clusters=num_clusters, random_state=0)
        clusters = kmeans.fit_predict(spike_waveforms)

        clusters_data[channel_index] = {}  # Initialize clusters data for this channel
        for i, spike_time in enumerate(spike_times):
            if i < len(clusters):
                cluster_label = clusters[i]
                if cluster_label not in clusters_data[channel_index]:
                    clusters_data[channel_index][cluster_label] = []
                clusters_data[channel_index][cluster_label].append(spike_time)
            else:
                print("Index out of bounds:", i)


        # Plot the PCA results with clustered points
        row = channel_index // num_cols
        col = channel_index % num_cols
        axs[row, col].scatter(pca_result[:, 0], pca_result[:, 1], c=clusters, cmap='viridis', s=50)
        axs[row, col].set_title(f'Channel {channel_index + 1}')
        axs[row, col].set_xlabel('PCA Component 1')
        axs[row, col].set_ylabel('PCA Component 2')

    # Hide unused subplots if num_channels is not a perfect square
    for i in range(num_channels, num_rows * num_cols):
        row = i // num_cols
        col = i % num_cols
        fig.delaxes(axs[row, col])

    plt.tight_layout()
    plt.subplots_adjust(top=0.95)
    if save_figure:
        save_path = os.path.join(save_directory, f"spike_clusters_{directory_name}.png")
        plt.savefig(save_path)
        print(f"Clustered spikes figure saved: {save_path}")
    plt.show()
    return clusters_data


def plot_raw_spikes(data, clusters, num_channels, lowcut, highcut, fs, directory_name, save_directory,
                    save_figure=False):
    # Calculate the number of rows and columns for the subplots to make them square
    num_cols = int(np.ceil(np.sqrt(num_channels)))
    num_rows = int(np.ceil(num_channels / num_cols))

    fig, axs = plt.subplots(num_rows, num_cols, figsize=(15, 10))
    fig.suptitle(f'Raw Spikes for Each Channel - Directory: {directory_name}')

    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index + 1}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)
        spike_times = detect_spikes(filtered_data)

        if len(spike_times) == 0:
            print(f"No spike waveforms detected for Channel {channel_index + 1}")
            continue

        window_size = 20
        cluster_colors = {}  # Dictionary to store cluster colors for each channel

        for spike_time in spike_times:
            start_index = max(0, spike_time - window_size)
            end_index = min(len(data_channel), spike_time + window_size)
            cluster_color = 'blue'  # Default color if spike does not belong to any cluster
            if channel_index in clusters:
                for cluster_label in clusters[channel_index]:
                    if spike_time in clusters[channel_index][cluster_label]:  # If spike belongs to a cluster
                        cluster_color = plt.cm.viridis(
                            cluster_label / len(clusters[channel_index]))  # Assign cluster color
                        break
            axs[channel_index // num_cols, channel_index % num_cols].plot(filtered_data[start_index:end_index],
                                                                          label=f'Spike {spike_time}',
                                                                          color=cluster_color)

        axs[channel_index // num_cols, channel_index % num_cols].set_title(
            f'Channel {channel_index + 1}, Clusters: {len(clusters[channel_index])}')
        axs[channel_index // num_cols, channel_index % num_cols].set_xlabel('Time (samples)')
        axs[channel_index // num_cols, channel_index % num_cols].set_ylabel('Amplitude (mV)')

    # Hide unused subplots if num_channels is not a perfect square
    for i in range(num_channels, num_rows * num_cols):
        row = i // num_cols
        col = i % num_cols
        fig.delaxes(axs[row, col])

    plt.tight_layout()
    plt.subplots_adjust(top=0.92)
    if save_figure:
        save_path = os.path.join(save_directory, f"raw_spikes_{directory_name}.png")
        plt.savefig(save_path)
        print(f"Raw spikes figure saved: {save_path}")
    plt.show()

def plot_global_spike_clusters(data, num_channels, lowcut, highcut, fs, directory_name, save_directory, save_figure=False):
    num_samples, num_channels = data.shape

    # Combine all channels into one array for clustering
    combined_data = np.ravel(data)

    # Filter the combined data
    filtered_combined_data = bandpass_filter(combined_data, lowcut, highcut, fs)

    # Detect spikes in the combined filtered data
    spike_times = detect_spikes(filtered_combined_data)

    if len(spike_times) == 0:
        print("No spike waveforms detected.")
        return None, None

    # Extract spike waveforms from the combined data
    spike_waveforms = extract_spikes(filtered_combined_data, spike_times)

    if len(spike_waveforms) < 2:
        print("Not enough spike waveforms detected.")
        return None, None

    # Find the optimal number of clusters
    num_clusters = find_optimal_clusters(spike_waveforms)

    print(f"Optimal number of clusters: {num_clusters}")

    # Perform PCA
    pca = PCA(n_components=2)
    pca_result = pca.fit_transform(spike_waveforms)

    # Perform k-means clustering
    kmeans = KMeans(n_clusters=num_clusters, random_state=0)
    clusters = kmeans.fit_predict(spike_waveforms)

    # Plot the PCA results with clustered points
    plt.figure(figsize=(10, 6))
    plt.scatter(pca_result[:, 0], pca_result[:, 1], c=clusters, cmap='viridis', s=50)
    plt.title(f'Global Spike Clusters - Directory: {directory_name}')
    plt.xlabel('PCA Component 1')
    plt.ylabel('PCA Component 2')
    plt.colorbar(label='Cluster')
    plt.tight_layout()

    if save_figure:
        save_path = os.path.join(save_directory, f"global_spike_clusters_{directory_name}.png")
        plt.savefig(save_path)
        print(f"Global spike clusters figure saved: {save_path}")
    plt.show()

    # Generate clusters data
    clusters_data = {}
    for i, spike_time in enumerate(spike_times):
        if i < len(clusters):
            cluster_label = clusters[i]
            if cluster_label not in clusters_data:
                clusters_data[cluster_label] = []
            clusters_data[cluster_label].append(spike_time)
        else:
            print("Index out of bounds:", i)

    return clusters_data


def plot_raw_and_clustered_spikes(data, num_channels, lowcut, highcut, fs, directory_name, save_directory,
                                  save_figure=False):

    clusters_data = {}  # Dictionary to store clusters data for each channel

    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index + 1}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)
        spike_times = detect_spikes(filtered_data)
        spike_waveforms = extract_spikes(filtered_data, spike_times)

        if len(spike_waveforms) < 2:
            print(f"Not enough spike waveforms detected for Channel {channel_index + 1}")
            continue

        # Find the optimal number of clusters
        num_clusters = find_optimal_clusters(spike_waveforms)
        print(f"Optimal number of clusters for Channel {channel_index + 1}: {num_clusters}")

        # Perform PCA
        pca = PCA(n_components=2)
        pca_result = pca.fit_transform(spike_waveforms)

        # Perform k-means clustering
        kmeans = KMeans(n_clusters=num_clusters, random_state=0)
        clusters = kmeans.fit_predict(spike_waveforms)

        clusters_data[channel_index] = {}  # Initialize clusters data for this channel
        for i, spike_time in enumerate(spike_times):
            if i < len(clusters):
                cluster_label = clusters[i]
                if cluster_label not in clusters_data[channel_index]:
                    clusters_data[channel_index][cluster_label] = []
                clusters_data[channel_index][cluster_label].append(spike_time)
            else:
                print("Index out of bounds:", i)

        # Plot clustered PCA
        fig, axs = plt.subplots(1, 2, figsize=(15, 5))
        cluster_colors = plt.cm.viridis(np.linspace(0, 1, num_clusters))
        axs[1].scatter(pca_result[:, 0], pca_result[:, 1], c=cluster_colors[clusters], s=50)
        axs[1].set_title(f'Channel {channel_index}, Clustered PCA')
        axs[1].set_xlabel('PCA Component 1')
        axs[1].set_ylabel('PCA Component 2')

        if len(spike_times) == 0:
            print(f"No spike waveforms detected for Channel {channel_index + 1}")
            continue

        window_size = 20

        for spike_time in spike_times:
            start_index = max(0, spike_time - window_size)
            end_index = min(len(data_channel), spike_time + window_size)
            cluster_color = 'blue'  # Default color if spike does not belong to any cluster
            if channel_index in clusters_data:
                for cluster_label in clusters_data[channel_index]:
                    if spike_time in clusters_data[channel_index][cluster_label]:  # If spike belongs to a cluster
                        cluster_color = cluster_colors[cluster_label]  # Assign cluster color
                        break
            axs[0].plot(filtered_data[start_index:end_index], label=f'Spike {spike_time}', color=cluster_color)
            axs[0].set_title(f'Channel {channel_index}, Raw Spikes')
            axs[0].set_xlabel('Time (samples)')
            axs[0].set_ylabel('Amplitude (mV)')

        plt.tight_layout()
        if save_figure:
            save_path = os.path.join(save_directory, f"raw_and_clustered_spikes_{directory_name}_channel_{channel_index}.png")
            plt.savefig(save_path)
            print(f"Raw and clustered spikes figure saved: {save_path}")
        # plt.show()

    return clusters_data

def plot_spikes_around_best(data, num_channels, fs, directory_name, save_directory, save_figure=False):
    window_size = int(fs)  # Define the window size (1 second before and after the spike)
    plt.figure(figsize=(15, num_channels * 2 + 2))  # Increased figure height

    # Find the maximum absolute value across all channels
    max_value = np.max(np.abs(data))

    # Define RGB values for each color
    channel_colors = [(0.8, 0.8, 0),
                      (0, 0.7, 0),
                      (1, 0.647, 0),
                      (0.713, 0.545, 0.765),
                      (1, 0, 0),
                      (0.647, 0.165, 0.165),
                      (0.867, 0.627, 0.867),
                      (0.867, 0.527, 0.667)]

    for channel_index in range(num_channels):
        plt.subplot(num_channels, 1, channel_index + 1)
        plt.subplots_adjust(hspace=0.9)
        # Find the index of the spike with the highest amplitude
        spike_indices = detect_spikes(data[:, channel_index])
        best_spike_index = max(spike_indices, key=lambda x: abs(data[:, channel_index][x]))
        best_spike_time = best_spike_index / fs

        start_index = max(0, int(best_spike_time - window_size))
        end_index = min(len(data), int(best_spike_time + window_size))
        time = np.arange(start_index, end_index) / fs
        data_channel = data[start_index:end_index, channel_index]

        # Plot the data
        color_index = channel_index % len(channel_colors)
        channel_color = channel_colors[color_index]
        plt.plot(time, data_channel, label=f'Spike at {best_spike_time}', color=channel_color)

        # Set y-axis limits for each subplot
        plt.ylim(-max_value*0.3, max_value*0.3)

        # Set title for each subplot
        plt.title(f'Channel {channel_index + 1}')
        if channel_index == 4:
            plt.ylabel('Amplitude (uV)', y=0.5)
    plt.xlabel('Time (s)')
    # Set main title for the figure
    plt.suptitle("Python GUI - 1 second of raw data from a single isolated neuron")

    if save_figure:
        save_path = os.path.join(save_directory, f"spike_around_best_{directory_name}.png")
        plt.savefig(save_path)
        print(f"Spike around best figure saved: {save_path}")
    plt.show()


def plot_raw_cluster_with_average(data, clusters, num_channels, lowcut, highcut, fs, directory_name, save_directory,
                                  save_figure=False):
    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index + 1}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)
        spike_times = detect_spikes(filtered_data)

        if len(spike_times) == 0:
            print(f"No spike waveforms detected for Channel {channel_index + 1}")
            continue

        num_clusters = len(clusters.get(channel_index, {}))
        if num_clusters == 0:
            print(f"No clusters detected for Channel {channel_index + 1}")
            continue

        num_cols = int(np.ceil(np.sqrt(num_clusters)))
        num_rows = int(np.ceil(num_clusters / num_cols)) if num_clusters > 1 else 1

        fig, axs = plt.subplots(num_rows, num_cols, figsize=(15, 10)) if num_clusters > 1 else plt.subplots(
            figsize=(15, 10))
        fig.suptitle(f'Channel {channel_index + 1} - Raw Spikes and Cluster Averages')

        # Ensure axs is always a 1D array for easier indexing
        if num_clusters == 1:
            axs = [axs]  # Convert single plot into a list for consistency
        elif isinstance(axs, np.ndarray):
            axs = axs.ravel()  # Flatten into 1D array if it's a multi-plot layout

        # Dictionary to hold spike waveforms for each cluster
        cluster_waveforms = {cluster_label: [] for cluster_label in clusters.get(channel_index, {})}

        # Determine a fixed length for waveforms
        fixed_length = 40  # Adjust this value based on your requirements

        for spike_time in spike_times:
            start_index = max(0, spike_time - 20)
            end_index = min(len(data_channel), spike_time + 20)
            spike_waveform = filtered_data[start_index:end_index]

            # Pad or truncate the waveform to the fixed length
            if len(spike_waveform) < fixed_length:
                spike_waveform = np.pad(spike_waveform, (0, fixed_length - len(spike_waveform)), mode='constant')
            else:
                spike_waveform = spike_waveform[:fixed_length]

            # Assign waveform to cluster
            if channel_index in clusters:
                for cluster_label in clusters[channel_index]:
                    if spike_time in clusters[channel_index][cluster_label]:
                        cluster_waveforms[cluster_label].append(spike_waveform)
                        break

        # Plot each cluster
        for cluster_index, (cluster_label, waveforms) in enumerate(cluster_waveforms.items()):
            ax = axs[cluster_index] if num_clusters > 1 else axs[0]  # Handle single and multiple clusters

            for waveform in waveforms:
                ax.plot(waveform, color="k")  # Plot waveform on the correct ax (Matplotlib axes)

            # Calculate and plot the average waveform in red
            if waveforms:
                avg_waveform = np.mean(np.array(waveforms), axis=0)
                ax.plot(avg_waveform, color='red', label='Average Spike', linewidth=2)

            ax.set_title(f'Cluster {cluster_label}')
            ax.set_xlabel('Time (samples)')
            ax.set_ylabel('Amplitude (mV)')
            ax.legend()

        # Hide unused subplots if num_clusters is not a perfect square
        if num_clusters > 1:
            for i in range(num_clusters, num_rows * num_cols):
                fig.delaxes(axs[i])

        plt.tight_layout()
        plt.subplots_adjust(top=0.95)
        plt.show()
        if save_figure:
            save_path = os.path.join(save_directory,
                                     f"raw_spikes_with_averages_channel_{channel_index + 1}_{directory_name}.png")
            plt.savefig(save_path)
            print(f"Raw spikes with averages figure saved: {save_path}")

        plt.close(fig)



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

        clusters = plot_clustered_spikes(data, num_channels, lowcut=lowcut, highcut=highcut,
                              fs=continuous.metadata['sample_rate'], directory_name=directory_name,
                              save_directory=save_directory, save_figure=True)
        #
        # plot_raw_spikes(data, clusters, num_channels, lowcut=lowcut, highcut=highcut,
        #                 fs=continuous.metadata['sample_rate'], directory_name=directory_name,
        #                 save_directory=save_directory, save_figure=True)
        #
        # clusters = plot_global_spike_clusters(data, num_channels, lowcut=lowcut, highcut=highcut,
        #                       fs=continuous.metadata['sample_rate'], directory_name=directory_name,
        #                       save_directory=save_directory, save_figure=True)
        #
        #
        # plot_raw_and_clustered_spikes(data, num_channels, lowcut=lowcut, highcut=highcut,
        #                 fs=continuous.metadata['sample_rate'], directory_name=directory_name,
        #                 save_directory=save_directory, save_figure=True)


        plot_raw_cluster_with_average(data, clusters, num_channels, lowcut, highcut, fs, directory_name, save_directory,
                                  save_figure=False)
