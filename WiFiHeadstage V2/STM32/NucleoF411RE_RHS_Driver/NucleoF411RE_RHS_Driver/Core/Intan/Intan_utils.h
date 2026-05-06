/*
 * utils.h
 *
 *  Created on: May 6, 2021
 *      Author: SimonTam
 */

#ifndef UTILS_H_
#define UTILS_H_

#include <stdio.h>
#include <stdlib.h>
#include "main.h"


void misosplit(uint16_t data, uint8_t* a, uint8_t* b);
void mosimerge(uint16_t data_in, uint32_t* data_out);
void config_intan(SPI_HandleTypeDef *hspi);
void SPI_SEND_RECV(SPI_HandleTypeDef *hspi, uint16_t *tx_ptr, uint16_t *rx_ptr, uint8_t size);


#endif /* UTILS_H_ */
