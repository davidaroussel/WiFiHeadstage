/*
 * SPI_communication.h
 *
 *  Created on: Apr. 3, 2023
 *      Author: David
 */

#ifndef SPI_COMMUNICATION_H_
#define SPI_COMMUNICATION_H_

void SPI_SEND_RECV(SPI_HandleTypeDef *hspi, uint16_t *tx_ptr, uint16_t *rx_ptr, uint8_t size);

#endif /* SPI_COMMUNICATION_H_ */
