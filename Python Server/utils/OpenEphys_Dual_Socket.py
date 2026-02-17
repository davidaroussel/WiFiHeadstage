import socket
import time
import threading
import numpy as np

# ---- SPECIFY THE SIGNAL PROPERTIES ---- #
totalDuration = 100
numChannels = 16
numSamples = 8192

Freq_Neuro = 25000
Freq_EMG = 15000

testingValue1 = 5000
testingValue2 = -5000

# ---- DEFINE HEADER VALUES ---- #
headerSize = 22
offset = 0
dataType = 2          # U16
elementSize = 2       # bytes per element

# ---------------------------------------------------------
# Utility
# ---------------------------------------------------------

def currentTime():
    return time.time_ns() / 1e9


def build_header(bytesPerBuffer):
    return (
        np.array([offset, bytesPerBuffer], dtype='i4').tobytes()
        + np.array([dataType], dtype='i2').tobytes()
        + np.array([elementSize, numChannels, numSamples], dtype='i4').tobytes()
    )


def generate_data(freq):
    OpenEphysOffset = 32768
    convertedValue1 = OpenEphysOffset + testingValue1
    convertedValue2 = OpenEphysOffset + testingValue2

    intList_1 = (np.ones((int(freq / 2),)) * convertedValue1).astype('uint16')
    intList_2 = (np.ones((int(freq / 2),)) * convertedValue2).astype('uint16')

    oneCycle = np.concatenate((intList_1, intList_2))
    allData = np.tile(oneCycle, (numChannels, totalDuration)).T

    return allData.flatten().tobytes()


# ---------------------------------------------------------
# Streaming Thread
# ---------------------------------------------------------

def stream_data(port, freq, label):

    bytesPerBuffer = numChannels * numSamples * elementSize
    header = build_header(bytesPerBuffer)

    buffersPerSecond = freq / numSamples
    bufferInterval = 1 / buffersPerSecond

    bytesToSend = generate_data(freq)
    totalBytes = len(bytesToSend)
    bufferIndex = 0

    tcpServer = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    tcpServer.bind(('localhost', port))
    tcpServer.listen(1)

    print(f"[{label}] Waiting for connection on port {port}...")
    tcpClient, address = tcpServer.accept()
    print(f"[{label}] Connected.")

    try:
        while bufferIndex < totalBytes:

            t1 = currentTime()

            tcpClient.sendall(
                header +
                bytesToSend[bufferIndex:bufferIndex + bytesPerBuffer]
            )

            t2 = currentTime()

            while (t2 - t1) < bufferInterval:
                t2 = currentTime()

            bufferIndex += bytesPerBuffer

        print(f"[{label}] Done streaming.")

    except Exception as e:
        print(f"[{label}] Connection error:", e)

    finally:
        tcpClient.close()
        tcpServer.close()


# ---------------------------------------------------------
# START BOTH STREAMS
# ---------------------------------------------------------

if __name__ == "__main__":

    neuro_thread = threading.Thread(
        target=stream_data,
        args=(10003, Freq_Neuro, "NEURO")
    )

    emg_thread = threading.Thread(
        target=stream_data,
        args=(10005, Freq_EMG, "EMG")
    )

    neuro_thread.start()
    emg_thread.start()

    neuro_thread.join()
    emg_thread.join()
