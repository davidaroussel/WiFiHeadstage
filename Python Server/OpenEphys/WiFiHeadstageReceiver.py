import socket
import struct
import threading
import time
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.animation import FuncAnimation
from queue import Queue

from BioMLServer.Headstage_Driver import HeadstageDriver

class WiFiHeadstageReceiver(BaseException):
    def __init__(self, p_queue, p_channels, p_buffer_size, p_buffer_factor, p_port, p_host_addr=""):
        BaseException.__init__(self)
        self.channels = p_channels
        self.num_channels = len(p_channels)
        self.queue_raw_data = p_queue
        self.buffer_size = p_buffer_size
        self.buffer_factor = p_buffer_factor
        self.m_port = p_port
        self.m_socket = 0
        self.m_host_addr = p_host_addr
        self.m_thread_socket = False
        self.m_socketConnectionThread = threading.Thread(target=self.connectSocket)
        self.m_connected = False
        self.m_received_data = 0
        self.m_headstageRecvThread = threading.Thread(target=self.continuedDataFromIntan)
        # For plotting
        self.k = []
        self.converted_array = []

        self.HeadstageDriver = HeadstageDriver()
        self.headstage_packet_size = []

    def startThread(self, threadID):
        if threadID.is_alive():
            print(f"Thread {threadID.getName()} is already running.")
        else:
            threadID.start()

    def stopThread(self, threadID):
        if threadID == self.m_socketConnectionThread:
            self.m_thread_socket.shutdown(socket.SHUT_RDWR)
            threadID.join()

    def connectSocket(self):
        print("---STARTING CONNECTION THREAD---")
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind((self.m_host_addr, self.m_port))
            s.listen()
            conn, addr = s.accept()
            self.m_socket = conn
            self.m_thread_socket = conn
            if conn:
                print(f"Connected by {addr}")
                self.m_connected = True

    def getHeadstageID(self):
        module_id = self.HeadstageDriver.getHeadstageID(self.m_socket)
        print("Headstage ID is: ", module_id)

    def verifyIntanChip(self):
        intan_response = self.HeadstageDriver.verifyIntanChip(self.m_socket, 0)
        print("Intan Response is: ", intan_response)

    def configureNumberChannel(self):
        self.HeadstageDriver.configureNumberChannel(self.m_socket, len(self.channels))

    def configureIntanChip(self):
        self.HeadstageDriver.configureIntanChip(self.m_socket)

    def configureSamplingFreq(self, samp_freq):
        self.HeadstageDriver.configureSamplingFreq(self.m_socket, samp_freq)

    def continuedDataFromIntan(self):
        BUFFER_SIZE = self.buffer_size * self.buffer_factor
        print("---STARTING HEADSTAGE_RECV THREAD---")
        command = b"A"
        time.sleep(1)
        for ch in self.channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_thread_socket.sendall(command)  # Start Intan Timer
        time.sleep(0.001)
        # trash_packet = self.m_thread_socket.recv(BUFFER_SIZE)

        time_start = time.time()
        data_size = 0
        while 1:
            data = []
            while len(data) < BUFFER_SIZE:
                rest_packet = self.m_thread_socket.recv(BUFFER_SIZE)
                # print("Lenght ", len(rest_packet))
                if not rest_packet:
                    print("BOOBOO")
                data += bytearray(rest_packet)
            data_size += len(data)
            self.queue_raw_data.put(data)

            # time_stop = time.time()
            # if time_stop - time_start > 10.0:
            #     self.stopDataFromIntan()
            #     print(data_size)


    def stopDataFromIntan(self):
        self.m_thread_socket.sendall(b"B")  # Stop Intan Timer

    def receiveSeqDataFromIntan(self, sample_size):
        command = b"A"
        num_channels = len(self.channels)
        for ch in self.channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_socket.sendall(command)  # Start Intan Timer
        time.sleep(1)
        self.m_received_data = self.m_socket.recv((num_channels * sample_size))
        self.m_socket.sendall(b"B")  # Stop Intan Timer
        print(self.m_received_data)
        time.sleep(0.1)

    def continuedDataSimulator(self):
        BUFFER_SIZE = self.buffer_size * self.buffer_factor
        data = [0 for i in range(0, BUFFER_SIZE)]
        while 1:
            self.queue_raw_data.put(data)
            time.sleep(0.001)