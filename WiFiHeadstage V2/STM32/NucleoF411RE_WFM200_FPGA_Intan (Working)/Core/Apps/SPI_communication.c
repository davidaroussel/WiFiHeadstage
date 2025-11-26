/*
 * SPI_communication.c
 *
 *  Created on: Apr. 3, 2023
 *      Author: David
 */

#include "Task_Apps_Start.h"
#include "SPI_communication.h"


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
