/**************************************************************************//**
 * Copyright 2021, Silicon Laboratories Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *****************************************************************************/

#ifndef DEMO_CONFIG_H
#define DEMO_CONFIG_H

#include "main.h"
#include "sl_wfx_cmd_api.h"
#include "sl_status.h"
#include "Task_Apps_Start.h"



#define USE_DHCP_CLIENT_DEFAULT    1   ///< If defined, DHCP is enabled, otherwise static address below is used

/************************** Station Static Default ****************************/
#define STA_IP_ADDR0_DEFAULT   (uint8_t) 192 ///< Static IP: IP address value 0
#define STA_IP_ADDR1_DEFAULT   (uint8_t) 168 ///< Static IP: IP address value 1
#define STA_IP_ADDR2_DEFAULT   (uint8_t) 0   ///< Static IP: IP address value 2
#define STA_IP_ADDR3_DEFAULT   (uint8_t) 1   ///< Static IP: IP address value 3

/*NETMASK*/
#define STA_NETMASK_ADDR0_DEFAULT   (uint8_t) 255 ///< Static IP: Netmask value 0
#define STA_NETMASK_ADDR1_DEFAULT   (uint8_t) 255 ///< Static IP: Netmask value 1
#define STA_NETMASK_ADDR2_DEFAULT   (uint8_t) 255 ///< Static IP: Netmask value 2
#define STA_NETMASK_ADDR3_DEFAULT   (uint8_t) 0   ///< Static IP: Netmask value 3

/*Gateway Address*/
#define STA_GW_ADDR0_DEFAULT   (uint8_t) 0        ///< Static IP: Gateway value 0
#define STA_GW_ADDR1_DEFAULT   (uint8_t) 0        ///< Static IP: Gateway value 1
#define STA_GW_ADDR2_DEFAULT   (uint8_t) 0        ///< Static IP: Gateway value 2
#define STA_GW_ADDR3_DEFAULT   (uint8_t) 0        ///< Static IP: Gateway value 3

/************************** Access Point Static Default ****************************/
#define AP_IP_ADDR0_DEFAULT   (uint8_t) 10 ///< Static IP: IP address value 0
#define AP_IP_ADDR1_DEFAULT   (uint8_t) 99 ///< Static IP: IP address value 1
#define AP_IP_ADDR2_DEFAULT   (uint8_t) 172   ///< Static IP: IP address value 2
#define AP_IP_ADDR3_DEFAULT   (uint8_t) 126   ///< Static IP: IP address value 3

/*NETMASK*/
#define AP_NETMASK_ADDR0_DEFAULT   (uint8_t) 255 ///< Static IP: Netmask value 0
#define AP_NETMASK_ADDR1_DEFAULT   (uint8_t) 255 ///< Static IP: Netmask value 1
#define AP_NETMASK_ADDR2_DEFAULT   (uint8_t) 255 ///< Static IP: Netmask value 2
#define AP_NETMASK_ADDR3_DEFAULT   (uint8_t) 0   ///< Static IP: Netmask value 3

/*Gateway Address*/
#define AP_GW_ADDR0_DEFAULT   (uint8_t) 0        ///< Static IP: Gateway value 0
#define AP_GW_ADDR1_DEFAULT   (uint8_t) 0        ///< Static IP: Gateway value 1
#define AP_GW_ADDR2_DEFAULT   (uint8_t) 0        ///< Static IP: Gateway value 2
#define AP_GW_ADDR3_DEFAULT   (uint8_t) 0        ///< Static IP: Gateway value 3
/***************************************************************************//**
 * Functions to initialize LwIP
 ******************************************************************************/
#ifdef __cplusplus
extern "C" {
#endif

/**************************************************************************//**
 * Start LwIP task.
 *****************************************************************************/
void lwip_start (void);

/**************************************************************************//**
 * Set station link status to up.
 *****************************************************************************/
void lwip_set_sta_link_up(void);

/**************************************************************************//**
 * Set station link status to down.
 *****************************************************************************/
void lwip_set_sta_link_down(void);

/**************************************************************************//**
 * Set AP link status to up.
 *****************************************************************************/
void lwip_set_ap_link_up(void);

/**************************************************************************//**
 * Set AP link status to down.
 *****************************************************************************/
void lwip_set_ap_link_down(void);

#ifdef __cplusplus
}
#endif

//#define LWIP_IPERF_SERVER ///< If defined, iperf server is enabled
//#define LWIP_HTTP_SERVER  ///< If defined, http server is enabled

extern char wlan_ssid[32+1];
extern char wlan_passkey[64+1];
extern sl_wfx_security_mode_t wlan_security;
extern uint8_t wlan_bssid[SL_WFX_BSSID_SIZE];
extern char softap_ssid[32+1];
extern char softap_passkey[64+1];
extern sl_wfx_security_mode_t softap_security;
extern uint8_t softap_channel;

extern uint8_t sta_ip_addr0;
extern uint8_t sta_ip_addr1;
extern uint8_t sta_ip_addr2;
extern uint8_t sta_ip_addr3;

extern uint8_t sta_netmask_addr0;
extern uint8_t sta_netmask_addr1;
extern uint8_t sta_netmask_addr2;
extern uint8_t sta_netmask_addr3;

extern uint8_t sta_gw_addr0;
extern uint8_t sta_gw_addr1;
extern uint8_t sta_gw_addr2;
extern uint8_t sta_gw_addr3;

extern uint8_t ap_ip_addr0;
extern uint8_t ap_ip_addr1;
extern uint8_t ap_ip_addr2;
extern uint8_t ap_ip_addr3;

extern uint8_t ap_netmask_addr0;
extern uint8_t ap_netmask_addr1;
extern uint8_t ap_netmask_addr2;
extern uint8_t ap_netmask_addr3;

extern uint8_t ap_gw_addr0;
extern uint8_t ap_gw_addr1;
extern uint8_t ap_gw_addr2;
extern uint8_t ap_gw_addr3;

extern struct netif ap_netif;
extern struct netif sta_netif;
#endif //DEMO_CONFIG_H
