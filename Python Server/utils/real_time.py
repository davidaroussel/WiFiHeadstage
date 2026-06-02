import numpy as np
import pandas as pd
from scipy.signal import butter, filtfilt, lfilter
import time
from numpy.lib.stride_tricks import sliding_window_view
import matplotlib.pyplot as plt
import numpy as np



class signalProcessing:
    def __init__(self):
        self.order = 4
        self.lowcut = 15
        self.highcut = 3000
        self.fs = 24000

        self.b, self.a = butter(self.order, [self.lowcut, self.highcut], fs=self.fs, btype='band')

        self.num_calls = 0

        self.spike_extracted_permanent = []
        self.nombre_totale_spike = 0
        self.spike_detected = np.zeros((32, 1024))

        self.raw_data = np.zeros((32, 2048))
        self.filtered_signal = np.zeros((32, 2048))
        self.neo_signal = np.zeros((32, 2048))



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
                    spike_ = self.filtered_signal[id_channel][spike_indice - pre + 512 : spike_indice + post + 512]
                    
                    insert_start = max(0, spike_indice - pre)
                    insert_end = min(1024, spike_indice + post)
                    
                    valid_length = insert_end - insert_start
                    spike_truncated = spike_[:valid_length]

                    self.spike_detected[id_channel][insert_start:insert_end] = spike_truncated
                    
        
        return self.spike_detected
                

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


