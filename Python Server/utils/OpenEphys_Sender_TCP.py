import socket
import time
import math
import numpy as np

#TRICK TO DISPLAY PLT FIGURE ON GUI
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

# ---- SPECIFY THE SIGNAL PROPERTIES ---- #
totalDuration = 600 # the total duration of the signal
numChannels = 4  # number of channels to send
numSamples = 500  # size of the data buffer
Freq = 30000  # sample rate of the signal
testingValue1 = 1000  # high value
testingValue2 = -1000  # low value

# ---- DEFINE HEADER VALUES ---- #
headerSize = 22  # Specifies that there are 22 bytes in the header
offset = 0  # Offset of bytes in this packet; only used for buffers > ~64 kB
dataType = 2  # Enumeration value based on OpenCV.Mat data types
elementSize = 2  # Number of bytes per element. elementSize = 2 for U16

bytesPerBuffer = numChannels * numSamples * elementSize

header = np.array([offset, bytesPerBuffer], dtype='i4').tobytes() + \
         np.array([dataType], dtype='i2').tobytes() + \
         np.array([elementSize, numChannels, numSamples], dtype='i4').tobytes()

# ---- COMPUTE SOME USEFUL VALUES ---- #
buffersPerSecond = Freq / numSamples
bufferInterval = 1 / buffersPerSecond

# ---- GENERATE THE DATA ---- #
OpenEphysOffset = 32768
convertedValue1 = OpenEphysOffset + (testingValue1)
convertedValue2 = OpenEphysOffset + (testingValue2)
intList_1 = (np.ones((int(Freq / 2),)) * convertedValue1).astype('uint16')  # if dataType == 2, use astype('uint16')
intList_2 = (np.ones((int(Freq / 2),)) * convertedValue2).astype('uint16')
oneCycle = np.concatenate((intList_1, intList_2))
allData = np.tile(oneCycle, (numChannels, totalDuration)).T

# ---- CREATE THE SOCKET SERVER ---- #
tcpServer = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
tcpServer.bind(('localhost', 10001))
tcpServer.listen(5)

print("Waiting for external connection to start...")
(tcpClient, address) = tcpServer.accept()
print("Connected.")

# ---- CONVERT DATA TO BYTES ---- #
bytesToSend = allData.flatten().tobytes()
totalBytes = len(bytesToSend)
bufferIndex = 0

print("Starting transmission")

bufferInterval_ns = bufferInterval * 1000000000
checkup_time_ns = 0.1 * math.pow(10, 9) # lets validate the total number of byte sent every 1 seconds
checkup_time_sec = checkup_time_ns / math.pow(10, 9)

expected_packet_sent = buffersPerSecond * (checkup_time_ns/math.pow(10,9))
expected_bytes_sent = expected_packet_sent * numSamples * numChannels * elementSize
total_packet_sent = 0
total_bytes_sent = 0
elapse_time = 0

dummy_timer = 0
interval_plotting_list = []
missing_packet_list = []
packet_counter = 0

late_packet_counter = 0
missing_packet = 0
late_packet_list = []
temp_late_packet_counter = 0

try:
    while (bufferIndex < totalBytes):
        t1 = time.perf_counter_ns()
        validation_done = False
        rc = tcpClient.sendall(header + bytesToSend[bufferIndex:bufferIndex + bytesPerBuffer])
        bufferIndex += bytesPerBuffer
        packet_counter += 1
        total_packet_sent += 1
        total_bytes_sent += bytesPerBuffer
        # print(dummy_timer)
        interval_plotting_list.append(dummy_timer)
        late_packet_list.append(0 - temp_late_packet_counter)
        temp_late_packet_counter = 0
        t2 = time.perf_counter_ns()

        while (t2 - t1) < bufferInterval_ns:
            if not validation_done:
                if elapse_time >= checkup_time_ns:
                    # print(expected_bytes_sent - total_bytes_sent)
                    missing_packet = expected_packet_sent - total_packet_sent
                    missing_packet_list.append(missing_packet)
                    # print(missing_packet_list[-1])
                    elapse_time = 0
                    total_packet_sent = 0
                    total_bytes_sent = 0
                    validation_done = True

                    late_packet_counter += missing_packet
                    if late_packet_counter >= 0:
                        temp_late_packet_counter = late_packet_counter
                    else:
                        temp_late_packet_counter = 0

            if late_packet_counter > 0:
                rc = tcpClient.sendall(header + bytesToSend[bufferIndex:bufferIndex + bytesPerBuffer])
                bufferIndex += bytesPerBuffer
                packet_counter += 1
                late_packet_counter -= 1
                late_packet_list.append(0)

            t2 = time.perf_counter_ns()
        t2 = time.perf_counter_ns()
        dummy_timer = (t2 - t1)/bufferInterval_ns
        elapse_time += (t2-t1)

    print("Done")
except BrokenPipeError:
    print("Connection closed by the server. Unable to send data. Exiting...")

except ConnectionAbortedError:
    print(
        "Connection was aborted, unable to send data. Try disconnecting and reconnecting the remote client. Exiting...")

except ConnectionResetError:
    print(
        "Connection was aborted, unable to send data. Try disconnecting and reconnecting the remote client. Exiting...")

finally:
    print("Closing connection...")
    time.sleep(1)
    tcpClient.close()
    print("Plotting delay ratio...")
    plt.figure(figsize=(10, 6))
    # plt.subplot(2, 1, 1)

    # plt.plot(interval_plotting_list)
    plt.xlabel(f"TCP Packets Sent (Each {int(buffersPerSecond)} packets represents 1 second)")
    plt.ylabel("Value of Counter")

    # value_period_index = max(interval_plotting_list) / 2
    value_period_index = 0.5

    period_to_packet_xaxis = []
    period_index = []
    for idx in range(len(interval_plotting_list)):
        if (idx > 0) and (idx % (buffersPerSecond * checkup_time_sec) == 0):
            period_to_packet_xaxis.append(missing_packet_list.pop(0))
            period_index.append(value_period_index)
        else:
            period_to_packet_xaxis.append(0)
            period_index.append(0)

    print("Lenght of period_index: ", len(period_index))
    print("Lenght of period_to_packet_xaxis: ", len(period_to_packet_xaxis))
    print("Lenght of interval_plotting_list: ", len(interval_plotting_list))
    print("Lenght of late_packet_list: ", len(late_packet_list))
    plt.plot(period_index, color='red')
    plt.plot(period_to_packet_xaxis, color='green')
    plt.plot(interval_plotting_list, color='blue')
    plt.plot(late_packet_list[:len(period_index)], color='orange')
    red_data = mpatches.Patch(color='red', label=f'{checkup_time_sec}sec period')
    green_data = mpatches.Patch(color='green', label=f'Missing Packets at each validation period of {checkup_time_sec}sec')
    blue_data = mpatches.Patch(color='blue', label='(time after sending - time before sending) / desired Delay')
    orange_data = mpatches.Patch(color='orange', label='Sent packets to catch Up')
    plt.grid()
    plt.legend(handles=[red_data, blue_data, green_data, orange_data])


    # plt.subplot(2, 1, 2)
    # plt.xlabel("Samples")
    # plt.ylabel("Number of missing packets (calculated every 10 seconds ~600 packets)")
    # plt.plot(period_index, color='red')
    # plt.plot(period_to_packet_xaxis, color='blue')



    plt.show()
