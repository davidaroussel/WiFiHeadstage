import socket
import sys

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = ('192.168.43.96', 10000)
print("Starting on TCP", server_address[0], "port", server_address[1])

sock.bind(server_address)

sock.listen(1)

state = True

while True:
    print("TCP server up and listening")
    connection, client_addresse = sock.accept()
    counter = 0
    try:
        print("Connection from", client_addresse)
        while state:
            data = connection.recv(32).hex()
            # test = int(data, 16)
            print('Data from client is:', data)
            # print("Sending back data to client:", data)
            # connection.sendall(data)
            print(counter)
            counter += 1

    finally:
        connection.close()