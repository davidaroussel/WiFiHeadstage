import serial
import socket
import numpy as np

# ================= CONFIG =================
SERIAL_PORT = "COM3"
SERIAL_BAUD = 921600
SYNC_MARKER = b'AA55'   # try b'\x55\xAA' if needed
FRAME_BYTES = 8192

numChannels = 16
numSamples = 500
elementSize = 2
dataType = 2
# ========================================

# ---- HEADER ---- #
offset = 0
bytesPerBuffer = numChannels * numSamples * elementSize

header = np.array([offset, bytesPerBuffer], dtype='i4').tobytes() + \
         np.array([dataType], dtype='i2').tobytes() + \
         np.array([elementSize, numChannels, numSamples], dtype='i4').tobytes()

# ---- OPEN SERIAL ---- #
ser = serial.Serial(SERIAL_PORT, SERIAL_BAUD, timeout=0.01)
print("Serial opened")

# ---- TCP SERVER ---- #
tcpServer = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcpServer.bind(("localhost", 10001))
tcpServer.listen(5)

print("Waiting for Open Ephys connection...")
(tcpClient, address) = tcpServer.accept()
print("Connected:", address)

# ---- BUFFERS ---- #
serial_buffer = bytearray()
stream_buffer = np.array([], dtype=np.uint16)

print("Streaming real FPGA data to Open Ephys (NO TIMING)...")

try:
    while True:
        # ===== READ SERIAL =====
        data = ser.read(ser.in_waiting)
        if data:
            serial_buffer += data

        # ===== FIND FRAMES =====
        while True:
            idx = serial_buffer.find(SYNC_MARKER)
            if idx == -1:
                break

            start = idx + 2
            end = start + FRAME_BYTES
            if len(serial_buffer) < end:
                break

            frame = serial_buffer[start:end]
            serial_buffer = serial_buffer[end:]

            # Convert to uint16 (adjust endian if needed)
            samples = np.frombuffer(frame, dtype='<u2')  # little-endian uint16
            stream_buffer = np.concatenate((stream_buffer, samples))

        # ===== SEND WHEN ENOUGH DATA =====
        required = numSamples * numChannels
        while len(stream_buffer) >= required:
            packet = stream_buffer[:required]
            stream_buffer = stream_buffer[required:]

            tcpClient.sendall(header + packet.tobytes())
            print(f"Sent TCP packet: {len(packet)} samples")

except KeyboardInterrupt:
    print("Stopped")

finally:
    ser.close()
    tcpClient.close()
    tcpServer.close()
    print("Closed")
