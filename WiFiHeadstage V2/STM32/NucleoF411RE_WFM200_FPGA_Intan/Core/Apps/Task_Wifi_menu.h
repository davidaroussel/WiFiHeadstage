/*
 * wifi_menu.h
 *
 *  Created on: Aug. 14, 2023
 *      Author: david
 */

#ifndef APPS_TASK_WIFI_MENU_H_
#define APPS_TASK_WIFI_MENU_H_

#include <stddef.h>
#include "lwip/ip_addr.h"
#include "lwip/err.h"
#include "lwip/tcp.h"


void WIFI_MENU_INIT(void *arg);
void wifi_menu_start(void const *arg);
static err_t wifi_menu_recv_callback(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err);


#endif /* APPS_TASK_WIFI_MENU_H_ */
