import socket
import time

import numpy as np

# ---- SPECIFY THE SIGNAL PROPERTIES ---- #
totalDuration = 1   # the total duration of the signal
numChannels =   8   # number of channels to send
bufferSize =    256# size of the data buffer
Freq =          15000 # sample rate of the signal
dataScale =         0.195 # scale value for mV conversion in OpenEphtys
OpenEphysOffset =   32768 # offset value for value around 0

testingValue1 = 1000  # high value
testingValue2 = 1000  # low value

testingValue3 = -5000  # low value
testingValue4=   3000  # high value

# ---- COMPUTE SOME USEFUL VALUES ---- #
bytesPerBuffer = bufferSize * 2 * numChannels
buffersPerSecond = Freq / bufferSize
bufferInterval = 1 / buffersPerSecond

# ---- GENERATE THE DATA ---- #
convertedValue1 = OpenEphysOffset+(testingValue1/dataScale)
convertedValue2 = OpenEphysOffset+(testingValue2/dataScale)


intList_1 = (np.ones((int(Freq/2),)) * convertedValue1).astype('uint16')
intList_2 = (np.ones((int(Freq/2),)) * convertedValue2).astype('uint16')

oneCycle = np.concatenate((intList_1, intList_2))
allData = np.tile(oneCycle, (numChannels, totalDuration+1)).T



#
# for i in range(len(allData)):
#     allData[i][0] = 32768
#     allData[i][1] = 65534
#     allData[i][0] = 32768




# allData = [Freq * totalDuration][numChannels]
#   CH1: allData[0][x] to allData[63][x] then allData[256][x] to allData[320][x] ...
#   CH2: allData[64][x] to allData[127][x]
#   CH3: allData[128][x] to allData[191][x]
#   CH4: allData[192][x] to allData[255][x]
# allData[512] = 0
#
# buffer = 256
# intervalle = 128
# for i in range(0, bufferSize, int(intervalle/2)):
#     for j in range(intervalle):
#         allData[i + j][0] = convertedValue4
#         allData[i + j][1] = convertedValue3
#     for j in range(intervalle*1, intervalle*2):
#         allData[i + j][0] = convertedValue3
#         allData[i + j][1] = convertedValue3
#
# allData = allData[0:bufferSize]



#FOR 1 CHANNEL
# for i in range(0, Freq * totalDuration, int(bufferSize/2)):
#     buffer = 64
#     for j in range(buffer * 0, buffer * 1, 1):
#         allData[i + j][0] = convertedValue4
#
#     for j in range(buffer * 1, buffer * 2, 1):
#         allData[i + j][0] = convertedValue2
#
#     for j in range(buffer * 2, buffer * 3, 1):
#         allData[i + j][0] = convertedValue4
#
#     for j in range(buffer * 3, buffer * 4, 1):
#         allData[i + j][0] = convertedValue2

#FOR 2 CHANNELS
# for i in range (0, Freq * totalDuration, bufferSize*2):
#     buffer = 64*2
#     for j in range(buffer*0, buffer*1, 1):
#         allData[i + j][0] = convertedValue4
#         allData[i + j][1] = convertedValue4
#
#     for j in range(buffer*1, buffer*2, 1):
#         allData[i + j][0] = convertedValue1
#         allData[i + j][1] = convertedValue1
#
#     for j in range(buffer * 2, buffer * 3, 1):
#         allData[i + j][0] = convertedValue4
#         allData[i + j][1] = convertedValue4
#
#     for j in range(buffer * 3, buffer * 4, 1):
#         allData[i + j][0] = convertedValue1
#         allData[i + j][1] = convertedValue1

#FOR 4 CHANNELS
# for i in range (0, Freq * totalDuration, bufferSize*2):
#     buffer = 64
#     for j in range(buffer*0, buffer*1, 1):
#         allData[i + j][0] = convertedValue4
#         allData[i + j][1] = convertedValue4
#         allData[i + j][2] = convertedValue4
#         allData[i + j][3] = convertedValue1
#
#     for j in range(buffer * 1, buffer * 2, 1):
#         allData[i + j][0] = convertedValue2
#         allData[i + j][1] = convertedValue2
#         allData[i + j][2] = convertedValue2
#         allData[i + j][3] = convertedValue2
#
#     for j in range(buffer * 2, buffer * 3, 1):
#         allData[i + j][0] = convertedValue3
#         allData[i + j][1] = convertedValue3
#         allData[i + j][2] = convertedValue3
#         allData[i + j][3] = convertedValue3
#
#     for j in range(buffer * 3, buffer * 4, 1):
#         allData[i + j][0] = convertedValue4
#         allData[i + j][1] = convertedValue4
#         allData[i + j][2] = convertedValue4
#         allData[i + j][3] = convertedValue4
#
#     for j in range(buffer*4, buffer*5, 1):
#         allData[i + j][0] = convertedValue4
#         allData[i + j][1] = convertedValue4
#         allData[i + j][2] = convertedValue4
#         allData[i + j][3] = convertedValue4
#
#     for j in range(buffer*5, buffer*6, 1):
#         allData[i + j][0] = convertedValue4
#         allData[i + j][1] = convertedValue4
#         allData[i + j][2] = convertedValue4
#         allData[i + j][3] = convertedValue4
#
#     for j in range(buffer * 6, buffer * 7, 1):
#         allData[i + j][0] = convertedValue1
#         allData[i + j][1] = convertedValue1
#         allData[i + j][2] = convertedValue1
#         allData[i + j][3] = convertedValue1
#
#     for j in range(buffer*7, buffer*8, 1):
#         allData[i + j][0] = convertedValue2
#         allData[i + j][1] = convertedValue2
#         allData[i + j][2] = convertedValue2
#         allData[i + j][3] = convertedValue2




# ---- SPECIFY THE IP AND PORT ---- #

#serverAddressPort = ("10.99.172.126", 10001)
serverAddressPort = ("192.168.1.132", 10001)
# ---- CREATE THE SOCKET OBJECT ---- #
UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

#allData = allData[0:Freq*totalDuration]


# ---- CONVERT DATA TO BYTES ---- #
bytesToSend = allData.flatten().tobytes()
totalBytes = len(bytesToSend)
bufferIndex = 0

print("Starting transmission")


def currentTime():
    return time.time_ns() / (10 ** 9)

COUNTER =0
# ---- STREAM DATA ---- #
while (1):
    t1 = currentTime()
    # print("Buffer: ", bytesToSend[bufferIndex:bufferIndex + bytesPerBuffer])
    # print("Size: ", len(bytesToSend[bufferIndex:bufferIndex + bytesPerBuffer]))


    UDPClientSocket.sendto(bytesToSend[bufferIndex:bufferIndex+bytesPerBuffer], serverAddressPort)
    t2 = currentTime()
    COUNTER += 1

    #CHECKING TO MAKE SURE WE DONE SEND DATA TO FAST
    while ((t2 - t1) < bufferInterval):
        t2 = currentTime()

    #bufferIndex += bytesPerBuffer

print("Done")