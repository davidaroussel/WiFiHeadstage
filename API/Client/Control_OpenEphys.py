import time

from open_ephys.control import OpenEphysHTTPServer
from open_ephys.control.network_control import NetworkControl

channel = 1
state = 1

gui_starter = OpenEphysHTTPServer(address='127.0.0.1')
gui_ttl = NetworkControl(ip_address='127.0.0.1', port=5556)

gui_starter.acquire()
time.sleep(1)
print("SENDING ")

gui_starter.record()
time.sleep(1)
print("RECORDING ")


# gui_ttl.start()
# print("SENDING ")
# time.sleep(1)
#
# gui_ttl.record()
# print("RECORDING ")
# time.sleep(1)

counter = 0
while True:
    gui_ttl.send_ttl(line=channel, state=state)
    time.sleep(1)
    state = not state
    counter += 1

    if counter == 10:
        gui_starter.idle()
        quit()


