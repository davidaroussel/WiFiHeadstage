import time
from queue import Queue
from WiFiHeadstageReceiver import WiFiHeadstageReceiver
from DataConverter import DataConverter
from CSVWriter import CSVWriter
from OpenEphysSender import OpenEphysSender
from utils import Toolkit


def main():
    #MODES
    CSV_WRITING = True
    OPENEPHYS_SENDING = False

    #GLOBAL VARIABLES
    HOST_ADDR      = ""
    HEADSTAGE_PORT = 5000
    OPENEPHYS_PORT = 10001
    CHANNELS    = [0, 1, 2, 3, 4, 5, 6, 7]
    BUFFER_SOCKET_FACTOR = 100
    BUFFER_SIZE = 1024
    FREQUENCY   = 12000

    #CONSTRUCTORS
    QUEUE_RAW_DATA  = Queue()
    QUEUE_EPHYS_DATA = Queue()
    QUEUE_CSV_DATA = Queue()

    TASK_WiFiServer      = WiFiHeadstageReceiver(QUEUE_RAW_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR,  p_port=HEADSTAGE_PORT, p_host_addr=HOST_ADDR)
    TASK_DataConverter   = DataConverter(QUEUE_RAW_DATA, QUEUE_EPHYS_DATA, QUEUE_CSV_DATA, CHANNELS, BUFFER_SIZE,BUFFER_SOCKET_FACTOR)
    TASK_OpenEphysSender = OpenEphysSender(QUEUE_EPHYS_DATA, BUFFER_SIZE, BUFFER_SOCKET_FACTOR, FREQUENCY, p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)
    TASK_CSVWriter       = CSVWriter(QUEUE_CSV_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR)

    #START THREADS
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_socketConnectionThread)
    while not TASK_WiFiServer.m_connected:
        time.sleep(1)

    TASK_WiFiServer.configureIntanChip()

    # Start other threads
    if CSV_WRITING:
        TASK_CSVWriter.startThread()
    if OPENEPHYS_SENDING:
        TASK_OpenEphysSender.startThread()
    TASK_DataConverter.startThread()
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_headstageRecvThread)

    # Continuous loop until "stop" is entered
    user_input = input("\n Enter 'stop' to disable sampling: ")
    if user_input.strip().lower() == "stop":
        TASK_WiFiServer.stopDataFromIntan()
        print("Closed Intan")

        if CSV_WRITING:
            TASK_CSVWriter.stopThread()
            print("Closed CSV Writer")

        if OPENEPHYS_SENDING:
            TASK_OpenEphysSender.stopThread()
            print("Closed OpenEphys Sender")

        TASK_DataConverter.stopThread()
        print("Closed everything")

        TASK_WiFiServer.stopThread(TASK_WiFiServer.m_socketConnectionThread)
        print("Closed WiFi Server")


if __name__ == "__main__":
    main()
