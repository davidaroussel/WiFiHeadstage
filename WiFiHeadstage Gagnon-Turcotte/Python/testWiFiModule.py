import socket
import os
import math
import struct
import threading
import time
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

#Coded by G. Gagnon-Turcotte at SiFiLabs
#Original version 6/22/2023

class WiFiServer(BaseException):
    #p_port: Port to listen on (non-privileged ports are > 1023)
    #p_host_addr: Standard loopback interface address (localhost)
    def __init__(self, p_port, p_host_addr, channels, samp_freq, buffer_size):
        BaseException.__init__(self)
        self.m_port = p_port
        self.m_socket = 0
        self.m_host_addr = p_host_addr
        self.m_channels = channels
        self.m_buffer_size = buffer_size
        self.m_samp_freq = samp_freq
        self.m_thread_socket = False
        self.m_serverThread = threading.Thread(target=self.serverThread)
        self.m_connected = False
        self.m_raw_data = []
        self.m_converted_array = [[] for i in range(8)]



        self.m_serverThread = threading.Thread(target=self.serverThread)

    #Start the server to receive the data
    def startServer(self):
        self.m_serverThread.start()

    #Stop the server
    def stopServer(self):
        if self.m_thread_socket:
            self.m_thread_socket.shutdown(socket.SHUT_RDWR)
            self.m_serverThread.join()


    def readMenu(self):
        self.m_socket.sendall(b"0")
        print(self.m_socket.recv(1024).decode("cp1252'"))

    def configureIntanChip(self):
        self.m_socket.sendall(b"A")
        print(self.m_socket.recv(1024).decode("utf-8"))
        print("Low-pass selection:")
        #input1 = input()
        input1 = "4"
        print("High-pass selection:")
        #input2 = input()
        input2 = "4"
        self.m_socket.sendall(b""+bytes(input1, 'ascii')+bytes(input2, 'ascii'))

    def receiveDataV1(self, buffer_size, loops):
        command = b"B"
        for ch in self.channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_socket.sendall(command)#Start Intan Timer
        #time.sleep(1)

        for i in range(loops):

            data = self.m_socket.recv(buffer_size)
            print("Loops ", i, " SizeOf Recv Buffer ", data.__sizeof__())
            ch_counter = 0
            # for i in range(0, len(data), 2):
            #     converted_data = int.from_bytes([data[i + 1], data[i]], byteorder='big', signed=True)
            #     self.m_converted_array[ch_counter % 8].append(converted_data*0.000195)
            #     ch_counter += 1

        self.m_socket.sendall(b"C")#Stop Intan Timer
        time.sleep(1)

    #This version will call socket.recv as long as the buffer is not filled (was not necessary, seems to work with the 1ms sleep)
    def receiveDataV2(self, buffer_size, loops):
        BUFFER_SIZE = buffer_size
        command = b"B"
        for ch in self.m_channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_socket.sendall(command)  # Start Intan Timer
        time.sleep(0.1)

        for i in range(loops):
            pourcentage = round((i/loops) * 100, 3)
            print(pourcentage, "%")

            data = []
            while len(data) < BUFFER_SIZE:
                rest_packet = self.m_socket.recv(BUFFER_SIZE)
                if not rest_packet:
                    print("BOOBOO")
                data += bytearray(rest_packet)
                time.sleep(0.001)
            self.m_raw_data.extend(data)


        self.m_socket.sendall(b"C")  # Stop Intan Timer
        time.sleep(1)



    #Considering that we have 8 channels !!
    def plotAllChannels(self):
        fig, axs = plt.subplots(4, 2, figsize=(30, 10))
        plt.gca().cla()

        ch_counter = 0
        for i in range(0, len(self.m_raw_data), 2):
            converted_data = int.from_bytes([self.m_raw_data[i + 1], self.m_raw_data[i]], byteorder='big', signed=True)
            self.m_converted_array[ch_counter % 8].append(converted_data * 0.000195)
            ch_counter += 1

        ch_counter = 0
        for row in range(4):
            for column in range(2):
                k = [i for i in range(len(self.m_converted_array[ch_counter]))]
                #VERSION FOR PYTHON 3.10
                axs[row, column].plot(k, self.m_converted_array[ch_counter])
                axs[row, column].title.set_text("CHANNEL {}".format(self.m_channels[ch_counter]))
                ch_counter += 1

            #VERSION FOR PYTHON 3.9 (needs reajusting figure declaration)
           #  fig.add_subplot(4,2,ch)
           #  plt.subplot(4, 2, ch+1)
           #  plt.title("CHANNEL {}".format(self.channels[ch]))
           #  plt.plot(k, self.m_converted_array[ch])
        plt.show()

    def serverThread(self):
        print("WAITING FOR THE DEVICE")
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as self.s:
            self.s.bind((self.m_host_addr, self.m_port))
            self.s.listen()
            conn, addr = self.s.accept()
            self.m_socket = conn
            self.m_thread_socket = conn
            if conn:
                print(f"Connected by {addr}")
                self.m_connected = True
                self.s.setblocking(True)

    def getID(self, p_id):
        self.m_socket.sendall(b"9")
        self.m_socket.sendall(p_id.to_bytes(1, 'big'))
        time.sleep(1)
        print(self.m_socket.recv(8))

    def calculateSamplingLoops(self, SAMPLING_TIME):
        NUM_CHANNEL = len(self.m_channels)
        BYTES_PER_CHANNEL = 2
        BYTES_PER_SEC = self.m_samp_freq * BYTES_PER_CHANNEL * NUM_CHANNEL
        TOTAL_NUMBER_OF_BYTES = BYTES_PER_SEC * SAMPLING_TIME
        LOOPS = math.floor(TOTAL_NUMBER_OF_BYTES / self.m_buffer_size) # Number of times we want to receive data from the Headstage before plotting the results

        REAL_SAMPLING_TIME = (LOOPS * self.m_buffer_size) / BYTES_PER_SEC
        print("Will sample for ", REAL_SAMPLING_TIME, "sec representing", LOOPS, " loops for a total of",
              TOTAL_NUMBER_OF_BYTES, " bytes")

        return LOOPS


if __name__ == "__main__":
    # Port 5000, IP assign by router, possible to configure the router to have this static IP
    SOCKET_PORT = 3000
    HOST_IP_ADDR = ""

    # TESTING_CHANNELS = [0, 1, 2, 3, 32, 33, 34, 35]
    TESTING_CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7]
    SAMPLING_TIME = 30  # Time sampling in seconds
    FREQ_SAMPLING = 15000
    BUFFER_SIZE = 1024*1000  # Maximum value possible for the WiFi UDP Socket communication

    HEADSTAGESERVER = WiFiServer(SOCKET_PORT, HOST_IP_ADDR, TESTING_CHANNELS, FREQ_SAMPLING, BUFFER_SIZE)
    LOOPS = HEADSTAGESERVER.calculateSamplingLoops(SAMPLING_TIME)

    HEADSTAGESERVER.startServer()

    while not(HEADSTAGESERVER.m_connected):
        time.sleep(1)

    # HEADSTAGESERVER.getID(0)
    # HEADSTAGESERVER.getID(1)
    # HEADSTAGESERVER.getID(2)
    HEADSTAGESERVER.configureIntanChip()

    # Buffer Size for Headstage communication is 1024 bytes.
    # Loops is the number of time we want to receive data

    print("Welcome to the Python Menu!")
    print("1. Samples the channels")
    print("2. Option 2")
    print("3. Option 3")
    print("4. Exit")


    while True:
        choice = input("Select an option: ")
        if choice == "1":

            HEADSTAGESERVER.receiveDataV2(BUFFER_SIZE, LOOPS)
            HEADSTAGESERVER.plotAllChannels()
            # Add your code for Option 1 here
        elif choice == "4":
            print("Exiting the menu.")
            break
        else:
            print("Invalid choice. Please select a valid option.")
