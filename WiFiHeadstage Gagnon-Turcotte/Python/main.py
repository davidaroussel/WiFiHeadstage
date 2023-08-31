# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 7/03/2023

import time
from queue import Queue
from WiFiHeadstageReceiver import WiFiHeadstageReceiver
from DataConverter import DataConverter

from OpenEphysSender import OpenEphysSender

from utils import Toolkit




if __name__ == "__main__":

    #GLOBAL VARIABLES
    HOST_ADDR      = ""
    HEADSTAGE_PORT = 5000
    OPENEPHYS_PORT = 10001

    CHANNELS    = [0, 1, 2, 3, 4, 5, 6, 7]
    BUFFER_SOCKET_FACTOR = 100
    BUFFER_SIZE = 1024
    FREQUENCY   = 15000

    #CONSTRUCTORS
    QUEUE_RAW_DATA  = Queue()
    QUEUE_CONV_DATA = Queue()

    TASK_WiFiServer      = WiFiHeadstageReceiver(QUEUE_RAW_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR,  p_port=HEADSTAGE_PORT, p_host_addr=HOST_ADDR)
    TASK_DataConverter   = DataConverter(QUEUE_RAW_DATA, QUEUE_CONV_DATA, CHANNELS, BUFFER_SIZE,BUFFER_SOCKET_FACTOR)
    TASK_OpenEphysSender = OpenEphysSender(QUEUE_CONV_DATA, BUFFER_SIZE, BUFFER_SOCKET_FACTOR, FREQUENCY, p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)

    #START THREADS
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_socketConnectionThread)
    while not TASK_WiFiServer.m_connected:
       time.sleep(1)

    TASK_WiFiServer.configureIntanChip()

    TASK_OpenEphysSender.startThread()
    TASK_DataConverter.startThread()
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_headstageRecvTread)







