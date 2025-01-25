#include <stdio.h>
#include <bcm2835.h>

#define SPI_CHANNEL 0          // SPI0 is used for communication (use SPI1 if necessary)
#define SPI_SPEED 500000       // SPI speed in Hz (500kHz is just an example)
#define SPI_MODE BCM2835_SPI_MODE0   // SPI Mode 0 (CPOL = 0, CPHA = 0)
#define MOSI_PIN RPI_GPIO_P1_19    // GPIO 19 for MOSI (can use a different GPIO if needed)
#define MISO_PIN RPI_GPIO_P1_21    // GPIO 21 for MISO (can use a different GPIO if needed)
#define CLK_PIN RPI_GPIO_P1_23     // GPIO 23 for Clock (can use a different GPIO if needed)
#define CS_PIN RPI_GPIO_P1_24      // GPIO 24 for Chip Select (can use a different GPIO if needed)

unsigned char intan_characters[5];

// Dummy function for Write_To_Intan_Chip (to replace actual implementation)
void Write_To_Intan_Chip(unsigned char *data, int p_id) {
    // SPI write functionality
    bcm2835_spi_transfern((char*)data, 4); // Writing 4 bytes at a time
}

void ReadWrite_To_Intan_Chip(char *data_r, unsigned char command, int p_id) {
    char data[4] = {command, 0, 0, 0}; // Example SPI command
    Write_To_Intan_Chip(data, p_id);
    // Read the response (assuming 4 bytes)
    bcm2835_spi_transfern((char*)data, 4);
    for (int i = 0; i < 4; i++) {
        data_r[i] = data[i];
    }
}

char* readIntanCharactersforTest(int p_id) {
    char data_r[4] = {0, 0, 0, 0};

    ReadWrite_To_Intan_Chip(data_r, 0b11101000, p_id);
    ReadWrite_To_Intan_Chip(data_r, 0b11101001, p_id);
    ReadWrite_To_Intan_Chip(data_r, 0b11101010, p_id);
    intan_characters[0] = data_r[1];

    ReadWrite_To_Intan_Chip(data_r, 0b11101011, p_id);
    intan_characters[1] = data_r[1];

    ReadWrite_To_Intan_Chip(data_r, 0b11101100, p_id);
    intan_characters[2] = data_r[1];

    ReadWrite_To_Intan_Chip(data_r, 0b11101100, p_id);
    intan_characters[3] = data_r[1];

    ReadWrite_To_Intan_Chip(data_r, 0b11101100, p_id);
    intan_characters[4] = data_r[1];

    return intan_characters;
}

int main() {
    // Initialize BCM2835 library
    if (!bcm2835_init()) {
        printf("BCM2835 initialization failed.\n");
        return -1;
    }

    // Set up SPI
    bcm2835_spi_set_clock_speed(SPI_SPEED);  // Set SPI speed (500kHz)
    bcm2835_spi_set_data_mode(SPI_MODE);     // Set SPI mode (Mode 0)
    bcm2835_spi_set_bit_order(BCM2835_SPI_BIT_ORDER_MSBFIRST); // Most Significant Bit first
    bcm2835_spi_chipSelect(BCM2835_SPI_CS0); // Chip Select (you can use SPI_CS1, SPI_CS2, or SPI_CS3)
    bcm2835_spi_set_bits_per_word(8);        // Set the bits per word (8 bits per byte)

    // Test read from Intan chip
    unsigned char p_high_freq_no = 1;
    unsigned char p_low_freq_no = 5;
    int p_id = 0;  // Example chip ID

    // Test read from Intan chip
    char* result = readIntanCharactersforTest(p_id);
    printf("Received data: %s\n", result);

    // Clean up and close the BCM2835 library
    bcm2835_close();

    return 0;
}
