import spidev
import RPi.GPIO as GPIO
import time

# GPIO Pins configuration
MOSI = 20
MISO = 19
SCLK = 21
CS = 7
CONTROL_GPIO = 12

# Initialize GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(CS, GPIO.OUT, initial=GPIO.HIGH)
GPIO.setup(CONTROL_GPIO, GPIO.OUT, initial=GPIO.LOW)

# Initialize SPI
spi = spidev.SpiDev()
spi.open(1, 0)  # SPI bus 1, device 0
spi.max_speed_hz = 1000000  # 1 MHz
spi.mode = 0b01  # SPI mode 1

def read_write_to_intan_chip(command, chip_id):
    """
    Sends a command to the Intan chip and reads the response.
    """
    GPIO.output(CS, GPIO.LOW)
    response = spi.xfer2([command >> 8, command & 0xFF])
    GPIO.output(CS, GPIO.HIGH)
    return response

def read_intan_characters_for_test(chip_id):
    """
    Reads Intan chip characters for testing.
    """
    intan_characters = []
    commands = [0b11101000, 0b11101001, 0b11101010, 0b11101011, 0b11101100]
    for command in commands:
        data = read_write_to_intan_chip(command, chip_id)
        intan_characters.append(data[1])
    return intan_characters

def configure_intan_chip(high_freq_no, low_freq_no, chip_id):
    """
    Configures the Intan chip with provided frequency parameters.
    """
    upper_cutoff_parameters = [
        [8, 0, 4, 0], [11, 0, 8, 0], [17, 0, 16, 0],
        [22, 0, 23, 0], [33, 0, 37, 0], [3, 1, 13, 1],
        [13, 1, 25, 1], [27, 1, 44, 1], [1, 2, 23, 2],
        [46, 2, 30, 3], [41, 3, 36, 4], [30, 5, 43, 6],
        [6, 9, 2, 11], [42, 10, 5, 13], [24, 13, 7, 16],
        [44, 17, 8, 21], [38, 26, 5, 31]
    ]

    lower_cutoff_parameters = [
        [13, 0], [15, 0], [17, 0], [18, 0], [21, 0], [25, 0],
        [28, 0], [34, 0], [44, 0], [48, 0], [54, 0], [62, 0],
        [5, 1], [18, 1], [40, 1], [20, 2], [42, 2], [8, 3],
        [9, 4], [44, 6], [49, 9], [35, 17], [1, 40], [56, 54]
    ]

    dummy_command = 0
    read_write_to_intan_chip(dummy_command, chip_id)  # Dummy
    read_write_to_intan_chip(dummy_command, chip_id)  # Dummy

    config_commands = [
        0b1000000011011110,  # Register 0
        0b1000000100110010,  # Register 1
        0b1000001001000000,  # Register 2
        0b1000001100000010,  # Register 3
        0b1000010001011101,  # Register 4
        0b1000010100000000,  # Register 5
        0b1000011000000000,  # Register 6
        0b1000011100000000   # Register 7
    ]

    for command in config_commands:
        read_write_to_intan_chip(command, chip_id)

    # Set upper cutoff parameters
    for i in range(4):
        command = 0b1000100000000000 | upper_cutoff_parameters[high_freq_no][i]
        read_write_to_intan_chip(command, chip_id)

    # Set lower cutoff parameters
    for i in range(2):
        command = 0b1000110000000000 | lower_cutoff_parameters[low_freq_no][i]
        read_write_to_intan_chip(command, chip_id)

    # Activate only used amplifiers and perform calibration sequence
    calibration_commands = [
        0b1000111011111111, 0b1000111111111111,
        0b1001000011111111, 0b1001000111111111,
        0b0101010100000000
    ]

    for command in calibration_commands:
        read_write_to_intan_chip(command, chip_id)

    for _ in range(9):
        read_write_to_intan_chip(0b1110100000000000, chip_id)  # Dummy for calibration sequence

def sample_intan_channels(data_out, channels, count, chip_id):
    """
    Samples Intan channels and stores the data.
    """
    for i in range(count):
        command = channels[i] if i < count - 2 else 0
        response = read_write_to_intan_chip(command, chip_id)
        data_out.append(response)

# Clean up on exit
def cleanup():
    spi.close()
    GPIO.cleanup()

# Example usage
try:
    chip_id = 0  # Example chip ID
    configure_intan_chip(3, 5, chip_id)  # Configure with example frequency params
    intan_characters = read_intan_characters_for_test(chip_id)
    print("Intan Characters:", intan_characters)
finally:
    cleanup()
