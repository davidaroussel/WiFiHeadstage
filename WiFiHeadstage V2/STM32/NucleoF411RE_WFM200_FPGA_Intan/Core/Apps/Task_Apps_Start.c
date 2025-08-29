/*
 * apps_config.c
 *
 *  Created on: Oct 7, 2022
 *      Author: David
 */

#include "Task_Apps_Start.h"
#include "stm32f4xx_hal_tim.h"
#include "Task_Wifi_menu.h"
#include "Task_TCP_Transmit.h"
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

uint32_t global_counter = 0;
TIM_HandleTypeDef htim2;
osSemaphoreId samplingSemaphore;
bool TIMER_FLAG = false;

// TIM2 Interrupt Handler
void TIM2_IRQHandler(void) {
    if (__HAL_TIM_GET_FLAG(&htim2, TIM_FLAG_UPDATE) != RESET) {
        __HAL_TIM_CLEAR_IT(&htim2, TIM_IT_UPDATE);
        TIMER_FLAG = true;
    }
}


void Timer2_Init(void) {
	__HAL_RCC_TIM2_CLK_ENABLE();

	uint32_t system_clock = 100000000;
	uint32_t target_frequency = TIMER_FREQUENCY;
	uint32_t prescaler = 9;
	uint32_t period = 999;

	printf("System Clock: %lu Hz \r\n", system_clock);
	printf("Target Timer Frequency: %d Hz \r\n", target_frequency);
	printf("Calculated Prescaler: %lu \r\n", prescaler);
	printf("Calculated Period: %lu \r\n", period);

	// Initialize the timer
	htim2.Instance = TIM2;
	htim2.Init.Prescaler = prescaler;
	htim2.Init.CounterMode = TIM_COUNTERMODE_UP;
	htim2.Init.Period = period;
	htim2.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;

	HAL_TIM_Base_Init(&htim2);
	HAL_NVIC_SetPriority(TIM2_IRQn, 1, 0);
	HAL_NVIC_EnableIRQ(TIM2_IRQn);
}


void StartSampling(void) {
    printf("Starting Sampling at %d Hz...\r\n", TIMER_FREQUENCY);
    HAL_TIM_Base_Start_IT(&htim2);
}

void StopSampling(void) {
    printf("Stopping Sampling...\r\n");
    HAL_TIM_Base_Stop_IT(&htim2);
}




void start_app_task(void)
{
	spi_to_wifi_queue = xQueueCreate(SPI_EVENTS_NB_MAX, sizeof(spi_to_udp_t));
  	if (spi_to_wifi_queue == NULL){
  		printf("booboo Queue \r\n");
  	}

  	//	INIT_UPD();

//	TASK_RHD_SPI_COMMUNICATION_INIT((void*) spi_to_wifi_queue);

//  	Timer2_Init();

	INIT_INTAN();

//	INIT_TCP();
//
//  	while (!TCP_Connected){
//  		HAL_Delay(10);
//  	}
//
//  	WIFI_MENU_INIT((void*) spi_to_wifi_queue);

//  	TASK_UDP_TRANSMIT_INIT((void*) spi_to_wifi_queue);
//  	TASK_TCP_TRANSMIT_INIT((void*) spi_to_wifi_queue);



//  	TASK_FPGA_COMMUNICATION_INIT((void*) spi_to_wifi_queue);

}


#endif
