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


// Callback function to process received UDP data
void wifi_menu_recv_callback(void *arg, struct udp_pcb *pcb, struct pbuf *p, const ip_addr_t *addr, u16_t port) {
    // Print the received data
    printf("Received data: %s\n", (char *)p->payload);

    // Free the p buffer
    pbuf_free(p);
}



void WIFI_MENU_INIT(void *arg){

	osThreadDef(udp_init_handle, wifi_menu_start, osPriorityRealtime, 0, configMINIMAL_STACK_SIZE*10);

	if (osThreadCreate(osThread(udp_init_handle), (void *) arg) == NULL){
		printf("Booboo creating UDP task \r\n");
	}
}


void wifi_menu_start(void const *arg){

	// Set the UDP receive callback function
	udp_recv(upcb, wifi_menu_recv_callback, NULL);

	// Main loop
	while (1) {
		//sys_check_timeouts();

        udp_recv(upcb, NULL, NULL);

        // Delay to allow other tasks to run
        vTaskDelay(pdMS_TO_TICKS(100));
	 }

}
