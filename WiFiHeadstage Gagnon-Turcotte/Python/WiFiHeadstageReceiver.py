# Coded by G. Gagnon-Turcotte at SiFiLabs
# Original version 6/22/2023

# Edited by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Started on 06/28/2023


import socket
import struct
import threading
import time
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.animation import FuncAnimation
from queue import Queue


class WiFiHeadstageReceiver(BaseException):
    # p_port: Port to listen on (non-privileged ports are > 1023)
    # p_host_addr: Standard loopback interface address (localhost)
    def __init__(self, p_queue, p_channels, p_buffer_size, p_port, p_host_addr=""):
        BaseException.__init__(self)
        self.channels = p_channels
        self.queue_raw_data = p_queue
        self.buffer_size = p_buffer_size
        self.m_port = p_port
        self.m_conn = 0
        self.m_host_addr = p_host_addr
        self.m_thread_socket = False
        self.m_socketConnectionThread = threading.Thread(target=self.connectSocket)
        self.m_connected = False

        self.m_received_data = 0
        self.m_headstageRecvTread = threading.Thread(target=self.continuedDataFromIntan)

        #For plotting
        self.k = []
        self.converted_array = []


    def startThread(self, threadID):
        threadID.start()

    # Stop the server
    def stopThread(self, threadID):
        if threadID == self.m_socketConnectionThread:
            self.m_thread_socket.shutdown(socket.SHUT_RDWR)
        self.m_socketConnectionThread.join()

    def connectSocket(self):
        print("---STARTING CONNECTION THREAD---")
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind((self.m_host_addr, self.m_port))
            s.listen()
            conn, addr = s.accept()
            self.m_conn = conn
            self.m_thread_socket = conn
            if conn:
                print(f"Connected by {addr}")
                self.m_connected = True

    def continuedDataFromIntan(self):
        BUFFER_SIZE = 1024
        print("---STARTING HEADSTAGE_RECV THREAD---")
        sample_size = self.buffer_size * 2 #since its 16bits
        command = b"B"
        num_channels = len(self.channels)
        for ch in self.channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_conn.sendall(command)  # Start Intan Timer
        time.sleep(1)


        while 1:
            time.sleep(0.001)
            data = self.m_conn.recv(BUFFER_SIZE)
            while len(data) < BUFFER_SIZE:
                rest_packet = self.m_conn.recv(BUFFER_SIZE - len(data))
                if not rest_packet:
                    print("BOOBOO")
                data += bytearray(rest_packet)


            self.queue_raw_data.put(data)


    def readMenu(self):
        self.m_conn.sendall(b"0")
        print(self.m_conn.recv(1024).decode("utf-8"))

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

    def receiveSeqDataFromIntan(self, sample_size):
        command = b"B"
        num_channels = len(self.channels)
        for ch in self.channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_conn.sendall(command)  # Start Intan Timer
        time.sleep(1)

        self.m_received_data = self.m_conn.recv((num_channels * sample_size))

        self.m_conn.sendall(b"C")  # Stop Intan Timer
        print(self.m_received_data)
        time.sleep(0.1)

    # P_ID: ID of the Intan Chip on the custom PCB
    def getID(self, p_id):
        self.m_conn.sendall(b"9")
        self.m_conn.sendall(p_id.to_bytes(1, 'big'))
        time.sleep(1)
        print("Intan Chip {}: {}".format(p_id, self.m_conn.recv(8)))

    def plotData(self):
        plt.gca().cla()
        plt.plot(self.k, self.converted_array)
        plt.show()

        bufsize = 4096
        while True:
            packet = self.m_conn.recv(bufsize)
            if len(packet) < bufsize:
                break



