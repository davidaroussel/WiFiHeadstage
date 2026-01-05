#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "Task_Apps_Start.h"


//MISOSPLIT FROM SIMON TAM
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



void Dummy_Task_RHD2164_Startup(void const *arg){
	uint16_t tx_vector[2];
	uint16_t rx_vector[2];
	uint8_t last_bit[1];

	uint8_t DATA_CH0[2];
	uint8_t DATA_CH32[2];

	uint16_t UDP_vector[32][2];

	uint16_t counter = 0;

	spi_to_udp_t spi_message = {0};

	SPI_HandleTypeDef *hspi;

	spi_flag = true;
	int last_bit_testing[1];
//	uint16_t tx_16b[1];
//	uint32_t tx_32b[1];
//	tx_16b[0] = 0b1110101100000000;
//	mosimerge(tx_16b[0], tx_32b[0]);
//	printf("Sending Data: %x Receiving %x \r\n",  tx_16b[0], tx_32b[0]);

	spi_message.spi_task_id = 1;
	spi_message.message_lenght = sizeof(rx_vector)/2;

	uint16_t convert0_cmd[2];
	convert0_cmd[0] = 0b0000000000000000;
	convert0_cmd[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, convert0_cmd, rx_vector, last_bit_testing);

	uint16_t convert63_cmd[2];
	convert63_cmd[0] = 0b0000111111111111;
	convert63_cmd[1] = 0b0000000000000000;


	uint16_t intan_cmd[5][2];
	intan_cmd[0][0] = 0b1111110011001100;
	intan_cmd[0][1] = 0b0000000000000000;

	intan_cmd[1][0] = 0b1111110011001111;
	intan_cmd[1][1] = 0b0000000000000000;

	signed short int FINAL_DATA_CH0[1];
	signed short int FINAL_DATA_CH32[1];

	float CH0_31_value[32];
	float CH32_63_value[32];

	float temp_value_0;
	float temp_value_32;

	uint8_t data_size = 2; //Number of 16bits packet to send

	config_intan(&hspi); //TODO CONFIRMER SI POINTEUR OU PAS POUR hspi


    while(1)
	{
    	if (spi_flag){
    		spi_flag = false;
			for (int i = 0; i< 32; i++){
				SPI_SEND_RECV(hspi, &convert63_cmd, rx_vector, data_size); //TODO CONFIRMER SI POINTEUR OU PAS POUR TX
				(hspi, convert63_cmd, rx_vector, last_bit_testing);
				//MSB
				misosplit(rx_vector[0], &DATA_CH32[0], &DATA_CH0[0]);
				//LSB
				misosplit(rx_vector[1], &DATA_CH32[1], &DATA_CH0[1]);
			}




//			FINAL_DATA_CH0[0] = (((DATA_CH0[0] <<8) | DATA_CH0[1]));
//			temp_value_0 = (FINAL_DATA_CH0[0] * RHD64_ADC_CONVERSION) / 1000;	//16 bit resolution  to 5mV scale
//
//			FINAL_DATA_CH32[0] = (((DATA_CH32[0]<<8) | DATA_CH32[1]));
//			temp_value_32 = (FINAL_DATA_CH32[0] * RHD64_ADC_CONVERSION)/1000;	//16 bit resolution  to 5mV scale
//
//			printf("Sending Data: %x - %x \r\n",  intan_cmd[0][0], intan_cmd[0][1]);
//			printf("CH0  Data: %x | %.3f mV \r\n", FINAL_DATA_CH0[0], temp_value_0);
//			printf("CH32 Data: %x | %.3f mV\r\n", FINAL_DATA_CH32[0], temp_value_32);


//			SPI_SEND_RECV_32(hspi, intan_cmd[1], rx_vector, last_bit_testing);
//			//MSB
//			misosplit(rx_vector[0], &DATA_CH32[0], &DATA_CH0[0]);
//			//LSB
//			misosplit(rx_vector[1], &DATA_CH32[1], &DATA_CH0[1]);
//
//			printf("Sending Data: %x - %x \r\n",   intan_cmd[1][0],  intan_cmd[1][1]);
//			data_intan = DATA_CH0[1];
//			printf("CH0  Data: %x - %x | %c \r\n",  DATA_CH0[0], DATA_CH0[1], data_intan);
//			data_intan = DATA_CH32[1];
//			printf("CH32 Data: %x - %x | %c \r\n",  DATA_CH32[0], DATA_CH32[1], data_intan);



    	}
		else{
			HAL_Delay(1);
		}
	}

}

