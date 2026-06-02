/*
 * Task_TCP_Transmit.c
 *
 *  Created on: Sep. 20, 2023
 *      Author: David
 */


/*
 * udp_task.c
 *
 *  Created on: Oct 2, 2022
 *      Author: david
 */

#include <stdbool.h>
#include "Task_Apps_Start.h"
#include "Task_TCP_Transmit.h"
#include "lwip/tcp.h"

extern struct udp_pcb *upcb;
extern bool tcp_flag;


void TCP_TRANSMIT_task_entry(void const *arg);


void TASK_TCP_TRANSMIT_INIT(void *arg){

//	udp_ready = xSemaphoreCreateBinary();

	osThreadDef(UDP_Tx_handle, TCP_TRANSMIT_task_entry, osPriorityAboveNormal, 0, configMINIMAL_STACK_SIZE*20);

	if (osThreadCreate(osThread(UDP_Tx_handle), (void *) arg) == NULL){
		printf("Booboo creating UDP task \r\n");
	}
}




void TCP_TRANSMIT_task_entry(void const *arg) {
    struct pbuf *p = NULL;
    spi_to_udp_t tcp_message = {0};
    uint32_t counter = 0;

    tcp_message.message_lenght = BUFFER_SIZE * 2;

    while (1) {
    	if (tcp_flag && xQueueReceive((QueueHandle_t)arg, (void *)&tcp_message, (TickType_t)1) == pdPASS) {
//        	printf("TCP SEND %i \r\n", counter);
        	if (p == NULL){
				p = pbuf_alloc(PBUF_TRANSPORT, BUFFER_SIZE*2, PBUF_RAM);
				printf("p is NULL \r\n");
			}
        	counter ++;
			//printf("%u \r\n", counter);
			//pbuf_take_at(p, counter, 2, SPI_DMA_BUFFER_SIZE);
			pbuf_take_at(p, (const void *)tcp_message.buffer, BUFFER_SIZE*2, 0);

            // Copy data from tcp_message to p->payload
//            memcpy(p->payload, tcp_message.buffer, tcp_message.message_lenght );

            // Set the length of the pbuf to the size of the data
//            p->len = tcp_message.message_lenght ;
//            p->tot_len = tcp_message.message_lenght ;

            // Print the data before sending (if needed)
//            printf("Sending Data (Length %d): ", p->len);
//            for (int i = 0; i < p->len/2; i++) {
//                printf("%04X ", ((uint16_t *)p->payload)[i]); // Assuming you want to print in hexadecimal format
//            }

            // Send data over the existing TCP connection
            err_t send_err = tcp_write(upcb, p->payload, p->len, TCP_WRITE_FLAG_COPY);
            if (send_err != ERR_OK) {
                printf("Error sending data over TCP: %d\r\n", send_err);
                // Handle the error appropriately
            } else {
                // Flush the data to ensure it's sent immediately
                tcp_output(upcb);
            }

            // Free the pbuf
//            pbuf_free(p);
//            p = NULL;

			// RESET FULL_TASK_Scope_Pin
//            FULL_TASK_SCOPE_Port->BSRR = (uint32_t)FULL_TASK_SCOPE_Pin << 16U;
        } else {
            vTaskDelay(1);
        }
    }
}
