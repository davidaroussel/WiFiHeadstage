## ORIGINAL CODE THAT WAS SENT BY THE CREATOR OF OPEN EPHYS TO TEST THE SOCKET COMMUNICATION

import socket
import time

import numpy as np

# ---- SPECIFY THE SIGNAL PROPERTIES ---- #
totalDuration = 100   # the total duration of the signal
numChannels = 32     # number of channels to send
bufferSize = 256    # size of the data buffer
Freq = 25000        # sample rate of the signal
testingValue1 = 1000  # high value
testingValue2= -1000  # low value

# ---- COMPUTE SOME USEFUL VALUES ---- #
bytesPerBuffer = bufferSize * 2 * numChannels
buffersPerSecond = Freq / bufferSize
bufferInterval = 1 / buffersPerSecond

# ---- GENERATE THE DATA ---- #
OpenEphysOffset = 32768
convertedValue1 = OpenEphysOffset+(testingValue1/0.195)
convertedValue2 = OpenEphysOffset+(testingValue2/0.195)
intList_1 = (np.ones((int(Freq/2),)) * convertedValue1).astype('uint16')
intList_2 = (np.ones((int(Freq/2),)) * convertedValue2).astype('uint16')
oneCycle = np.concatenate((intList_1, intList_2))
allData = np.tile(oneCycle, (numChannels, totalDuration)).T

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

# ---- STREAM DATA ---- #
while (bufferIndex < totalBytes):
    t1 = currentTime()
    # print(len(bytesToSend[bufferIndex:bufferIndex+bytesPerBuffer]))
    UDPClientSocket.sendto(bytesToSend[bufferIndex:bufferIndex+bytesPerBuffer], serverAddressPort)
    t2 = currentTime()

    while ((t2 - t1) < bufferInterval):
        t2 = currentTime()

    bufferIndex += bytesPerBuffer

print("Done")