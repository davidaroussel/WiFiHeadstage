import socket
import time

import numpy as np

# ---- SPECIFY THE SIGNAL PROPERTIES ---- #
totalDuration = 1   # the total duration of the signal
numChannels = 8     # number of channels to send
bufferSize = 100     # size of the data buffer
Freq = 1000        # sample rate of the signal
testingValue1 = 3000  # high value
testingValue2=  -1000  # low value

# ---- COMPUTE SOME USEFUL VALUES ---- #
bytesPerBuffer = bufferSize * 2 * numChannels
buffersPerSecond = Freq / bufferSize
bufferInterval = 1 / buffersPerSecond

# ---- GENERATE THE DATA ---- #
OpenEphysOffset = 32768
convertedValue1 = OpenEphysOffset+(testingValue1/0.195)
convertedValue2 = OpenEphysOffset+(testingValue2/0.195)
intList_1 = (np.ones((int(Freq/4),)) * convertedValue1).astype('uint16')
intList_2 = (np.ones((int(Freq/4),)) * convertedValue2).astype('uint16')
intList_3 = (np.ones((int(Freq/4),)) * convertedValue1).astype('uint16')
intList_4 = (np.ones((int(Freq/4),)) * convertedValue2).astype('uint16')

oneCycle = np.concatenate((intList_1, intList_2, intList_3, intList_4))

allData = np.tile(oneCycle, (numChannels, totalDuration)).T

# ---- SPECIFY THE IP AND PORT ---- #
serverAddressPort = ("192.168.1.132", 10001)

# ---- CREATE THE SOCKET OBJECT ---- #
UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

test = []
#CHANNEL0
for i in range(100):
        #test.append(int(OpenEphysOffset + (-4000 / 0.195)))
        test.append(OpenEphysOffset + (1 / 0.195))

#CHANNEL1
for i in range(50):
        test.append(int(OpenEphysOffset + (5000 / 0.195)))
for i in range(50):
        test.append(int(OpenEphysOffset + (-2000 / 0.195)))

#CHANNEL2
for i in range(50):
        test.append(int(OpenEphysOffset + (5000 / 0.195)))
for i in range(50):
        test.append(int(OpenEphysOffset + (-2000 / 0.195)))

#CHANNEL3
for i in range(50):
        test.append(int(OpenEphysOffset + (5000 / 0.195)))
for i in range(50):
        test.append(int(OpenEphysOffset + (-2000 / 0.195)))

#CHANNEL4
for i in range(50):
        test.append(int(OpenEphysOffset + (5000 / 0.195)))
for i in range(50):
        test.append(int(OpenEphysOffset + (-2000 / 0.195)))

#CHANNEL5
for i in range(50):
        test.append(int(OpenEphysOffset + (5000 / 0.195)))
for i in range(50):
        test.append(int(OpenEphysOffset + (-2000 / 0.195)))

#CHANNEL6
for i in range(25):
        test.append(int(OpenEphysOffset + (5000 / 0.195)))
for i in range(25):
        test.append(int(OpenEphysOffset + (-2000 / 0.195)))
for i in range(25):
        test.append(int(OpenEphysOffset + (5000 / 0.195)))
for i in range(25):
        test.append(int(OpenEphysOffset + (-2000 / 0.195)))

#CHANNEL7
for i in range(25):
        test.append(int(OpenEphysOffset + (5000 / 0.195)))
for i in range(25):
        test.append(int(OpenEphysOffset + (2000 / 0.195)))
for i in range(25):
        test.append(int(OpenEphysOffset + (5000 / 0.195)))
for i in range(25):
        test.append(int(OpenEphysOffset + (2000 / 0.195)))

arr = np.array(test,  np.uint16)
bytesFromArr = arr.flatten().tobytes()

allData[0][0] = 32773
allData[0][1] = 0

# ---- CONVERT DATA TO BYTES ---- #
bytesToSend = allData.flatten().tobytes()
totalBytes = len(bytesToSend)
bufferIndex = 0

print("Starting transmission")

def currentTime():
    return time.time_ns() / (10 ** 9)

list_test = []
for i in range(0,200,2):
    list_test.append((bytesFromArr[i+1] << 8 | bytesFromArr[i]))

# ---- STREAM DATA ---- #
while 1:
    t1 = currentTime()

    sending = bytesFromArr
    list_test = (sending[1] << 8 | sending[0])


    UDPClientSocket.sendto(sending, serverAddressPort)
    t2 = currentTime()

    while ((t2 - t1) < bufferInterval):
        t2 = currentTime()

    #bufferIndex += bytesPerBuffer

print("Done")