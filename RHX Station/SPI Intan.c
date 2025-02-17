#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/spi/spidev.h>
#include <sys/ioctl.h>
#include <string.h>

#define SPI_DEVICE "/dev/spidev0.0"  // Adjust if using SPI1, e.g., "/dev/spidev1.0"
#define SPI_SPEED  5000000           // Set to max speed supported by your device
#define SPI_MODE   SPI_MODE_0        // SPI Mode (0,1,2,3)
#define BITS_PER_WORD 8              // Default bits per word

int main() {
    int spi_fd;
    uint8_t tx_buf[] = {0xAA, 0xBB, 0xCC};  // Example data to send
    uint8_t rx_buf[sizeof(tx_buf)] = {0};  // Buffer to store received data

    struct spi_ioc_transfer spi_trans = {
        .tx_buf = (unsigned long)tx_buf,
        .rx_buf = (unsigned long)rx_buf,
        .len = sizeof(tx_buf),
        .speed_hz = SPI_SPEED,
        .delay_usecs = 0,  // 🚀 Reduce CS delay to zero
        .bits_per_word = BITS_PER_WORD,
        .cs_change = 0      // Keep CS asserted between messages
    };

    // Open SPI device
    spi_fd = open(SPI_DEVICE, O_RDWR);
    if (spi_fd < 0) {
        perror("Failed to open SPI device");
        return EXIT_FAILURE;
    }

    // Configure SPI settings
    ioctl(spi_fd, SPI_IOC_WR_MODE, &SPI_MODE);
    ioctl(spi_fd, SPI_IOC_WR_BITS_PER_WORD, &BITS_PER_WORD);
    ioctl(spi_fd, SPI_IOC_WR_MAX_SPEED_HZ, &SPI_SPEED);

    // Perform SPI transaction
    if (ioctl(spi_fd, SPI_IOC_MESSAGE(1), &spi_trans) < 0) {
        perror("SPI transfer failed");
        close(spi_fd);
        return EXIT_FAILURE;
    }

    printf("Received data: ");
    for (size_t i = 0; i < sizeof(rx_buf); i++) {
        printf("%02X ", rx_buf[i]);
    }
    printf("\n");

    close(spi_fd);
    return EXIT_SUCCESS;
}