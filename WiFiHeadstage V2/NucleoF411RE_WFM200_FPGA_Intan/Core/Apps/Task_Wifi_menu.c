/*
 * wifi_menu.c
 *
 *  Created on: Aug. 14, 2023
 *      Author: david
 */
#include <stddef.h>
#include <Task_Wifi_menu.h>
#include "lwip/ip_addr.h"
#include "lwip/err.h"
#include "lwip/udp.h"
#include "Task_Apps_Start.h"
#include "Task_UDP_Transmit.h"


extern struct udp_pcb *upcb;
extern ip_addr_t server_addr;

void wifi_menu_start(void const *arg);

// Callback function to process received UDP data
void wifi_menu_recv_callback(void *arg, struct udp_pcb *pcb, struct pbuf *p, const ip_addr_t *addr, u16_t port) {
    // Print the received data
    printf("Received data: %s\n", (char *)p->payload);

    // Free the p buffer
    pbuf_free(p);
}



void WIFI_MENU_INIT(void *arg){

	osThreadDef(wifi_menu_handle, wifi_menu_start, osPriorityRealtime, 0, configMINIMAL_STACK_SIZE);

	if (osThreadCreate(osThread(wifi_menu_handle), (void *) arg) == NULL){
		printf("Booboo creating UDP task \r\n");
	}
}


void wifi_menu_start(void const *arg){

 // Replace with the IP address of the Python server
    char message[] = "Hello from the STM32 client!";
    struct pbuf *p = pbuf_alloc(PBUF_TRANSPORT, sizeof(message), PBUF_RAM);
	memcpy(p->payload, message, sizeof(message));

    while (1) {

    	// Send data to the server
    	udp_send(upcb, p);

    	// Set up callback function to receive data
    	udp_recv(upcb, wifi_menu_recv_callback, NULL);

    	// Wait for a while to allow reception of response
    	HAL_Delay(1000);
  }

  udp_remove(upcb);

}
