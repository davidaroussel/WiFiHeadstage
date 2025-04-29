"""
    A zmq client to test remote control of open-ephys GUI
"""

import zmq
import os
import time
from open_ephys.control import OpenEphysHTTPServer
from open_ephys.control.network_control import NetworkControl
import requests
from OpenEphys.OpenEphys_Configuration import OpenEphys_Configuration

def run_client():
    OE_config = OpenEphys_Configuration()

    # Basic start/stop commands
    start_cmd = 'StartRecord'
    stop_cmd = 'StopRecord'

    # Example settings
    rec_dir = os.path.join(r"C:\Users\david\Documents\Open Ephys\NewTesting")
    print("Saving data to:", rec_dir)

    # Some commands
    commands = [start_cmd + ' RecDir=%s' % rec_dir,
                start_cmd + ' CreateNewDir=1',
                start_cmd + ' PrependText=Session01',
                start_cmd + ' CreateNewDir=1' + ' PrependText=',
                start_cmd + ' PrependText=Session02',
                start_cmd + ' CreateNewDir=1' + ' PrependText=',
                start_cmd + ' PrependText=Session03',
                start_cmd + ' CreateNewDir=1' + ' PrependText=',
                start_cmd + ' PrependText=Session04',
                start_cmd + ' CreateNewDir=1' + ' PrependText=',
                start_cmd + ' PrependText=Session05',
                start_cmd + ' CreateNewDir=1' + ' PrependText=',
                start_cmd + ' PrependText=Session06',
                ]

    # Connect network handler
    ip = '127.0.0.1'
    port = 5556
    timeout = 1.

    retVal_list = []
    OE_config = OpenEphys_Configuration()
    retVal_list.append(OE_config.get_GUI_status())
    retVal_list.append(OE_config.get_GUI_recording_node())
    retVal_list.append(OE_config.set_GUI_recording_path(rec_dir))
    retVal_list.append(OE_config.get_GUI_recording_path())
    retVal_list.append(OE_config.get_ES_processor_id())
    retVal_list.append(OE_config.get_ES_info())
    retVal_list.append(OE_config.set_ES_scale(0.195))
    retVal_list.append(OE_config.set_ES_offset(32768))
    retVal_list.append(OE_config.set_ES_port(10001))
    retVal_list.append(OE_config.set_ES_frequency(3500))
    retVal_list.append(OE_config.get_ES_info())
    for retVal in retVal_list:
        print(retVal)

    url = "tcp://%s:%d" % (ip, port)

    with zmq.Context() as context:
        with context.socket(zmq.REQ) as socket:
            socket.RCVTIMEO = int(500)  # timeout in milliseconds
            socket.connect(url)

            # Start data acquisition
            socket.send_string('StartAcquisition')
            print("StartAcquisition: ", socket.recv())

            socket.send_string('IsAcquiring')
            print("IsAcquiring:", socket.recv())
            print("")

            for start_cmd in commands:
                for cmd in [start_cmd, stop_cmd]:
                    socket.send_string(cmd)
                    print(socket.recv())

                    if 'StartRecord' in cmd:
                        # Record data for 5 seconds
                        socket.send_string('IsRecording')
                        print("IsRecording:", socket.recv())

                        socket.send_string('GetRecordingPath' + f' RecordNode={OE_config.recording_node}')
                        print("Recording path:", socket.recv())

                        time.sleep(5)
                    else:
                        # Stop for 1 second
                        socket.send_string('IsRecording')
                        print("IsRecording:", socket.recv())
                        time.sleep(0.01)

                print("")

            # Finally, stop data acquisition; it might be a good idea to
            # wait a little bit until all data have been written to hard drive
            time.sleep(0.5)
            socket.send_string('StopAcquisition')
            print(socket.recv())


if __name__ == '__main__':
    run_client()