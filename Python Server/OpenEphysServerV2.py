import sys
import numpy as np
import time
from queue import Queue
from OpenEphys.WiFiHeadstageReceiverV2 import WiFiHeadstageReceiverV2
from OpenEphys.DataConverterV2 import DataConverterV2
from OpenEphys.TTL_Controller import TTL_Controller
from OpenEphys.OpenEphys_Configuration import OpenEphys_Configuration

def create_data_array():
    # Row template for normal data (rdh2132)
    rdh2132_row = [0x0001] + [int(np.random.randint(0, 0x10000, dtype=np.uint16)) for _ in range(15)]

    # Row template for special row (rdh2216)
    rdh2216_row = [0x0002] + [0xFFFF]*15

    num_channels = 16
    num_samples = 2560  # number of rows

    # Initialize data array (rows × channels)
    data = np.zeros((num_samples, num_channels), dtype=np.uint16)

    # Fill data
    for row_idx in range(num_samples):
        if (row_idx - 7) % 10 == 0:  # special row every 10 starting at index 7
            data[row_idx] = rdh2216_row
        else:
            data[row_idx] = [0x0001] + [int(np.random.randint(0, 0x10000, dtype=np.uint16)) for _ in range(15)]

    # Flatten to 1D array in row-major order
    flat_data = data.flatten()  # 2560*16 = 40960 16-bit words

    # Convert to bytes (16-bit values → 2 bytes each)
    byte_data = flat_data.tobytes()

    # Each buffer = 8192 bytes → 4096 words → 256 rows × 16 channels
    buffer_size_bytes = 8192
    num_buffers = len(byte_data) // buffer_size_bytes

    print(f"Total byte_data length: {len(byte_data)}")
    print(f"Number of 8192-byte buffers: {num_buffers}")

    interleaved = data.T.flatten()
    byte_buffer = interleaved.tobytes()

    print("Shape:", data.shape)
    print("Total values:", data.size)
    print("Total bytes:", len(byte_buffer))

    # Show first few columns
    print("First 32 interleaved values:")
    print(interleaved[:32])


if __name__ == "__main__":
    # create_data_array()


    #MODES
    TTL_GENERATOR       = False
    CONFIGURE_OPENEPHYS = False
    PRINT_OE_INFO       = False
    DUAL_CHIP_MODE      = True

    #GLOBAL VARIABLES
    HOST_ADDR      = ""#"192.168.2.196"
    HEADSTAGE_PORT = 10001
    OPENEPHYS_PORT = 10003
    OPENEPHYS_EMG_PORT = 10004 #NOT CONNECTED YET
    TTL_EVENT_PORT = 5556

    #HEADSTAGE CONFIGS

    # 12 CHANNELS CONFIGURATION
    HEADSTAGE_BUFFER_SIZE = 8192
    OPENEPHYS_BUFFER_SIZE = 1024
    FREQUENCY   = 25000

    ttl_channel_key_mapping = {
        2: ("q", "a"),
        3: ("w", "s"),
        4: ("e", "d"),
        5: ("r", "f")
    }

    retVal_list = []
    OE_config = OpenEphys_Configuration()
    try:
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
                print("\n")
    except Exception as e:
        print("[WARNING] OpenEphys Needs to be Started to configure EphysSocket")
        exit()
    #CONSTRUCTORS
    QUEUE_RAW_DATA   = Queue()
    QUEUE_CSV_DATA   = Queue()

    # CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
    #             16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]

    CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

    TASK_WiFiServer    = WiFiHeadstageReceiverV2(QUEUE_RAW_DATA, CHANNELS, HEADSTAGE_BUFFER_SIZE, p_port=HEADSTAGE_PORT, p_host_addr=HOST_ADDR)
    TASK_DataConverter = DataConverterV2(QUEUE_RAW_DATA, QUEUE_CSV_DATA, CHANNELS, FREQUENCY, HEADSTAGE_BUFFER_SIZE, DUAL_CHIP_MODE, p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)
    TASK_Manual_TTL    = TTL_Controller(OE_config, ttl_channel_key_mapping, port=TTL_EVENT_PORT, ip_addr=HOST_ADDR)

    #START THREADS
    TASK_WiFiServer.startThread(TASK_WiFiServer.m_socketConnectionThread)
    while not TASK_WiFiServer.m_connected:
        time.sleep(0.5)

    # Start other threads
    if TTL_GENERATOR:
        TASK_Manual_TTL.startThread()
    TASK_DataConverter.startThread()
    TASK_DataConverter.startEMGThread()
    TASK_DataConverter.startNeuroThread()

    while not (TASK_DataConverter.tcp_connected_neuro & TASK_DataConverter.tcp_connected_emg):
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

