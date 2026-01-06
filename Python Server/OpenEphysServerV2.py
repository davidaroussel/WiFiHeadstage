import sys
import time
from queue import Queue
from OpenEphys.WiFiHeadstageV2Recv import WiFiHeadstageReceiverV2
from OpenEphys.DataConverterV2 import DataConverterV2
from OpenEphys.TTL_Controller import TTL_Controller
from OpenEphys.OpenEphys_Configuration import OpenEphys_Configuration


if __name__ == "__main__":
    #MODES
    TTL_GENERATOR       = False
    CONFIGURE_OPENEPHYS = True
    PRINT_OE_INFO       = True

    #GLOBAL VARIABLES
    HOST_ADDR      = "192.168.2.196"
    HEADSTAGE_PORT = 10001
    OPENEPHYS_PORT = 10003
    TTL_EVENT_PORT = 5556

    #HEADSTAGE CONFIGS

    # 12 CHANNELS CONFIGURATION
    HEADSTAGE_BUFFER_SIZE = 8196
    OPENEPHYS_BUFFER_SIZE = 1024
    FREQUENCY   = 12800

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

    CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]

    TASK_WiFiServer    = WiFiHeadstageReceiverV2(QUEUE_RAW_DATA, CHANNELS, HEADSTAGE_BUFFER_SIZE, p_port=HEADSTAGE_PORT, p_host_addr=HOST_ADDR)
    TASK_DataConverter = DataConverterV2(QUEUE_RAW_DATA, QUEUE_CSV_DATA, CHANNELS, FREQUENCY, HEADSTAGE_BUFFER_SIZE, p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)
    TASK_Manual_TTL    = TTL_Controller(OE_config, ttl_channel_key_mapping, port=TTL_EVENT_PORT, ip_addr=HOST_ADDR)

    #START THREADS
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_socketConnectionThread)
    while not TASK_WiFiServer.m_connected:
        time.sleep(0.5)

    # Start other threads
    if TTL_GENERATOR:
        TASK_Manual_TTL.startThread()
    TASK_DataConverter.startThread()

    while not TASK_DataConverter.tcp_connected:
        pass

    time.sleep(0.1)
    print("Match Parameters with OpenEphys !!")
    print("Socket        : ", OPENEPHYS_PORT)
    print("Sampling Rate : ", FREQUENCY, "Hz")
    print("Number Of CH  : ", len(CHANNELS))
    print("Buffer Size   : ", HEADSTAGE_BUFFER_SIZE, "bytes")

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

    # OE_config.Network_Events_Connect()
    # OE_config.GUI_Start_Acquisition()
    # time.sleep(2)
    # OE_config.get_GUI_Acquisition_status()
    # OE_config.get_GUI_Recording_status()
    # time.sleep(1)
    # OE_config.GUI_Start_Recording()
    # time.sleep(1)
    # OE_config.get_GUI_Acquisition_status()
    # OE_config.get_GUI_Recording_status()
    # time.sleep(5)
    # OE_config.GUI_Stop_Recording()
    # time.sleep(2)
    # OE_config.GUI_Stop_Acquisition()

