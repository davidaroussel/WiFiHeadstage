# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 7/03/2023

import time
from socket import *
from threading import Thread
import numpy as np
import matplotlib.pyplot as plt
from queue import Queue
from .DataConverter import DataConverter


class OpenEphysSender:
    def __init__(self, q_queue, p_buffer_size, p_buffer_factor, p_frequency, p_port, p_host_addr=""):
        self.queue_conv_data = q_queue
        self.buffer_size = p_buffer_size
        self.buffer_factor = p_buffer_factor
        self.frequency = p_frequency
        self.host_addr = p_host_addr
        self.port = p_port
        self.buffServer_Flag = False
        self.buffServer_Thread = Thread(target=self.sendToOpenEphys)

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
        openEphys_AddrPort = ("192.168.1.147", self.port)
        openEphys_Socket = socket(family=AF_INET, type=SOCK_STREAM)
        try:
            openEphys_Socket.connect(openEphys_AddrPort)
        except Exception as e:
            print("Error connecting to OpenEphys:", e)
            return

        try:
            while True:
                item = self.queue_conv_data.get()
                openEphys_Socket.sendall(item)
        except KeyboardInterrupt:
            print("---Connection closed---")
        finally:
            openEphys_Socket.close()

    def sendToOpenEphys(self):
        # SPECIFY THE IP AND PORT #
        print("---STARTING SEND_OPENEPHYS THREAD---")
        openEphys_AddrPort = ("192.168.1.147", self.port)
        openEphys_Socket = socket(family=AF_INET, type=SOCK_DGRAM)

        buffersPerSecond = self.frequency / self.buffer_size
        bufferInterval = 1 / buffersPerSecond

        while True:
            t1 = self.currentTime()
            item = self.queue_conv_data.get()

            openEphys_Socket.sendto(item, openEphys_AddrPort)
            t2 = self.currentTime()

            # CHECKING TO MAKE SURE WE DONE SEND DATA TO FAST
            while ((t2 - t1) < bufferInterval):
                t2 = self.currentTime()

    def send_to_openEphys(self):
        openEphys_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        openEphys_socket.connect(("192.168.1.147", self.port))

        def send_data(data):
            openEphys_socket.sendall(data)
        try:
            while True:
                # Generate or fetch data to send
                data = b'your_data_here'  # Replace with your data
                send_data(data)
        except KeyboardInterrupt:
            openEphys_socket.close()
            print("---Connection closed---")


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

    CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7]
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
