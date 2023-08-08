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
    HOST_ADDR = "192.168.1.132"
    HEADSTAGE_PORT = 5000
    OPENEPHYS_PORT = 10001

    CHANNELS = [0, 1, 2, 3, 31, 32, 46, 47]
    BUFFER_SIZE = 50
    FREQUENCY = 15000

    #CONSTRUCTORS
    QUEUE_RAW_DATA = Queue()
    QUEUE_CONV_DATA = Queue()

    TASK_WiFiServer = WiFiHeadstageReceiver(QUEUE_RAW_DATA, CHANNELS, BUFFER_SIZE,  p_port=HEADSTAGE_PORT, p_host_addr=HOST_ADDR)
    TASK_DataConverter = DataConverter(QUEUE_RAW_DATA, QUEUE_CONV_DATA, CHANNELS, BUFFER_SIZE)
    TASK_OpenEphysSender = OpenEphysSender(QUEUE_CONV_DATA, BUFFER_SIZE, FREQUENCY, p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)


    #START THREADS
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_socketConnectionThread)
    while not TASK_WiFiServer.m_connected:
       time.sleep(1)
    TASK_OpenEphysSender.startThread()
    TASK_DataConverter.startThread()
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_headstageRecvTread)







