/**************************************************************************//**
 * Copyright 2018, Silicon Laboratories Inc.
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

#ifndef SL_WFX_HOST_PIN_H
#define SL_WFX_HOST_PIN_H

#include "stm32f4xx_hal.h"
#include "sl_wfx_host_api.h"

/* PIN D11 ON NUCLEO BOARD*/
#define WFM_MOSI_GPIO_Port GPIOA
#define WFM_MOSI_Pin GPIO_PIN_7

/* PIN D12 ON NUCLEO BOARD*/
#define WFM_MISO_GPIO_Port GPIOA
#define WFM_MISO_Pin GPIO_PIN_6

/* PIN D13 ON NUCLEO BOARD*/
#define WFM_SCK_GPIO_Port GPIOA
#define WFM_SCK_Pin GPIO_PIN_5

/* PIN A2 ON NUCLEO BOARD*/
#define WFM_NSS_GPIO_Port GPIOA
#define WFM_NSS_Pin GPIO_PIN_4

/* PIN A5 ON NUCLEO BOARD*/
#define WFM_RESET_GPIO_Port GPIOC        //WILL BE CHANGE TO PB1
#define WFM_RESET_Pin GPIO_PIN_0

/* PIN D6 ON NUCLEO BOARD*/
#define WFM_SPI_WIRQ_Port GPIOB
#define WFM_SPI_WIRQ_Pin GPIO_PIN_10

/* PIN A3 ON NUCLEO BOARD*/
#define WFM_GPIO_WIRQ_Port GPIOB        //WILL BE CHANGE TO PB2
#define WFM_GPIO_WIRQ_Pin GPIO_PIN_0

/* PIN D15 ON NUCLEO BOARD*/
#define WFM_WUP_GPIO_Port GPIOB        //WILL BE CHANGE TO PB3
#define WFM_WUP_Pin GPIO_PIN_8




#endif /* SL_WFX_HOST_PIN_H */
