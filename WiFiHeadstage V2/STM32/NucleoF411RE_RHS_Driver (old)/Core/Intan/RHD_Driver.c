/*
 * RHD_Driver.c
 *
 *  Created on: Feb 23, 2025
 *      Author: david
 */

#include "Intan_utils.h"

void INIT_RHD(SPI_HandleTypeDef *hspi){
	uint16_t tx_vector;
	uint16_t rx_vector[1];
	uint8_t data_size = 1; //Number of Bytes to send
	uint8_t reg_address;
	uint8_t reg_value;
	uint16_t formated_value;
	uint8_t bit_shifting = 1;
	const char *rhd_versions[] = {"RHD2132", "RHD2216", "RHD2164"};
	const char *rhd_detected = rhd_versions[2];
	//SET CS_PIN
	RHD_SPI_CS_Port->BSRR = RHD_SPI_CS_Pin;

	for (int i = 0; i<9 ; i++){
		// Register 63 for DUMMY READ on BOOT
		tx_vector = 0b1111111100000000;
		SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	}

	// Register 0 - ADC config.
	reg_address = 0b10000000;
	reg_value = 0b11011110;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// Register 1 - Supply sensor & ADC buffer bias current
	reg_address = 0b10000001;
	reg_value = 0b00100000; //(ADC BUFFER BIAS AT 32)
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// Register 2 - MUX bias current
	reg_address = 0b10000010;
	reg_value = 0b00101000; //(MUX BIAS AT 40)
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// Register 3 - MUX Load, Temp sensor, Aux digital output
	reg_address = 0b10000011;
	reg_value = 0b00000010;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// Register 4 - ADC output format & DSP offset removal
	reg_address = 0b10000100;
	reg_value = 0b11010110;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// Register 5 - Impedance check control
	reg_address = 0b10000101;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// Register 6 - Impedance check DAC [unchanged]
	reg_address = 0b10000110;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// Register 7 - Impedance check amplifier select [unchanged]
	reg_address = 0b10000111;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// Register 8-13 - On-chip amplifier bandwidth select
	// 	Reg. 8 -> 30
	reg_address = 0b10001000;
	reg_value = 0b00011110;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// 	Reg. 9 -> 5
	reg_address = 0b10001001;
	reg_value = 0b00000101;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	//	Reg. 10 -> 43
	reg_address = 0b10001010;
	reg_value = 0b00101011;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	//	Reg. 11 -> 6
	reg_address = 0b10001011;
	reg_value = 0b00000110;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// 	Reg. 12 -> 54
	reg_address = 0b10001100;
	reg_value = 0b00110110;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// 	Reg. 13 -> 0
	reg_address = 0b10001101;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// Register 14-21 - Individual amplifier power
	//	Reg. 14
	reg_address = 0b10001110;
	reg_value = 0b11111111;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	//	Reg. 15
	reg_address = 0b10001111;
	reg_value = 0b11111111;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	//	Reg. 16
	reg_address = 0b10010000;
	reg_value = 0b11111111;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	//	Reg. 17
	reg_address = 0b10010001;
	reg_value = 0b11111111;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	//	Reg. 18
	reg_address = 0b10010010;
	reg_value = 0b11111111;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	//	Reg. 19
	reg_address = 0b10010011;
	reg_value = 0b11111111;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	//	Reg. 20
	reg_address = 0b10010100;
	reg_value = 0b11111111;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	//	Reg. 21
	reg_address = 0b10010101;
	reg_value = 0b11111111;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	// Calibrate ADC
	HAL_Delay(100);
	reg_address = 0b01010101;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	for (int i = 0; i<9 ; i++){
		// Register 63 for DUMMY READ on BOOT
		reg_address = 0b11111111;
		reg_value = 0b00000000;
		tx_vector = (reg_address << 8) | reg_value;
		SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	}

	//Read Register 59 MISO MARKER
	reg_address = 0b11111011;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);
	formated_value = rx_vector[0] << bit_shifting;

	//Send dummy CMD to RECV N-2 MISO
	reg_address = 0b11111111;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);
	formated_value = rx_vector[0] << bit_shifting;

	//Send dummy CMD to RECV N-2 MISO
	reg_address = 0b11111111;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);
	formated_value = rx_vector[0] << bit_shifting;
	printf("Char Receiving Data - MISO MARKER :   %c - 0x%04X \r\n", (int)formated_value, formated_value);
	printf("------------------------------------------------  \r\n");

	if (formated_value == 0x00){
		bit_shifting = 0;
		printf("Shifting Bit to 0 \r\n");
		printf("------------------------------------------------  \r\n");
	}

	//Read Register 40
	reg_address = 0b11101000;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
 	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);

	//Read Register 41
	reg_address = 0b11101001;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);;

	//Read Register 42
	reg_address = 0b11101010;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);
	formated_value = rx_vector[0] << bit_shifting;
	printf("Char Receiving Data - Should be I :   %c - 0x%04X \r\n", (char)formated_value, formated_value);
	printf("------------------------------------------------  \r\n");

	//Read Register 43
	reg_address = 0b11101011;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);
	formated_value = rx_vector[0] << bit_shifting;
	printf("Char Receiving Data - Should be N :   %c - 0x%04X \r\n", (char)formated_value, formated_value);
	printf("------------------------------------------------  \r\n");

	//Read Register 44
	reg_address = 0b11101100;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);
	formated_value = rx_vector[0] << bit_shifting;
	printf("Char Receiving Data - Should be T :   %c - 0x%04X \r\n", (char)formated_value, formated_value);
	printf("------------------------------------------------  \r\n");


	//Read Register 63
	reg_address = 0b11111111;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);
	formated_value = rx_vector[0] << bit_shifting;
	printf("Char Receiving Data - Should be A :   %c - 0x%04X \r\n", (char)formated_value, formated_value);
	printf("------------------------------------------------  \r\n");

	//Send dummy CMD to RECV N-2 MISO
	reg_address = 0b11111111;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);
	formated_value = rx_vector[0] << bit_shifting;
	printf("Char Receiving Data - Should be N :   %c - 0x%04X \r\n", (char)formated_value, formated_value);
	printf("------------------------------------------------  \r\n");

	//Send dummy CMD to RECV N-2 MISO
	reg_address = 0b11111111;
	reg_value = 0b00000000;
	tx_vector = (reg_address << 8) | reg_value;
	SPI_SEND_RECV(hspi, &tx_vector, rx_vector, data_size);
	formated_value = rx_vector[0] << bit_shifting;

	if (formated_value == 0x01){
		rhd_detected = rhd_versions[0];
	}
	else if (formated_value == 0x02){
		rhd_detected = rhd_versions[1];
	}

	printf("Char Receiving Data - CHIP ID : %s - 0x%04X \r\n", rhd_detected, formated_value);
	printf("------------------------------------------------  \r\n");

 }

