import socket
import time
import math
import matplotlib.pyplot as plt
import numpy as np

counter = 0
ROUNDS = 1000
NUM_CHANNELS = 64
BYTES_PER_DATA = 2
FPGA_BUFFER_SIZE = 15
RHD64_DATA_BUFFER = [[None for i in range(ROUNDS)] for j in range(NUM_CHANNELS)]

localIP = "10.99.172.126"
localPort = 10000
UDP_HEADER_SIZE = 150
UDP_BUFFER_SIZE = NUM_CHANNELS * BYTES_PER_DATA * FPGA_BUFFER_SIZE
bufferSize = UDP_BUFFER_SIZE + UDP_HEADER_SIZE

UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
UDPServerSocket.bind((localIP, localPort))

print("UDP server up and listening on {}".format(localIP))

NUM_OF_COLUMN = 4

# Create a list to store the parsed data from the binary message
parsed_data = []
plot_data = []

def plotAllChannels():
    fig, axs = plt.subplots(int(NUM_CHANNELS / NUM_OF_COLUMN), NUM_OF_COLUMN, figsize=(30, 10))
    plt.gca().cla()
    ch_counter = 0
    for col in range(NUM_OF_COLUMN):
        for row in range(int(NUM_CHANNELS / NUM_OF_COLUMN)):
            k = [i for i in range(len(RHD64_DATA_BUFFER[ch_counter]))]
            axs[row, col].plot(k, RHD64_DATA_BUFFER[ch_counter])
            axs[row, col].title.set_text("CHANNEL {}".format(ch_counter))
            ch_counter += 1
    plt.tight_layout()
    plt.show()

def plotChannel(channel_number):
    if channel_number < 0 or channel_number >= NUM_CHANNELS:
        print("Invalid channel number")
        return

    fig, ax = plt.subplots(figsize=(10, 5))
    k = [i for i in range(len(RHD64_DATA_BUFFER[channel_number]))]
    ax.plot(k, RHD64_DATA_BUFFER[channel_number])
    ax.set_title("CHANNEL {}".format(channel_number))
    plt.show()

while 1:
    t1 = time.time()
    bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)
    t2 = time.time()


    print("Counter: ", counter)

    message = bytesAddressPair[0][:UDP_BUFFER_SIZE]

    # Iterate through the binary message and parse it into 16-bit values
    for i in range(0, len(message), BYTES_PER_DATA):
        byte1 = message[i]
        byte2 = message[i + 1]
        data_value = (byte2 << 8) | byte1

        channels = (i // BYTES_PER_DATA) % NUM_CHANNELS
        rounds = i // (BYTES_PER_DATA * NUM_CHANNELS)
        RHD64_DATA_BUFFER[channels][rounds] = data_value

        # Append the parsed value to the list
        parsed_data.append(data_value)

    counter += 1
    if counter == 1000:
        # Now, you can plot the parsed data
        plt.figure(figsize=(10, 5))
        k = np.arange(len(parsed_data))
        plt.plot(k, parsed_data)
        plt.title("Parsed Data")
        plt.xlabel("Sample")
        plt.ylabel("Value")
        plt.show()

    # Reset the parsed data for the next round

        counter = 0
