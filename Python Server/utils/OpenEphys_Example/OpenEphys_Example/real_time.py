import numpy as np
import pandas as pd
from scipy.signal import butter, filtfilt, lfilter
import time
from numpy.lib.stride_tricks import sliding_window_view
import matplotlib.pyplot as plt
import numpy as np
from socket import *



class signalProcessing:
    def __init__(self, queue_raw_data, buffer_size, channel_number, SAMPLING_FREQ):
        self.queue_raw_data = queue_raw_data
        self.channel_number = channel_number
        self.fs = SAMPLING_FREQ
        self.buffer_size = buffer_size

        self.order = 4
        self.lowcut = 15
        self.highcut = 3000

        self.b, self.a = butter(self.order, [self.lowcut, self.highcut], fs=self.fs, btype='band')

        self.num_calls = 0

        self.spike_extracted_permanent = []
        self.nombre_totale_spike = 0
        self.spike_detected = np.zeros((self.channel_number, self.buffer_size))
        self.delayed_spikes = np.zeros((self.channel_number, self.buffer_size))

        self.raw_data = np.zeros((self.channel_number, self.buffer_size*2))            # WHY 2048 ??
        self.filtered_signal = np.zeros((self.channel_number, self.buffer_size*2))
        self.neo_signal = np.zeros((self.channel_number, self.buffer_size*2))


    def connect_TCP(self):
        numChannels = self.channel_number * 2  # number of channels to send
        numSamples = self.buffer_size  # size of the data buffer
        Freq = self.fs  # sample rate of the signal
        offset = 0  # Offset of bytes in this packet; only used for buffers > ~64 kB
        dataType = 2  # Enumeration value based on OpenCV.Mat data types
        elementSize = 2  # Number of bytes per element. elementSize = 2 for U16

        bytesPerBuffer = numChannels * numSamples * elementSize
        self.header = np.array([offset, bytesPerBuffer], dtype='i4').tobytes() + \
                 np.array([dataType], dtype='i2').tobytes() + \
                 np.array([elementSize, numChannels, numSamples], dtype='i4').tobytes()

        buffersPerSecond = Freq / numSamples
        bufferInterval = 1 / buffersPerSecond
        self.port = 10001
        self.ip_address = ""
        openEphys_AddrPort = (self.ip_address, self.port)
        try:
            self.openEphys_Socket = socket(family=AF_INET, type=SOCK_STREAM)
            self.openEphys_Socket.bind(openEphys_AddrPort)
            self.openEphys_Socket.listen(3)
            print("Waiting for OpenEphys TCP connection...")
            (self.tcpClient, self.address) = self.openEphys_Socket.accept()
            print("OpenEphys Socket Plugin Connected !!!")
            self.tcp_connected = True

        except Exception as e:
            print("Error connecting to OpenEphys:", e)
            return

    def convertData(self):
        OpenEphysOffset = 32768
        first_round = 1
        self.connect_TCP()
        print("---STARTING SEND_OPENEPHYS THREAD---")
        keep_going = True
        while keep_going:
            keep_going, data_index, raw_data = self.queue_raw_data.get()
            if raw_data is None:
                print("None")
                time.sleep(0.001)
            else:
                spike_results = self.spikeDetecting(raw_data)

                spike_data = ((spike_results / 5000) * OpenEphysOffset) + OpenEphysOffset
                raw_data = ((raw_data / 5000) * OpenEphysOffset) + OpenEphysOffset

                # MODE: VSTACK
                # duplex_data = np.vstack([raw_data, spike_data])

                # MODE: ODD AND EVEN
                buffer = np.empty((raw_data.shape[0] * 2, raw_data.shape[1]))
                buffer[0::2, :] = raw_data  # even rows
                buffer[1::2, :] = spike_data  # odd row
                duplex_data = buffer
                duplex_data[9][0] = 0
                duplex_data[9][1] = 0
                np_conv = np.array(duplex_data, np.int16).flatten().tobytes()
                rc = self.tcpClient.sendall(self.header + np_conv)

                # self.delayed_spikes = raw_data


    def spike_sorting_task(self, plot_mode="overlay_spikes"):
        raw_buffers = []  # to store raw data
        ret_buffers = []  # to store retVal
        finish = True

        while finish:
            if not self.queue_raw_data.empty():
                finish, data_index, data = self.queue_raw_data.get()
                retVal = self.spikeDetecting(data)

                # store buffers for plotting
                raw_buffers.append(data)
                ret_buffers.append(retVal)
            else:
                time.sleep(0.0001)

        # concatenate all buffers along columns
        raw_array = np.hstack(raw_buffers)  # channels x total_samples
        ret_array = np.hstack(ret_buffers)

        n_channels = raw_array.shape[0]

        for ch in range(n_channels):
            plt.figure(figsize=(12, 3))

            if plot_mode == "full_signal":
                plt.plot(raw_array[ch], label="Raw Data", alpha=0.7)
                plt.plot(ret_array[ch], label="retVal", alpha=0.7)
                plt.legend(["Raw Data", "retVal"])
            elif plot_mode == "overlay_spikes":
                # Only plot retVal buffers
                for i, buf in enumerate(ret_buffers):
                    plt.plot(buf[ch])
                plt.legend(["retVal buffers"])
            else:
                raise ValueError("plot_mode must be 'full_signal' or 'overlay_spikes'")

            plt.title(f"Channel {ch}")
            plt.xlabel("Sample")
            plt.ylabel("Amplitude")
            plt.grid(True)
            plt.show()

    def MTO_operator(self, x, k=5):
        x = np.asarray(x)
        
        center = x[k:-k]           
        left   = x[:-2*k]          
        right  = x[2*k:]           

        mto = center**2 - left * right
        padded = np.pad(mto, (k, k), mode='constant', constant_values=0)
        return padded



    def spikeDetecting(self, signal_2d):
        #print(signal_2d.shape)
        self.num_calls += 1
        self.spike_detected = np.zeros((self.channel_number, self.buffer_size))
        for id_channel, data_channel in enumerate(signal_2d):
            if (self.num_calls < 2):
                self.raw_data[id_channel][0:1024] = data_channel
                #print("here 1")
            else:
                if(self.num_calls == 2):
                    self.raw_data[id_channel][1024:2048] = data_channel
                    self.filtered_signal[id_channel] = filtfilt(self.b, self.a, self.raw_data[id_channel])
                    #print("here 2")

                else:
                    new_data = lfilter(self.b, self.a, data_channel)
                    B = new_data.shape[0]
                    self.filtered_signal[id_channel] = np.roll(self.filtered_signal[id_channel], -B)
                    self.filtered_signal[id_channel][-B:] = new_data
                    #print("here 3")

                self.neo_signal[id_channel] = self.MTO_operator(self.filtered_signal[id_channel])

                #print(len(self.neo_singal))

                # start_time = index_sample / self.fs
                # time_axis = start_time + np.arange(1024) / self.fs
                array_thresholds = np.zeros(1024)
                W = 1025
                wins = sliding_window_view(np.abs(self.neo_signal[id_channel]), W)
                #med = np.median(wins, axis=1)
                array_thresholds = 3 * np.sqrt(np.einsum("ij,ij->i", wins, wins) / wins.shape[1])
                list_spike_indice = []
                count = 0
                i = 0
                md = 3  # nombre minimal des echantillons consecutifs sous le seuil
                window_data_restricted = self.neo_signal[id_channel][512:1536]
                while i < (len(window_data_restricted)) - md:
                    if(window_data_restricted[i] > array_thresholds[i]):
                        for j in range(md):
                            if(window_data_restricted[i+j] > array_thresholds[i]):
                                count += 1
                    if(count >= md):
                        local_min = np.argmax(window_data_restricted[i:i+int(0.002 * self.fs)])
                        list_spike_indice.append(local_min + i)
                        i += int(0.002 * self.fs)
                    else:
                        i += 1
                    count = 0
                #print(list_spike_indice)
                #---------------- extraction des spikes ---------------
                pre = int(0.001 * self.fs)
                post = int(0.001 * self.fs)
                self.nombre_totale_spike += len(list_spike_indice)

                for spike_indice in list_spike_indice:
                    #print(spike_indice)
                    spike_ = self.filtered_signal[id_channel][spike_indice - pre + 512: spike_indice + post + 512]

                    insert_start = max(0, spike_indice - pre)
                    insert_end = min(1024, spike_indice + post)

                    valid_length = insert_end - insert_start
                    spike_truncated = spike_[:valid_length]

                    self.spike_detected[id_channel][insert_start:insert_end] = spike_truncated

            # self.spike_detected[0][0] = 200
            # self.spike_detected[0][1] = 200
            #
            # self.spike_detected[0][-1] = -200
            # self.spike_detected[0][-2] = -200
        return self.spike_detected
                

if __name__ == '__main__':

    df = pd.read_csv("C_Difficult1_noise015_data.csv")
    t = df["Time (s)"].values
    signal_extracted = df["Signal"].values

    n_samples_20s = int(32 * 24000)

    signal_extracted = signal_extracted[:n_samples_20s]
    t = t[:n_samples_20s]
    raw_data = signal_extracted
    print(len(raw_data))

    sp = signalProcessing()

    n_channels = 32
    n_samples = 24000
    data_matrix = raw_data[:n_channels * n_samples].reshape(n_channels, n_samples)

    print(data_matrix.shape)

    t_start = time.perf_counter_ns()

    for index_sample in range(0, data_matrix.shape[1], 1024):
        #print(index_sample)
        sp.spikeDetecting(data_matrix[:, index_sample:index_sample+1024])
        #time.sleep(0.04)


    t_end = time.perf_counter_ns()
    duration_ns = t_end - t_start
    print(f"Temps pipeline  : {duration_ns} ns  ({duration_ns/1_000:.3f} µs  |  {duration_ns/1_000_000:.3f} ms)")


