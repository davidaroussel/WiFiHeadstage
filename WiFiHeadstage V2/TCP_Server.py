import socket

counter = 0
ROUNDS = 1000
NUM_CHANNELS = 64
BYTES_PER_DATA = 2
FPGA_BUFFER_SIZE = 15
RHD64_DATA_BUFFER = [[None for i in range(ROUNDS)] for j in range(NUM_CHANNELS)]

localIP = "0.0.0.0"
localPort = 10000
UDP_HEADER_SIZE = 150
UDP_BUFFER_SIZE = NUM_CHANNELS * BYTES_PER_DATA * FPGA_BUFFER_SIZE
bufferSize = UDP_BUFFER_SIZE + UDP_HEADER_SIZE

print(f"TCP server up and listening on {localIP}:{localPort}")

# Create a socket object
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the server IP and port
server_socket.bind((localIP, localPort))

# Listen for incoming client connections (up to 5 clients in the queue)
server_socket.listen(5)
while True:
    try:
        # Accept a client connection
        client_socket, client_address = server_socket.accept()
        print(f"Accepted connection from {client_address}")

        # Receive data from the client
        data = client_socket.recv(1024).decode()
        print(f"Received data from client: {data}")

        # Process the received data (you can customize this part)
        response_data = f"Server received: {data}"

        # Send a response back to the client
        client_socket.send(response_data.encode())
        print(f"Sent response to client: {response_data}")

        # Close the client socket
        client_socket.close()
        print(f"Closed connection with {client_address}")

    except KeyboardInterrupt:
        # Handle Ctrl+C to gracefully exit the server
        print("Server shutting down...")
        server_socket.close()
        break

    except Exception as e:
        print(f"An error occurred: {str(e)}")

print("Server is stopped.")