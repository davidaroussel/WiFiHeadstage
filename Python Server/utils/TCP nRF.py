import socket
import time


def tcp_receive(host="192.168.2.196", port=5000, buffer_size=8192):
    FRAME_SIZE = 8192
    PAYLOAD_SIZE = 8192
    data_buffer = bytearray()
    START_CAPS = b'\xAA\x55'
    caps_error = 0
    print(f"[INFO] TCP server starting on {host}:{port}")
    while True:
        server_socket = None
        conn = None

        try:
            # CREATE SOCKET
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
                data_buffer.extend(data)
                if len(data_buffer) >= buffer_size:
                    #NOT THE PROPER CAP
                    if data_buffer[:2] != START_CAPS:
                        caps_error += 1
                        del data_buffer[0]
                        if caps_error % 81920 == 0:
                            print(f"[HEADSTAGE] OFFSET START CAPS {caps_error}")
                            continue

                    # PROPER CAP 0xAA55
                    else:
                        payload = data_buffer[:PAYLOAD_SIZE]
                        del data_buffer[:FRAME_SIZE]
                        print("[RECEIVED] ", payload)
        except KeyboardInterrupt:
            print("\n[INFO] Server stopped manually.")
            break

        except Exception as e:
            print(f"[ERROR] Socket error: {e}")
            time.sleep(1)

        finally:
            if conn:
                conn.close()
                print("[INFO] Client socket closed.")
            if server_socket:
                server_socket.close()
                print("[INFO] Server socket closed. Restarting...\n")


if __name__ == "__main__":
    tcp_receive(port=10001)
