/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
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
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "cmsis_os.h"
#include "mbedtls.h"

#include "stm32f4xx_hal_tim.h"
#include "demo_config.h"
#include "sl_wfx_host.h"
#include "sl_wfx_host_events.h"
#include "sl_wfx_host_pin.h"
#include "config-freertos.h"
#include "wifi_cli.h"
#include <mbedtls/threading.h>


#include "trcDefines.h"

/* Private variables ---------------------------------------------------------*/


UART_HandleTypeDef huart2;

SPI_HandleTypeDef hspi4;
DMA_HandleTypeDef hdma_spi4_rx;
DMA_HandleTypeDef hdma_spi4_tx;

osThreadId defaultTaskHandle;



#ifdef __GNUC__
/* With GCC, small printf (option LD Linker->Libraries->Small printf
   set to 'Yes') calls __io_putchar() */
#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif /* __GNUC__ */


/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_DMA_Init(void);
static void MX_USART2_UART_Init(void);
//static void MX_SPI1_Init(void);
static void MX_SPI4_Init(void);


#ifdef spi_mode_only
static QueueHandle_t spi_to_wifi_queue = NULL;
#endif
/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* Configure the system clock */
  SystemClock_Config();

    /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_USART2_UART_Init();
  //MX_SPI1_Init(); THIS WILL BE HANDLE BY THE SL_WFX_DRIVER --> SL_WFX_INIT()

  //THIS INIT TAKES CARE OF MOSI,MISO AND CLK GPIO
  MX_SPI4_Init();
  /* Clear the console and buffer */
  printf("\033\143");
  printf("\033[3J");
  printf("Hello, welcome to the WFM200 driver \r\n");


#ifndef spi_mode_only
  /* Task init */
//  vTraceEnable(TRC_START);
  sl_wfx_task_start();
  wifi_events_start();
  //wifi_cli_start();					/*NOT GOING TO USE THE CLI SINCE THERE WILL NOT BE ANY USART CONNECTION*/
  lwip_start();
#endif

#ifdef spi_mode_only

  spi_to_wifi_queue = xQueueCreate(SPI_EVENTS_NB_MAX, sizeof(spi_to_udp_t));
  	if (spi_to_wifi_queue == NULL){
  		printf("booboo Queue \r\n");
  	}

  //udp_app_init((void*) spi_to_wifi_queue);
  RHD64_SPI_COMMUNICATION ((void*) spi_to_wifi_queue);

#endif


  /* Start scheduler */
  osKernelStart();

  /* We should never get here as control is now taken by the scheduler */
  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);


//  //STRUCT FOR 100MHz SETUP
//  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
//  RCC_OscInitStruct.HSEState = RCC_HSE_BYPASS;
//  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
//  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
//  RCC_OscInitStruct.PLL.PLLM = 8;
//  RCC_OscInitStruct.PLL.PLLN = 400;
//  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;
//  RCC_OscInitStruct.PLL.PLLQ = 4;

  //SETUP FOR 96MHz
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_BYPASS;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 8;
//  RCC_OscInitStruct.PLL.PLLN = 384; //96MHz
//  RCC_OscInitStruct.PLL.PLLN = 360; //90MHz
//  RCC_OscInitStruct.PLL.PLLN = 320; //80MHz
//  RCC_OscInitStruct.PLL.PLLN = 300; //75MHz
//  RCC_OscInitStruct.PLL.PLLN = 280; //70MHz
//  RCC_OscInitStruct.PLL.PLLN = 260; //65MHz
//  RCC_OscInitStruct.PLL.PLLN = 240; //60MHz
//  RCC_OscInitStruct.PLL.PLLN = 200; //55MHz

  RCC_OscInitStruct.PLL.PLLN = 400;

  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;
  RCC_OscInitStruct.PLL.PLLQ = 8;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_3) != HAL_OK)
  {
    Error_Handler();
  }

  /**Configure the Systick interrupt time*/
	HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq()/1000);
	  /**Configure the Systick */
	HAL_SYSTICK_CLKSourceConfig(SYSTICK_CLKSOURCE_HCLK);
	/* SysTick_IRQn interrupt configuration */
	HAL_NVIC_SetPriority(SysTick_IRQn, 15, 0);

}


void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
	if (htim->Instance == TIM1) {
		HAL_IncTick();
	}
}


/**
  * @brief SPI4 Initialization Function
  * @param None
  * @retval None
  */
static void MX_SPI4_Init(void)
{

  /* SPI4 parameter configuration*/
  hspi4.Instance = SPI4;
  hspi4.Init.Mode = SPI_MODE_SLAVE;
  hspi4.Init.Direction = SPI_DIRECTION_2LINES_RXONLY;
  hspi4.Init.DataSize = SPI_DATASIZE_16BIT;
  hspi4.Init.CLKPolarity = SPI_POLARITY_LOW;
  hspi4.Init.CLKPhase = SPI_PHASE_1EDGE;
  hspi4.Init.NSS = SPI_NSS_SOFT;
  hspi4.Init.FirstBit = SPI_FIRSTBIT_MSB;
  hspi4.Init.TIMode = SPI_TIMODE_DISABLE;
  hspi4.Init.CRCCalculation = SPI_CRCCALCULATION_DISABLE;
  hspi4.Init.CRCPolynomial = 10;
  if (HAL_SPI_Init(&hspi4) != HAL_OK)
  {
	Error_Handler();
  }
}

/**
  * @brief USART2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART2_UART_Init(void)
{

  huart2.Instance = USART2;
  huart2.Init.BaudRate = 921600;
  huart2.Init.WordLength = UART_WORDLENGTH_8B;
  huart2.Init.StopBits = UART_STOPBITS_1;
  huart2.Init.Parity = UART_PARITY_NONE;
  huart2.Init.Mode = UART_MODE_TX_RX;
  huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart2.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart2) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * Enable DMA controller clock
  */
static void MX_DMA_Init(void)
{

  /* DMA controller clock enable */
  __HAL_RCC_DMA2_CLK_ENABLE();

  /* DMA interrupt init */


  /* DMA2_Stream3_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(DMA2_Stream3_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(DMA2_Stream3_IRQn);


}


//INIT THE WFM PINs THAT ARE NOT SPI RELATED
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOH_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(WFM_NSS_GPIO_Port, WFM_NSS_Pin, GPIO_PIN_SET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(WFM_RESET_GPIO_Port, WFM_RESET_Pin, GPIO_PIN_RESET);


  //  /*Configure GPIO pin Output Level */
//  HAL_GPIO_WritePin(WFM_GPIO_WIRQ_Port, WFM_GPIO_WIRQ_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin : WFM_NSS_Pin */
  GPIO_InitStruct.Pin = WFM_NSS_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
  HAL_GPIO_Init(WFM_NSS_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pin : WFM_RESET_Pin */
  GPIO_InitStruct.Pin = WFM_RESET_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
  HAL_GPIO_Init(WFM_RESET_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pin : WFM_RESET_Pin */
   GPIO_InitStruct.Pin = WFM_WUP_Pin;
   GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
   GPIO_InitStruct.Pull = GPIO_NOPULL;
   GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
   HAL_GPIO_Init(WFM_WUP_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pin : WFM_SPI_WIRQ_Pin */
  GPIO_InitStruct.Pin = WFM_SPI_WIRQ_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_IT_RISING;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(WFM_SPI_WIRQ_Port, &GPIO_InitStruct);


  /*Configure GPIO pin: RHD_CS */
  GPIO_InitStruct.Pin = UDP_TASK_SCOPE_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
  HAL_GPIO_Init(UDP_TASK_SCOPE_Port, &GPIO_InitStruct);

  /*Configure GPIO pin: RHD_CS */
  GPIO_InitStruct.Pin = SPI_TASK_SCOPE_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
  HAL_GPIO_Init(SPI_TASK_SCOPE_Port, &GPIO_InitStruct);

  /*Configure GPIO pin: RHD_CS */
  GPIO_InitStruct.Pin = FULL_TASK_SCOPE_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
  HAL_GPIO_Init(FULL_TASK_SCOPE_Port, &GPIO_InitStruct);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(UDP_TASK_SCOPE_Port, UDP_TASK_SCOPE_Pin, GPIO_PIN_RESET);
  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(UDP_TASK_SCOPE_Port, UDP_TASK_SCOPE_Pin, GPIO_PIN_SET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(SPI_TASK_SCOPE_Port, SPI_TASK_SCOPE_Pin, GPIO_PIN_RESET);
  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(SPI_TASK_SCOPE_Port, SPI_TASK_SCOPE_Pin, GPIO_PIN_SET);


  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(FULL_TASK_SCOPE_Port, FULL_TASK_SCOPE_Pin, GPIO_PIN_RESET);
  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(FULL_TASK_SCOPE_Port, FULL_TASK_SCOPE_Pin, GPIO_PIN_SET);


  /*Configure GPIO pin : WFM_WIRQ_Pin */
//  GPIO_InitStruct.Pin = WFM_GPIO_WIRQ_Pin;
//  GPIO_InitStruct.Mode = GPIO_MODE_IT_RISING;
//  GPIO_InitStruct.Pull = GPIO_NOPULL;
//  HAL_GPIO_Init(WFM_GPIO_WIRQ_Port, &GPIO_InitStruct);

  /* EXTI interrupt init*/
//  HAL_NVIC_SetPriority(EXTI15_10_IRQn, 10, 0);
//  HAL_NVIC_EnableIRQ(EXTI15_10_IRQn);

}


/**
  * @brief  Retargets the C library printf function to the USART.
  * @param  None
  * @retval None
  */
PUTCHAR_PROTOTYPE
{
  /* Place your implementation of fputc here */
  /* e.g. write a character to the USART3 and Loop until the end of transmission */
  HAL_UART_Transmit(&huart2, (uint8_t *)&ch, 1, 0xFFFF);

  return ch;
}


/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
