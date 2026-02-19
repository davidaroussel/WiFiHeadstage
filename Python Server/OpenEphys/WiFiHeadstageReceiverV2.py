import socket
import select
import struct
import threading
import time
from datetime import datetime
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
        print("--- STARTING CONNECTION THREAD ---")


        host = self.m_host_addr
        port = self.m_port
        FIRST_PACKET_TIMEOUT = 10.0 # TIMEOUT FOR DISCONNECTION
        STREAM_TIMEOUT = 4.0        # TIMEOUT WHILE STREAMING
        while True:
            server_socket = None
            conn = None

            try:
                # ---------------------------------
                # Create server socket
                # ---------------------------------
                server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
                server_socket.bind((host, port))
                server_socket.listen(1)

                print("[HEADSTAGE] Waiting for client...")
                conn, addr = server_socket.accept()

                self.m_socket = conn
                self.m_connected = True

                print(f"[HEADSTAGE] Client connected from {addr} at {datetime.now().strftime('%H:%M:%S')}")

                streaming_started = False
                connection_time = time.time()
                last_data_time = None

                # ---------------------------------
                # Client handling loop
                # ---------------------------------
                while True:

                    # Determine timeout depending on state
                    if not streaming_started:
                        timeout = FIRST_PACKET_TIMEOUT - (time.time() - connection_time)
                        if timeout <= 0:
                            print("[HEADSTAGE] No first packet within 20s → closing connection")
                            break
                    else:
                        timeout = STREAM_TIMEOUT

                    # Wait for socket activity
                    readable, _, exceptional = select.select([conn], [], [conn], timeout)

                    # Timeout reached
                    if not readable:
                        if not streaming_started:
                            print("[HEADSTAGE] First packet timeout (20s)")
                        else:
                            print("[HEADSTAGE] Stream stopped for 4s → assuming client dead")
                        break

                    # Exceptional socket condition
                    if exceptional:
                        print("[HEADSTAGE] Socket exception detected")
                        break

                    # Receive data
                    chunk = conn.recv(self.buffer_size)

                    if not chunk:
                        print("[HEADSTAGE] Client disconnected cleanly")
                        break

                    # Mark streaming started
                    if not streaming_started:
                        print("[HEADSTAGE] First data packet received → streaming active")
                        streaming_started = True

                    last_data_time = time.time()
                    self.queue_raw_data.put(chunk)

            except Exception as e:
                print(f"[HEADSTAGE] Socket error: {e}")
                time.sleep(1)

            finally:
                self.m_connected = False

                if conn:
                    try:
                        conn.close()
                    except:
                        pass
                    print("[HEADSTAGE] Client socket closed")

                if server_socket:
                    try:
                        server_socket.close()
                    except:
                        pass
                    print("[HEADSTAGE] Server socket closed")

                self.m_socket = None
                print("[HEADSTAGE] Restarting server...\n")

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