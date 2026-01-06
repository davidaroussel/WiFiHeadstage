import socket
import struct
import threading
import time
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.animation import FuncAnimation
from queue import Queue

from BioMLServer.Headstage_Driver import HeadstageDriver

class WiFiHeadstageReceiverV2(BaseException):
    def __init__(self, p_queue, p_channels, p_buffer_size, p_port, p_host_addr=""):
        BaseException.__init__(self)
        self.channels = p_channels
        self.num_channels = len(p_channels)
        self.queue_raw_data = p_queue
        self.buffer_size = p_buffer_size
        self.m_port = p_port
        self.m_socket = 0
        self.m_host_addr = p_host_addr
        self.m_thread_socket = False
        self.m_socketConnectionThread = threading.Thread(target=self.handleSocket)
        self.m_connected = False
        self.m_received_data = 0

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
            self.m_thread_socket.close()
            threadID.join()
        elif threadID == self.m_headstageRecvThread:
            threadID.join()

    def handleSocket(self):
        print("---STARTING CONNECTION THREAD---")
        while True:  # Server lifetime loop
            server_socket = None
            conn = None
            host = self.m_host_addr
            port = self.m_port
            counter = 0
            try:
                # Create server socket
                server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

                server_socket.bind((host, port))
                server_socket.listen(1)

                print("[INFO] Waiting for a client to connect...")
                conn, addr = server_socket.accept()
                print(f"[INFO] Client connected from: {addr}")
                self.m_connected = True

                # Client receive loop
                while True:
                    chunk = conn.recv(self.buffer_size)
                    if not chunk:
                        print("[INFO] Client disconnected.")
                        break

                    if counter % 100 == 0:
                        print(f"[RECEIVED] {chunk}")
                        counter = 1
                    counter += 1
                    self.queue_raw_data.put(chunk)

            except KeyboardInterrupt:
                print("\n[INFO] Server stopped manually.")
                break

            except Exception as e:
                print(f"[ERROR] Socket error: {e}")
                time.sleep(1)  # Prevent tight crash loop

            finally:
                if conn:
                    conn.close()
                    print("[INFO] Client socket closed.")
                if server_socket:
                    server_socket.close()
                    print("[INFO] Server socket closed. Restarting...\n")

    #TODO
    def getHeadstageID(self):
        module_id = self.HeadstageDriver.getHeadstageID(self.m_socket, p_id=0)
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
    def stopDataFromIntan(self):
        self.m_thread_socket.sendall(b"B")  # Stop Intan Timer


    def continuedDataSimulator(self):
        BUFFER_SIZE = self.buffer_size
        data = [0 for i in range(0, BUFFER_SIZE)]
        while 1:
            self.queue_raw_data.put(data)
            time.sleep(0.001)