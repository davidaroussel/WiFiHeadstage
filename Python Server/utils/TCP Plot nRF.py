import socket
import time
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

def tcp_receive_with_plot(
        host="192.168.2.196",
        port=5000,
        buffer_size=8192,
        plot_after_seconds=5
    ):
    """
    Receives TCP data as raw bytes, stores them, and plots them after a specified number of seconds.
    """

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    print(f"[INFO] Starting TCP server on {host}:{port}")
    server_socket.bind((host, port))
    server_socket.listen(1)

    print("[INFO] Waiting for a client to connect...")
    conn, addr = server_socket.accept()
    print(f"[INFO] Client connected from: {addr}")

    data_list = []          # Store received numeric data for plotting
    timestamps = []         # Store timestamps
    start_time = time.time()

    plt.ioff()  # We'll only plot after finishing reception

    try:
        while True:
            data = conn.recv(buffer_size)
            if not data:
                print("[INFO] Client disconnected.")
                break

            # Convert raw bytes to integers 0-255
            values = list(data)
            elapsed = time.time() - start_time

            data_list.extend(values)
            timestamps.extend([elapsed] * len(values))  # same timestamp for all bytes received at once
            print(f"[RECEIVED] {values[:16]} ... {len(values)} bytes")  # print first 16 for readability

    except KeyboardInterrupt:
        print("\n[INFO] Server stopped manually.")
    finally:
        conn.close()
        server_socket.close()
        print("[INFO] TCP server closed.")

        # Plot final data
        plt.figure()
        plt.plot(timestamps, data_list, marker='.', linestyle='none', markersize=2)
        plt.xlabel("Time (s)")
        plt.ylabel("Byte Value (0-255)")
        plt.title("TCP Data Received as Bytes")
        plt.show()


if __name__ == "__main__":
    tcp_receive_with_plot(port=10001)
