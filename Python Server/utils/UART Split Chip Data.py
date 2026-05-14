import serial
import time
import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import serial.tools.list_ports

# ============================================================
# CONFIG
# ============================================================
SERIAL_PORT = "COM12"      # CHANGE THIS
SERIAL_BAUD = 921600

NUM_CHANNELS = 16
SAMPLE_SIZE_BYTES = 2
BUFFER_SIZE = 8192
CAPTURE_DURATION = 2

RAW_LOG_FILE = "raw_uart_log.txt"

# ============================================================
# LIST PORTS
# ============================================================
def list_ports():

    print("Available COM ports:")

    ports = serial.tools.list_ports.comports()

    for p in ports:
        print(f"{p.device} - {p.description}")

# ============================================================
# RAW LOG
# ============================================================
def save_raw_log(raw_uint16):

    with open(RAW_LOG_FILE, "w") as f:

        for value in raw_uint16:

            # HEX formatting like:
            # F8FF F6FF ...
            f.write(f"{value:04X} ")

    print(f"[INFO] Raw log saved to: {RAW_LOG_FILE}")

# ============================================================
# UART RECEIVE + PLOT
# ============================================================
def uart_receive_and_plot():

    ser = serial.Serial(SERIAL_PORT, SERIAL_BAUD, timeout=0.01)

    print(f"[INFO] UART opened on {SERIAL_PORT}")
    print(f"[INFO] Capturing for {CAPTURE_DURATION} seconds...")

    capture_buffer = bytearray()

    start_time = time.time()

    try:

        # ====================================================
        # CAPTURE LOOP
        # ====================================================
        while time.time() - start_time < CAPTURE_DURATION:

            data = ser.read(ser.in_waiting or 1)

            if data:
                capture_buffer.extend(data)

        print("[INFO] Capture complete")
        print(f"[INFO] Received {len(capture_buffer)} bytes")

    finally:

        ser.close()
        print("[INFO] Serial closed")

    # ========================================================
    # KEEP COMPLETE BLOCKS
    # ========================================================
    usable_bytes = (len(capture_buffer) // BUFFER_SIZE) * BUFFER_SIZE

    if usable_bytes == 0:
        print("[ERROR] No complete 8192-byte blocks received")
        return

    capture_buffer = capture_buffer[:usable_bytes]

    print(f"[INFO] Using {usable_bytes} bytes")

    # ========================================================
    # CONVERT RAW BYTES -> UINT16
    # ========================================================
    raw_data = np.frombuffer(capture_buffer, dtype=np.uint16)

    print(f"[INFO] Total uint16 samples: {len(raw_data)}")

    # ========================================================
    # SAVE RAW LOG
    # ========================================================
    save_raw_log(raw_data)

    # ========================================================
    # RESHAPE INTO CHANNELS
    # ========================================================
    usable_samples = (len(raw_data) // NUM_CHANNELS) * NUM_CHANNELS

    raw_data = raw_data[:usable_samples]

    frames = raw_data.reshape(-1, NUM_CHANNELS)

    # channels first
    channel_data = frames.T

    print(f"[INFO] Samples per channel: {channel_data.shape[1]}")

    # ========================================================
    # CONVERT TO SIGNED
    # ========================================================
    channel_data = channel_data.astype(np.int16)

    # ========================================================
    # PLOT
    # ========================================================
    fig, axes = plt.subplots(
        NUM_CHANNELS,
        1,
        figsize=(18, 24),
        sharex=True
    )

    fig.suptitle("UART Capture - 16 Channels", fontsize=18)

    for ch in range(NUM_CHANNELS):

        axes[ch].plot(channel_data[ch])

        axes[ch].set_ylabel(f"CH {ch}")

        axes[ch].grid(True)

    axes[-1].set_xlabel("Sample Index")

    plt.tight_layout()

    plt.show()

# ============================================================
# MAIN
# ============================================================
if __name__ == "__main__":

    list_ports()

    uart_receive_and_plot()