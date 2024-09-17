import time
from queue import Queue
from utils.WiFiHeadstageReceiver import WiFiHeadstageReceiver
from OpenEphys.DataConverter import DataConverter
from OpenEphys.CSVWriter import CSVWriter
from OpenEphys.OpenEphysSender import OpenEphysSender

from open_ephys.control import OpenEphysHTTPServer
from open_ephys.control.network_control import NetworkControl


def main():

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

    #HEADSTAGE CONFIGS
    # CHANNELS_LIST = [[0, 1, 2, 3, 4, 5, 6, 7],
    #                  [8, 9, 10, 11, 12, 13, 14, 15],
    #                  [16, 17, 18, 19, 20, 21, 22, 23],
    #                  [24, 25, 26, 27, 28, 29, 30, 31]]
    # CHANNELS = CHANNELS_LIST[1]
    # CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7,
    #              8, 9, 10, 11, 12, 13, 14, 15,
    #              16, 17, 18, 19, 20, 21, 22, 23,
    #              24, 25, 26, 27, 28, 29, 30, 31]

    CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7,
                8, 9, 10, 11, 12, 13, 14, 15]

    # CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7, 15, 16, 17, 18]
    BUFFER_SOCKET_FACTOR = 100
    BUFFER_SIZE = 1024
    FREQUENCY   = 7000

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

    TASK_WiFiServer.configureNumberChannel()
    TASK_WiFiServer.configureIntanChip()
    TASK_WiFiServer.configureIntanSamplingFreq(FREQUENCY)

    # Start other threads
    if CSV_WRITING:
        TASK_CSVWriter.startThread()
    if OPENEPHYS_SENDING:
        TASK_OpenEphysSender.startThread()
    TASK_DataConverter.startThread()
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_headstageRecvThread)

    gui_starter.acquire()
    time.sleep(1)
    print("SENDING ")
    #
    # gui_starter.record()
    # time.sleep(1)
    # print("RECORDING ")
    #
    # counter = 0
    # while True:
    #     gui_ttl.send_ttl(line=channel, state=state)
    #     time.sleep(1)
    #     state = not state
    #     counter += 1
    #
    #     if counter == 100:
    #         gui_starter.idle()
    #         print("STOP ")
    #         quit()

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