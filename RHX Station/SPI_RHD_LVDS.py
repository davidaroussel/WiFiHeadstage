import spidev
import RPi.GPIO as GPIO
import time

# GPIO Pins configuration
MOSI = 20
MISO = 19
SCLK = 21
CS = 16
CONTROL_GPIO = 12

# Disable GPIO warnings
GPIO.setwarnings(False)

# Initialize GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(CS, GPIO.OUT, initial=GPIO.HIGH)
GPIO.setup(CONTROL_GPIO, GPIO.OUT, initial=GPIO.LOW)

# Initialize SPI
spi = spidev.SpiDev()

try:
    spi.open(1, 0)  # SPI bus 1, device 0
    spi.max_speed_hz = 2500000  # 1 MHz
    spi.mode = 0b0  # SPI mode 1
except FileNotFoundError:
    print("Error: Could not open SPI device. Make sure SPI is enabled on your Raspberry Pi.")


def read_write_to_intan_chip(command, chip_id):
    """
    Sends a command to the Intan chip and reads the response.
    """
    GPIO.output(CS, GPIO.LOW)
    response = spi.xfer2([command >> 8, command & 0xFF])
    #     bin_value = [bin(num) for num in response]
    # print(f"Commande : {command:016b}, Response: {response} - {bin_value}")
    GPIO.output(CS, GPIO.HIGH)
    return response


def read_intan_characters_for_test(chip_id, bit_shifting):
    intan_characters = []
    commands = [0b1110100000000000, 0b1110100100000000, 0b1110101000000000, 0b1110101100000000, 0b1110110000000000]
    for command in commands:
        data = read_write_to_intan_chip(command, chip_id)
        ascii_data = hex(int(data[1]) << bit_shifting)
        intan_characters.append(ascii_data)

    # Dummy command to retrieve n+2 !!!!!!!!!!!
    command = 0b0000000000000000  # DUMMY BYTES HERE
    data = read_write_to_intan_chip(command, chip_id)
    ascii_data = hex(int(data[1]) << bit_shifting)
    intan_characters.append(ascii_data)
    data = read_write_to_intan_chip(command, chip_id)
    ascii_data = hex(int(data[1]) << bit_shifting)
    intan_characters.append(ascii_data)

    ret_val = intan_characters[2:]  # CROPPING THE ARRAY TO ONLY HAVE THE 2-7 DATA, REMOVE THE 0 AND 1

    return ret_val


def indentify_intan_chip(chip_id):
    rhd_versions = ["RHD2132", "RHD2216", "None", "RHD2164"]
    bit_shifting = None

    # Read Register 59 MISO MARKER
    command = 0b1111101100000000
    read_write_to_intan_chip(command, chip_id)

    # Read Register 63 Dummy Register
    command = 0b1111111100000000
    read_write_to_intan_chip(command, chip_id)
    miso_marker = read_write_to_intan_chip(command, chip_id)
    print(miso_marker)
    ascii_data = hex(miso_marker[1])

    if miso_marker[1] == 0:
        bit_shifting = 0
        print("BIT SHIFTING TO 0 ")
    else:
        big_shifting = 1
        print("BIT SHIFTING TO 1 ")

    Intan_Chip_ID = read_write_to_intan_chip(command, chip_id)
    print("Intan CHIP ID: ", Intan_Chip_ID[1])
    print("Intan CHIP   : ", rhd_versions[Intan_Chip_ID[1] - 1])

    return bit_shifting


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
        0b1000011100000000  # Register 7
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


if __name__ == "__main__":
    chip_id = 0  # Example chip ID (Not Used Right Now)

    command = 0b1111111100000000  # Dummy CMD To Wake Up Chip
    read_write_to_intan_chip(command, chip_id)
    read_write_to_intan_chip(command, chip_id)

    configure_intan_chip(0, 0, chip_id)

    bit_shifting = indentify_intan_chip(chip_id)

    for i in range(1000):
        intan_characters = read_intan_characters_for_test(chip_id, bit_shifting)
        print("Intan Characters:", intan_characters)
        ascii_value = ''.join(chr(int(h, 16)) for h in intan_characters)
        print("ASCII : ", ascii_value)
        time.sleep(2)
