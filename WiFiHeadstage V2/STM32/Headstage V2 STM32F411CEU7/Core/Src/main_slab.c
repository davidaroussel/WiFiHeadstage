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


/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
//#define SPI_RX_FPGA_BUFFER_SIZE 256
//uint8_t spi_rx_fpga_buffer[SPI_RX_FPGA_BUFFER_SIZE];

#define SPI_TX_FPGA_BUFFER_SIZE 256
uint8_t spi_tx_fpga_buffer[SPI_TX_FPGA_BUFFER_SIZE];


#define SPI_RX_nRF_BUFFER_SIZE 8192
uint8_t spi_rx_nrf_buffer[SPI_RX_nRF_BUFFER_SIZE];

#define SPI_TX_nRF_BUFFER_SIZE 8192
uint8_t spi_tx_nrf_buffer[SPI_TX_nRF_BUFFER_SIZE];

//#define FPGA_CHUNK_SIZE 256
//#define FPGA_ACCUM_SIZE 8192
//#define NRF_FRAME_SIZE 8192

//uint8_t fpga_accum_buffer[FPGA_ACCUM_SIZE];
//uint32_t fpga_accum_index = 0;
//uint8_t nrf_tx_buffer[NRF_FRAME_SIZE];
uint8_t nrf_rx_buffer[SPI_TX_nRF_BUFFER_SIZE];

#define SLAB_COUNT     4
#define SLAB_SIZE      8192
#define FPGA_CHUNK_SIZE 256
#define FPGA_CHUNKS_PER_SLAB (SLAB_SIZE / FPGA_CHUNK_SIZE)

typedef enum {
    SLAB_FREE = 0,
    SLAB_FILLING,
    SLAB_READY,
    SLAB_TX
} slab_state_t;

typedef struct {
    uint8_t     data[SLAB_SIZE];
    volatile slab_state_t state;
    volatile uint16_t     chunk_index;
} fpga_slab_t;

fpga_slab_t slabs[SLAB_COUNT] __attribute__((aligned(4)));

volatile uint8_t current_rx_slab = 0;
volatile uint8_t current_tx_slab = 0;

volatile uint8_t spi_fpga_ready = 0;
volatile uint8_t spi_nrf_ready  = 0;
volatile uint8_t reset_spi_flag = 0;

//init everythinb at zero
//slab.malloc


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

/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_DMA_Init(void);
static void SPI4_Master_Init(void);
static void SPI4_Slave_Init(void);
static void MX_SPI1_Init(void);
static void Prepare_nRF_Frame(fpga_slab_t *slab);
static void Reset_All_SPI_Links(void);
static void Init_Intan(void);
static void Slab_Init(void);
static int Find_Free_Slab(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
//volatile uint8_t spi_fpga_ready = 0;
//volatile uint8_t spi_nrf_ready = 0;
volatile uint32_t spi_counter = 0;
//volatile uint8_t fpga_frame_ready = 0;
//volatile uint8_t reset_spi_flag = 0;
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

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */
  for (int i=0; i<SPI_TX_FPGA_BUFFER_SIZE; i++){
 	  spi_tx_fpga_buffer[i] = 0x33;
   }

   for (uint32_t i = 0; i < SPI_TX_nRF_BUFFER_SIZE; i++) {
       spi_tx_nrf_buffer[i] = i%255;
   }


//   uint8_t fpga_nrf_loops = SPI_RX_nRF_BUFFER_SIZE / SPI_RX_FPGA_BUFFER_SIZE;

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_SPI1_Init();
  /* USER CODE BEGIN 2 */

  Slab_Init();
  current_rx_slab = 0;
  slabs[0].state = SLAB_FILLING;
  slabs[0].chunk_index = 0;

  //FOR THE NRF TO WAIT UNTIL EVERYTHING IS READY
  HAL_GPIO_WritePin(FPGA_MUX_4_GPIO_Port, FPGA_MUX_4_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(FPGA_MUX_5_GPIO_Port, FPGA_MUX_5_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(RDY_nRF_GPIO_Port, RDY_nRF_Pin, GPIO_PIN_SET);


  Init_Intan();


  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
	  if(reset_spi_flag){
		  NVIC_SystemReset();
		  reset_spi_flag = 0;

	  }
/* USER CODE END WHILE */
	  if (spi_nrf_ready) {
		  spi_nrf_ready = 0;
//		  printf("%d \r\n", current_tx_slab);
		  fpga_slab_t *tx_slab = &slabs[current_tx_slab];

	  if (tx_slab->state == SLAB_READY) {

		// Add header/footer without touching RX data
		Prepare_nRF_Frame(tx_slab);
		tx_slab->state = SLAB_TX;

		HAL_GPIO_WritePin(RDY_nRF_GPIO_Port, RDY_nRF_Pin, GPIO_PIN_SET);

		// Debug: first 8 bytes
//		printf("TX sanity: %02X %02X %02X %02X - %02X %02X %02X %02X\r\n",
//			   tx_slab->data[0], tx_slab->data[1], tx_slab->data[2], tx_slab->data[3],
//			   tx_slab->data[4], tx_slab->data[5], tx_slab->data[6], tx_slab->data[7]);

//		printf("TX sanity full slab (slab=%d):\r\n", current_tx_slab);
//		for (int i = 0; i < SLAB_SIZE; i += 16) {
//			for (int j = 0; j < 16; j++) {
//				printf("%02X ", tx_slab->data[i + j]);
//			}
//			printf("\r\n");
//		}
//		printf("--------------------------------------------\r\n");

		// Send full slab over SPI1
		HAL_SPI_TransmitReceive_DMA(&hspi1, tx_slab->data, nrf_rx_buffer, SLAB_SIZE);

		HAL_GPIO_WritePin(RDY_nRF_GPIO_Port, RDY_nRF_Pin, GPIO_PIN_RESET);

		tx_slab->state = SLAB_FREE;
		tx_slab->chunk_index = 0;

		// Move to next TX slab
		current_tx_slab = (current_tx_slab + 1) % SLAB_COUNT;
	  }

	 }
  }
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
    RCC_OscInitTypeDef RCC_OscInitStruct = {0};
    RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

    /** Configure the main internal regulator output voltage */
    __HAL_RCC_PWR_CLK_ENABLE();
    __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

    /** Initializes the RCC Oscillators according to the specified parameters */
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLQ = 4;

//    RCC_OscInitStruct.PLL.PLLM = 25;
//    RCC_OscInitStruct.PLL.PLLN = 320;    // SYSCLK = 80 MHz Not Working
//    RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;

//    RCC_OscInitStruct.PLL.PLLM = 16;
//    RCC_OscInitStruct.PLL.PLLN = 192;    // SYSCLK = 75 MHz Not Working
//    RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;


//    RCC_OscInitStruct.PLL.PLLM = 25;
//    RCC_OscInitStruct.PLL.PLLN = 280;    // SYSCLK = 70 MHz
//    RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;

    RCC_OscInitStruct.PLL.PLLM = 25;
    RCC_OscInitStruct.PLL.PLLN = 240;    // SYSCLK = 60 MHz
    RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;
//
//    RCC_OscInitStruct.PLL.PLLM = 16;
//	RCC_OscInitStruct.PLL.PLLN = 128;    // SYSCLK = 50 MHz
//	RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;


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
  hspi1.Init.NSS = SPI_NSS_HARD_INPUT;
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

/**
  * @brief SPI4 Initialization Function
  * @param None
  * @retval None
  */
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
	  hspi4.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_8;
	  hspi4.Init.FirstBit = SPI_FIRSTBIT_MSB;
	  hspi4.Init.TIMode = SPI_TIMODE_DISABLE;
	  hspi4.Init.CRCCalculation = SPI_CRCCALCULATION_DISABLE;
	  hspi4.Init.CRCPolynomial = 10;

	  if (HAL_SPI_Init(&hspi4) != HAL_OK)
	  {
	    Error_Handler();
	  }

	GPIO_InitTypeDef GPIO_InitStruct = {0};
	GPIO_InitStruct.Pin   = RHD_SPI_CS_Pin;
	GPIO_InitStruct.Mode  = GPIO_MODE_OUTPUT_PP;
	GPIO_InitStruct.Pull  = GPIO_NOPULL;
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
	HAL_GPIO_Init(RHD_SPI_CS_Port, &GPIO_InitStruct);
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
	GPIO_InitStruct.Pin = RHD_SPI_CS_Pin;
	GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
	GPIO_InitStruct.Pull = GPIO_NOPULL;
	GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
	GPIO_InitStruct.Alternate = GPIO_AF6_SPI4;
	HAL_GPIO_Init(RHD_SPI_CS_Port, &GPIO_InitStruct);
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

void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
    if (GPIO_Pin == Reboot_SPI_Pin)
    {
    	reset_spi_flag = 1;
    }
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
  __HAL_RCC_GPIOH_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(RDY_nRF_GPIO_Port, RDY_nRF_Pin, GPIO_PIN_SET);
  HAL_GPIO_WritePin(FPGA_MUX_4_GPIO_Port, FPGA_MUX_4_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(FPGA_MUX_5_GPIO_Port, FPGA_MUX_5_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(debug_Port, debug_Pin, GPIO_PIN_SET);

  /*Configure GPIO pins : RDY_nRF_Pin FPGA_MUX_5_Pin FPGA_MUX_4_Pin */
  GPIO_InitStruct.Pin = RDY_nRF_Pin|FPGA_MUX_5_Pin|FPGA_MUX_4_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  GPIO_InitStruct.Pin = debug_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH;
  HAL_GPIO_Init(debug_Port, &GPIO_InitStruct);



//  GPIO_InitStruct.Pin = Reboot_SPI_Pin;
//  GPIO_InitStruct.Mode = GPIO_MODE_IT_FALLING;
//  GPIO_InitStruct.Pull = GPIO_NOPULL;
//  HAL_GPIO_Init(Reboot_SPI_Port, &GPIO_InitStruct);
//
//  HAL_NVIC_SetPriority(EXTI9_5_IRQn, 0, 0);
//  HAL_NVIC_EnableIRQ(EXTI9_5_IRQn);

  /* USER CODE BEGIN MX_GPIO_Init_2 */

  /* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */
void HAL_SPI_TxRxCpltCallback(SPI_HandleTypeDef *hspi)
{
    if (hspi->Instance == SPI1)
    {


    }

    else  if (hspi->Instance == SPI4)
    {
		fpga_slab_t *slab = &slabs[current_rx_slab];

		slab->chunk_index++;

		// Check if current slab is full
		if (slab->chunk_index >= FPGA_CHUNKS_PER_SLAB)
		{
			slab->state = SLAB_READY;
			spi_nrf_ready = 1;

			int free_index = Find_Free_Slab();
			if (free_index >= 0)
			{
				current_rx_slab = free_index;
				slab = &slabs[free_index];
				slab->state = SLAB_FILLING;
				slab->chunk_index = 0;
			}
			else
			{
				// No free slab: cap index
				slab->chunk_index = FPGA_CHUNKS_PER_SLAB - 1;
			}
		}

		// Schedule next chunk
		uint32_t offset = slab->chunk_index * FPGA_CHUNK_SIZE;
		uint8_t *rx_chunk = &slab->data[offset];
		HAL_SPI_TransmitReceive_DMA(&hspi4, spi_tx_fpga_buffer, rx_chunk, FPGA_CHUNK_SIZE);
    }
}

static void Init_Intan(void){
	  HAL_SPI_DeInit(&hspi4);


	  //GPIO PIN HIGH


	  //    Start SPI4 as MASTER
	  SPI4_Master_Init();
	//  HAL_Delay(1000);

	  HAL_Delay(1000);

	  SPI_HandleTypeDef *hspi = &hspi4;
	  int rhd_status = INIT_RHD(hspi);

	   //Poll for RHD detection
	  while (rhd_status == 0) {
		  rhd_status = INIT_RHD(hspi);
		  HAL_Delay(1);

		  //if not after 2 sec, retoggle GPIO
	  }

	//  HAL_Delay(500);

	  //GPIO PIN LOW

	  //ACTIVE 3.3V FPGA

	  // De-init SPI before changing mode
	  HAL_SPI_DeInit(&hspi4);
	//  HAL_Delay(3000);

	  // Re-init as SLAVE
	  SPI4_Slave_Init();

	  slabs[0].state = SLAB_FILLING;
	  current_rx_slab = 0;

	  HAL_SPI_TransmitReceive_DMA(&hspi4, spi_tx_fpga_buffer, slabs[0].data, FPGA_CHUNK_SIZE);



	//  HAL_Delay(500);
	  HAL_GPIO_WritePin(FPGA_MUX_4_GPIO_Port, FPGA_MUX_4_Pin, GPIO_PIN_SET);
	  HAL_GPIO_WritePin(FPGA_MUX_5_GPIO_Port, FPGA_MUX_5_Pin, GPIO_PIN_SET);


}


//static void Reset_All_SPI_Links(void)
//{
//
//
//    HAL_SPI_DMAStop(&hspi4);
//    HAL_SPI_Abort(&hspi4);
//    HAL_SPI_DeInit(&hspi4);
//
//    // Optional but STRONGLY recommended
//    __HAL_RCC_SPI4_FORCE_RESET();
//    __HAL_RCC_SPI4_RELEASE_RESET();
//
//    memset(spi_rx_fpga_buffer, 0, SPI_RX_FPGA_BUFFER_SIZE);
//    memset(spi_tx_fpga_buffer, 0, SPI_TX_FPGA_BUFFER_SIZE);
//    memset(fpga_accum_buffer,  0, FPGA_ACCUM_SIZE);
//
//    fpga_accum_index = 0;
//    spi_counter = 0;
//    spi_fpga_ready = 0;
//    fpga_frame_ready = 0;
//
//    SPI4_Slave_Init();
//
//    HAL_SPI_TransmitReceive_DMA(&hspi4, spi_tx_fpga_buffer, spi_rx_fpga_buffer, SPI_RX_FPGA_BUFFER_SIZE);
//
//    reset_spi_flag = 0;
//}


static void Slab_Init(void)
{
    for (int i = 0; i < SLAB_COUNT; i++) {
        slabs[i].state = SLAB_FREE;
        slabs[i].chunk_index = 0;
    }
}

static int Find_Free_Slab(void)
{
    for (int i = 0; i < SLAB_COUNT; i++) {
        if (slabs[i].state == SLAB_FREE)
            return i;
    }
    return -1;
}

static void Prepare_nRF_Frame(fpga_slab_t *slab)
{
    if (!slab || slab->state != SLAB_READY) return;

    uint8_t *buf = slab->data;  // pointer to slab DMA buffer

    // Move raw data to temporary buffer if needed (optional)
    // Here we keep zero-copy: header/footer added around existing data

    /* ---- Header ---- */
    buf[0] = 0xAA;
    buf[1] = 0x55;

    static uint16_t frame_id = 0;
    buf[2] = (frame_id >> 8) & 0xFF;
    buf[3] = frame_id & 0xFF;
    frame_id++;

    /* ---- Footer ---- */
    buf[SLAB_SIZE - 2] = 0x55;
    buf[SLAB_SIZE - 1] = 0xAA;
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
#ifdef USE_FULL_ASSERT
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
