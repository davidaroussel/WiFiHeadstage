/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
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
/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "../Intan/Intan_utils.h"
#include "../Intan/RHS_Driver.h"
#include "../Intan/RHD_Driver.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
#define ID_PATATO  0xF5
#define ID_POTATO  0x3B

#define FPGA_CHUNK_SIZE 2048
#define FPGA_ACCUM_SIZE 4096
#define STACK_SIZE FPGA_ACCUM_SIZE / FPGA_CHUNK_SIZE

#define SPI_RX_FPGA_BUFFER_SIZE FPGA_CHUNK_SIZE
uint8_t spi_rx_fpga_buffer[SPI_RX_FPGA_BUFFER_SIZE];

#define SPI_TX_FPGA_BUFFER_SIZE FPGA_CHUNK_SIZE
uint8_t spi_tx_fpga_buffer[SPI_TX_FPGA_BUFFER_SIZE];


#define NRF_FRAME_SIZE FPGA_ACCUM_SIZE
uint8_t fpga_accum_buffer[FPGA_ACCUM_SIZE];
uint32_t fpga_accum_index = 0;

uint8_t nrf_tx_buffer[NRF_FRAME_SIZE];
uint8_t nrf_rx_buffer[NRF_FRAME_SIZE];



/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
SPI_HandleTypeDef hspi1;
SPI_HandleTypeDef hspi4;
DMA_HandleTypeDef hdma_spi1_rx;
DMA_HandleTypeDef hdma_spi1_tx;
DMA_HandleTypeDef hdma_spi4_rx;
DMA_HandleTypeDef hdma_spi4_tx;

UART_HandleTypeDef huart2;

TIM_HandleTypeDef htim11;

/* USER CODE BEGIN PV */
#ifdef __GNUC__
/* With GCC, small printf (option LD Linker->Libraries->Small printf
   set to 'Yes') calls __io_putchar() */
#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif /* __GNUC__ */

void HAL_SPI_RxCpltCallback(SPI_HandleTypeDef *hspi);
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_DMA_Init(void);
static void MX_USART2_UART_Init(void);
static void SPI4_Master_Init(void);
static void SPI4_Slave_Init(void);
static void MX_SPI1_Init(void);
static void Prepare_nRF_Frame(void);
static void Check_nRF_Message(void);
static void Init_Intan_RHS(void);
/* USER CODE BEGIN PFP */
static void MX_TIM11_Init(void);
/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */


volatile uint8_t spi_fpga_ready = 0;
volatile uint8_t spi_nrf_ready = 0;
volatile uint32_t spi_counter = 0;
volatile uint8_t fpga_frame_ready = 0;

static boolean test_stim = 0;
static boolean MEP_Mode  = 0;
static boolean Z_Mode    = 0;



/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */
  /* USER CODE BEGIN 2 */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  for (int i=0; i<NRF_FRAME_SIZE; i++){
	  nrf_tx_buffer[i] = i%255;
  }


  /* Initialize all configured peripherals */
  MX_GPIO_Init();

  MX_DMA_Init();
  if(DEVKIT){
	 MX_USART2_UART_Init();
  }
  MX_SPI1_Init();

  HAL_GPIO_WritePin(FPGA_MUX_4_GPIO_Port, FPGA_MUX_4_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(FPGA_MUX_5_GPIO_Port, FPGA_MUX_5_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(RHS_Chip_SEL_Port, RHS_Chip_SEL_Pin,  GPIO_PIN_SET);  //LOW: 0-15 CHANNEL (RED) || HIGH: 16:31 (GREEN)
  HAL_GPIO_WritePin(RDY_nRF_GPIO_Port, RDY_nRF_Pin, GPIO_PIN_SET);
  SPI_HandleTypeDef *hspi;
  hspi = &hspi4;   //PASSTHROUGH
//hspi = &hspi3; //NOT PASSTHROUGH    NEED TO CHANGE STUFF IN SPI_SEND_RECV
  HAL_Delay(500);

  Init_Intan_RHS();

	if(test_stim)
	{  	//GABRIEL QUESTIONS: MIN-MAX TESTÉ
		//Test electrical stimulation
		HAL_TIM_Base_Start_IT(&htim11);
		uint16_t p_activated_channels = 0x0001;
		uint32_t p_period_us = 10000;
		uint32_t p_pulse_width_us = 100;
		uint32_t p_dead_zone_us = 100;
		CURRENT_STEP_SIZE p_nA_stepsize = Curr_10000nA;
		uint8_t p_current_amplitude = 0b00000010;
		uint32_t p_callback_period_us = 10;
		RHS2116_setup_stim_pattern(hspi, p_activated_channels, p_period_us, p_pulse_width_us, p_dead_zone_us, p_nA_stepsize, p_current_amplitude, p_callback_period_us);
	//		RHS2116_start_stim_pattern(hspi);
		while(1){
			RHS2116_start_stim_pattern_single_shot(hspi);
			HAL_Delay(10);
		}
	}
	else if (MEP_Mode){
		HAL_TIM_Base_Start_IT(&htim11);
		uint8_t CHANNEL = 1;
		uint32_t STIM_CURRENT_uA = 30;
		RHS2116_MEP_Config_Params();
		RHS2116_MEP_Run_Stimulation(hspi, CHANNEL, STIM_CURRENT_uA);

	}
	else if (Z_Mode)
	{	if(DEVKIT){
			printf("Impedance Measurement \r\n");
		}
		HAL_TIM_Base_Start_IT(&htim11);
		uint8_t testing_channel = 0;
		uint8_t testing_time = 2;
	//Test electrode impedance measurement
		for (int i = 0; i<1000; i++)
		{
			uint16_t impedance = RHS2116_Electrode_Impedance_Test(hspi, testing_channel, testing_time);
			if(DEVKIT){
				printf("Measured impredance: %d \r\n", impedance);
			}
		}
	}
	else{
		  if (HAL_SPI_TransmitReceive_DMA(&hspi4, spi_tx_fpga_buffer, spi_rx_fpga_buffer, SPI_RX_FPGA_BUFFER_SIZE) != HAL_OK) {
		      printf("[ERROR] SPI DMA transmit/receive failed!\r\n");
		      Error_Handler();
		  }
		    printf("[INFO] Sending RDY_FPGA signal...\r\n");
		  //  HAL_Delay(1000);

		    HAL_GPIO_WritePin(FPGA_MUX_4_GPIO_Port, FPGA_MUX_4_Pin, GPIO_PIN_SET);
		    HAL_GPIO_WritePin(FPGA_MUX_5_GPIO_Port, FPGA_MUX_5_Pin, GPIO_PIN_SET);
		    printf("[INFO] RDY_FPGA pin set LOW.\r\n");
	}




  while (1)
  {
	  if (spi_fpga_ready)
	  {

		  spi_fpga_ready = 0;

		  memcpy(&fpga_accum_buffer[fpga_accum_index],
				 spi_rx_fpga_buffer,
				 SPI_RX_FPGA_BUFFER_SIZE);

		  fpga_accum_index += SPI_RX_FPGA_BUFFER_SIZE;

		  if (fpga_accum_index >= FPGA_ACCUM_SIZE)
		  {
			  fpga_accum_index = 0;
			  fpga_frame_ready = 1;   // mark frame complete
			  HAL_GPIO_WritePin(RDY_nRF_GPIO_Port, RDY_nRF_Pin, GPIO_PIN_SET);
		  }
	  }

	  if (fpga_frame_ready)
	  {
		  HAL_SPI_TransmitReceive_DMA(&hspi4, spi_tx_fpga_buffer, spi_rx_fpga_buffer, SPI_RX_FPGA_BUFFER_SIZE);
		  if (spi_counter == STACK_SIZE){
			  spi_nrf_ready = 1;
			  spi_counter = 0;
		  }

		  HAL_GPIO_WritePin(RDY_nRF_GPIO_Port, RDY_nRF_Pin, GPIO_PIN_SET);
		  fpga_frame_ready = 0;
		  spi_nrf_ready = 1;
	  }

	  if (spi_nrf_ready)
	  {
	      spi_nrf_ready = 0;

	      Prepare_nRF_Frame();

	      HAL_SPI_TransmitReceive_DMA( &hspi1,nrf_tx_buffer, nrf_rx_buffer, NRF_FRAME_SIZE);

	      HAL_GPIO_WritePin(RDY_nRF_GPIO_Port, RDY_nRF_Pin, GPIO_PIN_RESET);
	  }
  }

  /* USER CODE END 3 */
}


void SystemClock_Config(void)
{
    RCC_OscInitTypeDef RCC_OscInitStruct = {0};
    RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

    //		FOR DEVKIT
    if (DEVKIT == 1){
		/** Configure the main internal regulator output voltage
		*/
		__HAL_RCC_PWR_CLK_ENABLE();
		__HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

		/** Initializes the RCC Oscillators according to the specified parameters
		* in the RCC_OscInitTypeDef structure.
		*/
		RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
		RCC_OscInitStruct.HSIState = RCC_HSI_ON;
		RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
		RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
		RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
		RCC_OscInitStruct.PLL.PLLM = 8;
		RCC_OscInitStruct.PLL.PLLN = 200;
		RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;
		RCC_OscInitStruct.PLL.PLLQ = 4;
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

    }
//		FOR HEADSTAGE !!!
    else if (DEVKIT == 0){


		/** Configure the main internal regulator output voltage */
		__HAL_RCC_PWR_CLK_ENABLE();
		__HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

		/** Initializes the RCC Oscillators according to the specified parameters */
		RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
		RCC_OscInitStruct.HSEState = RCC_HSE_ON;
		RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
		RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
		RCC_OscInitStruct.PLL.PLLQ = 4;
		RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;

	//    RCC_OscInitStruct.PLL.PLLM = 25;
	//    RCC_OscInitStruct.PLL.PLLN = 280;    // SYSCLK = 70 MHz

			RCC_OscInitStruct.PLL.PLLM = 25;
			RCC_OscInitStruct.PLL.PLLN = 264;  // SYSCLK = 66 MHz

//	    RCC_OscInitStruct.PLL.PLLM = 25;
//	    RCC_OscInitStruct.PLL.PLLN = 240;      // SYSCLK = 60 MHz

	//    RCC_OscInitStruct.PLL.PLLM = 16;
	//	RCC_OscInitStruct.PLL.PLLN = 128;      // SYSCLK = 50 MHz

	//	RCC_OscInitStruct.PLL.PLLM = 25;
	//	RCC_OscInitStruct.PLL.PLLN = 192;      // SYSCLK = 48 MHz

	//    RCC_OscInitStruct.PLL.PLLM = 25;
	//    RCC_OscInitStruct.PLL.PLLN = 168;    // SYSCLK = 42 MHz

		if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
		{
			Error_Handler();
		}

		/** Initializes the CPU, AHB and APB buses clocks */
		RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK
									| RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
		RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
		RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
		RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
		RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

		if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_3) != HAL_OK)
		{
			Error_Handler();
		}
    }
}
/**
  * @brief SPI1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_SPI1_Init(void)
{

  /* USER CODE BEGIN SPI1_Init 0 */

  /* USER CODE END SPI1_Init 0 */

  /* USER CODE BEGIN SPI1_Init 1 */

  /* USER CODE END SPI1_Init 1 */
  /* SPI1 parameter configuration*/
    hspi1.Instance = SPI1;
	hspi1.Init.Mode = SPI_MODE_SLAVE;
	hspi1.Init.Direction = SPI_DIRECTION_2LINES;
	hspi1.Init.DataSize = SPI_DATASIZE_8BIT;
	hspi1.Init.CLKPolarity = SPI_POLARITY_LOW;
	hspi1.Init.CLKPhase = SPI_PHASE_1EDGE;
	hspi1.Init.NSS = SPI_NSS_HARD_INPUT;  // SLAVE → external NSS
	hspi1.Init.FirstBit = SPI_FIRSTBIT_MSB;
	hspi1.Init.TIMode = SPI_TIMODE_DISABLE;
	hspi1.Init.CRCCalculation = SPI_CRCCALCULATION_DISABLE;
	hspi1.Init.CRCPolynomial = 10;

  if (HAL_SPI_Init(&hspi1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN SPI1_Init 2 */

  /* USER CODE END SPI1_Init 2 */

}

static void SPI4_Master_Init(void)
{
	  /* SPI4 parameter configuration */
	  hspi4.Instance = SPI4;
	  hspi4.Init.Mode = SPI_MODE_MASTER;
	  hspi4.Init.Direction = SPI_DIRECTION_2LINES;
	  hspi4.Init.DataSize = SPI_DATASIZE_16BIT;
	  hspi4.Init.CLKPolarity = SPI_POLARITY_LOW;  // Set CPOL = 0
	  hspi4.Init.CLKPhase = SPI_PHASE_1EDGE;       // Set CPHA = 0
	  hspi4.Init.NSS = SPI_NSS_SOFT;
	  if (DEVKIT){
		  hspi4.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_32;
	  }
	  else{
		  hspi4.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_8;
	  }
	  hspi4.Init.FirstBit = SPI_FIRSTBIT_MSB;
	  hspi4.Init.TIMode = SPI_TIMODE_DISABLE;
	  hspi4.Init.CRCCalculation = SPI_CRCCALCULATION_DISABLE;
	  hspi4.Init.CRCPolynomial = 10;

	  if (HAL_SPI_Init(&hspi4) != HAL_OK)
	  {
	    Error_Handler();
	  }

	GPIO_InitTypeDef GPIO_InitStruct = {0};
	GPIO_InitStruct.Pin   = RHS_SPI_CS_Pin;
	GPIO_InitStruct.Mode  = GPIO_MODE_OUTPUT_PP;
	GPIO_InitStruct.Pull  = GPIO_NOPULL;
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
	HAL_GPIO_Init(RHS_SPI_CS_Port, &GPIO_InitStruct);
}


static void SPI4_Slave_Init(void)
{
    hspi4.Instance = SPI4;
    hspi4.Init.Mode = SPI_MODE_SLAVE;
    hspi4.Init.Direction = SPI_DIRECTION_2LINES;
    hspi4.Init.DataSize = SPI_DATASIZE_8BIT;
    hspi4.Init.CLKPolarity = SPI_POLARITY_LOW;
    hspi4.Init.CLKPhase = SPI_PHASE_1EDGE;
    hspi4.Init.NSS = SPI_NSS_HARD_INPUT;  // SLAVE → external NSS
    hspi4.Init.FirstBit = SPI_FIRSTBIT_MSB;
    hspi4.Init.TIMode = SPI_TIMODE_DISABLE;
    hspi4.Init.CRCCalculation = SPI_CRCCALCULATION_DISABLE;
    hspi4.Init.CRCPolynomial = 10;

    if (HAL_SPI_Init(&hspi4) != HAL_OK){
        Error_Handler();
    }
    GPIO_InitTypeDef GPIO_InitStruct = {0};
	GPIO_InitStruct.Pin = RHS_SPI_CS_Pin;
	GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
	GPIO_InitStruct.Pull = GPIO_NOPULL;
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
	GPIO_InitStruct.Alternate = GPIO_AF6_SPI4;
	HAL_GPIO_Init(RHS_SPI_CS_Port, &GPIO_InitStruct);
}
/**
  * @brief USART2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART2_UART_Init(void)
{

  /* USER CODE BEGIN USART2_Init 0 */

  /* USER CODE END USART2_Init 0 */

  /* USER CODE BEGIN USART2_Init 1 */

  /* USER CODE END USART2_Init 1 */
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
  /* USER CODE BEGIN USART2_Init 2 */

  /* USER CODE END USART2_Init 2 */

}

/**
  * Enable DMA controller clock
  */
static void MX_DMA_Init(void)
{

  /* DMA controller clock enable */
  __HAL_RCC_DMA2_CLK_ENABLE();

  /* DMA interrupt init */
  /* DMA2_Stream0_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(DMA2_Stream0_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(DMA2_Stream0_IRQn);
  /* DMA2_Stream1_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(DMA2_Stream1_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(DMA2_Stream1_IRQn);
  /* DMA2_Stream2_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(DMA2_Stream2_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(DMA2_Stream2_IRQn);
  /* DMA2_Stream3_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(DMA2_Stream3_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(DMA2_Stream3_IRQn);

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};
/* USER CODE BEGIN MX_GPIO_Init_1 */
/* USER CODE END MX_GPIO_Init_1 */

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOH_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(FPGA_MUX_4_GPIO_Port, FPGA_MUX_4_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(FPGA_MUX_5_GPIO_Port, FPGA_MUX_5_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(RHS_Chip_SEL_Port, RHS_Chip_SEL_Pin, GPIO_PIN_SET);  //IS USED AS CTRL_IN FOR THIS CASE
  HAL_GPIO_WritePin(RDY_nRF_GPIO_Port, RDY_nRF_Pin, GPIO_PIN_SET);

  /*Configure GPIO pins : RDY_nRF_Pin FPGA_MUX_5_Pin FPGA_MUX_4_Pin */
  GPIO_InitStruct.Pin = RDY_nRF_Pin|FPGA_MUX_5_Pin|FPGA_MUX_4_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);


  /*Configure GPIO pin : PC11 --- CONFIRM FOR HEADSTAGE, USE SECOND MISO !!*/
  GPIO_InitStruct.Pin = RHS_Chip_SEL_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(RHS_Chip_SEL_Port, &GPIO_InitStruct);


/* USER CODE BEGIN MX_GPIO_Init_2 */
/* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */
void HAL_SPI_TxRxCpltCallback(SPI_HandleTypeDef *hspi)
{
    if (hspi->Instance == SPI1)
    {
    	uint8_t testing = 0;

    }

    else  if (hspi->Instance == SPI4)
    {
        spi_counter++;
        spi_fpga_ready = 1;
//        printf("SPI_COUNTER %i \r\n", spi_counter);
        // Restart DMA immediately
    }
}


static void Prepare_nRF_Frame(void)
{
//	printf("PREPARE FRAME \r\n");

	memcpy(nrf_tx_buffer, fpga_accum_buffer, FPGA_ACCUM_SIZE);


//	for(int i=0; i<FPGA_ACCUM_SIZE; i+=2)
//		printf("%02X%02X ", nrf_tx_buffer[nrf_write_idx][i], nrf_tx_buffer[nrf_write_idx][i+1]);
//	printf("\r\n");
//	printf("\r\n");
//    printf("%02X%02X %02X%02X %02X%02X %02X%02X", nrf_tx_buffer[0], nrf_tx_buffer[1], nrf_tx_buffer[64], nrf_tx_buffer[65], nrf_tx_buffer[128], nrf_tx_buffer[129], nrf_tx_buffer[192], nrf_tx_buffer[193]);
//    printf("\r\n");

//    for (int i = 0; i<NRF_FRAME_SIZE; i+=64){
//    	printf("%02X%02X ", nrf_tx_buffer[i], nrf_tx_buffer[i+1]);
//    }
//    printf("--------------------------------------------------------------------------");
//    printf("\r\n");
//    printf("\r\n");
}




static void Init_Intan_RHS(void){

	SPI_HandleTypeDef *hspi;
	hspi = &hspi4;   //PASSTHROUGH

	uint16_t init_check = 0xFFFF;

	if (DUAL_CHIP){
		HAL_SPI_DeInit(hspi);

		SPI4_Master_Init(); //PASSTHROUGH
		MX_TIM11_Init();

		SET_BIT(hspi->Instance->CR1, SPI_CR1_SPE);
		hspi->Instance->CR1 |= SPI_CR1_DFF;

		printf("Init First RHS \r\n");
		HAL_Delay(500);
		HAL_GPIO_WritePin(RHS_Chip_SEL_Port, RHS_Chip_SEL_Pin, GPIO_PIN_SET);  //LOW: 0-15 CHANNEL (RED) || HIGH: 16:31 (GREEN)
		HAL_Delay(500);


		while (init_check == 0xFFFF) {
		init_check = INIT_RHS(hspi);
		}

		printf("Init Second RHS \r\n");
		HAL_Delay(500);
		HAL_GPIO_WritePin(RHS_Chip_SEL_Port, RHS_Chip_SEL_Pin, GPIO_PIN_RESET);  //LOW: 0-15 CHANNEL (RED) || HIGH: 16:31 (GREEN)
		HAL_Delay(500);

		init_check = 0xFFFF;
		while (init_check == 0xFFFF) {
		init_check = INIT_RHS(hspi);
		}
		if (!MEP_Mode && !Z_Mode && !test_stim){
			// De-init SPI before changing mode
			HAL_SPI_DeInit(&hspi4);
			printf("[INFO] SPI deinitialized.\r\n");
			//  HAL_Delay(1000);

			// Re-init as SLAVE
			SPI4_Slave_Init();
			printf("[INFO] SPI SLAVE mode initialized.\r\n");
		}


	}else{
		HAL_SPI_DeInit(hspi);

		SPI4_Master_Init(); //PASSTHROUGH
		HAL_GPIO_WritePin(RHS_SPI_CS_Port, RHS_SPI_CS_Pin, 1);
		MX_TIM11_Init();
		printf("Init RHS \r\n");

		SET_BIT(hspi->Instance->CR1, SPI_CR1_SPE);
		hspi->Instance->CR1 |= SPI_CR1_DFF;
		HAL_GPIO_WritePin(RHS_Chip_SEL_Port, RHS_Chip_SEL_Pin, GPIO_PIN_SET);
		while (init_check == 0xFFFF) {
		init_check = INIT_RHS(hspi);
		}

		HAL_Delay(1);

		if (!MEP_Mode && !Z_Mode && !test_stim){
			// De-init SPI before changing mode
			HAL_SPI_DeInit(&hspi4);
			printf("[INFO] SPI deinitialized.\r\n");
			//  HAL_Delay(1000);

			// Re-init as SLAVE
			SPI4_Slave_Init();
			printf("[INFO] SPI SLAVE mode initialized.\r\n");
		}
	}

}


static void MX_TIM11_Init(void)
{

  /* USER CODE BEGIN TIM11_Init 0 */

  /* USER CODE END TIM11_Init 0 */

  /* USER CODE BEGIN TIM11_Init 1 */

  /* USER CODE END TIM11_Init 1 */
  htim11.Instance = TIM11;
  htim11.Init.Prescaler = 0;
  htim11.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim11.Init.Period = 1000;
  htim11.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim11.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim11) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM11_Init 2 */

  /* USER CODE END TIM11_Init 2 */

}


/**
  * @brief  Retargets the C library printf function to the USART.
  * @param  None
  * @retval None
  */
PUTCHAR_PROTOTYPE
{
  /* Place your implementation of fputc here */
  /* e.g. write a character to the USART2 and Loop until the end of transmission */
  HAL_UART_Transmit(&huart2, (uint8_t *)&ch, 1, 0xFFFF);

  return ch;
}


/* USER CODE END 4 */

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
