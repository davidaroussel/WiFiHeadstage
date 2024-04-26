import socket
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.animation import FuncAnimation
import time
import sys
localIP = "10.99.172.126"
#localIP = "192.168.43.96"
#localIP = "192.168.0.226"

localPort = 10001
buffer = 1024
bufferSize = buffer+56

msgFromServer = "Hello"

bytesToSend = str.encode(msgFromServer)

# Create a datagram socket

UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

# Bind to address and ip

UDPServerSocket.bind((localIP, localPort))

print("UDP server up and listening on {}".format(localIP))

# Create figure for plotting


dataFilter = [0]*25*100
dataBufferInd = [0]*25
dataBufferPlot = []
dataBufferPlot_spi1 = [0]*100
dataBufferPlot_spi2 = [0]*100
statBuffer = [0.0]*10

listDataInt = [0]*25

fig, (ax1, ax2) = plt.subplots(2)
fig.subplots_adjust(hspace=0.5)

# fig, (ax0,ax1,ax2,ax3,ax4,ax5,ax6,ax7,ax8,ax9,ax10,ax11,ax12,ax13,ax14,ax15,ax16,
#       ax17,ax18,ax19,ax20,ax21,ax22,ax23,ax24,ax25,ax26, ax27,ax28,ax29,ax30,ax31) = plt.subplots(32, 1)



ys = [0] * 1024
xs = []

loopcounter = 0
dataCounter = 0
plotCounter = 0
errorCounter = 0
errorNumber = 0


xs_plot = []

ys_36channel_plot = []

# This function is called periodically from FuncAnimation
def animate(xs, ys, counter,xs_plot):
    ys_plot_spi1 = []
    ys_plot_spi2 = []
    if singleplot == 1:
        for i in range(0, 200):
            ys_plot_spi1.extend(list(ys[i][:2048]))

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


# This function is called periodically from FuncAnimation
def test_performance_8192(ys):
    errorCounter = 0
    compareCounter = 0
    for i in range(0, 1):
        for j in range(0, 8192):
            compareValue = int(ys[i][j])
            compareCounter = j // 8
            if (int(compareValue) != compareCounter):
                errorCounter += 1
                print(compareValue)
                print(ys[i][j])
    print("Error: bytes %d | Rate %d%% " % (errorCounter, (errorCounter/204800)*100))


# This function is called periodically from FuncAnimation
def test_performance_2048(dataBufferPlot, errorNumber, statBuffer):
    errorCounter = 0
    compareCounter = 0
    result = 0.0
    ys_plot_spi1 = []
    ys_plot_spi2 = [] #LIST FOR

    #Filtrer liste pour diviser selon SPI1 ou SPI2
    for i in range(0, 100):
        # Filtrer les task_id en deux liste
        if dataBufferPlot[i][0] == 1:
            ys_plot_spi1.extend(list(dataBufferPlot[i][1:2049]))
        elif dataBufferPlot[i][0] == 2:
            ys_plot_spi2.extend(list(dataBufferPlot[i][1:2049]))


    #Tester les DEUX listes pour valider le contenu
    numberOfBuffer = int(len(ys_plot_spi1)/2048)
    for i in range(0, numberOfBuffer):  #FILTER ALL DATA IN BUFFER
        for j in range(0, 2048):
            compareValue = ys_plot_spi1[j +(i*2048)]
            compareCounter = j // 8
            if (int(compareValue) != compareCounter):
                errorCounter += 1
    pourcentage = (errorCounter/len(ys_plot_spi1))*100
    print("SPI1: Error %d: bytes %d | Rate %f%% " % (errorNumber, errorCounter, pourcentage))

    errorCounter = 0
    numberOfBuffer = int(len(ys_plot_spi2)/2048)
    for i in range(0, numberOfBuffer):  #FILTER ALL DATA IN BUFFER
        for j in range(0, 2048):
            compareValue = ys_plot_spi2[j +(i*2048)]
            compareCounter = j // 8
            if (int(compareValue) != compareCounter):
                errorCounter += 1
    pourcentage = (errorCounter / len(ys_plot_spi2)) * 100
    print("SPI2: Error %d: bytes %d | Rate %f%% " % (errorNumber, errorCounter, pourcentage))

    # statBuffer[errorNumber] = pourcentage
    # if errorNumber >= 9:
    #     for i in range(1,10):
    #         result += statBuffer[i]
    #     result = result / 10
    #     print("--------------------------")
    #     print("Total: %.15f%%" % (result))
    #     print("--------------------------")
    #     result = 0


# This function is called periodically from FuncAnimation
def test_performance_1024(ys):
    errorCounter = 0
    compareCounter = 0
    for i in range(0, 100):
        for j in range(0, bufferSize):
            compareValue = ys[i][j]
            compareCounter = (j // 4) * 2
            if (compareCounter>=256):
                compareCounter = compareCounter%256
            if (int(compareValue) != compareCounter):
                errorCounter += 1
    print("error counter %d %d " % (errorCounter, errorCounter//bufferSize))




testPerfor = 0
singleplot = 1
counter = 0

while(1):
    startTime = time.time()
    totalTime = (time.time() - startTime)
    while (totalTime < 1.00):
        bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)
        message = bytesAddressPair[0]
        dataBufferPlot.append(message[:buffer])
        plotCounter += 1
        totalTime = (time.time() - startTime)
        #print(message)


    print(len(dataBufferPlot))
    print(len(dataBufferPlot)*buffer)
    dataBufferPlot = []
    print(totalTime)








