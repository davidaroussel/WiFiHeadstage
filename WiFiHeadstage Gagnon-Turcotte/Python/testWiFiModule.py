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
    def __init__(self, p_port, p_host_addr = ""):
        BaseException.__init__(self)
        self.m_port = p_port
        self.m_conn = 0
        self.m_host_addr = p_host_addr
        self.m_thread_socket = False
        self.m_serverThread = threading.Thread(target=self.serverThread)
        self.dummy_buffer_for_test = []
        self.m_connected = False
        self.converted_array = [[] for i in range(8)]
        self.channels = []

    #Start the server to receive the data
    def startServer(self):
        self.m_serverThread.start()

    #Stop the server
    def stopServer(self):
        if self.m_thread_socket:
            self.m_thread_socket.shutdown(socket.SHUT_RDWR)
            self.m_serverThread.join()

#End public

#Private

    def readMenu(self):
        self.m_conn.sendall(b"0")
        print(self.m_conn.recv(1024).decode("cp1252'"))

    def configureIntanChip(self):
        self.m_conn.sendall(b"A")
        print(self.m_conn.recv(1024).decode("utf-8"))
        print("Low-pass selection:")
        #input1 = input()
        input1 = "4"
        print("High-pass selection:")
        #input2 = input()
        input2 = "B"
        self.m_conn.sendall(b""+bytes(input1, 'ascii')+bytes(input2, 'ascii'))

    def receiveDataTest(self):
        command = b"B"

        #self.channels = [0, 1, 2, 3, 34, 35, 46, 47]
        self.channels = [33, 34, 35, 36, 37, 38, 39, 40]
        #self.channels = [0, 1, 2, 3, 4, 5, 6, 7]
        for ch in self.channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_conn.sendall(command)#Start Intan Timer
        #time.sleep(1)

        for i in range(10):
            time.sleep(0.001)
            data = self.m_conn.recv(1024)
            print(data.__sizeof__())


            ch_counter = 0
            for i in range(0, len(data), 2):
                converted_data = int.from_bytes([data[i + 1], data[i]], byteorder='big', signed = True)
                self.converted_array[ch_counter%8].append(converted_data*0.000000195)
                ch_counter += 1
        

        self.m_conn.sendall(b"C")#Stop Intan Timer
        time.sleep(1)


    def receiveDataTestV2(self):
        BUFFER_SIZE = 1024
        command = b"B"

        # self.channels = [33, 34, 35, 36, 37, 38, 39, 40]
        # self.channels = [0, 1, 2, 3, 32, 33, 46, 47]
        # self.channels = [0, 1, 2, 3, 4, 5, 6, 7]

        for ch in self.channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_conn.sendall(command)  # Start Intan Timer
        # time.sleep(1)

        for i in range(100):

            data = self.m_conn.recv(BUFFER_SIZE)
            print(data.__sizeof__())

            while len(data) < BUFFER_SIZE:
                rest_packet = self.m_conn.recv(BUFFER_SIZE- len(rest_packet))
                if not rest_packet:
                    print("BOOBOO")
                data.extend(rest_packet)

            ch_counter = 0
            for i in range(0, len(data), 2):
                converted_data = int.from_bytes([data[i + 1], data[i]], byteorder='big', signed=True)
                self.converted_array[ch_counter % 8].append(converted_data * 0.000000195)
                ch_counter += 1

        self.m_conn.sendall(b"C")  # Stop Intan Timer
        time.sleep(1)

    def plotAllChannels(self):

        fig , axs = plt.subplots(4, 2, figsize=(30,10))
        plt.gca().cla()

        for row in range(4):
            for column in range(2):
                k = [i for i in range(len(self.converted_array[row+column]))]

                #VERSION FOR PYTHON 3.10
                axs[row, column].plot(k, self.converted_array[row+column])
                axs[row, column].title.set_text("CHANNEL {}".format(self.channels[row+column]))
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
            self.m_conn = conn
            self.m_thread_socket = conn
            if conn:
                print(f"Connected by {addr}")
                self.m_connected = True
                self.s.setblocking(True)

    def getID(self, p_id):
        self.m_conn.sendall(b"9")
        self.m_conn.sendall(p_id.to_bytes(1, 'big'))
        time.sleep(1)
        print(self.m_conn.recv(8))

#end private

#How to use, simply reimplement the functions
#Example

if __name__ == "__main__":
    tmp = WiFiServer(5000, p_host_addr="192.168.1.121") #Port 5000, localhost
    tmp.startServer()


    while not(tmp.m_connected):
        time.sleep(1)

    # tmp.getID(0)
    # tmp.getID(1)
    # tmp.getID(2)
    tmp.configureIntanChip()

    tmp.receiveDataTest()

    #tmp.receiveDataTestV2()

   # tmp.plot()
    tmp.plotAllChannels()


