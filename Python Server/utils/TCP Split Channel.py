import socket
import numpy as np
import matplotlib.pyplot as plt
import time

START_CAPS = b'\xAA\x55'
NUM_CHANNELS = 32
BYTES_PER_SAMPLE = NUM_CHANNELS * 2  # 16-bit per channel
SEQUENCES_DURATION = 10  # seconds to sample

def tcp_receive(host="192.168.2.196", port=5000):
    print(f"[INFO] TCP server starting on {host}:{port}")
    data_buffer = b''
    channel_data = [[] for _ in range(NUM_CHANNELS)]

    start_time = time.time()

    while True:
        try:
            server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            server_socket.bind((host, port))
            server_socket.listen(1)

            print("[INFO] Waiting for a client to connect...")
            conn, addr = server_socket.accept()
            print(f"[INFO] Client connected from: {addr}")

            while True:
                chunk = conn.recv(4096)
                if not chunk:
                    print("[INFO] Client disconnected.")
                    break

                data_buffer += chunk

                # Process all messages in buffer
                while True:
                    start_idx = data_buffer.find(START_CAPS)
                    if start_idx == -1:
                        # Keep last byte in case start caps split
                        data_buffer = data_buffer[-1:] if len(data_buffer) > 1 else data_buffer
                        break

                    # Check if we have enough bytes for a full message
                    if len(data_buffer) - start_idx >= 2 + BYTES_PER_SAMPLE:
                        message = data_buffer[start_idx:start_idx + 2 + BYTES_PER_SAMPLE]
                        data_buffer = data_buffer[start_idx + 2 + BYTES_PER_SAMPLE:]

                        data_bytes = message[2:]
                        samples = np.frombuffer(data_bytes, dtype=np.uint16)

                        for ch in range(NUM_CHANNELS):
                            channel_data[ch].append(samples[ch])
                    else:
                        break

                # Stop after 10 seconds
                if time.time() - start_time >= SEQUENCES_DURATION:
                    print("[INFO] 10 seconds of data collected. Stopping.")
                    conn.close()
                    server_socket.close()

                    # Plot all channels in a single figure with subplots
                    fig, axes = plt.subplots(NUM_CHANNELS, 1, figsize=(12, 2*NUM_CHANNELS), sharex=True)
                    for ch in range(NUM_CHANNELS):
                        axes[ch].plot(channel_data[ch], color='blue')
                        axes[ch].set_ylabel(f"Ch {ch}")
                        axes[ch].grid(True)

                    axes[-1].set_xlabel("Sample Index")
                    plt.suptitle("All 32 Channels over 10 Seconds", fontsize=16)
                    plt.tight_layout(rect=[0, 0, 1, 0.97])
                    plt.show()
                    return

        except KeyboardInterrupt:
            print("\n[INFO] Server stopped manually.")
            break

        except Exception as e:
            print(f"[ERROR] Socket error: {e}")

        finally:
            if conn:
                conn.close()
            if server_socket:
                server_socket.close()


if __name__ == "__main__":
    tcp_receive(port=10001)
