import socket


def tcp_receive(host="1"
                     "92.168.2.196", port=5000, buffer_size=4096):
    """
    Simple TCP server that receives data continuously.

    :param host: IP address to bind (0.0.0.0 = all interfaces)
    :param port: Port to listen on
    :param buffer_size: Max bytes to read per recv()
    """
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    print(f"[INFO] Starting TCP server on {host}:{port}")
    server_socket.bind((host, port))
    server_socket.listen(1)

    print("[INFO] Waiting for a client to connect...")
    conn, addr = server_socket.accept()
    print(f"[INFO] Client connected from: {addr}")

    try:
        while True:
            data = conn.recv(buffer_size)
            if not data:
                print("[INFO] Client disconnected.")
                break
            print(f"[RECEIVED] {data}")
    except KeyboardInterrupt:
        print("\n[INFO] Server stopped manually.")
    finally:
        conn.close()
        server_socket.close()
        print("[INFO] TCP server closed.")


if __name__ == "__main__":
    tcp_receive(port=10001)
