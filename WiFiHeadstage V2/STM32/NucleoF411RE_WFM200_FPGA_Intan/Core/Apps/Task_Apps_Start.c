/*
 * apps_config.c
 *
 *  Created on: Oct 7, 2022
 *      Author: David
 */

#include "Task_Apps_Start.h"
#include "freeRTOS.h"
//
//

#ifndef spi_mode_only

static QueueHandle_t spi_to_wifi_queue = NULL;

osThreadId id;
bool spi_flag = false;
struct udp_pcb *upcb = NULL;
struct tcp_pcb *tpcb = NULL;
osTimerId periodicTimerHandle;
TimerHandle_t PTHandle;


volatile uint8_t current_buffer;
uint16_t rx_buffers[NUM_BUFFERS][SPI_BUFFER_SIZE];
uint16_t rx_buffer[SPI_BUFFER_SIZE];

bool TCP_Connected = false;


uint16_t UDP_FREQUENCY = 16/2;




void start_app_task(void)
{
//	INIT_UPD();
//	INIT_TCP();

//	osTimerDef(periodicTimer, PTCallback);
//	periodicTimerHandle = osTimerCreate(osTimer(periodicTimer), osTimerPeriodic, NULL);

	spi_to_wifi_queue = xQueueCreate(SPI_EVENTS_NB_MAX, sizeof(spi_to_udp_t));
  	if (spi_to_wifi_queue == NULL){
  		printf("booboo Queue \r\n");
  	}

  	//osTimerStart(periodicTimerHandle, UDP_FREQUENCY);
//  	while (!TCP_Connected){
//  		HAL_Delay(10);
//  	}
//  	WIFI_MENU_INIT();
//  	TASK_UDP_TRANSMIT_INIT((void*) spi_to_wifi_queue);
//  	TASK_TCP_TRANSMIT_INIT((void*) spi_to_wifi_queue);

  	TASK_RHD64_SPI_COMMUNICATION_INIT((void*) spi_to_wifi_queue);
//  	TASK_FPGA_COMMUNICATION_INIT((void*) spi_to_wifi_queue);

}


#endif
