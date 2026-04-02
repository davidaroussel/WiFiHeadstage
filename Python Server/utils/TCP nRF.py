import socket
import time
import numpy as np


def tcp_receive(host="192.168.2.196", port=5000, buffer_size=8192):
    FRAME_SIZE = 8192
    PAYLOAD_SIZE = 8192
    BLOCK_SIZE = 32

    data_buffer = bytearray()
    START_CAPS = b'\xAA\x54'
    caps_error = 0

    # Accumulators
    emg_accumulator = np.array([], dtype=np.int16)
    neuro_accumulator = np.array([], dtype=np.int16)

    counter_crash = 0
    counter_tries = 0
    deleted_item_counter = 0
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

                while len(data_buffer) >= FRAME_SIZE:
                    payload = data_buffer[:PAYLOAD_SIZE]
                    del data_buffer[:FRAME_SIZE]
                    raw = np.frombuffer(payload, dtype='>i2')

                    num_blocks = raw.size // BLOCK_SIZE
                    raw_blocks = raw[:num_blocks * BLOCK_SIZE].reshape(num_blocks, BLOCK_SIZE)

                    emg_mask = np.all((raw_blocks & 0x0001) == 1, axis=1)
                    neuro_mask = np.all((raw_blocks & 0x0001) == 0, axis=1)

                    valid_rows_mask = emg_mask | neuro_mask
                    deleted_rows = num_blocks - valid_rows_mask.sum()

                    if emg_mask.any():
                        emg_accumulator = np.concatenate(
                            (emg_accumulator, raw_blocks[emg_mask].ravel())
                        )

                    if neuro_mask.any():
                        neuro_accumulator = np.concatenate(
                            (neuro_accumulator, raw_blocks[neuro_mask].ravel())
                        )
                    counter_tries += 1
                    if deleted_rows > 0:
                        counter_crash += 1
                        deleted_item_counter += deleted_rows
                        if counter_crash % 100 == 0:
                            pourcentage = (deleted_item_counter / (100 * counter_tries * 128))*100
                            print(
                                f"[ALERT] {deleted_item_counter} invalid 32-value rows across 100x 8192 Bytes buffer "
                                f"for {counter_tries} tries. [Failed Rate: {pourcentage:.2f}%]")
                            deleted_item_counter = 0
                            counter_tries = 0

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