import sys
import time
from queue import Queue
from OpenEphys.WiFiHeadstageReceiver import WiFiHeadstageReceiver
from OpenEphys.DataConverter import DataConverter
from OpenEphys.CSVWriter import CSVWriter
from OpenEphys.OpenEphysSender import OpenEphysSender

from open_ephys.control import OpenEphysHTTPServer
from open_ephys.control.network_control import NetworkControl


if __name__ == "__main__":
    channel = 5
    state = 1
    gui_starter = OpenEphysHTTPServer(address='127.0.0.1')
    gui_ttl = NetworkControl(ip_address='127.0.0.1', port=5556)

    #MODES
    CSV_WRITING = False
    OPENEPHYS_SENDING = True

    #GLOBAL VARIABLES
    HOST_ADDR      = ""
    HEADSTAGE_PORT = 5000
    OPENEPHYS_PORT = 10001
#alllllo
    #HEADSTAGE CONFIGS
    # 8 CHANNELS CONFIGURATION
    CHANNELS_LIST = [[0, 1, 2, 3, 4, 5, 6, 7],
                     [8, 9, 10, 11, 12, 13, 14, 15],
                     [16, 17, 18, 19, 20, 21, 22, 23],
                     [24, 25, 26, 27, 28, 29, 30, 31]]
    CHANNELS = CHANNELS_LIST[2]

    # 32 CHANNELS CONFIGURATION
    # CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7,
    #              8, 9, 10, 11, 12, 13, 14, 15,
    #              16, 17, 18, 19, 20, 21, 22, 23,
    #              24, 25, 26, 27, 28, 29, 30, 31]

    # 16 CHANNELS CONFIGURATION
    CHANNELS_LIST = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
                     [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]]
    CHANNELS = CHANNELS_LIST[0]

    CHANNELS = [3, 8, 21, 27] #4, 9, 22, 28

    # 12 CHANNELS CONFIGURATION
    BUFFER_SOCKET_FACTOR = 100
    BUFFER_SIZE = 256
    FREQUENCY   = 24000

    CHANNELS_LIST = [[0, 1, 2, 3],
                     [4, 5, 6, 7],
                     [8, 9, 10, 11],
                     [12, 13, 14, 15],
                     [16, 17, 18, 19],
                     [20, 21, 22, 23],
                     [24, 25, 26, 27],
                     [28, 29, 30, 31]]
    # CHANNELS = CHANNELS_LIST[0]

    #CONSTRUCTORS
    QUEUE_RAW_DATA   = Queue()
    QUEUE_EPHYS_DATA = Queue()
    QUEUE_CSV_DATA   = Queue()

    TASK_WiFiServer      = WiFiHeadstageReceiver(QUEUE_RAW_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR,  p_port=HEADSTAGE_PORT, p_host_addr=HOST_ADDR)
    TASK_DataConverter   = DataConverter(QUEUE_RAW_DATA, QUEUE_EPHYS_DATA, QUEUE_CSV_DATA, CHANNELS, BUFFER_SIZE,BUFFER_SOCKET_FACTOR)
    TASK_OpenEphysSender = OpenEphysSender(QUEUE_EPHYS_DATA, BUFFER_SIZE, BUFFER_SOCKET_FACTOR, FREQUENCY, p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)
    TASK_CSVWriter       = CSVWriter(QUEUE_CSV_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR)

    #START THREADS
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_socketConnectionThread)
    while not TASK_WiFiServer.m_connected:
        time.sleep(0.5)

    TASK_WiFiServer.getHeadstageID()
    TASK_WiFiServer.verifyIntanChip()
    TASK_WiFiServer.configureNumberChannel()
    TASK_WiFiServer.configureIntanChip()
    TASK_WiFiServer.configureSamplingFreq(FREQUENCY)

    # Start other threads
    if CSV_WRITING:
        TASK_CSVWriter.startThread()
    if OPENEPHYS_SENDING:
        TASK_OpenEphysSender.startThread()
    TASK_DataConverter.startThread()
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_headstageRecvThread)

    # # Continuous loop until "stop" is entered
    user_input = input("\n Enter 'stop' to disable sampling: ")
    if user_input.strip().lower() == "stop":
        TASK_WiFiServer.stopDataFromIntan()
        print("Closed Intan")
        print("Closed everything")
        sys.exit(-1)
