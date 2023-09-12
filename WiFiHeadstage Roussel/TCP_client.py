import socket
import sys

# Create a TCP/IP socket
import time

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect the socket to the port where the server is listening
server_address = ('10.99.172.157', 10000)
print ("Connecting to", server_address[0], "port", server_address[1])

sock.connect(server_address)

counter = 0

for i in range(10):

    # Send data
    message = 'Hello TCP Server'
    print('Sending: ', message)
    message_encoded = str.encode(message)
    sock.sendall(message_encoded)

    # Look for the response
    amount_received = 0
    amount_expected = len(message)

    while amount_received < amount_expected:

        if amount_received == 0:
            counter += 1
            if counter > 100:
                print("closing socket")
                sock.close()
                exit()
        else:
            data = sock.recv(128)
            amount_received += len(data)

    print("received:", data)

    i += 1
    time.sleep(1)
    print("------------------------------")



print("closing socket")
sock.close()