import time
from queue import Queue
from BLE_spinalcordsystem import SpinalCordSystem_BLE
from Data_Converter import DataConverter
from Open_Ephys_Sender import OpenEphysSender

from open_ephys.control import OpenEphysHTTPServer
from open_ephys.control.network_control import NetworkControl


if __name__ == "__main__":
    BLE_MCU_NAME = "SpinalCordSystem"
    channel = 5
    state = 1
    gui_starter = OpenEphysHTTPServer(address='127.0.0.1')
    gui_ttl = NetworkControl(ip_address='127.0.0.1', port=5556)

    #MODES
    CSV_WRITING = True
    OPENEPHYS_SENDING = True
    DATA_SIMULATOR = True

    #GLOBAL VARIABLES
    HOST_ADDR      = ""
    HEADSTAGE_PORT = 5000
    OPENEPHYS_PORT = 10001

    #HEADSTAGE CONFIGS
    # 8 CHANNELS CONFIGURATION
    # CHANNELS_LIST = [[0, 1, 2, 3, 4, 5, 6, 7],
    #                  [8, 9, 10, 11, 12, 13, 14, 15],
    #                  [16, 17, 18, 19, 20, 21, 22, 23],
    #                  [24, 25, 26, 27, 28, 29, 30, 31]]
    # CHANNELS = CHANNELS_LIST[3]

    BUFFER_SOCKET_FACTOR = 100
    BUFFER_SIZE = 1024

    FREQUENCY  = 20000
    CHANNELS = [0, 1]

    #CONSTRUCTORS
    QUEUE_RAW_DATA  = Queue()
    QUEUE_EPHYS_DATA = Queue()

    TASK_BLEHost         = SpinalCordSystem_BLE(BLE_MCU_NAME, QUEUE_RAW_DATA, CHANNELS, BUFFER_SOCKET_FACTOR)
    TASK_DataConverter   = DataConverter(QUEUE_RAW_DATA, QUEUE_EPHYS_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR)
    TASK_OpenEphysSender = OpenEphysSender(QUEUE_EPHYS_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR, FREQUENCY, p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)

    #START THREADS
    TASK_BLEHost.startBLE_Thread()
    while not TASK_BLEHost._connected:
        time.sleep(1)

    TASK_BLEHost.sendInitiationPacket()

    counter = 0
    while not TASK_BLEHost.first_response:
        counter += 1


    # Start other threads
    if OPENEPHYS_SENDING:
        TASK_OpenEphysSender.startThread()
    TASK_DataConverter.startThread()


    ### CONTROL OPEN EPHYS WITH PYTHON ###
    # gui_starter.acquire()
    # time.sleep(1)
    # print("SENDING ")
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
    print("\r")
    user_input = input("Enter 'stop' to disable sampling: ")
    if user_input.strip().lower() == "stop":
        TASK_BLEHost.stopRecording()
        TASK_BLEHost.disconnect()
        print("Closed BLE Module")

        if OPENEPHYS_SENDING:
            TASK_OpenEphysSender.stopThread()
            print("Closed OpenEphys Sender")

        TASK_DataConverter.stopThread()
        print("Closed everything")

        TASK_BLEHost.stopThread()
        print("Closed BLE Host")
