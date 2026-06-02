#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <linux/ioctl.h>
#include <linux/types.h>
#include <linux/spi/spidev.h>
#include <gpiod.h>

#define SPI_DEVICE          "/dev/spidev1.0"
#define SPI_SPEED           25000000  // 25 MHz SPI Speed
#define SPI_MODE            SPI_MODE_0  // SPI Mode 0
#define GPIO_CHIP_NAME      "gpiochip0"  // GPIO chip
#define GPIO_CS_PIN         16  // GPIO 16 for CS (Pin 36)
#define GPIO_TOGGLE_PIN     12  // GPIO 12 to toggle (Pin 32)

uint8_t tx_buffer[16];
uint8_t rx_buffer[16];
uint32_t len_data = 16;
int fd;
int ret;
struct spi_ioc_transfer trx;
struct gpiod_chip *chip;
struct gpiod_line *cs_line;  // CS (Chip Select) line
struct gpiod_line *toggle_line;  // Line for toggling GPIO 12

// Function to set the SPI settings
int setup_spi(int fd) {
    uint8_t mode = SPI_MODE_0;  // SPI Mode: Clock Polarity (CPOL) = 0, Clock Phase (CPHA) = 0
    uint8_t bits = 8; 
    uint32_t speed = SPI_SPEED;  // Clock speed in Hz
    uint16_t delay = 0;  // No delay

    // Set SPI mode
    if (ioctl(fd, SPI_IOC_WR_MODE, &mode) == -1) {
        perror("Error setting SPI mode");
        return -1;
    }

    // Set bits per word to 8
    if (ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &bits) == -1) {
        perror("Error setting bits per word");
        return -1;
    }

    // Set max speed
    if (ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed) == -1) {
        perror("Error setting max speed");
        return -1;
    }

    // Set the delay between transactions
    if (ioctl(fd, SPI_IOC_WR_LSB_FIRST, &delay) == -1) {
        perror("Error setting delay");
        return -1;
    }

    return 0;
}

// Function to initialize GPIO for CS and Toggle
int init_gpio(struct gpiod_chip **chip, struct gpiod_line **cs_line, struct gpiod_line **toggle_line, int fd) {
    // Open the GPIO chip
    *chip = gpiod_chip_open_by_name(GPIO_CHIP_NAME);
    if (!*chip) {
        perror("Failed to open GPIO chip");
        close(fd);
        return 1;
    }

    // Get the CS pin (GPIO 16)
    *cs_line = gpiod_chip_get_line(*chip, GPIO_CS_PIN);
    if (!*cs_line) {
        perror("Failed to get GPIO line for CS");
        gpiod_chip_close(*chip);
        close(fd);
        return 1;
    }

    // Get the Toggle pin (GPIO 12)
    *toggle_line = gpiod_chip_get_line(*chip, GPIO_TOGGLE_PIN);
    if (!*toggle_line) {
        perror("Failed to get GPIO line for Toggle");
        gpiod_chip_close(*chip);
        close(fd);
        return 1;
    }

    // Configure the CS pin as an output and set its default state to high (deselect chip)
    ret = gpiod_line_request_output(*cs_line, "SPI_CS", 1);
    if (ret < 0) {
        perror("Failed to configure CS pin");
        gpiod_chip_close(*chip);
        close(fd);
        return 1;
    }

    // Configure the Toggle pin as an output
    ret = gpiod_line_request_output(*toggle_line, "GPIO_TOGGLE", 1);
    if (ret < 0) {
        perror("Failed to configure Toggle pin");
        gpiod_chip_close(*chip);
        close(fd);
        return 1;
    }

    // Initially set CS high (deselect chip) and toggle pin low
    gpiod_line_set_value(*cs_line, 1);
    gpiod_line_set_value(*toggle_line, 0); // Start with GPIO 12 LOW

    return 0;
}


// Function to send SPI commands (16-bit)
void send_spi_command(uint16_t command) {
    tx_buffer[0] = (command >> 8) & 0xFF;  // High byte
    tx_buffer[1] = command & 0xFF;         // Low byte

    // Pull CS low (activate chip select)
    gpiod_line_set_value(cs_line, 0);

    // Set up the SPI transaction structure
    trx.tx_buf = (unsigned long)tx_buffer;  // Pointer to the transmit buffer
    trx.rx_buf = (unsigned long)rx_buffer;  // Pointer to the receive buffer
    trx.bits_per_word = 8;                  // 8 bits per word
    trx.speed_hz = SPI_SPEED;               // Set the SPI speed
    trx.len = 2;                            // Length of data in bytes (2 bytes for 16-bit word)

    // Execute the SPI transfer
    ret = ioctl(fd, SPI_IOC_MESSAGE(1), &trx);
    if (ret == -1) {
        perror("SPI transfer failed");
        close(fd);
        exit(EXIT_FAILURE);
    }

    // Pull CS high (deactivate chip select)
    gpiod_line_set_value(cs_line, 1);

    // Print the sent command and the received data
    printf("Sent command: 0x%04x, Received: 0x%02x%02x\n", command, rx_buffer[0], rx_buffer[1]);
}

int main(void) {
    // Open SPI device
    fd = open(SPI_DEVICE, O_RDWR);
    if (fd < 0) {
        perror("Error opening SPI device");
        return 1;
    }

    // Set up the SPI communication parameters
    if (setup_spi(fd) < 0) {
        close(fd);
        return 1;
    }

    // Initialize GPIO for CS (Chip Select) and Toggle GPIO 12
    ret = init_gpio(&chip, &cs_line, &toggle_line, fd);
    if (ret != 0) {
        perror("Error initializing GPIO");
        return 1;  
    }

    gpiod_line_set_value(toggle_line, 1);

    // Commands to send (16-bit values)
    uint16_t commands[] = {
        0b1110100000000000,
        0b1110100100000000,
        0b1110101000000000,
        0b1110101100000000,
        0b1110110000000000
    };

    // Send each command via SPI
    for (int i = 0; i < 5; i++) {
        send_spi_command(commands[i]);
    }

    // Close the GPIO line and chip
    gpiod_chip_close(chip);

    // Close the SPI device
    close(fd);

    return 0;
}