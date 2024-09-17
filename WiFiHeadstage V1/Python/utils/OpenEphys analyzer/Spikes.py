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

import matplotlib.ticker as ticker

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
def detect_spikes(data, threshold_factor=4, window_size=30):
    """
    Detect spikes based on the threshold and find the highest amplitude for each spike within a window size.

    Parameters:
    - data: The signal data to analyze.
    - threshold_factor: Multiplier for the standard deviation to set the threshold.
    - window_size: Size of the window to search for the highest amplitude around each detected spike.

    Returns:
    - spike_times: Array of indices where spikes are detected based on the highest amplitude within the window.
    """
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

# Extract spike waveforms
def extract_spikes(data, spike_times, window_size=30):
    spikes = []
    for t in spike_times:
        if t > window_size and t < len(data) - window_size:
            spikes.append(data[t - window_size:t + window_size])
    return np.array(spikes)

# Calculate RMS of signal (average spike waveform)
def rms(signal):
    return np.sqrt(np.mean(signal ** 2))

# Estimate noise by selecting segments without spikes
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
    plt.suptitle("1 second of raw data from a single isolated neuron")

    if save_figure:
        save_path = os.path.join(save_directory, f"spike_around_best_{directory_name}.png")
        plt.savefig(save_path)
        print(f"Spike around best figure saved: {save_path}")
    plt.show()



def plot_best_spike_with_surrounding_individual(data, num_channels, fs, directory_name, save_directory, save_figure=False):
    enlarged_window = 15 * fs
    time_window = 0.5 * fs  # 0.5 seconds before and after the spike
    total_window = 2 * time_window  # Total window size (1 second)
    zoomed_window = 0.01 * fs
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


        # Plot the data for the 10 seconds before and after the best spike
        fig, ax = plt.subplots(figsize=(15, 10))
        ax.plot(time_enlarged, channel_data[start_index_enlarged:end_index_enlarged], color='black')
        ax.plot(time_zoomed_red, channel_data[start_index_zoom_red:end_index_zoomed_red], color='red')
        ax.set_title(f'Channel {channel_index + 1} - Best Spike')
        ax.set_xlabel('Time (s)')
        ax.set_ylabel('Amplitude (µV)')

        if save_figure:
            save_path = os.path.join(save_directory, f"best_spike_channel_{channel_index + 1}.png")
            plt.savefig(save_path)
            print(f"Best spike with surrounding data figure saved: {save_path}")


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
            print(f"Best spike with surrounding data figure saved: {save_path}")



        fig, ax = plt.subplots(figsize=(15, 10))
        ax.plot(time_zoomed_red, channel_data[start_index_zoom_red:end_index_zoomed_red], color='red')
        ax.set_title(f'Channel {channel_index + 1} - Best Spike - Zoomed')
        ax.set_xlabel('Time (s)')
        ax.set_ylabel('Amplitude (µV)')

        # Set the Y-axis limit based on the maximum amplitude across all channels

        if save_figure:
            save_path = os.path.join(save_directory, f"best_spike_channel_{channel_index + 1} - Zoomed.png")
            plt.savefig(save_path)
            print(f"Best spike with surrounding data figure saved: {save_path}")

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
        fs = continuous.metadata['sample_rate']
        print(fs)
        # plot_spikes_one_figure(data, num_channels, lowcut=180.0, highcut=3000.0, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=True)
        # plot_all_spikes_separate_figure(data, num_channels, lowcut=180.0, highcut=3000.0, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=True)
        # plot_extracted_noise(data, num_channels, lowcut=180.0, highcut=3000.0, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=True)
        # plot_spikes_around_best(data, num_channels, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=True)


        plot_best_spike_with_surrounding_individual(data, num_channels, fs, directory_name, save_directory, save_figure=False)