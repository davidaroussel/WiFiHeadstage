import sys
import time
from queue import Queue
from OpenEphys.WiFiHeadstageReceiver import WiFiHeadstageReceiver
from OpenEphys.DataConverter import DataConverter
from OpenEphys.CSVWriter import CSVWriter
from OpenEphys.OpenEphysSender import OpenEphysSender
from OpenEphys.TTL_Controller import TTL_Controller
from OpenEphys.OpenEphys_Configuration import OpenEphys_Configuration


if __name__ == "__main__":
    #MODES
    CSV_WRITING         = False
    OPENEPHYS_SENDING   = True
    TTL_GENERATOR       = False
    CONFIGURE_OPENEPHYS = False
    PRINT_OE_INFO       = True

    #GLOBAL VARIABLES
    HOST_ADDR      = ""
    HEADSTAGE_PORT = 5000
    OPENEPHYS_PORT = 10001
    TTL_EVENT_PORT = 5556

    #HEADSTAGE CONFIGS
    # 8 CHANNELS CONFIGURATION
    CHANNELS_LIST = [[0, 1, 2, 3, 4, 5, 6, 7],
                     [8, 9, 10, 11, 12, 13, 14, 15],
                     [16, 17, 18, 19, 20, 21, 22, 23],
                     [24, 25, 26, 27, 28, 29, 30, 31]]
    CHANNELS = CHANNELS_LIST[2]

    # 32 CHANNELS CONFIGURATION
    CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7,
                 8, 9, 10, 11, 12, 13, 14, 15,
                 16, 17, 18, 19, 20, 21, 22, 23,
                 24, 25, 26, 27, 28, 29, 30, 31]

    # 16 CHANNELS CONFIGURATION
    CHANNELS_LIST = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
                     [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]]
    CHANNELS = CHANNELS_LIST[0]

    CHANNELS_LIST = [[0, 1, 2, 3],
                     [4, 5, 6, 7],
                     [8, 9, 10, 11],
                     [12, 13, 14, 15],
                     [16, 17, 18, 19],
                     [20, 21, 22, 23],
                     [24, 25, 26, 27],
                     [28, 29, 30, 31]]
    CHANNELS = CHANNELS_LIST[0]

    # CHANNELS = [3, 8, 21, 27] #4, 9, 22, 28

    # 12 CHANNELS CONFIGURATION
    BUFFER_SOCKET_FACTOR = 1
    BUFFER_SIZE = 256
    FREQUENCY   = 20000

    ttl_channel_key_mapping = {
        2: ("q", "a"),
        3: ("w", "s"),
        4: ("e", "d"),
        5: ("r", "f")
    }

    retVal_list = []
    OE_config = OpenEphys_Configuration()
    if CONFIGURE_OPENEPHYS:
        retVal_list.append(OE_config.get_GUI_status())
        retVal_list.append(OE_config.get_GUI_recording_node())
        retVal_list.append(OE_config.set_GUI_recording_path(r"C:\Users\david\Documents\Open Ephys\TESTING"))
        retVal_list.append(OE_config.get_ES_processor_id())
        retVal_list.append(OE_config.get_ES_info())
        retVal_list.append(OE_config.set_ES_scale(0.195))
        retVal_list.append(OE_config.set_ES_offset(32768))
        retVal_list.append(OE_config.set_ES_port(OPENEPHYS_PORT))
        retVal_list.append(OE_config.set_ES_frequency(FREQUENCY))
        retVal_list.append(OE_config.get_ES_info())
    if PRINT_OE_INFO:
        for retVal in retVal_list:
            print(retVal)

    #CONSTRUCTORS
    QUEUE_RAW_DATA   = Queue()
    QUEUE_CSV_DATA   = Queue()

    TASK_WiFiServer    = WiFiHeadstageReceiver(QUEUE_RAW_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR, p_port=HEADSTAGE_PORT, p_host_addr=HOST_ADDR)
    TASK_DataConverter = DataConverter(QUEUE_RAW_DATA, QUEUE_CSV_DATA, CHANNELS, FREQUENCY, BUFFER_SIZE, p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)
    TASK_Manual_TTL    = TTL_Controller(OE_config, ttl_channel_key_mapping, port=TTL_EVENT_PORT, ip_addr=HOST_ADDR)
    TASK_CSVWriter     = CSVWriter(QUEUE_CSV_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR)

    #START THREADS
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_socketConnectionThread)
    while not TASK_WiFiServer.m_connected:
        time.sleep(0.5)

    TASK_WiFiServer.stopDataFromIntan()
    TASK_WiFiServer.getHeadstageID()
    TASK_WiFiServer.verifyIntanChip()
    TASK_WiFiServer.configureNumberChannel()
    TASK_WiFiServer.configureIntanChip()
    TASK_WiFiServer.configureSamplingFreq(FREQUENCY)
    TASK_WiFiServer.check_fifo_state()

    # Start other threads
    if CSV_WRITING:
        TASK_CSVWriter.startThread()
    if TTL_GENERATOR:
        TASK_Manual_TTL.startThread()
    TASK_DataConverter.startThread()
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_headstageRecvThread)

    while not TASK_DataConverter.tcp_connected:
        pass

    time.sleep(0.1)
    print("Match Parameters with OpenEphys !!")
    print("Socket        : ", OPENEPHYS_PORT)
    print("Sampling Rate : ", FREQUENCY, "Hz")
    print("Number Of CH  : ", len(CHANNELS))
    print("Buffer Size   : ", BUFFER_SIZE, "bytes")

    # try:
    #     while(1):
    #         time.sleep(1)
    # except KeyboardInterrupt:
    #     print("Ctrl+C pressed")
    # finally:
    #     print("Closing Acquisition...")
    #     OE_config.Network_Events_Connect()
    #     OE_config.GUI_Stop_Recording()
    #     OE_config.GUI_Stop_Acquisition()
    #     print("Done Closing Acquisition")

    OE_config.Network_Events_Connect()
    OE_config.GUI_Start_Acquisition()
    time.sleep(2)
    OE_config.get_GUI_Acquisition_status()
    OE_config.get_GUI_Recording_status()
    time.sleep(1)
    OE_config.GUI_Start_Recording()
    time.sleep(1)
    OE_config.get_GUI_Acquisition_status()
    OE_config.get_GUI_Recording_status()
    time.sleep(5)
    OE_config.GUI_Stop_Recording()
    time.sleep(2)
    OE_config.GUI_Stop_Acquisition()

