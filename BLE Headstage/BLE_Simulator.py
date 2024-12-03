import threading
import time
from queue import Queue
import struct
import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

class BLE_Simulator:
    def __init__(self, p_channels, p_frequency, p_queue_raw_data, p_buffer_size):
        self.channels = p_channels
        self.frequency = p_frequency
        self.queue_raw = p_queue_raw_data
        self.buffer_size = p_buffer_size
        self._running = False
        self._simulator_thread = None
        self.data_counter = 0
        self.wave_generators = {}
        self.sample_period = 1 / self.frequency

    def init_wave(self, channel_ids, wave_type="sine", amplitude=32767, frequency=10):
        """
        Initialize the specified channels with the given wave type.
        wave_type can be 'sine', 'square', 'triangle', or 'dc'.
        """
        # Constrain amplitude to signed 16-bit integer limits
        max_amplitude = 32767
        amplitude = min(amplitude, max_amplitude)

        for channel_id in channel_ids:
            self.wave_generators[channel_id] = {
                "wave_type": wave_type,
                "amplitude": amplitude,
                "frequency": frequency,
                "time": 0
            }

    def _generate_wave(self, channel_id, time_point):
        wave_gen = self.wave_generators[channel_id]
        wave_type = wave_gen["wave_type"]
        frequency = wave_gen["frequency"]
        amplitude = wave_gen["amplitude"]

        if wave_type == "sine":
            # Generate a sine wave between -32768 and 32767
            return int(amplitude * np.sin(2 * np.pi * frequency * time_point))  # Mapping to -32768 to 32767
        elif wave_type == "square":
            # Generate a square wave: alternating between -32768 and 32767
            return int(amplitude if np.sin(2 * np.pi * frequency * time_point) >= 0 else -amplitude)
        elif wave_type == "triangle":
            # Generate a triangle wave between -32768 and 32767
            return int((amplitude * 2 / np.pi) * np.arcsin(np.sin(2 * np.pi * frequency * time_point)))  # Mapping to -32768 to 32767
        elif wave_type == "dc":
            # DC value is constant and mapped to signed range
            return int(amplitude)  # DC wave has a constant value

    def _generate_data_packet(self):
        packet_size = 227
        packet = bytearray(packet_size)

        for channel_id in self.channels:
            channel_data = []
            for _ in range((packet_size - 3) // (2 * len(self.channels))):  # 2 bytes per sample
                wave_value = self._generate_wave(channel_id, self.wave_generators[channel_id]["time"])
                channel_data.append(wave_value)
                self.wave_generators[channel_id]["time"] += self.sample_period

            # Prepare packet structure
            channel_data_bytes = b"".join(struct.pack("<h", v) for v in channel_data)  # 16-bit signed integers
            packet[0] = channel_id
            packet[1:3] = struct.pack("<H", 0)  # No lost bytes
            packet[3:] = channel_data_bytes[:packet_size - 3]

            self.queue_raw.put((channel_id, channel_data))
            self.data_counter += 1

    def start(self):
        if self._simulator_thread is None or not self._simulator_thread.is_alive():
            self._running = True
            self._simulator_thread = threading.Thread(target=self._simulate_data)
            self._simulator_thread.start()

    def _simulate_data(self):
        while self._running:
            self._generate_data_packet()
            time.sleep(self.sample_period)

    def stop(self):
        self._running = False

    def join(self):
        if self._simulator_thread is not None:
            self._simulator_thread.join()

    def plot_converted_data(self, converted_array_Ephys):
        """
        Plot the converted data (Ephys) for each channel.
        """
        # Create time points for plotting based on buffer size and frequency
        time_points = np.linspace(0, self.buffer_size / self.frequency, self.buffer_size)

        # Create subplots for each channel
        plt.figure(figsize=(10, 6))

        for i in range(self.num_channels):
            plt.subplot(self.num_channels, 1, i + 1)  # Create a subplot for each channel
            plt.plot(time_points, converted_array_Ephys[i], label=f"Channel {i}")
            plt.title(f"Converted Data for Channel {i}")
            plt.xlabel("Time (s)")
            plt.ylabel("Amplitude (mV)")
            plt.legend(loc="best")
            plt.grid(True)

        # Adjust layout and show the plot
        plt.tight_layout()
        plt.show()



if __name__ == "__main__":
    CHANNELS = [0, 1]
    FREQUENCY = 15000
    BUFFER_SIZE = 1024
    maxOpenEphysValue = 0.005
    OpenEphysOffset = 32768
    converting_value = (0.000000195 / maxOpenEphysValue) * OpenEphysOffset

    QUEUE_RAW_DATA = Queue()
    QUEUE_EPHYS_DATA = Queue()

    simulator = BLE_Simulator(CHANNELS, FREQUENCY, QUEUE_RAW_DATA, BUFFER_SIZE)
    simulator.init_wave([0], wave_type="sine", amplitude=32767, frequency=50)  # Max amplitude for signed 16-bit
    simulator.init_wave([1], wave_type="square", amplitude=30000, frequency=60)  # Square wave for channel 1
    simulator.start()

    time.sleep(1)  # Run the simulator for 1 second
    simulator.stop()
    simulator.join()

    # Retrieve and display some data from the queue
    channel_data = {channel: [] for channel in CHANNELS}
    while not QUEUE_RAW_DATA.empty():
        channel, data = QUEUE_RAW_DATA.get()
        channel_data[channel].extend(data)  # Collect all data for each channel

    # Plot the data for each channel
    plt.figure(figsize=(10, 6))

    # Create subplots for each channel
    for channel, data in channel_data.items():
        plt.subplot(len(channel_data), 1, CHANNELS.index(channel) + 1)
        plt.plot(data, label=f"Channel {channel}")
        plt.title(f"Channel {channel} Data")
        plt.xlabel("Sample")
        plt.ylabel("Amplitude")
        plt.legend(loc="best")
        plt.grid(True)

    # Adjust layout and show the plot
    plt.tight_layout()
    plt.show()

    print("Done")
    # Retrieve and display some data from the queue
    converted_channel_data = {channel: [] for channel in CHANNELS}
    for channel_number in channel_data:
        raw_data = channel_data[channel_number]
        for data in raw_data:
            converted_data = OpenEphysOffset + (data * converting_value)
            converted_channel_data[channel_number].append(data)


     # Create subplots for each channel
    for channel, data in converted_channel_data.items():
        plt.subplot(len(converted_channel_data), 1, CHANNELS.index(channel) + 1)
        plt.plot(data, label=f"Channel {channel}")
        plt.title(f"Channel {channel} Data")
        plt.xlabel("Sample")
        plt.ylabel("Amplitude")
        plt.legend(loc="best")
        plt.grid(True)

    # Adjust layout and show the plot
    plt.tight_layout()
    plt.show()
