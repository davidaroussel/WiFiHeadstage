# Coded by D. Roussel at BIOMEDICAL MICROSYSTEMS LABORATORY
# Original version 12/04/2024

import time
from open_ephys.control import OpenEphysHTTPServer
from open_ephys.control.network_control import NetworkControl
import keyboard

# CONTROL OPEN EPHYS WITH PYTHON --TEMPLATE--
if __name__ == "__main__":
    channel = 2
    state = 1
    # Usage of both library was recommended by founder Josh Siegle
    # gui_starter's TTL fonctionnality was never finished so it makes the app crash
    gui_starter = OpenEphysHTTPServer(address='127.0.0.1')
    gui_ttl = NetworkControl(ip_address='127.0.0.1', port=5556)

    ## CONTROL OPEN EPHYS WITH PYTHON (optional section) ###
    gui_starter.acquire()
    time.sleep(1)
    print("SENDING ")
    # gui_starter.record()
    # time.sleep(1)
    # print("RECORDING ")

    while True:
        if keyboard.is_pressed('q'):
            # Toggle channel 0 HIGH
            gui_ttl.send_ttl(line=4, state=1)
            print("Channel 0 HIGH")
        elif keyboard.is_pressed('w'):
            # Toggle channel 0 LOW
            gui_ttl.send_ttl(line=4, state=0)
            print("Channel 0 LOW")
        elif keyboard.is_pressed('e'):
            # Toggle channel 1 HIGH
            gui_ttl.send_ttl(line=5, state=1)
            print("Channel 1 HIGH")
        elif keyboard.is_pressed('r'):
            # Toggle channel 1 LOW
            gui_ttl.send_ttl(line=5, state=0)
            print("Channel 1 LOW")

        time.sleep(0.1)  # Short delay to prevent excessive CPU usage
