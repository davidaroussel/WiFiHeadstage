/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2022 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f4xx_hal.h"
#include "sl_wfx_host_pin.h"

#define  UDP_BUFFER_SIZE 128
#define  SPI_BUFFER_SIZE 64    // Define the size of each buffer
#define  NUM_BUFFERS 2         // Number of rolling buffers



#define USART_TX_GPIO_Port GPIOA
#define USART_TX_Pin GPIO_PIN_2

#define USART_RX_GPIO_Port GPIOA
#define USART_RX_Pin GPIO_PIN_3


//DEGUGGER
#define TMS_GPIO_Port GPIOA
#define TMS_Pin GPIO_PIN_13

#define TCK_GPIO_Port GPIOA
#define TCK_Pin GPIO_PIN_14

#define SWO_GPIO_Port GPIOB
#define SWO_Pin GPIO_PIN_3


//PIN FOR TIMING ANALYSIS WITH A SCOPE1
//#define UDP_TASK_SCOPE_Port GPIOC
//#define UDP_TASK_SCOPE_Pin GPIO_PIN_8
//
//#define SPI_TASK_SCOPE_Port GPIOC
//#define SPI_TASK_SCOPE_Pin GPIO_PIN_6
//
#define MUX_TOGGLE_Port GPIOA
#define MUX_TOGGLE_Pin GPIO_PIN_13


//INTAN RHD SPI PIN (SPI 4)
#define RHD_SPI_MOSI_Port GPIOA
#define RHD_SPI_MOSI_Pin GPIO_PIN_1

#define RHD_SPI_MISO_Port GPIOA
#define RHD_SPI_MISO_Pin GPIO_PIN_11

#define RHD_SPI_CLK_Port GPIOB
#define RHD_SPI_CLK_Pin GPIO_PIN_13

#define RHD_SPI_CS_Port GPIOB
#define RHD_SPI_CS_Pin GPIO_PIN_12


//INTAN RHS SPI PIN (SPI3)
#define RHS_SPI_MOSI_Port GPIOB
#define RHS_SPI_MOSI_Pin GPIO_PIN_5

#define RHS_SPI_MISO_Port GPIOB
#define RHS_SPI_MISO_Pin GPIO_PIN_4

#define RHS_SPI_CLK_Port GPIOC
#define RHS_SPI_CLK_Pin GPIO_PIN_10

#define RHS_SPI_CS_Port GPIOC
#define RHS_SPI_CS_Pin GPIO_PIN_1



/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);


#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
