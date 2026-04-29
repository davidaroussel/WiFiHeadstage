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


#endif /* UTILS_H_ */
