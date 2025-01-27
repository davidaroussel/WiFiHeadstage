#include <stdio.h>
#include <wiringPi.h>
#include <wiringPiSPI.h>

#define SPI_CHANNEL 1        // SPI1 is channel 1 (GPIO 20, 21, 19, 16)
#define SPI_SPEED 500000     // SPI speed (adjust if needed)
#define SPI_MODE 0           // SPI mode 0 (CPOL = 0, CPHA = 0)
#define MOSI_PIN 20          // GPIO 20 for MOSI
#define MISO_PIN 19          // GPIO 19 for MISO
#define CLK_PIN 21           // GPIO 21 for Clock
#define CS_PIN 16            // GPIO 16 for Chip Select

unsigned char intan_characters[5];

// Dummy function for Write_To_Intan_Chip (to replace actual implementation)
void Write_To_Intan_Chip(unsigned char *data, int p_id) {
    // SPI write functionality
    wiringPiSPIDataRW(SPI_CHANNEL, data, 4); // Writing 4 bytes at a time
}

void ReadWrite_To_Intan_Chip(char *data_r, unsigned char command, int p_id) {
    char data[4] = {command, 0, 0, 0}; // Example SPI command
    Write_To_Intan_Chip(data, p_id);
    // Read the response (assuming 4 bytes)
    wiringPiSPIDataRW(SPI_CHANNEL, data, 4);
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
    // Setup wiringPi and SPI
    wiringPiSetupGpio(); // Use BCM GPIO numbering
    if (wiringPiSPISetup(SPI_CHANNEL, SPI_SPEED) < 0) {
        printf("SPI setup failed: %s\n", strerror(errno));
        return -1;
    }

    // Configure the chip here
    unsigned char p_high_freq_no = 1;
    unsigned char p_low_freq_no = 5;
    int p_id = 0;  // Example chip ID

    // Test read from Intan chip
    char* result = readIntanCharactersforTest(p_id);
    printf("Received data: %s\n", result);

    return 0;
}