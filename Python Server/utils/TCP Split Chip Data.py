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


def remove_repeated_rows_fast(blocks, min_repeats=4):
    sorted_blocks = np.sort(blocks, axis=1)

    # Compute run lengths
    diff = np.diff(sorted_blocks, axis=1)
    same = (diff == 0)

    # Count consecutive equal values
    counts = np.ones_like(sorted_blocks)
    counts[:, 1:] += same

    # Reset count when value changes
    counts = np.where(same, counts[:, :-1] + 1, 1)
    counts = np.concatenate([np.ones((blocks.shape[0], 1)), counts], axis=1)

    max_counts = counts.max(axis=1)

    mask = max_counts < min_repeats
    return blocks[mask], mask

def tcp_receive(host="192.168.2.196", port=5000, buffer_size=8192):

    # =============================
    # CONSTANTS
    # =============================
    FRAME_SIZE = 8192
    PAYLOAD_SIZE = 8192
    START_CAPS = b'\xAA\x54'

    TARGET_NEURO_SAMPLES = 4096
    TARGET_EMG_SAMPLES = 4096
<<<<<<< HEAD
    NUM_CHANNELS = 16
=======
    NUM_CHANNELS = 32
>>>>>>> ed5c0376b362634e1e81d9a369ec4feb75cb968b

    OpenEphysOffset = 32768
    maxOpenEphysValue = 0.005
    scale = (0.000000195 / maxOpenEphysValue) * OpenEphysOffset

<<<<<<< HEAD
    capture_duration = 5 # seconds
=======
    capture_duration = 20 # seconds
>>>>>>> ed5c0376b362634e1e81d9a369ec4feb75cb968b

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
                    if counter % 10 == 0:
                        print(f"Counter {counter}")
                    # print(f"Counter {counter}")
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
<<<<<<< HEAD
                    # if False:
=======
>>>>>>> ed5c0376b362634e1e81d9a369ec4feb75cb968b
                        print(f"Final Counter {counter}")
                        print("[INFO] 10 seconds reached. Processing...")

                        raw = np.frombuffer(capture_buffer, dtype='>i2')
                        n = raw.size
                        block_size = 16  # size of each data block
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

                        # Remove rows with repeated values (e.g., -1800 repeated 16 times)
                        filtered_blocks, repeat_mask = remove_repeated_rows_fast(raw_blocks, min_repeats=4)

                        print(f"[INFO] Rows removed due to repetition: {np.sum(~repeat_mask)}")

                        # LSB masks
                        emg_mask = np.all((raw_blocks & 0x0001) == 1, axis=1)  # True if all 32 LSB=1
                        neuro_mask = np.all((raw_blocks & 0x0001) == 0, axis=1)  # True if all 32 LSB=0

                        # Valid rows
                        valid_rows_mask = (emg_mask | neuro_mask) & repeat_mask
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

                        fig, axes = plt.subplots(NUM_CHANNELS, 2, figsize=(18, 20))
                        fig.suptitle("EMG & Neuro: Raw (blue) vs Filtered (red)", fontsize=16)

                        # Share X within each column
                        for ch in range(1, NUM_CHANNELS):
                            axes[ch, 0].sharex(axes[0, 0])  # left column shares with top-left
                            axes[ch, 1].sharex(axes[0, 1])  # right column shares with top-right

                        # log_raw_capture_with_headers(
                        #     capture_buffer,
                        #     file_path="raw_data.txt",
                        #     points_per_line=16
                        # )

                        log_hex_16bit(
                            capture_buffer,
                            file_path="hex_data.txt",
                            values_per_row=64,
                            group_size=16
                        )

                        for ch in range(NUM_CHANNELS):
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

def log_hex_16bit(
    buffer,
    file_path="hex_dump.txt",
    values_per_row=64,
    group_size=16
):
    """
    Write buffer as 16-bit HEX values.

    Format:
    - 64 values per row
    - extra spacing every 16 values
    - values shown as 4-digit uppercase HEX

    Example row:
    00AF 12BC 0F01 ...    A1B2 C3D4 ...
    """

    import numpy as np

    # Interpret as unsigned 16-bit big-endian
    data = np.frombuffer(buffer, dtype='>u2')

    with open(file_path, "w") as f:

        for row_start in range(0, len(data), values_per_row):

            row = data[row_start:row_start + values_per_row]

            parts = []

            for i, value in enumerate(row):

                # 4-digit HEX
                parts.append(f"{value:04X}")

                # extra spacing every group_size values
                if (i + 1) % group_size == 0 and (i + 1) != len(row):
                    parts.append("   ")   # bigger separator

            f.write(" ".join(parts))
            f.write("\n")

def analyze_forced_buffer(file_path):
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
        mid_val = line[16]

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

def analyze_full_buffer_dual_mode(file_path):
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

def analyze_full_buffer_single_mode(file_path):
    output_file = "anomalies.txt"
    with open(file_path, 'r') as f:
        data = f.read().split()

    buffer = np.array([int(x) for x in data], dtype=np.int16)

    # -------------------------------------------------
    # Find first channel 0 (LSB = 1)
    # -------------------------------------------------
    lsb = buffer & 0x0001
    start_candidates = np.where(lsb == 1)[0]

    if start_candidates.size == 0:
        raise ValueError("No CH0 marker (LSB=1) found in data")

    start_idx = start_candidates[0]

    print(f"[INFO] Channel 0 alignment index: {start_idx}")

    buffer = buffer[start_idx:]

    block_size = 16
    num_rows = buffer.size // block_size

    anomalies = []

    # -------------------------------------------------
    # Process rows
    # -------------------------------------------------
    for row_idx in range(num_rows):

        start = row_idx * block_size
        end = start + block_size
        row = buffer[start:end]

        if row.size < block_size:
            continue

        row_lsb = row & 0x0001

        ch0_valid = row_lsb[0] == 1
        others_valid = np.all(row_lsb[1:] == 0)

        if not (ch0_valid and others_valid):

            mismatch_indices = np.where(
                np.concatenate(([not ch0_valid], row_lsb[1:] != 0))
            )[0]

            anomalies.append({
                "row_number": row_idx + 1,
                "mismatch_indices": mismatch_indices.tolist(),
                "row_data": row.copy()
            })

    # -------------------------------------------------
    # Write anomalies
    # -------------------------------------------------
    if anomalies:
        with open(output_file, "w") as f:
            for entry in anomalies:
                f.write(f"Row {entry['row_number']}:\n")
                f.write(f"Data: {' '.join(map(str, entry['row_data']))}\n")
                f.write(
                    f"Problem: CH0 must have LSB=1 and CH1-CH15 must have LSB=0.\n"
                )
                f.write(
                    f"Mismatching indices: {entry['mismatch_indices']}\n"
                )
                f.write("-" * 80 + "\n")

        print(f"[INFO] {len(anomalies)} anomalous rows found. See {output_file}")

    else:
        print("[INFO] No anomalies detected.")

    return anomalies


EXPECTED_PATTERN = np.array([
    1,0, 2,2, 4,4, 6,6, 8,8, 10,10, 12,12, 14,14,
    17,16, 18,18, 20,20, 22,22, 24,24, 26,26, 28,28, 30,30
], dtype=np.int16)


def analyze_full_buffer_counter_source(file_path):

    with open(file_path, "r") as f:
        data = f.read().split()

    buffer = np.array([int(x) for x in data], dtype=np.int16)

    block_size = 32
    num_rows = buffer.size // block_size

    anomalies = []

    for row_idx in range(num_rows):

        start = row_idx * block_size
        row = buffer[start:start + block_size]

        if row.size < block_size:
            continue

        mismatch_mask = row != EXPECTED_PATTERN
        mismatch_indices = np.where(mismatch_mask)[0]

        if mismatch_indices.size > 0:

            anomalies.append({
                "row_number": row_idx + 1,
                "mismatch_count": mismatch_indices.size,
                "mismatch_indices": mismatch_indices.tolist(),
                "expected_values": EXPECTED_PATTERN[mismatch_indices].tolist(),
                "observed_values": row[mismatch_indices].tolist(),
                "row_data": row.copy()
            })

    # -----------------------------
    # Write anomalies
    # -----------------------------
    if anomalies:
        with open("pattern_anomalies.txt", "w") as f:

            for entry in anomalies:

                f.write(f"Row {entry['row_number']}:\n")
                f.write(f"Data: {' '.join(map(str, entry['row_data']))}\n")

                f.write(
                    f"Problem: {entry['mismatch_count']} mismatches "
                    f"at indices {entry['mismatch_indices']}\n"
                )

                for i, idx in enumerate(entry["mismatch_indices"]):
                    f.write(
                        f"  Index {idx}: expected {entry['expected_values'][i]}, "
                        f"observed {entry['observed_values'][i]}\n"
                    )

                f.write("-" * 80 + "\n")

        print(f"[INFO] {len(anomalies)} anomalous rows found. See pattern_anomalies.txt")

    else:
        print("[INFO] No anomalies detected.")

    anomaly_count = len(anomalies)
    success_rows = num_rows - anomaly_count
    success_rate = (success_rows / num_rows) * 100 if num_rows > 0 else 0

    print(f"Total rows      : {num_rows}")
    print(f"Valid rows      : {success_rows}")
    print(f"Anomalous rows  : {anomaly_count}")
    print(f"Success rate    : {success_rate:.4f}%")

    return success_rate



def analyze_counter_pattern(file_path):

    with open(file_path, "r") as f:
        data = f.read().split()

    buffer = np.array([int(x) for x in data], dtype=np.int32)

    block_size = 32
    num_rows = buffer.size // block_size

    anomalies = []

    expected_k = 0
    repeat_toggle = 0  # each pattern appears twice

    for row_idx in range(num_rows):

        start = row_idx * block_size
        row = buffer[start:start + block_size]

        if row.size < block_size:
            continue

        # -----------------------------
        # Skip header row (all 175)
        # -----------------------------
        if np.all(row == 175) and expected_k == 0:
            repeat_toggle += 1
            continue

        # -----------------------------
        # Build expected row
        # -----------------------------
        expected_row = np.full(32, expected_k, dtype=np.int32)
        expected_row[0] = expected_k + 1
        expected_row[16] = expected_k + 1

        # -----------------------------
        # Compare
        # -----------------------------
        mismatch_mask = row != expected_row
        mismatch_indices = np.where(mismatch_mask)[0]

        if mismatch_indices.size > 0:
            anomalies.append({
                "row_number": row_idx + 1,
                "expected_k": expected_k,
                "mismatch_count": mismatch_indices.size,
                "mismatch_indices": mismatch_indices.tolist(),
                "expected_values": expected_row[mismatch_indices].tolist(),
                "observed_values": row[mismatch_indices].tolist(),
                "row_data": row.copy()
            })

        # -----------------------------
        # Check duplicate row consistency
        # -----------------------------
        if row_idx % 2 == 1:
            prev_row = buffer[(row_idx - 1)*32 : row_idx*32]
            if not np.array_equal(row, prev_row):
                print(f"[WARNING] Row {row_idx+1} is not identical to previous row")

        # -----------------------------
        # Update pattern state
        # -----------------------------
        repeat_toggle += 1

        if repeat_toggle == 2:
            repeat_toggle = 0
            if expected_k >= 126:
                expected_k = 0
            else:
                expected_k += 2

    # -----------------------------
    # Write anomalies
    # -----------------------------
    if anomalies:
        with open("counter_pattern_anomalies.txt", "w") as f:

            for entry in anomalies:
                f.write(f"Row {entry['row_number']} (k={entry['expected_k']}):\n")
                f.write(f"Data: {' '.join(map(str, entry['row_data']))}\n")

                f.write(
                    f"Problem: {entry['mismatch_count']} mismatches "
                    f"at indices {entry['mismatch_indices']}\n"
                )

                for i, idx in enumerate(entry["mismatch_indices"]):
                    f.write(
                        f"  Index {idx}: expected {entry['expected_values'][i]}, "
                        f"observed {entry['observed_values'][i]}\n"
                    )

                f.write("-" * 80 + "\n")

        print(f"[INFO] {len(anomalies)} anomalous rows found. See counter_pattern_anomalies.txt")

    else:
        print("[INFO] No anomalies detected.")

    anomaly_count = len(anomalies)
    success_rows = num_rows - anomaly_count
    success_rate = (success_rows / num_rows) * 100 if num_rows > 0 else 0

    print(f"Total rows      : {num_rows}")
    print(f"Valid rows      : {success_rows}")
    print(f"Anomalous rows  : {anomaly_count}")
    print(f"Success rate    : {success_rate:.4f}%")

    return success_rate

def plot_channels_segment(file_path, start_row=8200, end_row=8400):
    # -----------------------------
    # Load file
    # -----------------------------
    with open(file_path, "r") as f:
        data = f.read().split()

    buffer = np.array([int(x) for x in data], dtype=np.int16)

    # -----------------------------
    # Align on channel 0 (LSB = 1)
    # -----------------------------
    lsb = buffer & 0x0001
    start_candidates = np.where(lsb == 1)[0]

    if start_candidates.size == 0:
        raise ValueError("No channel 0 marker (LSB=1) found")

    align_idx = start_candidates[0]
    buffer = buffer[align_idx:]

    # -----------------------------
    # Reshape into rows of 16
    # -----------------------------
    block_size = 16
    num_rows = buffer.size // block_size
    rows = buffer[:num_rows * block_size].reshape(num_rows, block_size)

    # -----------------------------
    # Extract requested segment
    # -----------------------------
    segment = rows[start_row:end_row]

    # -----------------------------
    # Plot channels
    # -----------------------------
    plt.figure(figsize=(12, 8))

    for ch in range(16):
        plt.plot(segment[:, ch], label=f"CH{ch}")

    plt.title(f"Channels 0–15 | Rows {start_row}–{end_row}")
    plt.xlabel("Row Index")
    plt.ylabel("Value")
    plt.legend(ncol=4)
    plt.grid(True)

    plt.show()


def analyze_constant_row_format(file_path):

    import numpy as np

    with open(file_path, "r") as f:
        lines = f.readlines()

    anomalies = []
    row_index = 0

    for line in lines:

        line = line.strip()

        if line == "":
            continue

        row_index += 1

        values = np.array([int(x) for x in line.split()], dtype=np.int16)

        # -------------------------
        # Check row size
        # -------------------------
        if values.size != 32:
            anomalies.append({
                "row": row_index,
                "problem": "Row does not contain 32 values",
                "data": values
            })
            continue

        # -------------------------
        # Check constant value
        # -------------------------
        if not np.all(values == values[0]):

            mismatch_idx = np.where(values != values[0])[0]

            anomalies.append({
                "row": row_index,
                "problem": "Row values are not constant",
                "mismatch_indices": mismatch_idx.tolist(),
                "data": values
            })
            continue

        # -------------------------
        # Check LSB rule
        # -------------------------
        row_lsb = values & 1
        first_lsb = row_lsb[0]

        if not np.all(row_lsb == first_lsb):

            mismatch_idx = np.where(row_lsb != first_lsb)[0]

            anomalies.append({
                "row": row_index,
                "problem": "LSB mismatch inside row",
                "mismatch_indices": mismatch_idx.tolist(),
                "data": values
            })

    # -------------------------
    # Write anomalies
    # -------------------------
    if anomalies:

        with open("format_anomalies.txt", "w") as f:

            for entry in anomalies:

                f.write(f"Row {entry['row']}:\n")
                f.write(f"Data: {' '.join(map(str, entry['data']))}\n")
                f.write(f"Problem: {entry['problem']}\n")

                if "mismatch_indices" in entry:
                    f.write(f"Mismatching indices: {entry['mismatch_indices']}\n")

                f.write("-" * 80 + "\n")

        print(f"[INFO] {len(anomalies)} anomalies detected. See format_anomalies.txt")

    else:
        print("[INFO] No anomalies detected.")

    return anomalies

def log_only_1_channel(file_path):
    import re

    target_column = 3  # 0-based index

    with open("raw_data.txt", "r") as infile, open("filtered_column.txt", "w") as outfile:
        for line in infile:
            line = line.strip()

            if not line:
                continue  # skip empty lines

            # Split on commas OR any whitespace
            columns = re.split(r'[,\s]+', line)

            if len(columns) > target_column:
                outfile.write(columns[target_column] + "\n")

def mark_anomalies_in_file(filename, threshold_factor=5):
    # Load data
    data = np.loadtxt(filename)

    # Compute derivative
    diff = np.diff(data)

    # Detect anomalies
    threshold = threshold_factor * np.std(diff)
    bad_indices = np.where(np.abs(diff) > threshold)[0]

    # IMPORTANT:
    # diff[i] corresponds to jump between data[i] and data[i+1]
    # So we mark i+1 as corrupted
    bad_points = set(bad_indices + 1)

    # Read original lines (to preserve formatting if needed)
    with open(filename, "r") as f:
        lines = f.readlines()

    # Rewrite file with annotations
    with open(filename, "w") as f:
        for i, line in enumerate(lines):
            value = line.strip()

            if i in bad_points:
                f.write(f"{value}  <-- ANOMALY\n")
            else:
                f.write(f"{value}\n")

    print(f"Found {len(bad_points)} anomalies.")
def check_uniform_rows(file_path):
    with open(file_path, 'r') as f:
        for line_number, line in enumerate(f, start=1):
            # Remove leading/trailing spaces and skip empty lines
            line = line.strip()
            if not line:
                continue

            # Convert row into a list of integers
            values = list(map(int, line.split()))

            # Check if row has exactly 16 values
            if len(values) != 16:
                print(f"Line {line_number}: skipped (not 16 values)")
                continue

            # Check if all values are the same
            if all(v == values[0] for v in values):
                print(f"Line {line_number}: ALL VALUES SAME -> {values[0]}")

if __name__ == "__main__":
    tcp_receive(port=10001)
    check_uniform_rows("raw_data.txt")
    # analyze_counter_pattern("raw_data.txt")
    # analyze_full_buffer_counter_source("raw_data.txt")
    # analyze_full_buffer_single_mode("raw_data.txt")
    # analyze_full_buffer_dual_mode("raw_data.txt")
    # analyze_constant_row_format("raw_data.txt")
    # log_only_1_channel("raw_data.txt")
    # plot_channels_segment("raw_data.txt", 0, 8400)
    # mark_anomalies_in_file("filtered_column.txt")