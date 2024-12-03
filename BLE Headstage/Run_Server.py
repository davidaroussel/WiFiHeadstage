import time
from queue import Queue
from BLE_Spinalcordsystem import SpinalCordSystem_BLE
from BLE_Simulator import BLE_Simulator
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

    # MODES
    CSV_WRITING = True
    OPENEPHYS_SENDING = True
    DATA_SIMULATOR = True  # Change to False to use BLE host

    # GLOBAL VARIABLES
    HOST_ADDR = ""
    HEADSTAGE_PORT = 5000
    OPENEPHYS_PORT = 10001

    # CHANNEL CONFIGURATION
    CHANNELS = [0, 1]
    BUFFER_SOCKET_FACTOR = 100
    BUFFER_SIZE = 1024
    FREQUENCY = 15000

    # CONSTRUCTORS
    QUEUE_RAW_DATA = Queue()
    QUEUE_EPHYS_DATA = Queue()

    if DATA_SIMULATOR:
        # BLE Simulator initialization
        TASK_BLE_Simulator = BLE_Simulator(CHANNELS, FREQUENCY, QUEUE_RAW_DATA, BUFFER_SIZE)
        # Initialize sine wave on channel 0 and square wave on channel 1
        TASK_BLE_Simulator.init_wave([0], wave_type="sine", amplitude=20000, frequency=20)
        TASK_BLE_Simulator.init_wave([1], wave_type="square", amplitude=30000, frequency=600)
        TASK_BLE_Simulator.start()
        print("Started BLE Simulator")
    else:
        # BLE Host initialization
        TASK_BLEHost = SpinalCordSystem_BLE(BLE_MCU_NAME, QUEUE_RAW_DATA, CHANNELS, BUFFER_SOCKET_FACTOR)
        TASK_BLEHost.startBLE_Thread()
        while not TASK_BLEHost._connected:
            time.sleep(1)
        TASK_BLEHost.sendInitiationPacket()
        print("Started BLE Host")


    # DataConverter setup
    TASK_DataConverter = DataConverter(QUEUE_RAW_DATA, QUEUE_EPHYS_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR)

    # OpenEphysSender setup
    TASK_OpenEphysSender = OpenEphysSender(QUEUE_EPHYS_DATA, CHANNELS, BUFFER_SIZE, BUFFER_SOCKET_FACTOR, FREQUENCY,
                                           p_port=OPENEPHYS_PORT, p_host_addr=HOST_ADDR)

    # Start DataConverter thread
    TASK_DataConverter.startThread()

    # Start OpenEphysSender thread if enabled
    if OPENEPHYS_SENDING:
        TASK_OpenEphysSender.startThread()
        print("Started OpenEphys Sender")

    ### CONTROL OPEN EPHYS WITH PYTHON (optional section) ###
    # Uncomment and modify if GUI control needed
    # gui_starter.acquire()
    # time.sleep(1)
    # print("SENDING ")
    # gui_starter.record()
    # time.sleep(1)
    # print("RECORDING ")
    # counter = 0
    # while True:
    #     gui_ttl.send_ttl(line=channel, state=state)
    #     time.sleep(1)
    #     state = not state
    #     counter += 1
    #     if counter == 100:
    #         gui_starter.idle()
    #         print("STOP ")
    #         quit()

    # Continuous loop until "stop" is entered
    print("\r")
    user_input = input("Enter 'stop' to disable sampling: ")
    if user_input.strip().lower() == "stop":
        # Stop the simulator or BLE host depending on the mode
        if DATA_SIMULATOR:
            TASK_BLE_Simulator.stop()
            TASK_BLE_Simulator.join()
            print("Closed BLE Simulator")
        else:
            TASK_BLEHost.stopRecording()
            TASK_BLEHost.disconnect()
            print("Closed BLE Host")
            TASK_BLEHost.stopThread()
            print("Closed BLE Host Thread")

        # Stop OpenEphysSender if enabled
        if OPENEPHYS_SENDING:
            TASK_OpenEphysSender.stopThread()
            print("Closed OpenEphys Sender")

        # Stop DataConverter thread
        TASK_DataConverter.stopThread()
        print("Closed Data Converter")
