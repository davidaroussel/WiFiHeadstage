import os
os.environ["OMP_NUM_THREADS"] = "1"
import numpy as np
from datetime import datetime
from scipy.signal import butter, filtfilt
import numpy as np
from open_ephys.analysis import *
import csv

#TRICK TO DISPLAY PLT FIGURE ON GUI
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import matplotlib.ticker as ticker

from Tools import *


def plot_spikes_one_figure(data, num_channels, lowcut, highcut, fs, directory_name, save_directory, save_figure=False):
    plt.figure(figsize=(10, 6))
    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index + 1}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)
        spike_times = detect_spikes(filtered_data)
        spike_waveforms = extract_spikes(filtered_data, spike_times)
        if len(spike_waveforms) == 0:
            print(f"No spike waveforms detected for Channel {channel_index + 1}")
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
        if np.isnan(snr):
            print(f"SNR for Channel {channel_index + 1}: NaN")
        else:
            print(f"SNR for Channel {channel_index + 1}: {snr} dB")
        plt.plot(avg_spike_waveform, label=f'Channel {channel_index + 1}')
    plt.title(f'Average Spike Waveforms for All Channels - Directory: {directory_name}')
    plt.xlabel('Time (samples)')
    plt.ylabel('Amplitude (mV)')
    plt.legend()
    if save_figure:
        save_path = os.path.join(save_directory, f"spikes_one_figure{directory_name}.png")
        plt.savefig(save_path)
        print(f"Figure saved: {save_path}")
    plt.show()

def plot_all_spikes_separate_figure(data, num_channels, lowcut, highcut, fs, directory_name, save_directory, save_figure=False):
    window_size = 20
    plt.figure(figsize=(15, 20))
    plt.suptitle(f'All Spikes for Each Channel - Directory: {directory_name}')
    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index + 1}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)
        spike_times = detect_spikes(filtered_data)
        if len(spike_times) == 0:
            print(f"No spike waveforms detected for Channel {channel_index + 1}")
            continue
        plt.subplot(num_channels, 1, channel_index + 1)
        for spike_time in spike_times:
            start_index = max(0, spike_time - window_size)
            end_index = min(len(data_channel), spike_time + window_size)
            plt.plot(filtered_data[start_index:end_index], label=f'Spike {spike_time}')
        plt.title(f'Channel {channel_index + 1}')
        plt.xlabel('Time (samples)')
        plt.ylabel('Amplitude (mV)')
    plt.tight_layout()
    plt.subplots_adjust(top=0.95)
    if save_figure:
        save_path = os.path.join(save_directory, f"all_spikes_separate_figure_{directory_name}.png")
        plt.savefig(save_path)
        print(f"Figure saved: {save_path}")
    plt.show()

def plot_extracted_noise(data, num_channels, lowcut, highcut, fs, directory_name, save_directory, save_figure=False):
    plt.figure(figsize=(10, 6))
    for channel_index in range(num_channels):
        print(f"\nProcessing Channel {channel_index + 1}")
        data_channel = data[:, channel_index]
        filtered_data = bandpass_filter(data_channel, lowcut, highcut, fs)
        spike_times = detect_spikes(filtered_data)
        noise_segments = extract_noise(filtered_data, spike_times)
        if len(noise_segments) == 0:
            print(f"No noise segments extracted for Channel {channel_index + 1}")
            continue
        plt.plot(noise_segments, label=f'Channel {channel_index + 1}')
    plt.title(f'Extracted Noise Segments for All Channels - Directory: {directory_name}')
    plt.xlabel('Time (samples)')
    plt.ylabel('Amplitude (mV)')
    plt.legend()
    if save_figure:
        save_path = os.path.join(save_directory, f"extracted_noise_{directory_name}.png")
        plt.savefig(save_path)
        print(f"Figure saved: {save_path}")
    plt.show()

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


def plot_spikes_around_best(data, num_channels, fs, directory_name, save_directory, save_figure=False):
    window_size = 0.04 * fs
    # window_size = 0.5 * fs

    # Calculate the number of rows and columns dynamically for subplots
    cols = int(np.ceil(np.sqrt(num_channels)))
    rows = int(np.ceil(num_channels / cols))

    fig, axs = plt.subplots(rows, cols, figsize=(15, rows * 2 + 2))  # Adjust figure size based on number of channels
    axs = axs.ravel()  # Flatten the 2D axes array for easy iteration

    # Find the maximum absolute value across all channels
    max_value = np.max(np.abs(data))

    for channel_index in range(num_channels):
        ax = axs[channel_index]

        # Find the index of the spike with the highest amplitude
        spike_indices = detect_spikes(data[:, channel_index])
        best_spike_index = max(spike_indices, key=lambda x: abs(data[:, channel_index][x]))
        best_spike_time = best_spike_index / fs  # Spike time in seconds

        start_index = max(0, int(best_spike_index - window_size))
        end_index = min(len(data), int(best_spike_index + window_size))

        # Generate time array with absolute time values in seconds
        time = np.arange(start_index, end_index) / fs
        data_channel = data[start_index:end_index, channel_index]

        # Plot the data for this channel in black
        ax.plot(time, data_channel, label=f'Spike at {best_spike_time:.3f}s', color='black')

        # Set y-axis limits for each subplot
        ax.set_ylim(-max_value, max_value)

        # Set title for each subplot, with a larger font size
        ax.set_title(f'Channel {channel_index + 1}', fontsize=16)

        # Set labels for the middle plots
        ax.set_ylabel('Amplitude (uV)', y=0.5, fontsize=14)
        ax.set_xlabel('Time (s)', y=0.5, fontsize=14)
        ax.xaxis.set_major_locator(ticker.MaxNLocator(6))


    # Hide any empty subplots if the number of channels isn't a perfect square
    for i in range(num_channels, rows * cols):
        axs[i].axis('off')

    # Set main title for the figure
    plt.suptitle("Best spikes for each channel connected to single isolated neurons in a 2-minute recording",
                 fontsize=18,
                 fontweight='bold')

    # Save the figure if required
    if save_figure:
        save_path = os.path.join(save_directory, f"spike_around_best_{directory_name}.png")
        plt.savefig(save_path)
        print(f"Spike around best figure saved: {save_path}")

    plt.show()

def plot_best_spike_with_surrounding_individual(data, num_channels, fs, directory_name, save_directory, save_figure=False):
    enlarged_window = 100 * fs
    time_window = 0.5 * fs  # 0.5 seconds before and after the spike
    total_window = 2 * time_window  # Total window size (1 second)
    zoomed_window = 1.5 * fs
    zoomed_window_red = 0.002 * fs

    for channel_index in range(num_channels):
        channel_data = data[:, channel_index]

        # Detect spikes in the current channel
        spike_indices = detect_spikes(channel_data)

        if len(spike_indices) == 0:
            print(f"No spikes detected for Channel {channel_index + 1}")
            continue

        # Find the spike with the highest amplitude
        best_spike_index = max(spike_indices, key=lambda x: abs(channel_data[x]))

        start_index_enlarged = int(max(0, best_spike_index - enlarged_window))
        end_index_enlarged = int(min(len(channel_data), best_spike_index + enlarged_window))
        time_enlarged = np.arange(start_index_enlarged, end_index_enlarged) / fs  # Time axis for the window

        start_index = int(max(0, best_spike_index - time_window))
        end_index = int(min(len(channel_data), best_spike_index + time_window))
        time = np.arange(start_index, end_index) / fs  # Time axis for the window

        start_index_zoom_red = int(max(0, best_spike_index - (zoomed_window_red)))
        end_index_zoomed_red = int(min(len(channel_data), best_spike_index + (zoomed_window_red)))
        time_zoomed_red = np.arange(start_index_zoom_red, end_index_zoomed_red) / fs  # Time axis for the window

        start_index_zoomed = int(max(0, best_spike_index - (zoomed_window)))
        end_index_zoomed = int(min(len(channel_data), best_spike_index + (zoomed_window)))
        time_zoomed = np.arange(start_index_zoomed, end_index_zoomed) / fs  # Time axis for the window


        # Plot the data for the 10 seconds before and after the best spike
        fig, ax = plt.subplots(figsize=(15, 10))
        ax.plot(time_enlarged, channel_data[start_index_enlarged:end_index_enlarged], color='black')
        ax.plot(time_zoomed_red, channel_data[start_index_zoom_red:end_index_zoomed_red], color='red')
        ax.set_title(f'Channel {channel_index + 1} - Best Spike - Enlarged')
        ax.set_xlabel('Time (s)')
        ax.set_ylabel('Amplitude (µV)')

        if save_figure:
            save_path = os.path.join(save_directory, f"best_spike_channel_{channel_index + 1}.png")
            plt.savefig(save_path)
            print(f"Best spike with surrounding data figure saved: {save_path} - Zoomed out")


        # Plot the data for the 10 seconds before and after the best spike
        fig, ax = plt.subplots(figsize=(15, 10))
        ax.plot(time, channel_data[start_index:end_index], color='black')
        ax.plot(time_zoomed_red, channel_data[start_index_zoom_red:end_index_zoomed_red], color='red')
        ax.set_title(f'Channel {channel_index + 1} - Best Spike')
        ax.set_xlabel('Time (s)')
        ax.set_ylabel('Amplitude (µV)')

        # Set the Y-axis limit based on the maximum amplitude across all channels
        max_amplitude = np.max(np.abs(channel_data[start_index:end_index]))
        y_limit = (-max_amplitude, max_amplitude)
        ax.set_ylim(y_limit)
        ax.xaxis.set_major_locator(ticker.MaxNLocator(5))  # Set maximum 5 major ticks on the X-axis

        if save_figure:
            save_path = os.path.join(save_directory, f"best_spike_channel_{channel_index + 1}.png")
            plt.savefig(save_path)
            print(f"Best spike with surrounding data figure saved: {save_path} - Normal")


        fig, ax = plt.subplots(figsize=(15, 10))
        ax.plot(time_zoomed, channel_data[start_index_zoomed:end_index_zoomed], color='black')
        ax.plot(time_zoomed_red, channel_data[start_index_zoom_red:end_index_zoomed_red], color='red')
        ax.set_title(f'Channel {channel_index + 1} - Best Spike - Zoomed')
        ax.set_xlabel('Time (s)')
        ax.set_ylabel('Amplitude (µV)')



        fig, ax = plt.subplots(figsize=(15, 10))
        ax.plot(time_zoomed_red, channel_data[start_index_zoom_red:end_index_zoomed_red], color='red')
        ax.set_title(f'Channel {channel_index + 1} - Best Spike - Zoomedx2')
        ax.set_xlabel('Time (s)')
        ax.set_ylabel('Amplitude (µV)')

        # Set the Y-axis limit based on the maximum amplitude across all channels

        if save_figure:
            save_path = os.path.join(save_directory, f"best_spike_channel_{channel_index + 1} - Zoomed In.png")
            plt.savefig(save_path)
            print(f"Best spike with surrounding data figure saved: {save_path}")

        plt.show()


def plot_all_data(data, num_channels, events, fs, directory_name, save_directory, save_figure=False):

    # Extract TTL events
    ttl_timestamps = events['timestamp']  # Timestamps in seconds
    ttl_states = events['state']  # Rising (1) and falling (0) edges
    ttl_events = events
    ttl_data = []
    for ttl_signal in ttl_events.values:
        ttl_data.append([ttl_signal[0], ttl_signal[1], ttl_signal[6]])

    ttl_dict = {}
    active_ttl = {}
    for ttl_id, sample_index, state in ttl_data:
        if state == 1:  # Rising edge
            active_ttl[ttl_id] = sample_index
        elif state == 0 and ttl_id in active_ttl:  # Falling edge
            if ttl_id not in ttl_dict:
                ttl_dict[ttl_id] = []
            ttl_dict[ttl_id].append((active_ttl[ttl_id], sample_index))
            del active_ttl[ttl_id]

    last_sample_index = data.shape[0]
    for ttl_id, start_sample in active_ttl.items():
        if ttl_id not in ttl_dict:
            ttl_dict[ttl_id] = []
        ttl_dict[ttl_id].append((start_sample, last_sample_index))

    # Assign unique colors for each TTL ID
    unique_ttl_ids = sorted(ttl_dict.keys())
    ttl_colors = {ttl_id: color for ttl_id, color in zip(unique_ttl_ids, plt.cm.tab10(np.linspace(0, 1, len(unique_ttl_ids))))}

    # Set up figure with subplots
    fig, axs = plt.subplots(num_channels, 1, figsize=(12, 2 * num_channels), sharex=True)
    fig.suptitle(f'Raw Data for All Channels - Directory: {directory_name}')

    for channel_index in range(num_channels):
        axs[channel_index].plot(np.arange(data.shape[0]), data[:, channel_index], color='black',
                                label=f'Ch {channel_index + 1}')

        # Overlay TTL events with different colors
        for ttl_id, ranges in ttl_dict.items():
            for start, end in ranges:
                axs[channel_index].axvspan(start, end, color=ttl_colors[ttl_id], alpha=0.3, label=f'TTL {ttl_id}')

        axs[channel_index].set_ylabel(f'Ch {channel_index + 1}')
        axs[channel_index].grid(True, linestyle='--', alpha=0.6)


    axs[-1].set_xlabel('Sample Index')  # Label only the last subplot for clarity
    axs[-1].xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'{int(x)}'))
    plt.tight_layout(rect=[0, 0, 1, 0.96])  # Adjust layout to fit title

    if save_figure:
        save_path = os.path.join(save_directory, f"all_data_{directory_name}.png")
        plt.savefig(save_path)
        print(f"Figure saved: {save_path}")

    plt.show()



if __name__ == '__main__':
    src_directory = r'../../analysis_results/'
    base_directory = r'C:\Users\david\Documents\Open Ephys\New folder'
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
        events = recording.events

        # Get the length of the continuous data
        num_samples_continuous = continuous.samples.shape[0]
        sample_rate = continuous.metadata['sample_rate']
        recording_duration_seconds = num_samples_continuous / sample_rate
        start_sample_index = 0

        print(f"{num_samples_continuous} samples recorded at {sample_rate} Hz.")
        print(f"Recording duration: {recording_duration_seconds:.2f} seconds")

        # Store the recording duration in the experiment_data dictionary
        experiment_data[directory_name] = {
            "num_samples": num_samples_continuous,
            "sample_rate": sample_rate,
            "duration_seconds": recording_duration_seconds,
        }

        data = continuous.get_samples(0, num_samples_continuous)
        num_samples, num_channels = data.shape
        print(f"Numbers of channels: {num_channels}")
        # plot_spikes_one_figure(data, num_channels, lowcut=180.0, highcut=3000.0, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=True)
        # plot_all_spikes_separate_figure(data, num_channels, lowcut=180.0, highcut=3000.0, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=True)
        # plot_extracted_noise(data, num_channels, lowcut=180.0, highcut=3000.0, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=True)
        # plot_spikes_around_best(data, num_channels, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=False)

        # plot_best_spike_with_surrounding_individual(data, num_channels, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=False)

        plot_all_data(data, num_channels, events,  fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=False)