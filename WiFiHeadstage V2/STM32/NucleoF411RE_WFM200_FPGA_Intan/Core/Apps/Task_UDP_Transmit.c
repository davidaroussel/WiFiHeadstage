/*
 * udp_task.c
 *
 *  Created on: Oct 2, 2022
 *      Author: david
 */

#include <stdbool.h>
#include "lwip/ip_addr.h"
#include "lwip/err.h"
#include "lwip/udp.h"
#include "Task_Apps_Start.h"
#include "Task_UDP_Transmit.h"


char *udp_ip_str_server = DEFAULT_IP_ADDR;
ip_addr_t udp_server_addr;
int udp_res = -1;
err_t udp_err;
extern struct udp_pcb *upcb;
extern bool spi_flag;





void UDP_TRANSMIT_task_entry(void const *arg);

int INIT_UPD(void){

	udp_err = ipaddr_aton(udp_ip_str_server, &udp_server_addr);

  if (udp_res == 0){
      printf("Failed to convert string (%s) to IP \r\n", udp_ip_str_server);
      //return SL_STATUS_FAIL;
  }
  upcb = udp_new();

  if (upcb == NULL){
      printf("UDP PCB creation failed \r\n");
      //return SL_STATUS_FAIL;
  }

  udp_err = udp_connect(upcb, &udp_server_addr, UDP_SERVER_PORT_DEFAULT);


  if (udp_err == ERR_OK){
        printf("Client UDP connected to %s \r\n", udp_ip_str_server);
  }

  return udp_err;
}



void TASK_UDP_TRANSMIT_INIT(void *arg){

//	udp_ready = xSemaphoreCreateBinary();

	osThreadDef(UDP_Tx_handle, UDP_TRANSMIT_task_entry, osPriorityAboveNormal, 0, configMINIMAL_STACK_SIZE*10);

	if (osThreadCreate(osThread(UDP_Tx_handle), (void *) arg) == NULL){
		printf("Booboo creating UDP task \r\n");
	}
}




void UDP_TRANSMIT_task_entry(void const *arg){

	  struct pbuf *p;
	  uint32_t counter = 0;
	  spi_to_udp_t udp_message = {0};


	  p = pbuf_alloc(PBUF_TRANSPORT, UDP_BUFFER_SIZE, PBUF_RAM);

	  while(1){
		if(xQueueReceive((QueueHandle_t)arg, (void *)&udp_message , (TickType_t)1) == pdPASS){
//			printf("%u \r\n", counter);
//			printf("%02x %02x %02x \r\n",udp_message.data0, udp_message.data1, udp_message.data2);

			 //SET UDP_TASK_Scope_Pin
//			UDP_TASK_SCOPE_Port->BSRR = UDP_TASK_SCOPE_Pin;

			if (p == NULL){
				p = pbuf_alloc(PBUF_TRANSPORT, UDP_BUFFER_SIZE, PBUF_RAM);
				printf("p is NULL \r\n");
			}


			counter ++;
			//pbuf_take_at(p, counter, 2, SPI_DMA_BUFFER_SIZE);
			pbuf_take_at(p, (const void *)udp_message.buffer, UDP_BUFFER_SIZE, 0);


//			for (int i = 0; i< SPI_DMA_BUFFER_SIZE; i++){
//				printf("0x%04x \r\n", ((uint16_t*)udp_message.buffer)[i]);
//			}

			//printf("0x%08x - 0x%08x - 0x%08x\r\n", *(uint16_t*)udp_message.buffer, *(uint16_t*)udp_message.buffer+2, *(uint16_t*)udp_message.buffer+udp_message.message_lenght-1);

			udp_send(upcb, p);

			//printf("%d \r\n",p->len);

//			//RESET UDP_TASK_Scope_Pin
//			UDP_TASK_SCOPE_Port->BSRR = (uint32_t)UDP_TASK_SCOPE_Pin << 16U;
//
//			//RESET FULL_TASK_Scope_Pin
//			FULL_TASK_SCOPE_Port->BSRR = (uint32_t)FULL_TASK_SCOPE_Pin << 16U;

			//printf("%u \r8n", counter);

			//spi_flag = true;
		}else{
			vTaskDelay(1);
		}
	 }

}



