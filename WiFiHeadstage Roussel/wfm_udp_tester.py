import socket


def main():
    server_host = '0.0.0.0'  # Use your server's IP address or '0.0.0.0' for all available interfaces
    server_port = 10001  # Choose an available port number

    server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server.bind((server_host, server_port))
    print(f"[*] Listening on {server_host}:{server_port}")

    # data = "testing testing"
    # client_address = ("10.99.172.126", 10000)
    while True:
        data, client_address = server.recvfrom(2)
        print(f"[*] Received data from {client_address[0]}:{client_address[1]} - {data.decode()}")

        # Echo the received data back to the client
        server.sendto(bytes(data, 'utf-8'), client_address)
        print("Sending")


if __name__ == "__main__":
    main()