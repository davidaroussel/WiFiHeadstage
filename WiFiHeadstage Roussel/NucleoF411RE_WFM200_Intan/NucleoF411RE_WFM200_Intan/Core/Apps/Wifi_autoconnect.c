/*
 * wifi_autoconnect.c
 *
 *  Created on: Jun. 2, 2022
 *      Author: david
 */

#include "dhcp_client.h"
#include "dhcp_server.h"
#include "ethernetif.h"
#include "sl_wfx_host_events.h"
#include "sl_wfx_host.h"
#include "demo_config.h"
#include "Task_Apps_Start.h"

#define SL_WFX_AUTOCONNECT_EVENTS_NB_MAX                 10u

sl_wfx_context_t wifi;

scan_result_list_t scan_list_auto_connect[SL_WFX_MAX_SCAN_RESULTS];

void wifi_station_connect_task_entry(const void *args);

/***************************************************************************//**
 * @brief Converts a hex character to its integer value
 *
 * @param ch Character to convert to integer.
 * @returns Returns integer result.
 ******************************************************************************/
char from_hex(char ch)
{
  return isdigit(ch) ? ch - '0' : tolower(ch) - 'a' + 10;
}

/***************************************************************************//**
 * @brief Returns a url-decoded version of the string str
 *
 * @param str String to decode.
 * @returns Success or fail.
 ******************************************************************************/
sl_status_t url_decode(char *str)
{
  char *pstr = str, rstr[64];
  int i = 0;

  if (strlen(str) > 64) {
    return SL_STATUS_FAIL;
  }

  while (*pstr) {
    if (*pstr == '%') {
      if (pstr[1] && pstr[2]) {
        rstr[i++] = from_hex(pstr[1]) << 4 | from_hex(pstr[2]);
        pstr += 2;
      }
    } else if (*pstr == '+') {
      rstr[i++]  = ' ';
    } else {
      rstr[i++] = *pstr;
    }
    pstr++;
  }
  rstr[i] = '\0';
  strcpy(str, &rstr[0]);
  return SL_STATUS_OK;
}



void wifi_autoconnexion_init(void)
{

	osThreadDef(autoconnect_task, wifi_station_connect_task_entry, osPriorityBelowNormal, 0, 1024);
	osThreadCreate(osThread(autoconnect_task), NULL);

}


/***************************************************************************//**
 * @brief Web server CGI handler to start the station interface.
 ******************************************************************************/
void wifi_station_connect_task_entry(const void *args)
{
  sl_status_t status;
  int num_params = 3;
  char *pc_param[] ={"ssid", "pwd", "secu"," "};
  char *pc_value[] ={WLAN_SSID_DEFAULT, WLAN_PASSKEY_DEFAULT, "WPA2"," "};

  int ssid_length = 0, passkey_length = 0;

  if (num_params == 3) {
    if (strcmp(pc_param[0], "ssid") == 0)
    {
      url_decode(pc_value[0]);
      ssid_length = strlen(pc_value[0]);
      memset(wlan_ssid, 0, 32);
      strncpy(wlan_ssid, pc_value[0], ssid_length);
    }
    if (strcmp(pc_param[1], "pwd") == 0)
    {
      url_decode(pc_value[1]);
      passkey_length = strlen(pc_value[1]);
      memset(wlan_passkey, 0, 64);
      strncpy(wlan_passkey, pc_value[1], passkey_length);
    }
    if (strcmp(pc_param[2], "secu") == 0)
    {
      url_decode(pc_value[2]);
      if ((strcmp(pc_value[2], "WPA2") == 0) || (strcmp(pc_value[2], "WPA") == 0))
      {
        wlan_security = WFM_SECURITY_MODE_WPA2_WPA1_PSK;
      }else if (strcmp(pc_value[2], "WEP") == 0)
      {
        wlan_security = WFM_SECURITY_MODE_WEP;
      }else if (strcmp(pc_value[2], "OPEN") == 0)
      {
        wlan_security = WFM_SECURITY_MODE_OPEN;
      }
    }
    if (!(wifi.state & SL_WFX_STA_INTERFACE_CONNECTED))
    {

      status = sl_wfx_send_join_command((uint8_t*) wlan_ssid, ssid_length,
                                        NULL, 0, wlan_security, 0, 0,
                                        (uint8_t*) wlan_passkey, passkey_length,
                                        NULL, 0);\

      if(status != SL_STATUS_OK)
      {
        printf("Connection command error\r\n");
        //strcpy(event_log, "Connection command error");
      }
    }
  }else{
    printf("Invalid Connection Request\r\n");
  }

  // Delete the init thread.
  while(1){
	  osThreadTerminate(NULL);
  }
}




