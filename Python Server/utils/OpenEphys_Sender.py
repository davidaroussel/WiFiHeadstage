## ORIGINAL CODE THAT WAS SENT BY THE CREATOR OF OPEN EPHYS TO TEST THE SOCKET COMMUNICATION

import socket
import time

import numpy as np

import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt


def generate_waveform(wave_type: str, frequency: float, num_samples: int, amplitude: float = 1.0, offset: float = 0.0):
    """
    Generate a waveform array with a specified number of samples at a given frequency, amplitude, and offset.

    :param wave_type: Type of waveform ('sine', 'square', 'triangle').
    :param frequency: Frequency of the waveform in Hz.
    :param num_samples: Number of samples to generate.
    :param amplitude: Amplitude of the waveform.
    :param offset: Offset to shift the waveform.
    :return: Numpy array containing the waveform.
    """
    t = np.linspace(0, 1, num_samples, endpoint=False)

    if wave_type == 'sine':
        wave = np.sin(2 * np.pi * frequency * t)
    elif wave_type == 'square':
        wave = np.sign(np.sin(2 * np.pi * frequency * t))
    elif wave_type == 'triangle':
        wave = 2 * np.abs(2 * (t * frequency - np.floor(t * frequency + 0.5))) - 1
    else:
        raise ValueError("Invalid wave_type. Choose from 'sine', 'square', or 'triangle'.")

    return np.round(amplitude * wave + offset).astype('uint16')


# ---- SPECIFY THE SIGNAL PROPERTIES ---- #
totalDuration = 40  # the total duration of the signal
numChannels = 16    # number of channels to send
bufferSize = 256    # size of the data buffer
Freq = 3500        # sample rate of the signal
testingValue1 = 5000   # high value
testingValue2 = -5000  # low value

# ---- COMPUTE SOME USEFUL VALUES ---- #
bytesPerBuffer = bufferSize * numChannels
buffersPerSecond = Freq / bufferSize
bufferInterval = 1 / buffersPerSecond

# ---- GENERATE THE DATA ---- #
OpenEphysOffset = 32768
convertedValue1 = OpenEphysOffset+(5000/0.195)
convertedValue2 = OpenEphysOffset+(-5000/0.195)
convertedValue3 = OpenEphysOffset+(-2500/0.195)
convertedValue4 = OpenEphysOffset+(-5000/0.195)
intList_1 = (np.ones((int(Freq/2),)) * convertedValue1).astype('uint16')
intList_2 = (np.ones((int(Freq/2),)) * convertedValue2).astype('uint16')
intList_3 = (np.ones((int(Freq/4),)) * convertedValue3).astype('uint16')
intList_4 = (np.ones((int(Freq/4),)) * convertedValue4).astype('uint16')
oneCycle = np.concatenate((intList_1, intList_2))

allData = np.tile(oneCycle, (numChannels, totalDuration)).T

signal_frequency = 10        # Hz
signal_amplitude = 10000
waveform = generate_waveform('sine', signal_frequency, Freq, signal_amplitude, OpenEphysOffset)

fig, axs = plt.subplots(2, 1, figsize=(10, 6), sharex=True)
# Plot the first waveform
axs[0].plot(waveform, label="Sine Wave")
axs[0].set_ylabel("Amplitude")
axs[0].set_title("Sine Wave")
axs[0].grid(True)
axs[0].legend()

# Plot the second waveform
axs[1].plot(oneCycle, label="Normal Data", color='r')
axs[1].set_xlabel("Sample Index")
axs[1].set_ylabel("Amplitude")
axs[1].set_title("Square Wave")
axs[1].grid(True)
axs[1].legend()

# Show the plot
plt.tight_layout()
# plt.show()

# allData = np.tile(waveform, (numChannels, totalDuration)).T

# ---- SPECIFY THE IP AND PORT ---- #
serverAddressPort = ("localhost", 10001)

# ---- CREATE THE SOCKET OBJECT ---- #
UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)


# ---- CONVERT DATA TO BYTES ---- #
bytesToSend = allData.flatten()
totalBytes = len(bytesToSend)
bufferIndex = 0

print("Starting transmission")

def currentTime():
    return time.time_ns() / (10 ** 9)

new_buffer_interval = bufferInterval * 0.98

# ---- STREAM DATA ---- #
while (bufferIndex < totalBytes):
    t1 = currentTime()
    print(len(bytesToSend[bufferIndex:bufferIndex+bytesPerBuffer]))
    UDPClientSocket.sendto(bytesToSend[bufferIndex:bufferIndex+bytesPerBuffer], serverAddressPort)
    t2 = currentTime()
    # print(min(bytesToSend[bufferIndex:bufferIndex+bytesPerBuffer]), max(bytesToSend[bufferIndex:bufferIndex + bytesPerBuffer]))

    while ((t2 - t1) <= new_buffer_interval):
        t2 = currentTime()

    bufferIndex += bytesPerBuffer

print("Done")