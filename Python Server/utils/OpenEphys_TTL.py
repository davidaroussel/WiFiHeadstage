# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 12/04/2024

import os
os.environ["OMP_NUM_THREADS"] = "1"
import time
from datetime import datetime
from open_ephys.control import OpenEphysHTTPServer
from open_ephys.control.network_control import NetworkControl
from open_ephys.analysis import *
import keyboard
import numpy as np
#TRICK TO DISPLAY PLT FIGURE ON GUI
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import matplotlib.ticker as ticker

def keyboard_controlled_ttl():
    channel = 2
    state = 1
    # Usage of both library was recommended by founder Josh Siegle
    # gui_starter's TTL fonctionnality was never finished so it makes the app crash
    gui_starter = OpenEphysHTTPServer(address='127.0.0.1')
    gui_ttl = NetworkControl(ip_address='127.0.0.1', port=5556)

    ## CONTROL OPEN EPHYS WITH PYTHON (optional section) ###
    gui_starter.acquire()
    time.sleep(1)
    print("SENDING ")
    # gui_starter.record()
    # time.sleep(1)
    # print("RECORDING ")

    while True:
        if keyboard.is_pressed('q'):
            # Toggle channel 0 HIGH
            gui_ttl.send_ttl(line=4, state=1)
            print("Channel 0 HIGH")
        elif keyboard.is_pressed('w'):
            # Toggle channel 0 LOW
            gui_ttl.send_ttl(line=4, state=0)
            print("Channel 0 LOW")
        elif keyboard.is_pressed('e'):
            # Toggle channel 1 HIGH
            gui_ttl.send_ttl(line=5, state=1)
            print("Channel 1 HIGH")
        elif keyboard.is_pressed('r'):
            # Toggle channel 1 LOW
            gui_ttl.send_ttl(line=5, state=0)
            print("Channel 1 LOW")

        time.sleep(0.1)  # Short delay to prevent excessive CPU usage

def plot_data_with_ttl_overlay():
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


        # Extract TTL events
        ttl_timestamps = events['timestamp']  # Timestamps in seconds
        ttl_states = events['state']  # Rising (1) and falling (0) edges
        ttl_events = events
        ttl_data = []
        recording_start_sample = ttl_events.values[0][1]

        for ttl_signal in ttl_events.values:
            ttl_id = ttl_signal[0]

            # Convert absolute sample index -> local plotted index
            sample_index = int(ttl_signal[1] - recording_start_sample)

            state = ttl_signal[6]

            ttl_data.append([ttl_id, sample_index, state])

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
        ttl_colors = {ttl_id: color for ttl_id, color in
                      zip(unique_ttl_ids, plt.cm.tab10(np.linspace(0, 1, len(unique_ttl_ids))))}

        # Set up figure with subplots
        fig, axs = plt.subplots(num_channels, 1, figsize=(12, 2 * num_channels), sharex=True)
        fig.suptitle(f'Raw Data for All Channels - Directory: {directory_name}')

        for channel_index in range(num_channels):
            for ttl_id, ranges in ttl_dict.items():
                for start, end in ranges:
                    axs[channel_index].plot(
                        np.arange(data.shape[0]),
                        data[:, channel_index],
                        color='black',
                        linewidth=0.2,
                        label=f'Ch {channel_index + 1}',
                        zorder=1
                    )

                # Draw TTL overlays ON TOP
                for ttl_id, ranges in ttl_dict.items():
                    for start, end in ranges:
                        axs[channel_index].axvspan(
                            start,
                            end,
                            color=ttl_colors[ttl_id],
                            alpha=0.3,
                            zorder=10
                        )

            axs[channel_index].set_ylabel(f'Ch {channel_index + 1}')
            axs[channel_index].grid(True, linestyle='--', alpha=0.6)

        axs[-1].set_xlabel('Sample Index')  # Label only the last subplot for clarity
        axs[-1].xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'{int(x)}'))
        plt.tight_layout(rect=[0, 0, 1, 0.96])  # Adjust layout to fit title
        plt.show()



# CONTROL OPEN EPHYS WITH PYTHON --TEMPLATE--
if __name__ == "__main__":
    #plot_data_with_ttl_overlay()
    keyboard_controlled_ttl()
