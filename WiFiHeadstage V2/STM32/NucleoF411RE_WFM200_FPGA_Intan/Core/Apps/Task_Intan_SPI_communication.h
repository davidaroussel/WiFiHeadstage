/*
 * spi_receive_task.c
 *
 *  Created on: Aug 20, 2023
 *      Author: david
 */

#ifndef INC_SPI_RECEIVE_TASK_H_
#define INC_SPI_RECEIVE_TASK_H_



#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include "SPI_communication.h"

void TASK_RHD_SPI_COMMUNICATION_INIT (void *arg);
void RHD_SPI_COMMUNICATION_task_entry(void const *arg);
void INIT_INTAN();


#endif /* INC_SPI_RECEIVE_TASK_H_ */
