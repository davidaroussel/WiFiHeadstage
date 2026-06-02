/*
 * spi_receive_task.c
 *
 *  Created on: Aug 20, 2023
 *      Author: david
 */

#include "../Intan/Intan_utils.h"
#include "Task_FPGA_communication.h"
#include "stm32f4xx_hal.h"
#include "Task_Apps_Start.h"
#include <math.h>




//#define udp_mode_only
extern SPI_HandleTypeDef hspi4;
extern uint16_t rx_buffers[NUM_BUFFERS][SPI_BUFFER_SIZE];

extern uint16_t rx_buffer[SPI_BUFFER_SIZE];

extern volatile uint8_t current_buffer;
extern bool spi_flag;

//extern osTimerId periodicTimerHandle;








void FPGA_COMMUNICATION_task_entry(void const *p_arg);



void INIT_FPGA(SPI_HandleTypeDef *hspi){


 }




void TASK_FPGA_COMMUNICATION_INIT(void *arg) {
	//CREATE xQueue
	osThreadDef(FPGA_handle, FPGA_COMMUNICATION_task_entry, osPriorityNormal, 0, configMINIMAL_STACK_SIZE*10);

	if (osThreadCreate(osThread(FPGA_handle), (void *)arg) == NULL){
		printf("Booboo created SPI task \r\n");
	}
}

void FPGA_COMMUNICATION_task_entry(void const *arg){
	spi_to_udp_t spi_message = {0};
	SPI_HandleTypeDef *hspi;
	uint16_t counter = 0;
	size_t num_elements = sizeof(rx_buffers[current_buffer]) / sizeof(rx_buffers[current_buffer][0]);
	int allGoodFlag = 0;
	hspi = &hspi4;
	HAL_SPI_Receive_DMA(hspi, rx_buffers[current_buffer], SPI_BUFFER_SIZE);
	while(1)
	{
 		if (spi_flag){
// 			FULL_TASK_SCOPE_Port->BSRR = FULL_TASK_SCOPE_Pin;
// 			SPI_TASK_SCOPE_Port ->BSRR = SPI_TASK_SCOPE_Pin;



			//printf("Data %04X-%04X-%04X-%04X \r\n", rx_buffers[current_buffer][0], rx_buffers[current_buffer][1], rx_buffers[current_buffer][BUFFER_SIZE - 2], rx_buffers[current_buffer][BUFFER_SIZE - 1]);


            spi_message.buffer = (void *)rx_buffers[current_buffer];
            if (arg != 0) {
                if (xQueueSend((QueueHandle_t)arg, (void *)&spi_message, (TickType_t)2) != pdPASS) {
                    printf("problem in queueSend \r\n");
                }
            }
            counter++;
			//printf("%lu \r\n", counter);


 			allGoodFlag = 0;
			spi_flag = 0;
			for (size_t i = 0; i < SPI_BUFFER_SIZE; i++) {
				if (rx_buffers[current_buffer][i] != 0x0001){
					allGoodFlag = 1;
					//printf("Data from %u= %u is %04X \r\n",current_buffer ,i, rx_buffers[current_buffer][i]);
				}
			}
			if (allGoodFlag == 0){
				printf("AllGood \r\n");
			}

			  //RESET SPI_TASK_Scope_Pin
//			  SPI_TASK_SCOPE_Port->BSRR = (uint32_t)SPI_TASK_SCOPE_Pin << 16U;
	    	}
			else{
				vTaskDelay(1);
			}
		}
}



