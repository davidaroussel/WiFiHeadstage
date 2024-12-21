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
#include "lwip/tcp.h"
#include "Task_Apps_Start.h"
#include "Task_TCP_Transmit.h"

#define DEVICE_ID "Headstage V2      ID:0"

extern struct tcp_pcb *tpcb;
extern ip_addr_t server_addr;

void wifi_menu_start(void const *arg);
static err_t wifi_menu_recv_callback(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err);

void WIFI_MENU_INIT(void *arg) {

    osThreadDef(wifi_menu_handle, wifi_menu_start, osPriorityRealtime, 0, configMINIMAL_STACK_SIZE);

    if (osThreadCreate(osThread(wifi_menu_handle), (void *) arg) == NULL) {
        printf("Error creating TCP task\r\n");
    }
}


void wifi_menu_start(void const *arg) {
    // Set up callback function to receive data
    printf("Waiting \r\n");
    tcp_recv(tpcb, wifi_menu_recv_callback);  // Set the receive callback only once

    while (1) {
        osDelay(1000);  // Some delay to keep the thread alive (replace as needed)
    }
}


// Function prototype
static err_t send_response(struct tcp_pcb *pcb, const char *message, size_t length);

// Callback function
static err_t wifi_menu_recv_callback(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err) {
    if (err != ERR_OK || p == NULL) {
        printf("Connection closed or error occurred\n");
        tcp_close(pcb);
        return ERR_ABRT;
    }

    // Process the received data
    char *data = (char *)p->payload;
    if (p->len < 1) {
        printf("Received empty or invalid data\r\n");
        pbuf_free(p);
        return ERR_VAL;
    }
    else {
    	//    	data[p->len] = '\0';  // Ensure the received data is null-terminated

    	// Print each byte of data to ensure it captures all received content
        osDelay(10);

        printf("Received data (length: %d): ", p->len);
        for (int i = 0; i < p->len; i++) {
            printf("%c", data[i]);  // Print character by character
        }
        printf("\r\n");
    }


    switch (data[0]) {
        case '0':
            printf("Executing Get Menu task\r\n");
            char menu[] = "*******************************************\r\n"
                          "* 0- Get Menu                             *\r\n"
                          "* 1- Get Headstage ID                     *\r\n"
                          "* 2- Get Intan Validation                 *\r\n"
                          "* 3- Configure Number of Channels         *\r\n"
                          "* 4- Configure Sampling Frequency         *\r\n"
                          "* 5- Configure Intan Chip Cutoff          *\r\n"
                          "* A- Start Intan Sampling                 *\r\n"
                          "* B- Stop Intan Sampling                  *\r\n"
                          "*******************************************\r\n";
            send_response(pcb, menu, strlen(menu));  // Send menu
            break;

        case '1':
            printf("Executing Get Headstage ID task\r\n");
            send_response(pcb, DEVICE_ID, strlen(DEVICE_ID));  // Send DEVICE_ID
            break;

        case '2':
            printf("Executing Verify Intan Chip task\r\n");
            char response[] = "INTAN FAKE";
            send_response(pcb, response, strlen(response));  // Intan Config
            break;

        case '3':
            if (p->len < 2) {
            	printf("Invalid data length for Configure Number of Channels\r\n");
                break;
            }
            uint8_t num_channels = data[1];
            printf("Configuring number of channels to: %d\r\n", num_channels);
            // Further processing
            break;

        case '4':
            if (p->len < 2) {
                printf("Invalid data length for Configure Sampling Frequency\r\n");
                break;
            }
            uint16_t sample_freq = (data[1] << 8) | data[2];
            printf("Configuring sampling frequency to: %d Hz\r\n", sample_freq);
            // Further processing
            break;

        case '5':

            if (p->len < 1) {
            	printf("Invalid data length for Intan Configuration\r\n");
                break;
            }
            printf("Executing Configure Intan Chip task\r\n");
            char config[] = "Please select the proper configuration\r\n"
            				              "High pass:                  Low pass:\r\n"
            				              "0- 300 Hz                   0- 20kHz\r\n"
            				              "1- 250 Hz                   1- 15kHz\r\n"
            				              "2- 200 Hz                   2- 10kHz\r\n"
            				              "3- 150 Hz                   3- 7.5 kHz\r\n"
            				              "4- 100 Hz                   4- 5.0 kHz\r\n"
            				              "5- 75 Hz                    5- 3.0 kHz\r\n"
            				              "6- 50 Hz                    6- 2.5 kHz\r\n"
            				              "7- 30 Hz                    7- 2.0 kHz\r\n"
            				              "8- 25 Hz                    8- 1.5 kHz\r\n"
            				              "9- 20 Hz                    9- 1.0 kHz\r\n"
            				              "A- 15 Hz                    A- 750 Hz\r\n"
            				              "B- 10 Hz                    B- 500 Hz\r\n"
            				              "C- 7.5 Hz                   C- 300 Hz\r\n"
            				              "D- 5.0 Hz                   D- 250 Hz\r\n"
            				              "E- 3.0 Hz                   E- 200 Hz\r\n"
            				              "F- 2.5 Hz                   F- 2.5 Hz\r\n"
            				              "G- 2.0 Hz                   G- 150 Hz\r\n"
            				              "H- 1.5 Hz                   H- 100 Hz\r\n"
            				              "I- 1.0 Hz\r\n"
            				              "J- 0.75 Hz\r\n"
            				              "K- 0.5 Hz\r\n"
            				              "L- 0.3 Hz\r\n"
            				              "M- 0.25 Hz\r\n";
            send_response(pcb, config, strlen(config));  // Intan Config
            // Wait for the second message
			printf("Waiting for configuration choices...\r\n");
			// Logic to receive and process the second message from the client
			// Example:
			char user_input[2]; // Assumes 2 characters: low-pass and high-pass
			int received = recv(pcb, user_input, sizeof(user_input), 0); // Adjust as needed
			if (received == 2) {
				printf("Received choices: Low-pass=%c, High-pass=%c\r\n", user_input[0], user_input[1]);
				// Process the received choices...
			} else {
				printf("Error: Expected 2 bytes for configuration choices\r\n");
			}
			break;

        case 'A':
            printf("Executing Start Intan Sampling task\r\n");
            break;

        case 'B':
            printf("Executing Stop Intan Sampling task\r\n");
            break;

        default:
            printf("Unknown command received\r\n");
            break;
    }

    // Free the received buffer
    pbuf_free(p);

    // Keep the connection alive
    return ERR_OK;
}

// Function to send response over TCP
static err_t send_response(struct tcp_pcb *pcb, const char *message, size_t length) {
    struct pbuf *response_buf = pbuf_alloc(PBUF_TRANSPORT, length, PBUF_RAM);
    if (response_buf != NULL) {
        pbuf_take(response_buf, message, length);

        err_t send_err = tcp_write(pcb, response_buf->payload, response_buf->len, TCP_WRITE_FLAG_COPY);
        if (send_err != ERR_OK) {
            printf("Error sending data over TCP: %d\r\n", send_err);
            pbuf_free(response_buf);  // Free buffer on error
            return send_err;
        } else {
            tcp_output(pcb);  // Flush the data to ensure it's sent immediately
        }

        pbuf_free(response_buf);  // Free the response buffer after sending
    } else {
        printf("Error allocating pbuf for message\r\n");
        return ERR_MEM;  // Return memory error if allocation fails
    }

    return ERR_OK;  // Success
}
