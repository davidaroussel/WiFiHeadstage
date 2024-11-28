/*
 * spi_receive_task.c
 *
 *  Created on: Oct 2, 2022
 *      Author: david
 */

#include "Intan_utils.h"
#include "Task_RHD64_SPI_communication.h"
#include "stm32f4xx_hal.h"
#include "Task_FPGA_communication.h"
#include "Task_Apps_Start.h"

#define RHD64_ADC_CONVERSION 0.195


SemaphoreHandle_t spi_data_ready;



//#define udp_mode_only
extern SPI_HandleTypeDef hspi4;

extern bool spi_flag;

//extern osTimerId periodicTimerHandle;


void RHD64_SPI_COMMUNICATION_task_entry(void const *p_arg);



void INIT_RHD64(SPI_HandleTypeDef *hspi){
	uint16_t tx_vector[2];
	uint16_t rx_vector[2];
	uint8_t misosplit_a[2];
	uint8_t misosplit_b[2];
	uint8_t last_bit[1];


	for (int i = 0; i<3 ; i++){
		// Register 63 for DUMMY READ on BOOT
		tx_vector[0] = 0b1111111111111111;
		tx_vector[1] = 0b0000000000000000;
		SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	}

	// Register 0 - ADC config.
	tx_vector[0] = 0b1100000000000000;
	tx_vector[1] = 0b1111001111111100;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	// Register 1 - Supply sensor & ADC buffer bias current
	tx_vector[0] = 0b1100000000000011;
	tx_vector[1] = 0b0000110000000000; //(ADC BUFFER BIAS AT 32)
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	// Register 2 - MUX bias current
	tx_vector[0] = 0b1100000000001100;
	tx_vector[1] = 0b0000110011000000; //(MUX BIAS AT 40)
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	// Register 3 - MUX Load, Temp sensor, Aux digital output
	tx_vector[0] = 0b1100000000001111;
	tx_vector[1] = 0b0000000000001100;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	// Register 4 - ADC output format & DSP offset removal
	tx_vector[0] = 0b1100000000110000;
	tx_vector[1] = 0b1111001100111100;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	// Register 5 - Impedance check control
	tx_vector[0] = 0b1100000000110011;
	tx_vector[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	// Register 6 - Impedance check DAC [unchanged]
	tx_vector[0] = 0b1100000000111100;
	tx_vector[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	// Register 7 - Impedance check amplifier select [unchanged]
	tx_vector[0] = 0b1100000000111111;
	tx_vector[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	// Register 8-13 - On-chip amplifier bandwidth select
	// 	Reg. 8 -> 30
	tx_vector[0] = 0b1100000011000000;
	tx_vector[1] = 0b0000001111111100;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	// 	Reg. 9 -> 5
	tx_vector[0] = 0b1100000011000011;
	tx_vector[1] = 0b0000000000110011;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	//	Reg. 10 -> 43
	tx_vector[0] = 0b1100000011001100;
	tx_vector[1] = 0b0000110011001111;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	//	Reg. 11 -> 6
	tx_vector[0] = 0b1100000011001111;
	tx_vector[1] = 0b0000000000111100;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	// 	Reg. 12 -> 54
	tx_vector[0] = 0b1100000011110000;
	tx_vector[1] = 0b0000111100111100;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	// 	Reg. 13 -> 0
	tx_vector[0] = 0b1100000011110011;
	tx_vector[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	// Register 14-21 - Individual amplifier power
	//	Reg. 14
	tx_vector[0] = 0b1100000011111100;
	tx_vector[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	//	Reg. 15
	tx_vector[0] = 0b1100000011111111;
	tx_vector[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	//	Reg. 16
	tx_vector[0] = 0b1100001100000000;
	tx_vector[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	//	Reg. 17
	tx_vector[0] = 0b1100001100000011;
	tx_vector[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	//	Reg. 18
	tx_vector[0] = 0b1100001100001100;
	tx_vector[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	//	Reg. 19
	tx_vector[0] = 0b1100001100001111;
	tx_vector[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	//	Reg. 20
	tx_vector[0] = 0b1100001100110000;
	tx_vector[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	//	Reg. 21
	tx_vector[0] = 0b1100001100110011;
	tx_vector[1] = 0b1111111111111111;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	// Calibrate ADC
	HAL_Delay(100);
	tx_vector[0] = 0b0011001100110011;
	tx_vector[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);



	for (int i = 0; i<9 ; i++){
		// Register 63 for DUMMY READ on BOOT
		tx_vector[0] = 0b1111111111111111;
		tx_vector[1] = 0b0000000000000000;
		SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	}


	//Read Register 40
	tx_vector[0] = 0b1111110011000000;
	tx_vector[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	//Read Register 41
	tx_vector[0] = 0b1111110011000011;
	tx_vector[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	//Read Register 42
	tx_vector[0] = 0b1111110011001100;
	tx_vector[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);

	misosplit(rx_vector[1], &misosplit_a[0], &misosplit_b[0]);

//	printf("Sending Data to read Reg40: %x - %x \r\n",  tx_vector[0], tx_vector[1]);
//	printf("Receving Data: %x - %c / %x \r\n",  rx_vector[0],data, misosplit_b[0]);



	char data_a = misosplit_a[0];
	char data_b = misosplit_b[0];
//	printf("Char Receving Data: %c %c \r\n", data_a, data_b);
	printf("Char Receving Data:        %c \r\n", data_b);
	printf("Hex  Receving Data: 0x%x 0x%x \r\n", data_a, data_b);


	//Read Register 43
	tx_vector[0] = 0b1111110011001111;
	tx_vector[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	misosplit(rx_vector[1], &misosplit_a[0], &misosplit_b[0]);
	data_a = misosplit_a[0];
	data_b = misosplit_b[0];
//	printf("Char Receving Data: %c %c \r\n", data_a, data_b);
	printf("Char Receving Data:        %c \r\n", data_b);
	printf("Hex  Receving Data: 0x%x 0x%x \r\n", data_a, data_b);


	//Read Register 44
	tx_vector[0] = 0b1111110011110000;
	tx_vector[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	misosplit(rx_vector[1], &misosplit_a[0], &misosplit_b[0]);
	data_a = misosplit_a[0];
	data_b = misosplit_b[0];
//	printf("Char Receving Data: %c %c \r\n", data_a, data_b);
	printf("Char Receving Data:        %c \r\n", data_b);
	printf("Hex  Receving Data: 0x%x 0x%x \r\n", data_a, data_b);



	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, last_bit);
	misosplit(rx_vector[1], &misosplit_a[0], &misosplit_b[0]);
	data_a = misosplit_a[0];
	data_b = misosplit_b[0];
//	printf("Char Receving Data: %c %c \r\n", data_a, data_b);
	printf("Char Receving Data:        %c \r\n", data_b);
	printf("Hex  Receving Data: 0x%x 0x%x \r\n", data_a, data_b);


	SPI_SEND_RECV_32(hspi, tx_vector, rx_vector, &last_bit);
	misosplit(rx_vector[1], &misosplit_a[0], &misosplit_b[0]);



	data_a = misosplit_a[0];
	data_b = misosplit_b[0];
	//printf("Char Receving Data: %c %c \r\n", data_a, data_b);
	printf("Char Receving Data:        %c \r\n", data_b);
	printf("Hex  Receving Data: 0x%x 0x%x \r\n", data_a, data_b);



	printf("FUCK OFF CA MARCHE !!!! \r\n");

 }




void TASK_RHD64_SPI_COMMUNICATION_INIT (void *arg) {
	//CREATE xQueue
	osThreadDef(RHD64_SPI_handle, RHD64_SPI_COMMUNICATION_task_entry, osPriorityNormal, 0, configMINIMAL_STACK_SIZE*10);

	if (osThreadCreate(osThread(RHD64_SPI_handle), (void *)arg) == NULL){
		printf("Booboo created SPI task \r\n");
	}
}

void RHD64_SPI_COMMUNICATION_task_entry(void const *arg){


	uint16_t tx_vector[2];
	uint16_t rx_vector[2];
	uint8_t last_bit[1];


	uint8_t DATA_CH0[2];
	uint8_t DATA_CH32[2];



	uint16_t UDP_vector[32][2];

	uint16_t counter = 0;

	spi_to_udp_t spi_message = {0};

	SPI_HandleTypeDef *hspi;
	hspi = &hspi4;

	//Activate SPI
	SET_BIT(hspi->Instance->CR1, SPI_CR1_SPE);

	//Activating the 16bit data mode
	SPI4->CR1 |= 0x800;


//	for (int i = 0; i<SPI_DMA_BUFFER_SIZE; i+=2){
//		for (int j = 0; j < SPI_LOOP_FOR_1MS; j++){
//			tx_vector[i] = i;
//			tx_vector[i+1] = i+1;
//		}
//	}

	INIT_RHD64(hspi);



#ifndef udp_mode_only

#ifdef spi_master_mode
	spi_flag = true;
	int last_bit_testing[1];
//	uint16_t tx_16b[1];
//	uint32_t tx_32b[1];
//	tx_16b[0] = 0b1110101100000000;
//	mosimerge(tx_16b[0], tx_32b[0]);
//	printf("Sending Data: %x Receiving %x \r\n",  tx_16b[0], tx_32b[0]);

	spi_message.spi_task_id = 1;
	spi_message.message_lenght = sizeof(rx_vector)/2;

	uint16_t convert0_cmd[2];
	convert0_cmd[0] = 0b0000000000000000;
	convert0_cmd[1] = 0b0000000000000000;
	SPI_SEND_RECV_32(hspi, convert0_cmd, rx_vector, last_bit_testing);

	uint16_t convert63_cmd[2];
	convert63_cmd[0] = 0b0000111111111111;
	convert63_cmd[1] = 0b0000000000000000;


	tx_vector[0] = 0b1111110011001100;
	tx_vector[1] = 0b0000000000000000;

	uint16_t intan_cmd[5][2];
	intan_cmd[0][0] = 0b1111110011001100;
	intan_cmd[0][1] = 0b0000000000000000;

	intan_cmd[1][0] = 0b1111110011001111;
	intan_cmd[1][1] = 0b0000000000000000;

	signed short int FINAL_DATA_CH0[1];
	signed short int FINAL_DATA_CH32[1];

	float CH0_31_value[32];
	float CH32_63_value[32];

	float temp_value_0;
	float temp_value_32;

    while(1)
	{
    	if (spi_flag){
    		spi_flag = false;
			//SET FULL_TASK_Scope_Pin
			FULL_TASK_SCOPE_Port->BSRR = FULL_TASK_SCOPE_Pin;
			//SET SPI_TASK_Scope_Pin
			SPI_TASK_SCOPE_Port->BSRR = SPI_TASK_SCOPE_Pin;


			for (int i = 0; i< 32; i++){
				SPI_SEND_RECV_32(hspi, convert63_cmd, rx_vector, last_bit_testing);
				//MSB
				misosplit(rx_vector[0], &DATA_CH32[0], &DATA_CH0[0]);
				//LSB
				misosplit(rx_vector[1], &DATA_CH32[1], &DATA_CH0[1]);
			}




//			FINAL_DATA_CH0[0] = (((DATA_CH0[0] <<8) | DATA_CH0[1]));
//			temp_value_0 = (FINAL_DATA_CH0[0] * RHD64_ADC_CONVERSION) / 1000;	//16 bit resolution  to 5mV scale
//
//			FINAL_DATA_CH32[0] = (((DATA_CH32[0]<<8) | DATA_CH32[1]));
//			temp_value_32 = (FINAL_DATA_CH32[0] * RHD64_ADC_CONVERSION)/1000;	//16 bit resolution  to 5mV scale
//
//			printf("Sending Data: %x - %x \r\n",  intan_cmd[0][0], intan_cmd[0][1]);
//			printf("CH0  Data: %x | %.3f mV \r\n", FINAL_DATA_CH0[0], temp_value_0);
//			printf("CH32 Data: %x | %.3f mV\r\n", FINAL_DATA_CH32[0], temp_value_32);


//			SPI_SEND_RECV_32(hspi, intan_cmd[1], rx_vector, last_bit_testing);
//			//MSB
//			misosplit(rx_vector[0], &DATA_CH32[0], &DATA_CH0[0]);
//			//LSB
//			misosplit(rx_vector[1], &DATA_CH32[1], &DATA_CH0[1]);
//
//			printf("Sending Data: %x - %x \r\n",   intan_cmd[1][0],  intan_cmd[1][1]);
//			data_intan = DATA_CH0[1];
//			printf("CH0  Data: %x - %x | %c \r\n",  DATA_CH0[0], DATA_CH0[1], data_intan);
//			data_intan = DATA_CH32[1];
//			printf("CH32 Data: %x - %x | %c \r\n",  DATA_CH32[0], DATA_CH32[1], data_intan);




			spi_message.buffer = (void*)tx_vector;
			if (arg != 0){
				if(xQueueSend((QueueHandle_t)arg,
							 (void *)&spi_message,
							 (TickType_t)2) != pdPASS)
				{
					printf("problem in queueSend \r\n");
				}
		  }
		  counter ++;
		 // printf("%lu \r\n", counter);

		  //RESET SPI_TASK_Scope_Pin
		  SPI_TASK_SCOPE_Port->BSRR = (uint32_t)SPI_TASK_SCOPE_Pin << 16U;
    	}
		else{
			vTaskDelay(1);
		}
	}
#endif

#ifdef spi_slave_mode
	HAL_SPI_Receive_DMA(&hspi4, received_vector, SPI_DMA_BUFFER_SIZE);
	while(1)
	{
		if (spi_flag){
			spi_message.buffer = (void*)received_vector;
			if (arg != 0){

				if(xQueueSend((QueueHandle_t)arg,
							 (void *)&spi_message,
							 (TickType_t)2) != pdPASS)
				{
					printf("problem in queueSend \r\n");
				}
			}
			spi_flag = false;
			HAL_SPI_Receive_DMA(&hspi4, received_vector, SPI_DMA_BUFFER_SIZE);
		}
		else{
			vTaskDelay(2);
		}
	}
#endif
#endif

#ifdef udp_mode_only

	  uint8_t bufferTest[SPI_DMA_BUFFER_SIZE] = {};


	while(1)
	{
		//SET FULL_TASK_Scope_Pin
		FULL_TASK_SCOPE_Port->BSRR = FULL_TASK_SCOPE_Pin;
		//SET SPI_TASK_Scope_Pin
		SPI_TASK_SCOPE_Port->BSRR = SPI_TASK_SCOPE_Pin;

		spi_message.buffer = (void*)transmit_vector;
		if (spi_flag){
			if (arg != 0){

				if(xQueueSend((QueueHandle_t)arg,
							 (void *)&spi_message,
							 (TickType_t)10) != pdPASS)
				{
					printf("problem in queueSend \r\n");
				}
				//RESET SPI_TASK_Scope_Pin
				SPI_TASK_SCOPE_Port->BSRR = (uint32_t)SPI_TASK_SCOPE_Pin << 16U;
			}
		}
		else{
			vTaskDelay(1);
		}
	}

#endif



}



