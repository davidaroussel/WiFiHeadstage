# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 7/03/2023

import time
from socket import *
from threading import Thread
import numpy as np
import matplotlib.pyplot as plt
from queue import Queue
from .DataConverter import DataConverter

def currentTime():
    return time.time_ns() / (10 ** 9)


class OpenEphysSender:
    def __init__(self, force_diff, q_queue, p_buffer_size, p_buffer_factor, p_frequency, p_port, p_host_addr=""):
        self.force_diff = force_diff
        self.queue_conv_data = q_queue
        self.buffer_size = p_buffer_size
        self.buffer_factor = p_buffer_factor
        self.frequency = p_frequency
        self.host_addr = p_host_addr
        self.port = p_port
        self.buffServer_Flag = False
        self.buffServer_Thread = Thread(target=self.sendToOpenEphysUDP)

    def startThread(self):
        self.buffServer_Thread.start()

    # Stop the server
    def stopThread(self):
        if self.buffServer_Flag:
            self.buffServer_Thread.join()

    def currentTime(self):
        return time.time_ns() / (10 ** 9)


    def sendToOpenEphysTCP(self):
        print("---STARTING SEND_OPENEPHYS THREAD---")

        numChannels = 8  # number of channels to send
        numSamples = 1024  # size of the data buffer
        Freq = 12000  # sample rate of the signal
        offset = 0  # Offset of bytes in this packet; only used for buffers > ~64 kB
        dataType = 2  # Enumeration value based on OpenCV.Mat data types
        elementSize = 2  # Number of bytes per element. elementSize = 2 for U16

        bytesPerBuffer = numChannels * numSamples * elementSize
        header = np.array([offset, bytesPerBuffer], dtype='i4').tobytes() + \
                 np.array([dataType], dtype='i2').tobytes() + \
                 np.array([elementSize, numChannels, numSamples], dtype='i4').tobytes()

        buffersPerSecond = Freq / numSamples
        bufferInterval = 1 / buffersPerSecond

        openEphys_AddrPort = ("localhost", self.port)
        try:
            openEphys_Socket = socket(family=AF_INET, type=SOCK_STREAM)
            openEphys_Socket.bind(openEphys_AddrPort)
            openEphys_Socket.listen(1)


            print("Waiting for external connection to start...")
            (tcpClient, address) = openEphys_Socket.accept()
            print("Connected.")
        except Exception as e:
            print("Error connecting to OpenEphys:", e)
            return

        try:
            while True:
                item = self.queue_conv_data.get()
                rc = tcpClient.sendto(header + item, address)

        except KeyboardInterrupt:
            print("---Connection closed---")
        finally:
            openEphys_Socket.close()

    def sendToOpenEphysUDP(self):
        # SPECIFY THE IP AND PORT #
        print("---STARTING SEND_OPENEPHYS THREAD---")
        openEphys_AddrPort = ("localhost", self.port)
        openEphys_Socket = socket(family=AF_INET, type=SOCK_DGRAM)

        if self.force_diff:
            buffersPerSecond = (self.frequency / self.buffer_size) / 2
            bufferInterval = 1 / buffersPerSecond
        else:
            buffersPerSecond = self.frequency / self.buffer_size
            bufferInterval = 1 / buffersPerSecond

        max_udp_size = 65535
        while True:
            t1 = self.currentTime()
            item = self.queue_conv_data.get()

            if len(item) > max_udp_size:
                half_point = len(item) // 2
                item_part1 = item[:half_point]
                item_part2 = item[half_point:]
                half_interval = bufferInterval / 2

                openEphys_Socket.sendto(item_part1, openEphys_AddrPort)
                t2 = self.currentTime()

                # CHECKING TO MAKE SURE WE DONE SEND DATA TO FAST
                while ((t2 - t1) < half_interval):
                    t2 = self.currentTime()

                t1 = self.currentTime()
                openEphys_Socket.sendto(item_part2, openEphys_AddrPort)
                t2 = self.currentTime()

                # CHECKING TO MAKE SURE WE DONE SEND DATA TO FAST
                while ((t2 - t1) < half_interval):
                    t2 = self.currentTime()
            else:

                openEphys_Socket.sendto(item, openEphys_AddrPort)
                t2 = self.currentTime()

                # CHECKING TO MAKE SURE WE DONE SEND DATA TO FAST
                while ((t2 - t1) < bufferInterval):
                    t2 = self.currentTime()

    def plotData(self):
        # SPECIFY THE IP AND PORT #
        print("---STARTING SEND_OPENEPHYS THREAD---")
        fig, axs = plt.subplots(8, 1, figsize=(30, 10))
        plt.gca().cla()
        file_number = 0
        full_data = [[] for i in range(8)]
        loops = 0
        while True:
            item = self.queue_conv_data.get()

            if loops < 10:
                print("Loops", loops)
                for ch in range(8):
                    full_data[ch] = full_data[ch] + item [ch]
                loops += 1
            else:
                print("Plotting !!")
                loops = 0

                for row in range(8):
                    k = [i for i in range(len(full_data[row]))]
                    # VERSION FOR PYTHON 3.10
                    axs[row].plot(k, full_data[row])
                    axs[row].title.set_text("CHANNEL {}".format(row))
                filename = "Figure"+str(file_number)+".png"
                plt.savefig(filename)
                file_number += 1
                fig, axs = plt.subplots(8, 1, figsize=(30, 10))
                plt.gca().cla()



if __name__ == "__main__":

    #GLOBAL VARIABLES
    HOST_ADDR = ""
    OPENEPHYS_PORT = 10001

    CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    BUFFER_SIZE = 1024
    FREQUENCY = 12000

    #CONSTRUCTORS
    QUEUE_RAW_DATA = Queue()
    QUEUE_CONV_DATA = Queue()

    TOOLKIT = Toolkit(QUEUE_RAW_DATA)
    TASK_DataConverter = DataConverter(QUEUE_RAW_DATA, QUEUE_CONV_DATA, CHANNELS, BUFFER_SIZE)
    TASK_OpenEphysSender = OpenEphysSender(QUEUE_CONV_DATA, BUFFER_SIZE, FREQUENCY, p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)

    TASK_OpenEphysSender.sendToOpenEphys()
    TASK_DataConverter.startThread()
    TOOLKIT.startThread()
