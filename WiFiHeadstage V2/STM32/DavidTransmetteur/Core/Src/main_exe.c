/*
 * main_exe.c
 *
 *  Created on: Mar 30, 2026
 *      Author: gabri
 */
#include "main.h"
#include "fifos.h"

#define TRUE 1
#define FALSE 0
#define EVENT_FIFO_SIZE 32
#define NB_EVENT_SOURCES 9

extern TIM_HandleTypeDef htim2;
#define DEMI_PERIOD 250

/*The fifos*/

FIFO_STRUCTURE_BYTE event_fifo;
uint8_t event_fifo_array[EVENT_FIFO_SIZE];
short unsigned int pin_list[NB_EVENT_SOURCES] = {GPIO_PIN_0, GPIO_PIN_1, GPIO_PIN_2, GPIO_PIN_3, GPIO_PIN_4, GPIO_PIN_5, GPIO_PIN_6,
									 GPIO_PIN_7, GPIO_PIN_8};


uint8_t event_processed_array[NB_EVENT_SOURCES];

/*End the fifos*/



void delay_us(uint16_t us)
{
    __HAL_TIM_SET_COUNTER(&htim2, 0);   // remet le compteur à 0
    while (__HAL_TIM_GET_COUNTER(&htim2) < 2*us);
}



void main_exe(void)
{
	HAL_GPIO_WritePin(GPIOB, GPIO_PIN_4, GPIO_PIN_RESET);

	for(int i = 0; i < NB_EVENT_SOURCES; i++)
		event_processed_array[i] = FALSE;

	event_fifo.fifo_array = event_fifo_array;
	initFIFO_byte(&event_fifo, EVENT_FIFO_SIZE);

	HAL_TIM_Base_Start(&htim2);

	while(1)
	{
		for(int i = 0; i < NB_EVENT_SOURCES; i++)
		{
			if((GPIOA->IDR & pin_list[i]) && event_processed_array[i] == FALSE)
			{
				event_processed_array[i] = TRUE;
				//pushFIFO_byte(&event_fifo, 8);
				pushFIFO_byte(&event_fifo, i);
				//pushFIFO_byte(&event_fifo, 1);
			}
			else if(!(GPIOA->IDR & pin_list[i]))
			{
				event_processed_array[i] = FALSE;
			}
		}

		if(!isFIFOempty_byte(&event_fifo))
		{
			volatile uint8_t event = popFIFO_byte(&event_fifo);

			GPIOB->ODR |= GPIO_PIN_4;
			delay_us(500);
			GPIOB->ODR &= ~GPIO_PIN_4;
			delay_us(100);

			GPIOB->ODR |= GPIO_PIN_4;
			delay_us(100 + (event + 1)*100);
			GPIOB->ODR &= ~GPIO_PIN_4;
			delay_us(100);

			/*for(int i = 0; i < 10; i++)
			{
				GPIOB->ODR |= GPIO_PIN_4;
				delay_us(200);
				GPIOB->ODR &= ~GPIO_PIN_4;
				delay_us(200);
			}*/


			GPIOB->ODR |= GPIO_PIN_4;
			delay_us(500);
			GPIOB->ODR &= ~GPIO_PIN_4;
			delay_us(100);

		}
		else
		{
			/*GPIOB->ODR |= GPIO_PIN_4;
			delay_us(200);
			GPIOB->ODR &= ~GPIO_PIN_4;
			delay_us(200);*/
		}
	}

}
