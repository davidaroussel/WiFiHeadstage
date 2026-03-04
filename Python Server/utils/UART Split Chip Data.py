import serial
import time
import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

# =============================
# CONFIG
# =============================
SERIAL_PORT = "COM3"
SERIAL_BAUD = 921600

NUM_CHANNELS = 16
BLOCK_SIZE = 32
capture_duration = 2

OpenEphysOffset = 32768
maxOpenEphysValue = 0.005
scale = (0.000000195 / maxOpenEphysValue) * OpenEphysOffset

LOG_FILE = "raw_uart_capture.txt"


# ============================================================
def log_capture_strict(raw_blocks, valid_mask):
    """
    Logs rows exactly as received.
    Marks anomalies explicitly.
    """

    with open(LOG_FILE, "a") as f:
        f.write("\n================ NEW CAPTURE ================\n")

        for i, row in enumerate(raw_blocks):
            row_lsb = row & 0x0001
            first_lsb = row_lsb[0]
            expected_type = "EMG" if first_lsb == 1 else "NEURO"

            if valid_mask[i]:
                status = f"VALID {expected_type}"
            else:
                mismatches = np.where(row_lsb != first_lsb)[0].tolist()
                status = f"ANOMALY mismatches at {mismatches}"

            line = " ".join(map(str, row))
            f.write(f"{line}    <-- {status}\n")

    print(f"[INFO] Logged {len(raw_blocks)} rows to {LOG_FILE}")


# ============================================================
def uart_receive_strict():

    ser = serial.Serial(SERIAL_PORT, SERIAL_BAUD, timeout=0.01)
    print(f"[INFO] UART opened on {SERIAL_PORT}")

    byte_buffer = bytearray()
    capture_buffer = bytearray()

    capture_active = False
    start_time = None

    try:
        while True:

            # =============================
            # READ SERIAL
            # =============================
            data = ser.read(ser.in_waiting or 1)
            if data:
                byte_buffer.extend(data)

            # =============================
            # Start capture immediately
            # =============================
            if not capture_active and len(byte_buffer) > 0:
                capture_active = True
                start_time = time.time()
                capture_buffer.clear()
                print("[INFO] Capture started")

            # =============================
            # Collect for duration
            # =============================
            if capture_active:
                capture_buffer.extend(byte_buffer)
                byte_buffer.clear()

                if time.time() - start_time >= capture_duration:

                    print("[INFO] Processing capture...")

                    usable_bytes = (len(capture_buffer) // 2) * 2

                    if usable_bytes == 0:
                        print("[WARNING] No complete samples")
                        capture_active = False
                        capture_buffer.clear()
                        continue

                    raw = np.frombuffer(capture_buffer[:usable_bytes], dtype='>i2')

                    num_rows = raw.size // BLOCK_SIZE
                    raw_blocks = raw[:num_rows * BLOCK_SIZE].reshape(num_rows, BLOCK_SIZE)

                    # STRICT VALIDATION (identical to TCP)
                    row_lsb = raw_blocks & 0x0001
                    first_lsb = row_lsb[:, 0][:, None]
                    valid_mask = np.all(row_lsb == first_lsb, axis=1)

                    deleted_indices = np.where(~valid_mask)[0]
                    print(f"[INFO] Deleted rows: {len(deleted_indices)}")

                    # ---- LOG STRICTLY ----
                    log_capture_strict(raw_blocks, valid_mask)

                    # ---- SPLIT ----
                    emg_mask = valid_mask & (first_lsb.flatten() == 1)
                    neuro_mask = valid_mask & (first_lsb.flatten() == 0)

                    raw_emg_data = raw_blocks[emg_mask].flatten()
                    raw_neuro_data = raw_blocks[neuro_mask].flatten()

                    # =============================
                    # PROCESS CHIP
                    # =============================
                    def process_chip(data):
                        usable = (data.size // NUM_CHANNELS) * NUM_CHANNELS
                        data = data[:usable]
                        reshaped = data.reshape(-1, NUM_CHANNELS).T
                        clipped = np.clip(reshaped, -32768, 32768)
                        converted = (clipped * scale + OpenEphysOffset).astype(np.uint16)
                        return converted

                    raw_emg_processed = process_chip(raw_emg_data)
                    raw_neuro_processed = process_chip(raw_neuro_data)

                    # =============================
                    # PLOT (IDENTICAL)
                    # =============================
                    fig, axes = plt.subplots(16, 2, figsize=(18, 20), sharex=False)
                    fig.suptitle("UART STRICT: Raw vs Valid (LSB rule)", fontsize=16)

                    for ch in range(16):

                        re = raw_emg_processed[ch][len(raw_emg_processed[ch]) // 2:]
                        rn = raw_neuro_processed[ch][len(raw_neuro_processed[ch]) // 2:]

                        axes[ch, 0].plot(re, color='tab:blue', alpha=0.7)
                        axes[ch, 0].set_ylabel(f"E Ch {ch}")
                        axes[ch, 0].set_yticks([])

                        axes[ch, 1].plot(rn, color='tab:blue', alpha=0.7)
                        axes[ch, 1].set_ylabel(f"N Ch {ch}")
                        axes[ch, 1].set_yticks([])

                    axes[-1, 0].set_xlabel("Sample Index")
                    axes[-1, 1].set_xlabel("Sample Index")

                    plt.tight_layout()
                    plt.show()

                    capture_active = False
                    capture_buffer.clear()
                    print("[INFO] Capture reset")

    except KeyboardInterrupt:
        print("Stopped")

    finally:
        ser.close()
        print("Serial closed")


# ============================================================
if __name__ == "__main__":
    uart_receive_strict()