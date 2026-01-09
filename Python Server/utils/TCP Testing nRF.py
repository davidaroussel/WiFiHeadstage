import socket
import time


def tcp_receive(host="192.168.2.196", port=5000, buffer_size=8196):
    """
    TCP server that automatically restarts listening when a client disconnects.
    """

    print(f"[INFO] TCP server starting on {host}:{port}")

    while True:  # Server lifetime loop
        server_socket = None
        conn = None

        try:
            # Create server socket
            server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

            server_socket.bind((host, port))
            server_socket.listen(1)

            print("[INFO] Waiting for a client to connect...")
            conn, addr = server_socket.accept()
            print(f"[INFO] Client connected from: {addr}")

            # Client receive loop
            while True:
                data = conn.recv(buffer_size)
                if not data:
                    print("[INFO] Client disconnected.")
                    break

                print(f"[RECEIVED] {data}")

        except KeyboardInterrupt:
            print("\n[INFO] Server stopped manually.")
            break

        except Exception as e:
            print(f"[ERROR] Socket error: {e}")
            time.sleep(1)  # Prevent tight crash loop

        finally:
            if conn:
                conn.close()
                print("[INFO] Client socket closed.")
            if server_socket:
                server_socket.close()
                print("[INFO] Server socket closed. Restarting...\n")


if __name__ == "__main__":
    tcp_receive(port=10001)
