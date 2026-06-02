/*
 * utils.c
 *
 *  Created on: May 6, 2021
 *      Author: SimonTam
 */

#include "Intan_utils.h"
#include "main.h"

void SPI_SEND_RECV(SPI_HandleTypeDef *hspi, uint16_t *tx_ptr, uint16_t *rx_ptr, uint8_t size) {
	uint16_t Size = size;

	/* Variable used to alternate Rx and Tx during transfer */
	uint32_t txallowed = 1U;

	/* Don't overwrite in case of HAL_SPI_STATE_BUSY_RX */
	if (hspi->State != HAL_SPI_STATE_BUSY_RX) {
		hspi->State = HAL_SPI_STATE_BUSY_TX_RX;
	}

	/* Set the transaction information */
	hspi->ErrorCode = HAL_SPI_ERROR_NONE;
	hspi->pRxBuffPtr = (uint8_t *)rx_ptr;
	hspi->RxXferCount = Size;
	hspi->RxXferSize = Size;
	hspi->pTxBuffPtr = (uint8_t *)tx_ptr;
	hspi->TxXferCount = Size;
	hspi->TxXferSize = Size;

	/* Init field not used in handle to zero */
	hspi->RxISR = NULL;
	hspi->TxISR = NULL;

	/* Check if the SPI is already enabled */
	if ((hspi->Instance->CR1 & SPI_CR1_SPE) != SPI_CR1_SPE) {
		/* Enable SPI peripheral */
		__HAL_SPI_ENABLE(hspi);
	}

	// RESET CS_PIN
	if (hspi->Instance == SPI3) {
		RHS_SPI_CS_Port->BSRR = (uint32_t)RHS_SPI_CS_Pin << 16U;
	} else if (hspi->Instance == SPI4) {
		RHD_SPI_CS_Port->BSRR = (uint32_t)RHD_SPI_CS_Pin << 16U;
	}

	while ((hspi->TxXferCount > 0U) || (hspi->RxXferCount > 0U)) {
		/* Check TXE flag */
		if ((__HAL_SPI_GET_FLAG(hspi, SPI_FLAG_TXE)) && (hspi->TxXferCount > 0U) && (txallowed == 1U)) {
			hspi->Instance->DR = *((uint16_t *)hspi->pTxBuffPtr);
			hspi->pTxBuffPtr += sizeof(uint16_t);
			hspi->TxXferCount--;
			/* Next Data is a reception (Rx). Tx not allowed */
			txallowed = 0U;
		}

		/* Check RXNE flag */
		if ((__HAL_SPI_GET_FLAG(hspi, SPI_FLAG_RXNE)) && (hspi->RxXferCount > 0U)) {
			*((uint16_t *)hspi->pRxBuffPtr) = (uint16_t)hspi->Instance->DR;
			hspi->pRxBuffPtr += sizeof(uint16_t);
			hspi->RxXferCount--;
			/* Next Data is a Transmission (Tx). Tx is allowed */
			txallowed = 1U;
		}
	}

	// SET CS_PIN
	if (hspi->Instance == SPI3){
		RHS_SPI_CS_Port->BSRR = RHS_SPI_CS_Pin;
	} else if (hspi->Instance == SPI4) {
		RHD_SPI_CS_Port->BSRR = RHD_SPI_CS_Pin;
	}
}

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
	uint8_t message_size = 2;

	// Register 0 - ADC config.
	tx[0] = 0b1100000000000000;
	tx[1] = 0b1111001111111100;
	SPI_SEND_RECV(hspi, tx, rx, message_size);

	// Register 1 - Supply sensor & ADC buffer bias current
	tx[0] = 0b1100000000000011;
	tx[1] = 0b0000110000000000;
	SPI_SEND_RECV(hspi, tx, rx, message_size);

	// Register 2 - MUX bias current
	tx[0] = 0b1100000000001100;
	tx[1] = 0b0000110011000000;
	SPI_SEND_RECV(hspi, tx, rx, message_size);

	// Register 3 - MUX Load, Temp sensor, Aux digital output
	tx[0] = 0b1100000000001111;
	tx[1] = 0b0000000000001100;
	SPI_SEND_RECV(hspi, tx, rx, message_size);

	// Register 4 - ADC output format & DSP offset removal
	tx[0] = 0b1100000000110000;
	tx[1] = 0b1111001100111100;
	SPI_SEND_RECV(hspi, tx, rx, message_size);

	// Register 5 - Impedance check control
	tx[0] = 0b1100000000110011;
	tx[1] = 0b0000000000000000;
	SPI_SEND_RECV(hspi, tx, rx, message_size);

	// Register 6 - Impedance check DAC [unchanged]
	tx[0] = 0b1100000000111100;
	tx[1] = 0b0000000000000000;
	SPI_SEND_RECV(hspi, tx, rx, message_size);

	// Register 7 - Impedance check amplifier select [unchanged]
	tx[0] = 0b1100000000111111;
	tx[1] = 0b0000000000000000;
	SPI_SEND_RECV(hspi, tx, rx, message_size);

	// Register 8-13 - On-chip amplifier bandwidth select
	// 	Reg. 8 -> 30
	tx[0] = 0b1100000011000000;
	tx[1] = 0b0000001111111100;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	// 	Reg. 9 -> 5
	tx[0] = 0b1100000011000011;
	tx[1] = 0b0000000000110011;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	//	Reg. 10 -> 43
	tx[0] = 0b1100000011001100;
	tx[1] = 0b0000110011001111;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	//	Reg. 11 -> 6
	tx[0] = 0b1100000011001111;
	tx[1] = 0b0000000000111100;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	// 	Reg. 12 -> 54
	tx[0] = 0b1100000011110000;
	tx[1] = 0b0000111100111100;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	// 	Reg. 13 -> 0
	tx[0] = 0b1100000011110011;
	tx[1] = 0b0000000000000000;
	SPI_SEND_RECV(hspi, tx, rx, message_size);

	// Register 14-21 - Individual amplifier power
	//	Reg. 14
	tx[0] = 0b1100000011111100;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	//	Reg. 15
	tx[0] = 0b1100000011111111;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	//	Reg. 16
	tx[0] = 0b1100001100000000;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	//	Reg. 17
	tx[0] = 0b1100001100000011;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	//	Reg. 18
	tx[0] = 0b1100001100001100;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	//	Reg. 19
	tx[0] = 0b1100001100001111;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	//	Reg. 20
	tx[0] = 0b1100001100110000;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
	//	Reg. 21
	tx[0] = 0b1100001100110011;
	tx[1] = 0b1111111111111111;
	SPI_SEND_RECV(hspi, tx, rx, message_size);

	// Calibrate ADC
	HAL_Delay(100);
	tx[0] = 0b0011001100110011;
	tx[1] = 0b0000000000000000;
	SPI_SEND_RECV(hspi, tx, rx, message_size);
}
