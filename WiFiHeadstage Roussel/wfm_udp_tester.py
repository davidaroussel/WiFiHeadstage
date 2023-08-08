import socket
import time
import struct
import threading
import random
import sched

timer_delay = 1

bufferSize = 1
localIP = "192.168.43.96"
serverAddressPort = (localIP, 10000)
intList_1 = [0xFF]*bufferSize
intList_2 = [65000]*bufferSize
testValue = []

bytesToSend_1 = struct.pack('%se' % len(intList_1), *intList_1)
bytesToSend_2 = struct.pack('%se' % len(intList_2), *intList_2)
buffer = 0xFF
value = 0

UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

counter = 0
while(1):
    if counter < 10000:
        UDPClientSocket.sendto(bytesToSend_1, serverAddressPort)
        counter += 1
    print("SENT_1")
    print("Value:  ", value)
