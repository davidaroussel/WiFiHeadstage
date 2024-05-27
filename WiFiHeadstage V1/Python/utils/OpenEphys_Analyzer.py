import os
import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
from scipy.signal import butter, filtfilt
from open_ephys.analysis import Session
import csv


# Bandpass filter function
def bandpass_filter(data, lowcut, highcut, fs, order=5):
    nyquist = 0.5 * fs
    low = lowcut / nyquist
    high = highcut / nyquist
    b, a = butter(order, [low, high], btype='band')
    y = filtfilt(b, a, data)
    return y


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


def plot_all_spikes_separate_figure(data, num_channels, lowcut, highcut, fs, directory_name, save_directory,
                                    save_figure=False):
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


if __name__ == '__main__':
    src_directory = r'../analysis_results/'
    base_directory = r'C:\Users\david\OneDrive\Ph.D G. ELECTRIQUE\Wi-Fi Headstage\SCOPE\2024-04-25\GOOD'
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

        data = continuous.get_samples(10000, 30000)
        num_samples, num_channels = data.shape
        # plot_spikes_one_figure(data, num_channels, lowcut=180.0, highcut=3000.0, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=True)
        # plot_all_spikes_separate_figure(data, num_channels, lowcut=180.0, highcut=3000.0, fs=continuous.metadata['sample_rate'], directory_name=directory_name, save_directory=save_directory, save_figure=True)
        # plot_extracted_noise(data, num_channels, lowcut=180.0, highcut=3000.0, fs=continuous.metadata['sample_rate'],
        #                      directory_name=directory_name, save_directory=save_directory, save_figure=True)

        snr_vrms_data = format_csv_data(num_channels)
        experiment_data[directory_name] = snr_vrms_data
    plot_snr_and_vrms(experiment_data)

        # Write SNR and Vrms values to CSV file
    csv_filename = os.path.join(save_directory, 'snr_vrms_results.csv')
    write_csv(experiment_data, csv_filename)
    print(f"CSV file saved: {csv_filename}")