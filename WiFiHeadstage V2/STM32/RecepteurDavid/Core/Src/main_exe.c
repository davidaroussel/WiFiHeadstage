/*
 * main_exe.c
 *
 *  Created on: May 7, 2026
 *      Author: gabri
 */

#include "main.h"
#include "stm32g0xx_ll_pwr.h"
#include "stm32g0xx_ll_bus.h"
#include "stm32g0xx_ll_rcc.h"
#include "stm32g0xx_ll_system.h"

#include "main_exe.h"
#include "fifos.h"


#define TRUE 1
#define FALSE 0

extern TIM_HandleTypeDef htim1;
extern DAC_HandleTypeDef hdac1;
extern TIM_HandleTypeDef htim2;

#define EVENT_FIFO_SIZE 128
FIFO_STRUCTURE_BYTE event_fifo;
uint8_t event_fifo_array[EVENT_FIFO_SIZE];

typedef char boolean;

int code = 0;

boolean pulse_time_elapsed = TRUE;
boolean reset_dac_output = TRUE;
boolean pulse_in_progress = TRUE;

void setDAC1output(uint32_t p_output)
{
	HAL_DAC_SetValue(&hdac1, DAC_CHANNEL_1, DAC_ALIGN_12B_R, p_output);
	HAL_DAC_Start(&hdac1, DAC_CHANNEL_1);
}

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
    if (htim->Instance == TIM2)
    {
    	if(pulse_in_progress)
    	{
    		pulse_in_progress = FALSE;
    		reset_dac_output = TRUE;
    	}
    	else
    	{
    		pulse_time_elapsed = TRUE;
    	}

    }
}

boolean rising_edge = FALSE;
boolean falling_edge = FALSE;

void manage_GPIO_Callback(uint16_t GPIO_Pin)
{
	static boolean header_found = FALSE;
	static int code_tmp = 0;
	static uint32_t last_edge_time = 0;



	uint32_t now = __HAL_TIM_GET_COUNTER(&htim1);

	//if(rising_edge || falling_edge)
	{
		uint32_t dt_edge = now - last_edge_time;
		last_edge_time = now;

		const int baseline = 100;

		if(falling_edge)
		{
			rising_edge = FALSE;
			falling_edge = FALSE;
			if(!header_found)
			{
				if(dt_edge >= baseline + 400)
				{
					header_found = TRUE;
					code_tmp = 0;
				}
				else
				{
					header_found = FALSE;
				}
			}
			else if(code_tmp != 0)
			{
				if(dt_edge >= baseline + 400)
				{
					if(!isFIFOfull_byte(&event_fifo))
						pushFIFO_byte(&event_fifo, code_tmp);
				}
				header_found = FALSE;
				code_tmp = 0;

			}
			else if(dt_edge >= baseline + 75 && header_found)
			{
				//header_found = FALSE;
				code_tmp = 1;
				if(dt_edge >= baseline + 150)
				{
					code_tmp = 2;
					if(dt_edge >= baseline + 250)
					{
						code_tmp = 3;
						if(dt_edge >= baseline + 350)
						{
							code_tmp = 4;
							if(dt_edge >= baseline + 450)
							{
								code_tmp = 5;
								if(dt_edge >= baseline + 550)
								{
									code_tmp = 6;
									if(dt_edge >= baseline + 650)
									{
										code_tmp = 7;
										if(dt_edge >= baseline + 750)
										{
											code_tmp = 8;
										}
									}
								}
							}

						}
					}
				}
			}
			else
			{
				header_found = 0;
				code_tmp = 0;
			}
		}

	}
}

void HAL_GPIO_EXTI_Rising_Callback(uint16_t GPIO_Pin)
{
	rising_edge = TRUE;
	manage_GPIO_Callback(GPIO_Pin);
}

void HAL_GPIO_EXTI_Falling_Callback(uint16_t GPIO_Pin)
{
	falling_edge = TRUE;
	manage_GPIO_Callback(GPIO_Pin);
}

void start_one_shot_timer(void)
{
	HAL_TIM_Base_Stop(&htim2);

	__HAL_TIM_SET_COUNTER(&htim2, 0);

	htim2.Instance->CR1 |= TIM_CR1_OPM;

	HAL_TIM_Base_Start_IT(&htim2);
}

void main_exe(void)
{
	event_fifo.fifo_array = event_fifo_array;
	initFIFO_byte(&event_fifo, EVENT_FIFO_SIZE);

	HAL_TIM_Base_Start(&htim1);

	while(1)
	{
		if(!isFIFOempty_byte(&event_fifo) && pulse_time_elapsed)
		{
			pulse_time_elapsed = FALSE;
			pulse_in_progress = TRUE;
			code = popFIFO_byte(&event_fifo);
			if(code == 1)
			{
				setDAC1output(512);
			}
			else if(code == 2)
			{
				setDAC1output(512*2);
			}
			else if(code == 3)
			{
				setDAC1output(512*3);
			}
			else if(code == 4)
			{
				setDAC1output(512*4);
			}
			else if(code == 5)
			{
				setDAC1output(512*5);
			}
			else if(code == 6)
			{
				setDAC1output(512*6);
			}
			else if(code == 7)
			{
				setDAC1output(512*7);
			}
			else if(code == 8)
			{
				setDAC1output(512*8 - 1);
			}
			start_one_shot_timer();
		}
		if(reset_dac_output)
		{
			reset_dac_output = FALSE;
			setDAC1output(0);
			start_one_shot_timer();
		}
		LL_PWR_SetPowerMode(LL_PWR_MODE_STOP0);
	}
}
