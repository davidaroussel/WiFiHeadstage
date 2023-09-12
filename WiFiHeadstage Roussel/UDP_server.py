import socket
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.animation import FuncAnimation
import time
import sys
localIP = "10.99.172.126"
#localIP = "192.168.43.96"
# localIP = "192.168.0.226"

localPort = 10000
UDP_HEADER_SIZE = 56
UDP_BUFFER_SIZE = 128
bufferSize = UDP_BUFFER_SIZE + UDP_HEADER_SIZE

msgFromServer = "Hello"

bytesToSend = str.encode(msgFromServer)

# Create a datagram socket
UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
UDPServerSocket.bind((localIP, localPort))

print("UDP server up and listening on {}".format(localIP))

# Create figure for plotting
dataFilter = [0]*25*100
dataBufferInd = [0]*25
dataBufferPlot = [0]*1000000
dataBufferPlot_spi1 = [0]*100
dataBufferPlot_spi2 = [0]*100
statBuffer = [0.0]*10

listDataInt = [0]*25

fig, ax1 = plt.subplots(1)
fig.subplots_adjust(hspace=0.5)

# fig, (ax0,ax1,ax2,ax3,ax4,ax5,ax6,ax7,ax8,ax9,ax10,ax11,ax12,ax13,ax14,ax15,ax16,
#       ax17,ax18,ax19,ax20,ax21,ax22,ax23,ax24,ax25,ax26, ax27,ax28,ax29,ax30,ax31) = plt.subplots(32, 1)



ys = [0] * 1024
xs = []

testCounter = 1
dataCounter = 0
plotCounter = 0
errorCounter = 0


xs_plot = []

# This function is called periodically from FuncAnimation
def animate_2graph(xs, ys, counter,xs_plot):
    ys_plot_spi1 = []
    ys_plot_spi2 = []
    if singleplot == 1:
        for i in range(0, 100):

            #Filtrer les task_id en deux liste
            if ys[i][0] == 1:
                ys_plot_spi1.extend(list(ys[i][1:2049]))
            elif ys[i][0] == 2:
                ys_plot_spi2.extend(list(ys[i][1:2049]))


        # Limit x and y lists to 2500 items
        ys_plot_spi1 = ys_plot_spi1[-300000:]
        ys_plot_spi2 = ys_plot_spi2[-300000:]


        # Créer premiere list enumérative xs
        xs_plot = [j for j in
                   range(1 + (len(ys_plot_spi1) * counter), len(ys_plot_spi1) + (len(ys_plot_spi1) * counter) + 1)]

        # Draw first plot x and y lists
        ax1.clear()
        ax1.plot(xs_plot, ys_plot_spi1, 'red')
        plt.pause(0.01)

        # Créer deuxieme list enumérative xs
        xs_plot = [j for j in
                   range(1 + (len(ys_plot_spi2) * counter), len(ys_plot_spi2) + (len(ys_plot_spi2) * counter) + 1)]

        # Draw second x and y lists
        ax2.clear()
        ax2.plot(xs_plot, ys_plot_spi2, 'blue')
        plt.pause(0.01)

        # Format plot
        plt.xticks(rotation=45, ha='right')
        plt.subplots_adjust(bottom=0.30)



    else:
        for i in range(0, 32):
            for j in range(0+i, 64, 204800):
                ys_plot.extend(list(ys[j]))
                # Limit x and y lists to 2500 items
            xs_plot = xs_plot[-32000:]
            ys_plot = ys_plot[-32000:]

            # Draw x and y lists
            ax1.clear()
            ax1.plot(xs_plot, ys_plot, '.')
            plt.pause(0.01)
        # Format plot
        plt.xticks(rotation=45, ha='right')
        plt.subplots_adjust(bottom=0.30)
        plt.title('SPI - UDP')
        plt.ylabel('SPI value')

def animate(xs, ys, counter,xs_plot):
    ys_plot = []

    for i in range(0, 100, 1):
        ys_plot.extend(list(ys[i]))
        # Limit x and y lists to 2500 items
    xs = xs[-5000000:]
    ys_plot = ys_plot[-5000000:]

    # Draw x and y lists
    ax1.clear()
    ax1.plot(xs, ys_plot, '.')
    plt.pause(0.01)
    # Format plot
    plt.xticks(rotation=45, ha='right')
    plt.title('SPI - UDP')
    plt.ylabel('SPI value')



# This function is called periodically from FuncAnimation
def test_performance(ys, testCounter):
    errorCounter = 0
    for i in range(0, 100):
        print("Buf %d" % (ys[i][0]))
        for j in range(1, UDP_BUFFER_SIZE):
            compareValue = int(ys[i][j])
            compareCounter = j // 16
            if (int(compareValue) != compareCounter):
                errorCounter += 1
                print("Error: #%d[%d]: %d, is %d"%(i,j, compareCounter, compareValue))
    print("#%d Error: bytes %d | Rate %d%% " % (testCounter, errorCounter, (errorCounter/UDP_BUFFER_SIZE*100)*100))



    # for i in range(0, 100):
    #     print("Buf %d" % (ys[i][0]))
    #     for j in range(1, UDP_BUFFER_SIZE):
    #         compareValue = int(ys[i][j])
    #         compareCounter = j // 16
    #         if (int(compareValue) != compareCounter):
    #             errorCounter += 1
    #             print("Error: #%d[%d]: %d, is %d"%(i,j, compareCounter, compareValue))
    # print("#%d Error: bytes %d | Rate %d%% " % (testCounter, errorCounter, (errorCounter/UDP_BUFFER_SIZE*100)*100))

testPerfor = 0
singleplot = 1
with_task_id = 0

counter = 0

RHD64_DATA_BUFFER = [[0 for i in range(64)] for j in range(15)]
MSG_BYTES_SIZE = 2

while(1):

        t1 = time.time()
        bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)
        t2 = time.time()
        #print("Temps : ", t2-t1, " s")
        print("Counter: ", plotCounter)

        message = bytesAddressPair[0]

        #print((dataBufferPlot[plotCounter]))
        plotCounter += 1
        buffer = dataBufferPlot[plotCounter]
        for i in range(0, UDP_BUFFER_SIZE, 2):
            rounds = i % 15
            channels = (i%15)%64
            RHD64_DATA_BUFFER[rounds][channels] = dataBufferPlot[plotCounter]









