/*
 * spi_receive_task.h
 *
 *  Created on: Oct 2, 2022
 *      Author: david
 */

#ifndef INC_SPI_RECEIVE_TASK_H_
#define INC_SPI_RECEIVE_TASK_H_

#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include "SPI_communication.h"


void TASK_RHD64_SPI_COMMUNICATION_INIT (void *arg);
void INIT_RHD64(SPI_HandleTypeDef *hspi);




#endif /* INC_SPI_RECEIVE_TASK_H_ */
