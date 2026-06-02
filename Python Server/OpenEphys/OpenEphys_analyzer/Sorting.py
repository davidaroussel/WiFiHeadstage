import os
os.environ["OMP_NUM_THREADS"] = "1"
import numpy as np
from datetime import datetime
from open_ephys.analysis import Session

#TRICK TO DISPLAY PLT FIGURE ON GUI
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

from sklearn.decomposition import PCA

from collections import defaultdict

from Tools import *



def perform_pca_and_clustering(data, window_size, num_components=5):
    pca_results = []
    cluster_list = []
    clusters_data = {}
    num_channels = data.shape[1]
    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)

        spike_times = detect_spikes(filtered_data, window_size=window_size)
        spike_waveforms = extract_spikes(filtered_data, spike_times)

        if len(spike_waveforms) < 2:
            print(f"Not enough spike waveforms detected for Channel {channel_index}")
            continue

        # Perform PCA
        pca = PCA(n_components=num_components)
        pca_result = pca.fit_transform(spike_waveforms)
        pca_results.append(pca_result)
        # print('Explained variance ratio:', pca.explained_variance_ratio_)

        # Find the optimal number of clusters
        num_clusters = find_optimal_clusters(pca_result)
        print(f"Optimal number of clusters for Channel {channel_index}: {num_clusters}")

        # Perform k-means clustering
        kmeans = KMeans(n_clusters=num_clusters, random_state=0)
        clusters = kmeans.fit_predict(spike_waveforms)
        cluster_list.append(clusters)

        clusters_data[channel_index] = {}
        for i, spike_time in enumerate(spike_times):
            if i < len(clusters):
                cluster_label = clusters[i]
                if cluster_label not in clusters_data[channel_index]:
                    clusters_data[channel_index][cluster_label] = []
                clusters_data[channel_index][cluster_label].append(spike_time)
            else:
                print("Index out of bounds:", i)


        # Calculate and plot statistics for this channel
<<<<<<< HEAD:WiFiHeadstage V1/Python/OpenEphys/OpenEphys analyzer/Sorting.py
        calculate_cluster_statistics(spike_waveforms, clusters, time_period=0.1)
=======
        # calculate_cluster_statistics(spike_waveforms, clusters, time_period=0.1)
>>>>>>> 84418e0d4bc2f894c7f7ec520b18aa74e4cf84ab:Python Server/OpenEphys/OpenEphys analyzer/Sorting.py

    return pca_results, cluster_list, clusters_data


def calculate_cluster_statistics(spike_waveforms, clusters, time_period):
    cluster_stats = defaultdict(lambda: {'count': 0, 'widths': []})

    for waveform, cluster in zip(spike_waveforms, clusters):
        # Calculate width between max and min values of the spike
        max_idx = np.argmax(waveform)
        min_idx = np.argmin(waveform[max_idx:]) + max_idx
        width = min_idx - max_idx  # Width between max and min

        cluster_stats[cluster]['count'] += 1
        cluster_stats[cluster]['widths'].append(width)

    # Prepare data for plotting
    occurrence_rates = []
    widths = []
    cluster_labels = []

    for cluster, stats in cluster_stats.items():
        occurrence_rate = stats['count'] / time_period  # Calculate occurrence rate
        avg_width = np.mean(stats['widths']) if stats['widths'] else 0  # Average width
        occurrence_rates.append(occurrence_rate)
        widths.append(avg_width)
        cluster_labels.append(cluster)


    plt.figure(figsize=(10, 6))
    scatter = plt.scatter(occurrence_rates, widths, c=cluster_labels, cmap='viridis', alpha=0.7)
    plt.colorbar(scatter, label='Cluster')
    plt.title('Spike Clusters: Occurrence Rate vs Width')
    plt.xlabel('Occurrence Rate (spikes/s)')
    plt.ylabel('Spike Width (samples)')
    plt.show()


def plot_cluster_raw_spikes(data, clusters, window_size,  num_channels, lowcut, highcut, fs, directory_name, save_directory,
                    save_figure=False):
    # Calculate the number of rows and columns for the subplots to make them square
    num_cols = int(np.ceil(np.sqrt(num_channels)))
    num_rows = int(np.ceil(num_channels / num_cols))

    fig, axs = plt.subplots(num_rows, num_cols, figsize=(15, 10))
    fig.suptitle(f'Raw Spikes for Each Channel - Directory: {directory_name}')

    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)
        spike_times = detect_spikes(filtered_data)

        if len(spike_times) == 0:
            print(f"No spike waveforms detected for Channel {channel_index}")
            continue

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
            f'Channel {channel_index}, Clusters: {len(clusters[channel_index])}')
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



def plot_all_channel_spike_clusters(data, lowcut, highcut, fs, directory_name, save_directory, save_figure=False):
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
    print("\n")
    print("Optimal number of clusters for all channels: ", num_clusters)

    # Perform PCA
    pca = PCA(n_components=5)
    pca_result = pca.fit_transform(spike_waveforms)

    # Perform k-means clustering
    kmeans = KMeans(n_clusters=num_clusters, random_state=0)
    clusters = kmeans.fit_predict(pca_result)

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


def plot_raw_and_clustered_spikes(data, pca_results, cluster_list, clusters_data, num_channels,
                                                    lowcut, highcut, fs, directory_name, save_directory, window_size,
                                                    save_figure=False):
    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)
        spike_times = detect_spikes(filtered_data)
        spike_waveforms = extract_spikes(filtered_data, spike_times)

        if len(spike_waveforms) < 2:
            print(f"Not enough spike waveforms detected for Channel {channel_index}")
            continue

        # Get PCA results and clusters for the current channel
        pca_result = pca_results[channel_index]
        clusters = cluster_list[channel_index]

        # Plot clustered PCA
        fig, axs = plt.subplots(1, 2, figsize=(15, 5))
        num_clusters = len(np.unique(clusters))
        cluster_colors = plt.cm.viridis(np.linspace(0, 1, num_clusters))

        axs[1].scatter(pca_result[:, 0], pca_result[:, 1], c=cluster_colors[clusters], s=50)
        axs[1].set_title(f'Channel {channel_index}, Clustered PCA')
        axs[1].set_xlabel('PCA Component 1')
        axs[1].set_ylabel('PCA Component 2')

        if len(spike_times) == 0:
            print(f"No spike waveforms detected for Channel {channel_index}")
            continue

        for spike_time in spike_times:
            start_index = max(0, spike_time - window_size)
            end_index = min(len(data_channel), spike_time + window_size)
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
            save_path = os.path.join(save_directory,
                                     f"raw_and_clustered_spikes_{directory_name}_channel_{channel_index}.png")
            plt.savefig(save_path)
            print(f"Raw and clustered spikes figure saved: {save_path}")
        plt.show()

    return clusters_data


def plot_raw_cluster_with_average(data, clusters, num_channels, lowcut, highcut, fs, directory_name, save_directory,
                                  save_figure=False):
    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)
        spike_times = detect_spikes(filtered_data)
        spike_waveforms = extract_spikes(filtered_data, spike_times)

        global_x_min, global_x_max = float('inf'), float('-inf')  # For finding global min/max for X-axis
        global_y_min, global_y_max = float('inf'), float('-inf')  # For finding global min/max for Y-axis

        avg_waveform_list = []

        # Add a figure with two subplots: one for raw data and one for filtered data
        # fig, axs = plt.subplots(1, 2, figsize=(15, 5))
        # fig.suptitle(f'Channel {channel_index} - Raw vs Filtered Data')
        # Plot raw data
        # axs[0].plot(data_channel, color='blue')
        # axs[0].set_title(f'Raw Data - Channel {channel_index}')
        # axs[0].set_xlabel('Time (samples)')
        # axs[0].set_ylabel('Amplitude')
        # # Plot filtered data
        # axs[1].plot(filtered_data, color='orange')
        # axs[1].set_title(f'Filtered Data - Channel {channel_index}')
        # axs[1].set_xlabel('Time (samples)')
        # axs[1].set_ylabel('Amplitude')
        # plt.tight_layout()
        # plt.show()

        # for idx, spike in enumerate(spike_waveforms):
        #     fig, axs = plt.subplots(figsize=(15, 5))
        #     fig.suptitle(f'Channel {channel_index} - Spike Waveform {idx}')
        #     axs.plot(spike, color='blue')
        #     axs.set_xlabel('Time (samples)')
        #     axs.set_ylabel('Amplitude')
        #     plt.tight_layout()
        #     plt.show()

        if len(spike_times) == 0:
            print(f"No spike waveforms detected for Channel {channel_index}")
            continue

        num_clusters = len(clusters.get(channel_index, {}))
        if num_clusters == 0:
            print(f"No clusters detected for Channel {channel_index}")
            continue

        num_cols = int(np.ceil(np.sqrt(num_clusters)))
        num_rows = int(np.ceil(num_clusters / num_cols)) if num_clusters > 1 else 1

        fig, axs = plt.subplots(num_rows, num_cols, figsize=(15, 10)) if num_clusters > 1 else (
                   plt.subplots(figsize=(15, 10)))
<<<<<<< HEAD:WiFiHeadstage V1/Python/OpenEphys/OpenEphys analyzer/Sorting.py
        fig.suptitle(f'Channel {channel_index} - Raw Spikes and Cluster Averages')
=======
        fig.suptitle(f'Channel {channel_index} - Raw Spikes and Cluster Averages',
                     fontsize=18, fontweight='bold')
>>>>>>> 84418e0d4bc2f894c7f7ec520b18aa74e4cf84ab:Python Server/OpenEphys/OpenEphys analyzer/Sorting.py

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

            # Update global min/max for X and Y axes
            for waveforms in cluster_waveforms.values():
                for waveform in waveforms:
                    global_x_min = min(global_x_min, 0)
                    global_x_max = max(global_x_max, len(waveform) - 1)
                    global_y_min = min(global_y_min, np.min(waveform))
                    global_y_max = max(global_y_max, np.max(waveform))

        # Plot each cluster
        for cluster_index, (cluster_label, waveforms) in enumerate(cluster_waveforms.items()):
            ax = axs[cluster_index] if num_clusters > 1 else axs[0]  # Handle single and multiple clusters

            for waveform in waveforms:
                ax.plot(waveform, color="k")  # Plot waveform on the correct ax (Matplotlib axes)

            # Calculate and plot the average waveform in red
            if waveforms:
                avg_waveform = np.mean(np.array(waveforms), axis=0)
                avg_waveform_list.append(avg_waveform)
                ax.plot(avg_waveform, color='red', label='Average Spike', linewidth=2)

<<<<<<< HEAD:WiFiHeadstage V1/Python/OpenEphys/OpenEphys analyzer/Sorting.py
            ax.set_title(f'Cluster {cluster_label}')
            ax.set_xlabel('Time (samples)')
            ax.set_ylabel('Amplitude (mV)')
=======
            ax.set_title(f'Cluster {cluster_label}', fontsize=14)
            ax.set_xlabel('Time (samples)', fontsize=12)
            ax.set_ylabel('Amplitude (uV)', fontsize=12)
>>>>>>> 84418e0d4bc2f894c7f7ec520b18aa74e4cf84ab:Python Server/OpenEphys/OpenEphys analyzer/Sorting.py
            ax.set_xlim(global_x_min, global_x_max)
            ax.set_ylim(global_y_min, global_y_max)
            ax.legend()

        # Hide unused subplots if num_clusters is not a perfect square
        if num_clusters > 1:
            for i in range(num_clusters, num_rows * num_cols):
                fig.delaxes(axs[i])

        plt.tight_layout()
        plt.subplots_adjust(top=0.95)
        if save_figure:
            save_path = os.path.join(save_directory,
                                     f"raw_spikes_with_averages_channel_{channel_index}_{directory_name}.png")
            plt.savefig(save_path)
            print(f"Raw spikes with averages figure saved: {save_path}")

<<<<<<< HEAD:WiFiHeadstage V1/Python/OpenEphys/OpenEphys analyzer/Sorting.py
=======

        fig, axs = plt.subplots(figsize=(15, 15))
        fig.suptitle(f'Channel {channel_index} - Average Spikes', fontsize=20, fontweight='bold')
        for idx, waveform in enumerate(avg_waveform_list):
            axs.plot(waveform)
        axs.set_xlabel('Time (samples)', fontsize=18)
        axs.set_ylabel('Amplitude (uV)', fontsize=18)
        plt.show()
        plt.close(fig)
>>>>>>> 84418e0d4bc2f894c7f7ec520b18aa74e4cf84ab:Python Server/OpenEphys/OpenEphys analyzer/Sorting.py

        fig, axs = plt.subplots(figsize=(15, 15))
        fig.suptitle(f'Channel {channel_index} - Average Spikes')
        for idx, waveform in enumerate(avg_waveform_list):
            axs.plot(waveform)
        axs.set_xlabel('Time (samples)')
        axs.set_ylabel('Amplitude (mV)')
        plt.show()
        plt.close(fig)

if __name__ == '__main__':
    # Define the directory for analysis results
    src_directory = r'../../analysis_results/'

    # Define the directory for raw data in Open Ephys format
    base_directory = r'C:\Users\david\OneDrive\Ph.D G. ELECTRIQUE\Wi-Fi Headstage\SCOPE\2024-04-25\GOOD\New folder'
    current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    # Define the save directory with the current date and time
    save_directory = os.path.join(src_directory, current_time)
    if not os.path.exists(save_directory):
        os.makedirs(save_directory)
    experiment_directories = [os.path.join(base_directory, directory) for directory in os.listdir(base_directory) if
                              os.path.isdir(os.path.join(base_directory, directory))]
    lowcut = 180.0
    highcut = 3000

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
        window_size = 30
        # Compute PCA and clusters
        pca_results, cluster_list, clusters_data = perform_pca_and_clustering(data, window_size,  num_components=5)

        # PLOT THE RAW SORTED SPIKES WITH THE AVERAGE FOR EACH CLUSTERS
        # plot_raw_cluster_with_average(data, clusters_data, num_channels, lowcut, highcut, fs, directory_name, save_directory, save_figure=False)

        # PLOTS THE PCA FOR ALL THE CHANNELS IN 1 FIGURE
        # plot_all_channel_spike_clusters(data, lowcut, highcut, fs, directory_name, save_directory, save_figure=False)

        # PLOTS THE RAW SPIKES FOR ALL THE CHANNELS IN INDIVIDUAL FIGURES
        # plot_cluster_raw_spikes(data, clusters_data, window_size, num_channels, lowcut=lowcut, highcut=highcut,
        #                 fs=continuous.metadata['sample_rate'], directory_name=directory_name,
        #                 save_directory=save_directory, save_figure=False)

        # Plots single channel Clustered PCA and Raw Sorted Spikes
        # plot_raw_and_clustered_spikes(data, pca_results, cluster_list, clusters_data, num_channels,
        #                             lowcut, highcut, fs, directory_name, save_directory, window_size,
        #                             save_figure=False)

