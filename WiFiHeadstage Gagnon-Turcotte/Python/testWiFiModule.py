import socket
import struct
import threading
import time
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

#Coded by G. Gagnon-Turcotte at SiFiLabs
#Original version 6/22/2023

class WiFiServer(BaseException):

#Public
    
    #p_port: Port to listen on (non-privileged ports are > 1023)
    #p_host_addr: Standard loopback interface address (localhost)
    def __init__(self,channels, p_port, p_host_addr):
        BaseException.__init__(self)
        self.m_port = p_port
        self.m_socket = 0
        self.m_host_addr = p_host_addr
        self.m_thread_socket = False
        self.m_serverThread = threading.Thread(target=self.serverThread)
        self.m_connected = False
        self.converted_array = [[] for i in range(8)]
        self.channels = channels

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
        input2 = "B"
        self.m_socket.sendall(b""+bytes(input1, 'ascii')+bytes(input2, 'ascii'))

    def receiveData(self, buffer_size, loops):
        command = b"B"
        for ch in self.channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_socket.sendall(command)#Start Intan Timer
        #time.sleep(1)

        for i in range(loops):
            time.sleep(0.001)
            data = self.m_socket.recv(buffer_size)
            print("Loops ", i, " SizeOf Recv Buffer ", data.__sizeof__())
            ch_counter = 0
            for i in range(0, len(data), 2):
                converted_data = int.from_bytes([data[i + 1], data[i]], byteorder='big', signed=True)
                self.converted_array[ch_counter % 8].append(converted_data*0.000195)
                ch_counter += 1

        self.m_socket.sendall(b"C")#Stop Intan Timer
        time.sleep(1)

    #This version will call socket.recv as long as the buffer is not filled (was not necessary, seems to work with the 1ms sleep)
    def receiveDataTest(self):
        BUFFER_SIZE = 1024

        command = b"B"
        for ch in self.channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_socket.sendall(command)  # Start Intan Timer
        # time.sleep(1)

        for i in range(250):
            data = self.m_socket.recv(BUFFER_SIZE)
            print(data.__sizeof__())

            while len(data) < BUFFER_SIZE:
                rest_packet = self.m_socket.recv(BUFFER_SIZE- len(rest_packet))
                if not rest_packet:
                    print("BOOBOO")
                data.extend(rest_packet)

            ch_counter = 0
            for i in range(0, len(data), 2):
                converted_data = int.from_bytes([data[i + 1], data[i]], byteorder='big', signed=True)
                self.converted_array[ch_counter % 8].append(converted_data * 0.000195)
                ch_counter += 1

        self.m_socket.sendall(b"C")  # Stop Intan Timer
        time.sleep(1)

    #Considering that we have 8 channels !!
    def plotAllChannels(self):
        fig , axs = plt.subplots(4, 2, figsize=(30, 10))
        plt.gca().cla()
        ch_counter = 0
        for row in range(4):
            for column in range(2):
                k = [i for i in range(len(self.converted_array[ch_counter]))]

                #VERSION FOR PYTHON 3.10
                axs[row, column].plot(k, self.converted_array[ch_counter])
                axs[row, column].title.set_text("CHANNEL {}".format(self.channels[ch_counter]))

                print(ch_counter)
                ch_counter += 1
            #VERSION FOR PYTHON 3.9 (needs reajusting figure declaration)
           #  fig.add_subplot(4,2,ch)
           #  plt.subplot(4, 2, ch+1)
           #  plt.title("CHANNEL {}".format(self.channels[ch]))
           #  plt.plot(k, self.converted_array[ch])
        plt.show()

    def plot(self):
        k = [i for i in range(len(self.converted_array[0]))]
        plt.figure(figsize=(200, 10))
        plt.gca().cla()
        plt.plot(k, self.converted_array[0])
        plt.show()


    def serverThread(self):
        print("IN THREAD")
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



if __name__ == "__main__":
    TESTING_CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7]
    BUFFER_SIZE = 1024  # Maximum value possible for the WiFi UDP Socket communication
    LOOPS = 100         # Number of times we want to receive data from the Headstage before plotting the results

    # Port 5000, IP assign by router, possible to configure the router to have this static IP
    SOCKET_PORT = 5000
    HOST_IP_ADDR = "192.168.1.121"

    HEADSTAGESERVER = WiFiServer(TESTING_CHANNELS, SOCKET_PORT, HOST_IP_ADDR)
    HEADSTAGESERVER.startServer()

    while not(HEADSTAGESERVER.m_connected):
        time.sleep(1)

    # HEADSTAGESERVER.getID(0)
    # HEADSTAGESERVER.getID(1)
    # HEADSTAGESERVER.getID(2)
    HEADSTAGESERVER.configureIntanChip()

    # Buffer Size for Headstage communication is 1024 bytes.
    # Loops is the number of time we want to receive data
    HEADSTAGESERVER.receiveData(BUFFER_SIZE, LOOPS)
    HEADSTAGESERVER.plotAllChannels()


