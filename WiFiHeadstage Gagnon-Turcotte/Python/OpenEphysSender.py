# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 7/03/2023

import time
from socket import *
from threading import Thread
import numpy as np
from queue import Queue

class OpenEphysSender():
    def __init__(self, q_queue, p_buffer_size, p_frequency, p_port, p_host_addr=""):
        self.queue_conv_data = q_queue
        self.buffer_size = p_buffer_size
        self.frequency = p_frequency
        self.host_addr = p_host_addr
        self.port = p_port
        self.buffServer_Flag = False
        self.buffServer_Thread = Thread(target=self.sendToOpenEphys)

    def startThread(self):
        self.buffServer_Thread.start()

    # Stop the server
    def stopThread(self):
        if self.buffServer_Flag:
            self.buffServer_Thread.join()

    def currentTime(self):
        return time.time_ns() / (10 ** 9)

    def sendToOpenEphys(self):
        # SPECIFY THE IP AND PORT #
        print("---STARTING SEND_OPENEPHYS THREAD---")
        openEphys_AddrPort = (self.host_addr, self.port)
        openEphys_Socket = socket(family=AF_INET, type=SOCK_DGRAM)

        buffersPerSecond = self.frequency / self.buffer_size
        bufferInterval = 1 / buffersPerSecond

        while True:
            t1 = self.currentTime()
            item = self.queue_conv_data.get()

            openEphys_Socket.sendto(item, openEphys_AddrPort)
            t2 = self.currentTime()

            # CHECKING TO MAKE SURE WE DONE SEND DATA TO FAST
            while ((t2 - t1) < bufferInterval):
                t2 = self.currentTime()


    # def convertData(self):
    #     while 1:
    #         print("here")
    #         item = self.queue_raw_data.get()
    #         if item is None:
    #             time.sleep(0.001)
    #         else:
    #             #CONVERT EACH VALUE AND SPLIT IT INTO EACH CHANNELS
    #             j = 0
    #             for i in range(0, len(item), 2):
    #                 in1 = item[i+1]
    #                 in2 = item[i]
    #                 converted_data = int.from_bytes([in1, in2], byteorder='big', signed=True)
    #                 self.converted_array[j%8][j//8] = (converted_data * 0.195) #REMOVED THE uV multiplier
    #
    #                 j = j + 1
    #             np_conv = np.array(self.converted_array, np.uint16).flatten().tobytes()
    #             self.queue_conv_data.put(np_conv)
