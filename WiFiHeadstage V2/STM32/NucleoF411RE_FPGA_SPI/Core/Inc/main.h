/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2025 STMicroelectronics.
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

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define B1_Pin GPIO_PIN_13
#define B1_GPIO_Port GPIOC
#define USART_TX_Pin GPIO_PIN_2
#define USART_TX_GPIO_Port GPIOA
#define USART_RX_Pin GPIO_PIN_3
#define USART_RX_GPIO_Port GPIOA
#define TMS_Pin GPIO_PIN_13
#define TMS_GPIO_Port GPIOA
#define TCK_Pin GPIO_PIN_14
#define TCK_GPIO_Port GPIOA
#define SWO_Pin GPIO_PIN_3
#define SWO_GPIO_Port GPIOB

/* USER CODE BEGIN Private defines */
#define RDY_FPGA_Pin GPIO_PIN_12
#define RDY_FPGA_GPIO_Port GPIOC

#define RDY_nRF_Pin GPIO_PIN_10
#define RDY_nRF_GPIO_Port GPIOC

#define FPGA_MUX_5_Pin GPIO_PIN_8
#define FPGA_MUX_5_GPIO_Port GPIOA

#define FPGA_MUX_4_Pin GPIO_PIN_9
#define FPGA_MUX_4_GPIO_Port GPIOA


//Nordic nRF SPI PIN (SPI 1)
#define nRF_SPI_MOSI_Port GPIOA
#define nRF_SPI_MOSI_Pin GPIO_PIN_7

#define nRF_SPI_MISO_Port GPIOA
#define nRF_SPI_MISO_Pin GPIO_PIN_6

#define nRF_SPI_CLK_Port GPIOA
#define nRF_SPI_CLK_Pin GPIO_PIN_5

#define nRF_SPI_CS_Port GPIOA
#define nRF_SPI_CS_Pin GPIO_PIN_4


//INTAN RHD SPI PIN (SPI 4)
#define RHD_SPI_MOSI_Port GPIOA
#define RHD_SPI_MOSI_Pin GPIO_PIN_1

#define RHD_SPI_MISO_Port GPIOA
#define RHD_SPI_MISO_Pin GPIO_PIN_11

#define RHD_SPI_CLK_Port GPIOB
#define RHD_SPI_CLK_Pin GPIO_PIN_13

#define RHD_SPI_CS_Port GPIOB
#define RHD_SPI_CS_Pin GPIO_PIN_12



//INTAN RHS SPI PIN (SPI3) NOT USED !!
#define RHS_SPI_MOSI_Port GPIOC
#define RHS_SPI_MOSI_Pin GPIO_PIN_12

#define RHS_SPI_MISO_Port GPIOC
#define RHS_SPI_MISO_Pin GPIO_PIN_11

#define RHS_SPI_CLK_Port GPIOC
#define RHS_SPI_CLK_Pin GPIO_PIN_10

#define RHS_SPI_CS_Port GPIOD
#define RHS_SPI_CS_Pin GPIO_PIN_2
/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
