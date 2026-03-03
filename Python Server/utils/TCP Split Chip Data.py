import socket
import time
import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

def log_raw_capture_with_headers(capture_buffer, file_path="raw_data.txt", points_per_line=32):
    # Convert raw bytes to signed 16-bit integers (big-endian)
    raw_ints = np.frombuffer(capture_buffer, dtype='>i2')

    # Convert capture buffer to bytes for header search
    buffer_bytes = bytes(capture_buffer)
    header = b'\xAA\x54'
    header_indices = []

    # Find all start positions of header in the buffer
    i = 0
    while True:
        idx = buffer_bytes.find(header, i)
        if idx == -1:
            break
        header_indices.append(idx // 2)  # convert byte index to 16-bit index
        i = idx + 2

    with open(file_path, 'w') as f:
        next_header_idx = 0
        header_pointer = 0

        for start in range(0, len(raw_ints), points_per_line):
            end = start + points_per_line
            # Check if current start crosses a header
            if header_pointer < len(header_indices) and start >= header_indices[header_pointer]:
                f.write('\n')  # add empty line at new frame
                header_pointer += 1

            line = ' '.join(map(str, raw_ints[start:end]))
            f.write(line + '\n')

    print(f"[INFO] Raw data saved to {file_path}, total {len(raw_ints)} integers, headers marked")

def tcp_receive(host="192.168.2.196", port=5000, buffer_size=8192):

    # =============================
    # CONSTANTS
    # =============================
    FRAME_SIZE = 8192
    PAYLOAD_SIZE = 8192
    START_CAPS = b'\xAA\x54'

    TARGET_NEURO_SAMPLES = 4096
    TARGET_EMG_SAMPLES = 4096
    NUM_CHANNELS = 16

    OpenEphysOffset = 32768
    maxOpenEphysValue = 0.005
    scale = (0.000000195 / maxOpenEphysValue) * OpenEphysOffset

    capture_duration = 2  # seconds

    # =============================
    # BUFFERS
    # =============================
    data_buffer = bytearray()
    capture_buffer = bytearray()

    caps_error = 0
    capture_active = False
    start_time = None

    print(f"[INFO] TCP server starting on {host}:{port}")
    counter = 0
    while True:
        server_socket = None
        conn = None

        try:
            server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            server_socket.bind((host, port))
            server_socket.listen(1)

            print("[INFO] Waiting for a client to connect...")
            conn, addr = server_socket.accept()
            print(f"[INFO] Client connected from: {addr}")

            while True:
                data = conn.recv(buffer_size)
                if not data:
                    print("[INFO] Client disconnected.")
                    break

                data_buffer.extend(data)

                while len(data_buffer) >= FRAME_SIZE:
                    counter += 1
                    print(f"Counter {counter}")
                    payload = data_buffer[:PAYLOAD_SIZE]
                    del data_buffer[:FRAME_SIZE]

                    # =============================
                    # START CAPTURE TIMER
                    # =============================
                    if not capture_active:
                        capture_active = True
                        start_time = time.time()
                        capture_buffer.clear()
                        print("[INFO] 10-second capture started")

                    capture_buffer.extend(payload)

                    # =============================
                    # AFTER 10 SECONDS → PROCESS
                    # =============================
                    if time.time() - start_time >= capture_duration:

                        print("[INFO] 10 seconds reached. Processing...")

                        raw = np.frombuffer(capture_buffer, dtype='>i2')
                        n = raw.size
                        block_size = 32  # size of each data block
                        num_lines = n // block_size

                        # -------------------------
                        # Buffers
                        # -------------------------
                        raw_emg_data = []
                        raw_neuro_data = []
                        filtered_emg_data = []
                        filtered_neuro_data = []

                        # Reshape into rows of 32 for easy LSB checking
                        raw_blocks = raw[:num_lines * block_size].reshape(num_lines, block_size)

                        # LSB masks
                        emg_mask = np.all((raw_blocks & 0x0001) == 1, axis=1)  # True if all 32 LSB=1
                        neuro_mask = np.all((raw_blocks & 0x0001) == 0, axis=1)  # True if all 32 LSB=0

                        # Valid rows
                        valid_rows_mask = emg_mask | neuro_mask
                        deleted_rows_indices = np.flatnonzero(~valid_rows_mask)

                        print(f"[INFO] Deleted rows in this buffer: {len(deleted_rows_indices)}")
                        print("Deleted row indices:", deleted_rows_indices)

                        # -------------------------
                        # Split raw vs filtered
                        # -------------------------
                        for i in range(num_lines):
                            line = raw_blocks[i]
                            # Raw buffers (all rows regardless of validity)
                            if (raw_blocks[i] & 0x0001).any():  # any 1? just for reference
                                raw_emg_data.append(line.copy())
                            else:
                                raw_neuro_data.append(line.copy())

                            # Filtered buffers (only valid rows)
                            if valid_rows_mask[i]:
                                if emg_mask[i]:
                                    filtered_emg_data.append(line.copy())
                                elif neuro_mask[i]:
                                    filtered_neuro_data.append(line.copy())

                        # Flatten buffers
                        raw_emg_data = np.vstack(raw_emg_data).flatten() if raw_emg_data else np.array([], dtype=int)
                        raw_neuro_data = np.vstack(raw_neuro_data).flatten() if raw_neuro_data else np.array([],
                                                                                                             dtype=int)
                        filtered_emg_data = np.vstack(filtered_emg_data).flatten() if filtered_emg_data else np.array(
                            [], dtype=int)
                        filtered_neuro_data = np.vstack(
                            filtered_neuro_data).flatten() if filtered_neuro_data else np.array([], dtype=int)

                        print(
                            f"[INFO] EMG rows: {len(raw_emg_data) // block_size}, Filtered EMG rows: {len(filtered_emg_data) // block_size}")
                        print(
                            f"[INFO] Neuro rows: {len(raw_neuro_data) // block_size}, Filtered Neuro rows: {len(filtered_neuro_data) // block_size}")
                        # =============================
                        # RESHAPE + CONVERT
                        # =============================
                        def process_chip(data):
                            usable = (data.size // NUM_CHANNELS) * NUM_CHANNELS
                            data = data[:usable]
                            reshaped = data.reshape(-1, NUM_CHANNELS).T
                            clipped = np.clip(reshaped, -32768, 32768)
                            converted = (clipped * scale + OpenEphysOffset).astype(np.uint16)
                            return converted

                        # Convert all buffers for plotting
                        raw_emg_processed = process_chip(raw_emg_data)
                        raw_neuro_processed = process_chip(raw_neuro_data)
                        filtered_emg_processed = process_chip(filtered_emg_data)
                        filtered_neuro_processed = process_chip(filtered_neuro_data)

                        # =============================
                        # PLOT: raw vs filtered
                        # =============================
                        fig, axes = plt.subplots(16, 2, figsize=(18, 20), sharex=False)
                        fig.suptitle("EMG & Neuro: Raw (blue) vs Filtered (red)", fontsize=16)

                        log_raw_capture_with_headers(
                            capture_buffer,
                            file_path="raw_data.txt",
                            points_per_line=32
                        )

                        for ch in range(16):
                            # Cut second half for plotting
                            re = raw_emg_processed[ch][len(raw_emg_processed[ch]) // 2:]
                            rn = raw_neuro_processed[ch][len(raw_neuro_processed[ch]) // 2:]
                            fe = filtered_emg_processed[ch][len(filtered_emg_processed[ch]) // 2:]
                            fn = filtered_neuro_processed[ch][len(filtered_neuro_processed[ch]) // 2:]

                            axes[ch, 0].plot(re, color='tab:blue', alpha=0.5)
                            axes[ch, 0].plot(fe, color='tab:red', alpha=0.7)
                            axes[ch, 0].set_ylabel(f"E Ch {ch}")
                            axes[ch, 0].set_yticks([])

                            axes[ch, 1].plot(rn, color='tab:blue', alpha=0.5)
                            axes[ch, 1].plot(fn, color='tab:red', alpha=0.7)
                            axes[ch, 1].set_ylabel(f"N Ch {ch}")
                            axes[ch, 1].set_yticks([])

                        axes[-1, 0].set_xlabel("Sample Index")
                        axes[-1, 1].set_xlabel("Sample Index")
                        plt.tight_layout()
                        plt.show()


                        # RESET
                        capture_active = False
                        capture_buffer.clear()
                        print("[INFO] Capture reset.")



        except KeyboardInterrupt:
            print("\n[INFO] Server stopped manually.")
            break

        except Exception as e:
            print(f"[ERROR] Socket error: {e}")
            time.sleep(1)

        finally:

            if conn:
                conn.close()
            if server_socket:
                server_socket.close()

def analyze_forced_buffer(file_path):
    """
    Analyze full 8192-value raw buffer from .txt file.
    Each line is 32 values.
    - Lines starting with -21932 are always valid headers, but rest of line must follow EMG/Neuro pattern.
    - EMG lines: first=65 or -21932, rest must be 85, 17th element=65
    - Neuro lines: first=72 or -21932, rest must be 0, 17th element=72
    """
    # Load data
    with open(file_path, 'r') as f:
        data = f.read().split()
    buffer = np.array([int(x) for x in data], dtype=int)

    line_size = 32
    num_lines = len(buffer) // line_size

    anomalies = []

    for line_idx in range(num_lines):
        start = line_idx * line_size
        end = start + line_size
        line = buffer[start:end]

        first_val = line[0]
        mid_val = line[16]  # 17th element

        # Determine pattern based on 17th element
        if mid_val == 65:  # EMG
            expected = np.full(line_size, 85, dtype=int)
            expected[0] = first_val if first_val in (65, -21932) else 65
            expected[16] = 65
        elif mid_val == 72:  # Neuro
            expected = np.zeros(line_size, dtype=int)
            expected[0] = first_val if first_val in (72, -21932) else 72
            expected[16] = 72
        else:
            anomalies.append((line_idx + 1, line))
            continue

        # Compare line to expected pattern
        if not np.array_equal(line, expected):
            anomalies.append((line_idx + 1, line))

    # Write anomalies to file
    if anomalies:
        with open("anomalies.txt", 'w') as f:
            for idx, line in anomalies:
                f.write(f"Line {idx}: {' '.join(map(str, line))}\n")
        print(f"[INFO] {len(anomalies)} anomalies found. See anomalies.txt")
    else:
        print("[INFO] No anomalies detected.")

def analyze_full_buffer(file_path):
    """
    Analyze raw buffer using strict 32-value row LSB validation.

    Rules:
    - Data is processed row by row (32 values per row).
    - If first value of row has LSB=1 → ALL 32 values must have LSB=1 (EMG).
    - If first value has LSB=0 → ALL 32 values must have LSB=0 (Neuro).
    - If not → anomaly with detailed explanation.
    """

    # -----------------------------
    # Load data
    # -----------------------------
    with open(file_path, 'r') as f:
        data = f.read().split()

    buffer = np.array([int(x) for x in data], dtype=np.int16)

    block_size = 32
    num_rows = buffer.size // block_size

    anomalies = []

    for row_idx in range(num_rows):
        start = row_idx * block_size
        end = start + block_size
        row = buffer[start:end]

        if row.size < block_size:
            continue  # ignore incomplete trailing data

        row_lsb = row & 0x0001
        first_lsb = row_lsb[0]

        # Expected type
        expected_type = "EMG (LSB=1)" if first_lsb == 1 else "Neuro (LSB=0)"

        # Find mismatches
        mismatch_mask = row_lsb != first_lsb
        mismatch_indices = np.where(mismatch_mask)[0]

        if mismatch_indices.size > 0:
            anomalies.append({
                "row_number": row_idx + 1,
                "expected_type": expected_type,
                "expected_lsb": int(first_lsb),
                "mismatch_count": mismatch_indices.size,
                "mismatch_indices": mismatch_indices.tolist(),
                "row_data": row.copy()
            })

    # -----------------------------
    # Write anomalies
    # -----------------------------
    if anomalies:
        with open("anomalies.txt", 'w') as f:
            for entry in anomalies:
                f.write(f"Row {entry['row_number']}:\n")
                f.write(f"Data: {' '.join(map(str, entry['row_data']))}\n")
                f.write(
                    f"Problem: Expected {entry['expected_type']} "
                    f"(all LSB={entry['expected_lsb']}), "
                    f"but found {entry['mismatch_count']} mismatching values "
                    f"at indices {entry['mismatch_indices']}.\n"
                )
                f.write("-" * 80 + "\n")

        print(f"[INFO] {len(anomalies)} anomalous rows found. See anomalies.txt")
    else:
        print("[INFO] No anomalies detected.")

if __name__ == "__main__":
    # tcp_receive(port=10001)
    analyze_full_buffer("raw_data.txt")