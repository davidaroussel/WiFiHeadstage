/*
 * utils.c
 *
 *  Created on: May 6, 2021
 *      Author: SimonTam
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "Task_Apps_Start.h"

void misosplit(uint16_t data, uint8_t* a, uint8_t* b)
{
	uint8_t aa = 0;
	uint8_t bb = 0;
	uint16_t mask_a = 0b1010101010101010;
	uint16_t mask_b = 0b0101010101010101;

	uint16_t masked_a = data & mask_a;
	masked_a >>= 1;
	uint16_t masked_b = data & mask_b;

	for(int i=0; i<8; i++)
	{
		aa += (0b1<<i & masked_a>>i);
		bb += (0b1<<i & masked_b>>i);
	}
	*a = aa << 1;
	*b = bb;
}


void mosimerge(uint16_t data_in, uint32_t* data_out)
{

//	data_out[0] = data_in & 0x00;
//	data_out[1] = data_in & 0x0F;
//	data_out[0], data_out[1] = data_in & 0x00;
//	data_out[2], data_out[3] = data_in & 0x01;
//	data_out[4], data_out[5] = data_in & 0x02;
//	data_out[6], data_out[7] = data_in & 0x03;
//	data_out[8], data_out[9] = data_in & 0x04;
//	data_out[10], data_out[11] = data_in & 0x05;
//	data_out[12], data_out[13] = data_in & 0x06;
//	data_out[14], data_out[15] = data_in & 0x07;
//
//	data_out[16], data_out[17] = data_in & 0x08;
//	data_out[18], data_out[19] = data_in & 0x09;
//	data_out[20], data_out[21] = data_in & 0x0a;
//	data_out[22], data_out[23] = data_in & 0x0b;
//	data_out[24], data_out[25] = data_in & 0x0c;
//	data_out[26], data_out[27] = data_in & 0x0d;
//	data_out[28], data_out[29] = data_in & 0x0e;
//	data_out[30], data_out[31] = data_in & 0x0f;
}



void convert_RHD_to_mV(){

}


void config_intan(SPI_HandleTypeDef *hspi)
{
	uint16_t tx[2];
	uint16_t rx[2];
	uint8_t last_bit[1];

	// Register 0 - ADC config.
	tx[0] = 0b1100000000000000;
	tx[1] = 0b1111001111111100;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);

	// Register 1 - Supply sensor & ADC buffer bias current
	tx[0] = 0b1100000000000011;
	tx[1] = 0b0000110000000000;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);

	// Register 2 - MUX bias current
	tx[0] = 0b1100000000001100;
	tx[1] = 0b0000110011000000;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);

	// Register 3 - MUX Load, Temp sensor, Aux digital output
	tx[0] = 0b1100000000001111;
	tx[1] = 0b0000000000001100;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);

	// Register 4 - ADC output format & DSP offset removal
	tx[0] = 0b1100000000110000;
	tx[1] = 0b1111001100111100;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);

	// Register 5 - Impedance check control
	tx[0] = 0b1100000000110011;
	tx[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);

	// Register 6 - Impedance check DAC [unchanged]
	tx[0] = 0b1100000000111100;
	tx[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);

	// Register 7 - Impedance check amplifier select [unchanged]
	tx[0] = 0b1100000000111111;
	tx[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);

	// Register 8-13 - On-chip amplifier bandwidth select
	// 	Reg. 8 -> 30
	tx[0] = 0b1100000011000000;
	tx[1] = 0b0000001111111100;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	// 	Reg. 9 -> 5
	tx[0] = 0b1100000011000011;
	tx[1] = 0b0000000000110011;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	//	Reg. 10 -> 43
	tx[0] = 0b1100000011001100;
	tx[1] = 0b0000110011001111;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	//	Reg. 11 -> 6
	tx[0] = 0b1100000011001111;
	tx[1] = 0b0000000000111100;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	// 	Reg. 12 -> 54
	tx[0] = 0b1100000011110000;
	tx[1] = 0b0000111100111100;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	// 	Reg. 13 -> 0
	tx[0] = 0b1100000011110011;
	tx[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);

	// Register 14-21 - Individual amplifier power
	//	Reg. 14
	tx[0] = 0b1100000011111100;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	//	Reg. 15
	tx[0] = 0b1100000011111111;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	//	Reg. 16
	tx[0] = 0b1100001100000000;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	//	Reg. 17
	tx[0] = 0b1100001100000011;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	//	Reg. 18
	tx[0] = 0b1100001100001100;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	//	Reg. 19
	tx[0] = 0b1100001100001111;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	//	Reg. 20
	tx[0] = 0b1100001100110000;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
	//	Reg. 21
	tx[0] = 0b1100001100110011;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);

	// Calibrate ADC
	HAL_Delay(100);
	tx[0] = 0b0011001100110011;
	tx[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx, rx, last_bit);
}
