# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 7/03/2023

import time
from socket import *
from threading import Thread
import numpy as np
import matplotlib.pyplot as plt
from queue import Queue
from Data_Converter import DataConverter

def currentTime():
    return time.time_ns() / (10 ** 9)


class OpenEphysSender:
    def __init__(self, q_queue, p_channels, p_buffer_size, p_buffer_factor, p_frequency, p_port, p_host_addr=""):
        self.queue_conv_data = q_queue
        self.channel_list = p_channels
        self.num_channels = len(self.channel_list)
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


    # NEEDS A DIFFERENT PLUGGIN THAT IS AVAILABLE, BUT NEEDS RECOMPILING TO SWITCH WITH THE UDP VERSION
    # Was tested briefly but never really used since I needed more bandwidth
    def sendToOpenEphysTCP(self):
        print("STARTING SEND_OPENEPHYS THREAD")
        offset = 0          # Offset of bytes in this packet; only used for buffers > ~64 kB
        dataType = 2        # Enumeration value based on OpenCV.Mat data types
        elementSize = 2     # Number of bytes per element. elementSize = 2 for U16

        bytesPerBuffer = self.num_channels * self.buffer_size * elementSize
        header = np.array([offset, bytesPerBuffer], dtype='i4').tobytes() + \
                 np.array([dataType], dtype='i2').tobytes() + \
                 np.array([elementSize, self.num_channels, self.buffer_size], dtype='i4').tobytes()

        buffersPerSecond = self.frequency / self.buffer_size
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
        print("Starting OpenEphys Thread")
        openEphys_AddrPort = ("localhost", self.port)
        openEphys_Socket = socket(family=AF_INET, type=SOCK_DGRAM)

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


