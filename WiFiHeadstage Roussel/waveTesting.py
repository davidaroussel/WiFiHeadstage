import numpy as np
import matplotlib.pyplot as plt

def generateSinusWave(bufferSize, frequency, sample_rate):
    buffer = np.zeros(bufferSize, dtype=np.int16)
    for i in range(bufferSize):
        t = i / sample_rate
        buffer[i] = int(32767.0 * np.sin(2.0 * np.pi * frequency * t))
    return buffer

# Parameters
sample_rates = [44100, 12000, 200]
frequency = 150  # Adjust as needed
duration = 1.0


# Generate and plot multiple sine waves
for sample_rate in sample_rates:
    bufferSize = int(sample_rate * duration)
    # Create time axis
    t = np.arange(0, duration, 1 / sample_rate)

    waveform = generateSinusWave(bufferSize, frequency, sample_rate)
    plt.plot(t, waveform, label=f'{sample_rate} Sample')

plt.xlabel('Time (s)')
plt.ylabel('Amplitude')
plt.title('Multiple Sine Waves')
plt.legend()
plt.grid(True)
plt.show()
