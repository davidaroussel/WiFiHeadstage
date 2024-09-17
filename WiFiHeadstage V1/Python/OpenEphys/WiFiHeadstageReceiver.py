import socket
import struct
import threading
import time
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.animation import FuncAnimation
from queue import Queue


class WiFiHeadstageReceiver(BaseException):
    def __init__(self, p_queue, p_channels, p_buffer_size, p_buffer_factor, p_port, p_host_addr=""):
        BaseException.__init__(self)
        self.channels = p_channels
        self.num_channels = len(p_channels)
        self.queue_raw_data = p_queue
        self.buffer_size = p_buffer_size
        self.buffer_factor = p_buffer_factor
        self.m_port = p_port
        self.m_conn = 0
        self.m_host_addr = p_host_addr
        self.m_thread_socket = False
        self.m_socketConnectionThread = threading.Thread(target=self.connectSocket)
        self.m_connected = False
        self.m_received_data = 0
        self.m_headstageRecvThread = threading.Thread(target=self.continuedDataFromIntan)
        # For plotting
        self.k = []
        self.converted_array = []

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
            self.m_conn = conn
            self.m_thread_socket = conn
            if conn:
                print(f"Connected by {addr}")
                self.m_connected = True

    def readMenu(self):
        self.m_thread_socket.sendall(b"0")
        print(self.m_thread_socket.recv(1024).decode("utf-8"))

    def getID(self, p_id):
        self.m_conn.sendall(b"9")
        self.m_conn.sendall(p_id.to_bytes(1, 'big'))
        time.sleep(1)
        print("Intan Chip {}: {}".format(p_id, self.m_conn.recv(8)))

    def configureNumberChannel(self):
        command = b"7"
        time.sleep(1)
        print(f"Setting number of channels to : {self.num_channels}")
        b_num_channels = self.num_channels.to_bytes(1, byteorder='big')
        self.m_conn.sendall(command + b_num_channels)
        time.sleep(0.001)

    def findCutoffChoice(self, input, cutoff):
        cutoff_value = None
        if cutoff == 'high':
            choice_index = self.cutoff_menu.find(input + '-')
            retline_index = self.cutoff_menu[choice_index:].find("\r\n") + choice_index
            choice_cutoff = self.cutoff_menu[choice_index:retline_index]
            midpoint = len(choice_cutoff) // 2
            cutoff_value = choice_cutoff[:midpoint].strip()
        elif cutoff == 'low':
            choice_index = self.cutoff_menu.rfind(input + '-')
            retline_index = self.cutoff_menu[choice_index:].find("\r\n") + choice_index
            cutoff_value = self.cutoff_menu[choice_index:retline_index]

        return cutoff_value

    def configureIntanChip(self):
        if not self.m_connected:
            print("Not connected.")
            return

        try:
            self.m_thread_socket.sendall(b"A")
            recv_message = self.m_thread_socket.recv(1024)
            self.cutoff_menu = recv_message.decode("utf-8")

            print(self.cutoff_menu)

            input1 = "2"
            choice_lowfreq = self.findCutoffChoice(input1, "high")
            print("Low-pass selection:")
            print(choice_lowfreq)

            input2 = "4"
            choice_highfreq = self.findCutoffChoice(input2, "low")
            print("High-pass selection:")
            print(choice_highfreq)
            self.m_thread_socket.sendall(b"" + bytes(input1, 'ascii') + bytes(input2, 'ascii'))

        except UnicodeDecodeError as e:
            print(f"Error configuring Intan Chip: {e}")
            print("Already configured")

    def configureIntanSamplingFreq(self, sample_freq):
        command = b"D"
        time.sleep(1)
        high_byte = (sample_freq >> 8) & 0xFF
        low_byte = sample_freq & 0xFF
        data1 = high_byte.to_bytes(1, 'big')
        data2 = low_byte.to_bytes(1, 'big')
        print(f"Sampling Frequence: {sample_freq}Hz")
        self.m_conn.sendall(command + data1 + data2)
        time.sleep(0.001)

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

    def continuedDataFromIntan(self):
        BUFFER_SIZE = self.buffer_size * self.buffer_factor
        print("---STARTING HEADSTAGE_RECV THREAD---")
        command = b"B"
        time.sleep(1)
        for ch in self.channels:
            command = command + ch.to_bytes(1, 'big')
        self.m_thread_socket.sendall(command)  # Start Intan Timer
        time.sleep(0.001)
        # trash_packet = self.m_thread_socket.recv(BUFFER_SIZE)
        while 1:
            data = []
            while len(data) < BUFFER_SIZE:
                rest_packet = self.m_thread_socket.recv(BUFFER_SIZE)
                if not rest_packet:
                    print("BOOBOO")
                data += bytearray(rest_packet)
            self.queue_raw_data.put(data)

    def continuedDataSimulator(self):
        BUFFER_SIZE = self.buffer_size * self.buffer_factor
        while 1:
            data = [0 for i in range(0, BUFFER_SIZE)]
            self.queue_raw_data.put(data)
            time.sleep(0.001)

    def stopDataFromIntan(self):
        self.m_thread_socket.sendall(b"C")  # Stop Intan Timer