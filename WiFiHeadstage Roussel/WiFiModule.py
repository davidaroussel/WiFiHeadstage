import socket
import os
import math
import struct
import threading
import time
import cmath
import matplotlib.pyplot as plt
from numpy.fft import fft
import numpy as np
from matplotlib.animation import FuncAnimation


class WiFiServer(BaseException):
    def __init__(self, p_port, p_host_addr, channels, samp_freq, buffer_size):
        BaseException.__init__(self)
        self.m_port = p_port
        self.m_socket = 0
        self.m_host_addr = p_host_addr
        self.m_channels = channels
        self.m_buffer_size = buffer_size
        self.m_samp_freq = samp_freq
        self.m_thread_socket = False
        self.m_serverThread = threading.Thread(target=self.connectTCP)
        self.m_connected = False
        self.m_raw_data = []
        self.m_converted_array = [[] for i in range(8)]

    def startServer(self):
        self.m_serverThread.start()

    #Stop the server
    def stopServer(self):
        if self.m_thread_socket:
            self.m_socket.shutdown(socket.SHUT_RDWR)
            self.m_serverThread.join()

    def connectTCP(self):
        print("WAITING FOR THE DEVICE")
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as self.s:
            self.s.bind((self.m_host_addr, self.m_port))
            self.s.listen()
            conn, addr = self.s.accept()
            self.m_socket = conn
            if conn:
                print(f"Connected by {addr}")
                self.m_connected = True

    def calculateSamplingLoops(self, SAMPLING_TIME):
        NUM_CHANNEL = len(self.m_channels)
        BYTES_PER_CHANNEL = 2
        BYTES_PER_SEC = self.m_samp_freq * BYTES_PER_CHANNEL * NUM_CHANNEL
        TOTAL_NUMBER_OF_BYTES = BYTES_PER_SEC * SAMPLING_TIME
        LOOPS = math.floor(TOTAL_NUMBER_OF_BYTES / self.m_buffer_size) # Number of times we want to receive data from the Headstage before plotting the results

        REAL_SAMPLING_TIME = (LOOPS * self.m_buffer_size) / BYTES_PER_SEC
        print(
            f"Will sample for {REAL_SAMPLING_TIME:.2f} sec representing {LOOPS} loops for a total of {TOTAL_NUMBER_OF_BYTES} bytes")

        return LOOPS

    def receiveMenu(self):
        self.m_socket.sendall(b"1")
        # Receive and display the menu
        menu = self.m_socket.recv(1024).decode("utf-8")
        print("Received Menu:")
        print(menu)

    def resetDevice(self):
        self.m_socket.sendall(b"4")
        main()

    def configureIntanChip(self):
        self.m_socket.sendall(b"2")
        print(self.m_socket.recv(1024).decode("utf-8"))

        print("Received Intan Menu:")

        print("Low-pass selection:")
        #input1 = input()
        input1 = "4"
        print("High-pass selection:")
        #input2 = input()
        input2 = "4"
        self.m_socket.sendall(b"A"+bytes(input1, 'ascii')+bytes(input2, 'ascii'))

    def receiveDataFINAL(self, buffer_size, loops):
        BUFFER_SIZE = buffer_size
        self.m_raw_data = []
        command = b"B"
        time.sleep(1)
        for ch in self.m_channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_socket.sendall(command)  # Start Intan Timer
        time.sleep(0.001)

        for i in range(loops):
            pourcentage = round((i/loops) * 100, 3)
            print(pourcentage, "%")

            data = []
            while len(data) < BUFFER_SIZE:
                rest_packet = self.m_socket.recv(BUFFER_SIZE)
                if not rest_packet:
                    print("BOOBOO")
                data += bytearray(rest_packet)
                #time.sleep(0.001)
            self.m_raw_data.extend(data)


        self.m_socket.sendall(b"C")  # Stop Intan Timer
        time.sleep(0.1)

        #EMPTY SOCKET BUFFER
        trash_bufsize = buffer_size
        while True:
            packet = self.m_socket.recv(trash_bufsize)
            if len(packet) < trash_bufsize:
                break

    def receiveDataDEV(self, buffer_size, loops):
        command = b"3"
        time.sleep(1)
        for ch in self.m_channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_socket.sendall(command)  # Start Intan Timer
        time.sleep(0.001)

        received_data = []  # Initialize a variable to store the received data

        while True:
            rest_packet = self.m_socket.recv(2048)
            print(rest_packet)

            # Append the received data to the list
            received_data.append(np.frombuffer(rest_packet, dtype=np.uint16))

            # Check if you have received enough data to plot
            if len(received_data) >= 5:  # Assuming 1024 values per reception
                # Concatenate and plot all received data
                all_received_data = np.concatenate(received_data)
                received_data.clear()  # Clear the received data list

                # Your plotting logic here using all_received_data
                plt.plot(all_received_data)
                plt.show()

        # data = []
        # while len(data) < buffer_size:
        #     rest_packet = self.m_socket.recv(buffer_size)
        #     print(rest_packet)
        #     if not rest_packet:
        #         print("BOOBOO")
        #     data += bytearray(rest_packet)
        #     # time.sleep(0.001)
        # self.m_raw_data.extend(data)

def main():
    # Port 5000, IP assign by router, possible to configure the router to have this static IP
    HOST_IP_ADDR = "0.0.0.0"
    SOCKET_PORT = 10000

    # TESTING_CHANNELS = [0, 1, 2, 3, 32, 33, 34, 35]
    TESTING_CHANNELS = [i for i in range(0, 64)]  # ALL OF THEM
    SAMPLING_TIME = 20  # Time sampling in seconds
    FREQ_SAMPLING = 15000
    BUFFER_SIZE = 1024 * 2000  # Maximum value possible for the WiFi UDP Socket communication

    HEADSTAGESERVER = WiFiServer(SOCKET_PORT, HOST_IP_ADDR, TESTING_CHANNELS, FREQ_SAMPLING, BUFFER_SIZE)
    LOOPS = HEADSTAGESERVER.calculateSamplingLoops(SAMPLING_TIME)

    HEADSTAGESERVER.startServer()

    while not (HEADSTAGESERVER.m_connected):
        time.sleep(1)
    #
    HEADSTAGESERVER.receiveMenu()
    HEADSTAGESERVER.configureIntanChip()
    HEADSTAGESERVER.receiveDataDEV(BUFFER_SIZE, LOOPS)
    HEADSTAGESERVER.receiveMenu()
    HEADSTAGESERVER.receiveDataDEV(BUFFER_SIZE, LOOPS)
    HEADSTAGESERVER.receiveMenu()




if __name__ == "__main__":
    main()