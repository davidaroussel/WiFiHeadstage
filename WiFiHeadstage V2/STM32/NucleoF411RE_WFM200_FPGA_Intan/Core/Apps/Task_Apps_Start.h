/*
 * App_config.h
 *
 *  Created on: Oct 2, 2022
 *      Author: david
 */

#ifndef APPS_APPS_CONFIG_H_
#define APPS_APPS_CONFIG_H_

#define SPI_EVENTS_NB_MAX                 20u



/* PRAGMA FOR DEBUGGING */

//#define udp_mode_only
//#define spi_mode_only
//#define spi_slave_mode
#define spi_master_mode

//TODO add WiFi INFO
//#define WLAN_SSID_DEFAULT       "Maison"                         ///< wifi ssid for client mode
//#define WLAN_PASSKEY_DEFAULT    "D94C96J02L09"                         ///< wifi password for client mode

//#define WLAN_SSID_DEFAULT       "Maison Up"                         ///< wifi ssid for client mode
//#define WLAN_PASSKEY_DEFAULT    "D94C96J02L09"                         ///< wifi password for client mode

#define WLAN_SSID_DEFAULT       "BioML_Headstage"                         ///< wifi ssid for client mode
#define WLAN_PASSKEY_DEFAULT    "51120biom"                         ///< wifi password for client mode

#define WLAN_SECURITY_DEFAULT   WFM_SECURITY_MODE_WPA2_PSK        ///< wifi security mode for client mode: WFM_SECURITY_MODE_OPEN/WFM_SECURITY_MODE_WEP/WFM_SECURITY_MODE_WPA2_WPA1_PSK
#define SOFTAP_SSID_DEFAULT     "silabs_softap"                   ///< wifi ssid for soft ap mode
#define SOFTAP_PASSKEY_DEFAULT  "changeme"                        ///< wifi password for soft ap mode
#define SOFTAP_SECURITY_DEFAULT WFM_SECURITY_MODE_WPA2_PSK        ///< wifi security for soft ap mode: WFM_SECURITY_MODE_OPEN/WFM_SECURITY_MODE_WEP/WFM_SECURITY_MODE_WPA2_WPA1_PSK
#define SOFTAP_CHANNEL_DEFAULT  6                                 ///< wifi channel for soft ap

#define DISABLE_CFG_MENU




#include "stm32f4xx_hal.h"
#include "cmsis_os.h"
#include <Task_Intan_SPI_communication.h>
#include "Task_UDP_Transmit.h"
#include "main.h"

void start_app_task(void);
//#define DEFAULT_IP_ADDR 		"192.168.0.154"
//#define DEFAULT_IP_ADDR 		"192.168.56.1"
#define  DEFAULT_IP_ADDR      "192.168.1.144"
//#define  DEFAULT_IP_ADDR      "192.168.1.5"
#define  UDP_SERVER_PORT_DEFAULT 10000
#define  TCP_SERVER_PORT_DEFAULT 10000


// STRUCT FOR SPI - SOCKET MESSAGE
typedef struct spi_to_udp_t{
    uint16_t spi_task_id;
    void *buffer;
    size_t message_lenght;

} spi_to_udp_t;


// STRUCT FOR SPI - SOCKET MESSAGE
typedef struct spi_to_tcp_t{
    uint16_t spi_task_id;
    void *buffer;
    size_t message_lenght;

} spi_to_tcp_t;




#endif /* APPS_APPS_CONFIG_H_ */
