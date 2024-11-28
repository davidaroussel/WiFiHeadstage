import socket
import os
import math
import threading
import time
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
from numpy.fft import fft
import numpy as np
import csv
from datetime import datetime

from BioMLServer.Headstage_Driver import HeadstageDriver


class WiFiServer(BaseException):
    #p_port: Port to listen on (non-privileged ports are > 1023)
    #p_host_addr: Standard loopback interface address (localhost)
    def __init__(self, p_port, p_host_addr, channels, samp_freq, buffer_size):
        BaseException.__init__(self)
        self.clients = []
        self.m_port = p_port
        self.m_socket = 0
        self.m_host_addr = p_host_addr
        self.m_channels = channels
        self.num_channels = len(self.m_channels)
        self.m_buffer_size = buffer_size
        self.m_samp_freq = samp_freq
        self.m_thread_socket = False
        self.m_serverThread = threading.Thread(target=self.serverThread)
        self.m_connected = False
        self.m_raw_data = []
        self.m_converted_array = [[] for i in range(self.num_channels)]
        self.m_vrms_array = [[] for i in range(self.num_channels)]
        self.cutoff_menu = ''

        directory = "./sampling data"
        timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        self.csv_directory = os.path.join(directory, timestamp)

    #Start the server to receive the data
    def startServer(self):
        self.m_serverThread.start()

    def stopServer(self):
        # if self.m_thread_socket:
        #     self.m_thread_socket.shutdown(socket.SHUT_RDWR)
        #     self.m_serverThread.join()

        for conn in self.clients:
            conn.shutdown(socket.SHUT_RDWR)
            conn.close()
        self.m_serverThread.join()

    def serverThread(self):
        print("WAITING FOR THE DEVICE")
        # with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as self.s:
        #     self.s.bind((self.m_host_addr, self.m_port))
        #     self.s.listen()
        #     conn, addr = self.s.accept()
        #     self.m_socket = conn
        #     self.m_thread_socket = conn
        #     if conn:
        #         print(f"Connected by {addr}")
        #         self.m_connected = True
        #         self.s.setblocking(True)
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as self.s:
            self.s.bind((self.m_host_addr, self.m_port))
            self.s.listen()
            # self.clients = []  # List to keep track of connected clients

            while True:  # Server will continuously listen for new clients
                self.m_socket, addr = self.s.accept()
                print(f"Connected by {addr}")
                self.m_connected = True
                self.m_socket.setblocking(True)


    def handle_client(self, conn, addr):
        try:
            while True:
                # Handle the client communication here
                data = conn.recv(1024)
                if not data:
                    break
                # Process the data or respond to the client
                print(f"Received from {addr}: {data}")
                conn.sendall(b"Message received")
        except Exception as e:
            print(f"Error with client {addr}: {e}")
        finally:
            # Clean up and close the connection
            print(f"Client {addr} disconnected")
            conn.close()
            self.clients.remove(conn)

    #This version will call socket.recv as long as the buffer is not filled (was not necessary, seems to work with the 1ms sleep)
    def receiveData(self, socket, buffer_size, loops):
        BUFFER_SIZE = buffer_size
        self.m_raw_data = []
        command = b"A"
        time.sleep(1)
        for ch in self.m_channels:
            command = command + ch.to_bytes(1, 'big')
        socket.sendall(command)  # Start Intan Timer
        time.sleep(0.001)

        for i in range(loops):
            pourcentage = round((i/loops) * 100, 3)
            print(pourcentage, "%")

            data = []
            while len(data) < BUFFER_SIZE:
                rest_packet = socket.recv(BUFFER_SIZE)
                if not rest_packet:
                    print("BOOBOO")
                data += bytearray(rest_packet)
                #time.sleep(0.001)
            self.m_raw_data.extend(data)


        socket.sendall(b"B")  # Stop Intan Timer
        time.sleep(0.1)

        #EMPTY SOCKET BUFFER
        trash_bufsize = buffer_size
        while True:
            packet = socket.recv(trash_bufsize)
            if len(packet) < trash_bufsize:
                break

    def convertData(self):
        converted_data = [[] for i in range(self.num_channels)]
        ch_counter = 0

        for i in range(0, len(self.m_raw_data), 2):
            value = int.from_bytes([self.m_raw_data[i + 1], self.m_raw_data[i]], byteorder='big', signed=True)
            converted_data[ch_counter].append(value)
            ch_counter = (ch_counter + 1) % self.num_channels

        self.m_converted_array = converted_data

    def plotOneChannel(self, channel_number):
        if channel_number < 0 or channel_number >= self.num_channels:
            raise ValueError("Invalid channel number. It should be in the range [0, 7]")

        fig, ax = plt.subplots(figsize=(10, 5))

        converted_data = self.m_converted_array[channel_number]
        vrms = [self.m_vrms_array[channel_number] for i in range(len(converted_data))]

        k = [i for i in range(len(converted_data))]
        ax.plot(k, converted_data, label="Noise")
        ax.plot(k, vrms, label="Vrms")

        ax.set_title("CHANNEL {}".format(self.m_channels[channel_number]))
        ax.set_xlabel("Sample Number")
        ax.set_ylabel("uV")

        plt.legend(loc='upper right')
        plt.show()
        plt.tight_layout()
        fft_data = np.fft.fft(converted_data)
        freqs = np.fft.fftfreq(len(converted_data))
        peak_coef = np.argmax(np.abs(fft_data))
        peak_freq = freqs[peak_coef]
        peak_freq = peak_freq * self.m_samp_freq
        print("CH:", channel_number, "FREQUENCE DU SIGNAL", peak_freq)

    #Considering that we have 8 channels !!
    def plotAllChannels(self):
        fig, axs = plt.subplots(self.num_channels, 1, figsize=(30, 10))
        plt.gca().cla()
        self.m_converted_array = [[] for i in range(self.num_channels)]

        ch_counter = 0
        for i in range(0, len(self.m_raw_data), 2):
            converted_data = int.from_bytes([self.m_raw_data[i + 1], self.m_raw_data[i]], byteorder='big', signed=True)
            LSB_FLAG = int(hex(converted_data), 16) & 0x01
            dataNumber = ch_counter // self.num_channels
            channelNumber = ch_counter % self.num_channels
            if LSB_FLAG == 1:
                if channelNumber == 0:
                    pass
                else:
                    print("OUT OF SYNC !!", "dataCounter", dataNumber)
                    diff_ch = self.num_channels - channelNumber
                    ch_counter += diff_ch

                    dataNumber = ch_counter // self.num_channels
                    channelNumber = ch_counter % self.num_channels
                    print("NOW ON", dataNumber, "with", channelNumber)
            self.m_converted_array[ch_counter % self.num_channels].append(converted_data * 0.195) #NOW IN uV (0.000000195 is V)
            ch_counter += 1

        ch_counter = 0
        for row in range(self.num_channels):
            k = [i for i in range(len(self.m_converted_array[ch_counter]))]
            #VERSION FOR PYTHON 3.10
            # axs[row].plot(k, self.m_converted_array[ch_counter])
            # axs[row].title.set_text("CHANNEL {}".format(self.m_channels[ch_counter]))
            # fft_data = np.fft.fft(self.m_converted_array[ch_counter])
            # freqs = np.fft.fftfreq(len(self.m_converted_array[ch_counter]))
            # peak_coef = np.argmax(np.abs(fft_data))
            # peak_freq = freqs[peak_coef]
            # peak_freq = peak_freq * self.m_samp_freq
            # print(" CH:", ch_counter, " FREQUENCE DU SIGNAL ", peak_freq)

            ch_counter += 1

        ch_counter = 0
        for row in range(self.num_channels):
            k = [i for i in range(len(self.m_converted_array[ch_counter]))]
            #VERSION FOR PYTHON 3.10
            axs[row].plot(k, self.m_converted_array[ch_counter])
            axs[row].title.set_text("CHANNEL {}".format(self.m_channels[ch_counter]))

            ch_counter += 1
            #VERSION FOR PYTHON 3.9 (needs reajusting figure declaration)
           #  fig.add_subplot(4,2,ch)
           #  plt.subplot(4, 2, ch+1)
           #  plt.title("CHANNEL {}".format(self.channels[ch]))
           #  plt.plot(k, self.m_converted_array[ch])
        plt.tight_layout()
        plt.show()

    def calculateVrmsForAllChannels(self):
        noDC_value = [[] for i in range(self.num_channels)]
        for ch_number, channel_data in enumerate(self.m_converted_array):
            if channel_data:
                meanValue = np.mean(np.array(channel_data[36000:]))
                for data in channel_data:
                    noDC_value[ch_number].append(data - meanValue)


                noDC_meanValue = np.mean(np.array(noDC_value[ch_number]) ** 2)
                mVrms = np.sqrt(noDC_meanValue)
                self.m_vrms_array[ch_number] = mVrms


        # Print the table
        print("Channel    |  Average Vrms")
        print("-----------|---------------")
        for i, avg_vrms in enumerate(self.m_vrms_array):
            if avg_vrms:
                print(f"Channel {i}: | {avg_vrms:.4f} uV")
        print("-----------|---------------")

    def writeDataToCSV(self, data):
        timestamp = datetime.now().strftime("%H-%M-%S")
        filename = f"{timestamp}.csv"
        csv_path = os.path.join(self.csv_directory, filename)
        try:
            with open(csv_path, 'w', newline='') as csv_file:
                writer = csv.writer(csv_file)
                writer.writerows(data)
            print(f"Data written to {filename} successfully.")
        except Exception as e:
            print(f"Error writing data to {filename}: {e}")

    def createDataForCSV(self):
        if not os.path.exists(self.csv_directory):
            os.makedirs(self.csv_directory)

        data = self.m_converted_array
        #data = [[i + 1 for _ in range(2000)] for i in range(8)]
        meanPerChannel = [np.mean(np.array(data[i])) for i in range(len(data))]
        data_for_csv = []

        data_row = ["Channels"]
        for i in range(len(data)):
            data_row.extend(["", "", f"Channel {i}", "", ""])
        data_for_csv.append(data_row)

        data_row = ["Avg"]
        for i in range(len(data)):
            data_row.extend(["", f"{meanPerChannel[i]}", "", "", ""])
        data_for_csv.append(data_row)

        data_row = []
        for i in range(len(data)):
            data_row.extend(["", "", "Data", "v - Vavg", "expo2"])
        data_for_csv.append(data_row)

        expo2_value = [[] for i in range(len(data))]
        v_Vavg = [[] for i in range(len(data))]

        min_list_index = min(enumerate(data), key=lambda x: len(x[1]))[0]
        for i in range(len(data[min_list_index])):
            data_row = ["", ""]
            for j in range(len(data)):
                expo2_value[j].append((data[j][i] - meanPerChannel[j]) ** 2)
                v_Vavg[j].append(data[j][i] - meanPerChannel[j])
                data_row.extend([data[j][i], v_Vavg[j][i], expo2_value[j][i], "", ""])
            data_for_csv.append(data_row)

        for i in range(len(data)):
            mean_value = np.mean(expo2_value[i])
            data_for_csv[0][((i + 1) * 5) - 1] = np.sqrt(mean_value)
            data_for_csv[0][((i + 1) * 5)] = f"mV"

            data_for_csv[1][((i + 1) * 5) - 1] = np.mean(expo2_value[i])
            data_for_csv[1][((i + 1) * 5) - 2] = np.mean(v_Vavg[i])

        return data_for_csv


if __name__ == "__main__":
    # Port 5000, IP assign by router, possible to configure the router to have this static IP
    SOCKET_PORT = 5000
    HOST_IP_ADDR = ""

    # 8 CHANNELS CONFIGURATION
    # CHANNELS_LIST = [[0, 1, 2, 3, 4, 5, 6, 7],
    #                  [8, 9, 10, 11, 12, 13, 14, 15],
    #                  [16, 17, 18, 19, 20, 21, 22, 23],
    #                  [24, 25, 26, 27, 28, 29, 30, 31]]
    # CHANNELS = CHANNELS_LIST[1]

    # 32 CHANNELS CONFIGURATION
    # CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7,
    #              8, 9, 10, 11, 12, 13, 14, 15,
    #              16, 17, 18, 19, 20, 21, 22, 23,
    #              24, 25, 26, 27, 28, 29, 30, 31]

    # 16 CHANNELS CONFIGURATION
    CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7,
                8, 9, 10, 11, 12, 13, 14, 15]

    # 12 CHANNELS CONFIGURATION
    # CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7, 15, 16, 17, 18]

    SAMPLING_TIME = 30  # Time sampling in seconds
    FREQ_SAMPLING = 4000
    BUFFER_SIZE = 1024*1000  # Maximum value possible for the WiFi UDP Socket communication

    # Buffer Size for Headstage communication is 1024 bytes.
    # Loops is the number of time we want to receive data
    HEADSTAGE_SERVER = WiFiServer(SOCKET_PORT, HOST_IP_ADDR, CHANNELS, FREQ_SAMPLING, BUFFER_SIZE)
    HEADSTAGE_DRIVER = HeadstageDriver()

    LOOPS = HEADSTAGE_DRIVER.calculateSamplingLoops(SAMPLING_TIME, FREQ_SAMPLING, len(CHANNELS), BUFFER_SIZE)

    HEADSTAGE_SERVER.startServer()

    while not(HEADSTAGE_SERVER.m_connected):
        time.sleep(1)

    # Add the connection to the list of clients
    headstage_id = HEADSTAGE_DRIVER.getHeadstageID(HEADSTAGE_SERVER.m_socket)
    headstage_object = {"name": headstage_id, "socket": HEADSTAGE_SERVER.m_socket}
    HEADSTAGE_SERVER.clients.append(headstage_object)

    while True:
        print("-------- Device Menu --------")
        for idx, client in enumerate(HEADSTAGE_SERVER.clients):
            print(f"- #{idx} : {client["name"]} - {client['socket'].getpeername()} ")
        print("- Refresh (R)")
        print("- Quit (Q)")
        print("-----------------------------")
        device_number = input("Select a device: ")
        if device_number.lower() == "r":
            for i in range(100):
                print("\r")
        if device_number.lower() == "quit" or device_number.lower() == "q":
            exit()
        if device_number.isdigit():
            if int(device_number) <= (len(HEADSTAGE_SERVER.clients) - 1):
                selected_headstage = HEADSTAGE_SERVER.clients[int(device_number)]['socket']
                HEADSTAGE_DRIVER.restartDevice(selected_headstage)
                HEADSTAGE_DRIVER.getMenu(selected_headstage)
                HEADSTAGE_DRIVER.verifyIntanChip(selected_headstage, p_id=0)
                HEADSTAGE_DRIVER.getHeadstageID(selected_headstage)
                HEADSTAGE_DRIVER.configureNumberChannel(selected_headstage, len(CHANNELS))
                HEADSTAGE_DRIVER.configureIntanChip(selected_headstage)
                HEADSTAGE_DRIVER.configureSamplingFreq(selected_headstage, FREQ_SAMPLING)
                HEADSTAGE_SERVER.receiveData(selected_headstage, BUFFER_SIZE, LOOPS)
                HEADSTAGE_SERVER.convertData()

                HEADSTAGE_SERVER.calculateVrmsForAllChannels()

                # HEADSTAGE_SERVER.plotOneChannel(2)
                HEADSTAGE_SERVER.plotAllChannels()

                # data_for_csv = HEADSTAGE_SERVER.createDataForCSV()
                # HEADSTAGE_SERVER.writeDataToCSV(data_for_csv)
