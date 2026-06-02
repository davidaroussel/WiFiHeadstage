import threading
import time

from open_ephys.control import OpenEphysHTTPServer
from open_ephys.control.network_control import NetworkControl
import keyboard

class TTL_Controller:
    def __init__(self, OE_config, key_mapping, port=5556, ip_addr='localhost'):
        self.OE_config = OE_config
        self.key_mapping = key_mapping
        self.ip_addr = ip_addr
        self.port = port
        self.gui_starter = OpenEphysHTTPServer(address=self.ip_addr)
        self.gui_ttl = NetworkControl(ip_address=self.ip_addr, port=self.port)
        self.ttl_thread = threading.Thread(target=self.ttl_sender)

    def startThread(self):
        self.ttl_thread.start()

    def stopThread(self):
        self.ttl_thread.join()

    def ttl_sender(self):
        print("---STARTING TTL_CONTROLLER THREAD---")
        prev_state = {key: False for keys in self.key_mapping.values() for key in keys}
        try:
            while True:
                for channel, (key_on, key_off) in self.key_mapping.items():
                    if keyboard.is_pressed(key_on):
                        if not prev_state[key_on]:
                            self.gui_ttl.send_ttl(line=channel, state=1)  # Turn ON
                            print(f"Channel {channel} ON")
                            prev_state[key_on] = True
                    else:
                        prev_state[key_on] = False

                    if keyboard.is_pressed(key_off):
                        if not prev_state[key_off]:  # Detect new press
                            self.gui_ttl.send_ttl(line=channel, state=0)  # Turn OFF
                            print(f"Channel {channel} OFF")
                            prev_state[key_off] = True
                    else:
                        prev_state[key_off] = False
                time.sleep(0.1)
        finally:
            print("Closing Acquisition")
            self.OE_config.Network_Events_Connect()
            self.OE_config.GUI_Stop_Recording()
            self.OE_config.GUI_Stop_Acquisition()
            print("Done Closing Acquisition")