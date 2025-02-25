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

//extern bool tcp_flag;

char *ip_str_server = DEFAULT_IP_ADDR;
ip_addr_t server_addr;
extern struct tcp_pcb *tpcb;
extern bool TCP_Connected;
int res = -1;
err_t err;


err_t tcp_connected(void *arg, struct tcp_pcb *tpcb, err_t err) {
    if (err == ERR_OK) {
        printf("TCP connection established successfully.\r\n");
        TCP_Connected = true;
        return ERR_OK;
    } else {
        printf("TCP connection error: %d\n", err);
        return err;
    }
}

int INIT_TCP(void) {
    res = ipaddr_aton(ip_str_server, &server_addr);
    if (res == 0) {
        printf("Failed to convert IP address: %s\n", ip_str_server);
        return -1;
    }

    tpcb = tcp_new();
    if (tpcb == NULL) {
        printf("Failed to create TCP PCB\n");
        return -2;
    }

    tcp_arg(tpcb, NULL);
    err = tcp_connect(tpcb, &server_addr, TCP_SERVER_PORT_DEFAULT, tcp_connected);
    if (err != ERR_OK) {
        printf("TCP connection failed with error %d\n", err);
        tcp_close(tpcb);
        return -3;
    }

    return ERR_OK;
}



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
    spi_to_tcp_t tcp_message = {0};
    uint32_t counter = 0;
    int BUFFER_SIZE = 1024;

    tcp_message.message_lenght = BUFFER_SIZE * 2;

    while (1) {
    	if (xQueueReceive((QueueHandle_t)arg, (void *)&tcp_message, (TickType_t)1) == pdPASS) {
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
            err_t send_err = tcp_write(tpcb, p->payload, p->len, TCP_WRITE_FLAG_COPY);
            if (send_err != ERR_OK) {
                printf("Error sending data over TCP: %d\r\n", send_err);
                // Handle the error appropriately
            } else {
                // Flush the data to ensure it's sent immediately
                tcp_output(tpcb);
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
