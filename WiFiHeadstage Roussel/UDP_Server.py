import socket
import time
import math
import matplotlib.pyplot as plt

localIP = "10.99.172.126"
#localIP = "192.168.43.96"
# localIP = "192.168.0.226"

localPort = 10000
UDP_HEADER_SIZE = 56
UDP_BUFFER_SIZE = 128
bufferSize = UDP_BUFFER_SIZE + UDP_HEADER_SIZE

# Create a datagram socket
UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
UDPServerSocket.bind((localIP, localPort))

print("UDP server up and listening on {}".format(localIP))

counter = 0
ROUNDS = 10000
NUM_CHANNELS = 64
BYTES_PER_DATA = 2
RHD64_DATA_BUFFER = [[None for i in range(ROUNDS)] for j in range(NUM_CHANNELS)]

NUM_OF_COLUMN = 4 #HAS TO BE A DIVIDER OF 64

def plotAllChannels():
    fig, axs = plt.subplots(int(NUM_CHANNELS/NUM_OF_COLUMN), NUM_OF_COLUMN, figsize=(30, 10))
    plt.gca().cla()
    ch_counter = 0
    for col in range(NUM_OF_COLUMN):
        for row in range(int(NUM_CHANNELS/NUM_OF_COLUMN)):
            k = [i for i in range(len(RHD64_DATA_BUFFER[ch_counter]))]
            #VERSION FOR PYTHON 3.10
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


while(1):
    t1 = time.time()
    bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)
    t2 = time.time()
    #print("Temps : ", t2-t1, " s")
    if counter %100 == 0:
        print("Counter: ", counter)

    message = bytesAddressPair[0][:UDP_BUFFER_SIZE]
    for i in range(0, UDP_BUFFER_SIZE, 2):
        byte1 = message[i]
        byte2 = message[i + 1]
        # Combine the two bytes to create a 16-bit value
        data_value = (byte2 << 8) | byte1

        channels = (i // BYTES_PER_DATA) % NUM_CHANNELS
        RHD64_DATA_BUFFER[channels][counter] = data_value

    counter += 1
    if counter == ROUNDS-1:
        plotChannel(0)
        #plotAllChannels()
        counter = 0










