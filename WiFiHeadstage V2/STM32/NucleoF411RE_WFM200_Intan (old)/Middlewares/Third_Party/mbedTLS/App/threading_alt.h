/**************************************************************************/ /**
 * @file
 * @brief Threading primitive implementation for mbed TLS
 *******************************************************************************
 * # License
 * <b>Copyright 2018 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * SPDX-License-Identifier: APACHE-2.0
 *
 * This software is subject to an open source license and is distributed by
 * Silicon Laboratories Inc. pursuant to the terms of the Apache License,
 * Version 2.0 available at https://www.apache.org/licenses/LICENSE-2.0.
 * Such terms and conditions may be further supplemented by the Silicon Labs
 * Master Software License Agreement (MSLA) available at www.silabs.com and its
 * sections applicable to open source software.
 *
 ******************************************************************************/

#ifndef MBEDTLS_THREADING_ALT_H
#define MBEDTLS_THREADING_ALT_H

/***************************************************************************//**
 * \addtogroup sl_crypto
 * \{
 ******************************************************************************/

/***************************************************************************//**
 * \addtogroup sl_crypto_threading Threading Primitives
 * \brief Threading primitive implementation for mbed TLS
 *
 * This file contains the glue logic between the mbed TLS threading API and
 * two RTOS'es supported, being Micrium OS and FreeRTOS. 
 *
 * \note
 * In order to use the Silicon Labs Hardware Acceleration plugins in multi-threaded applications, 
 * define @ref MBEDTLS_THREADING_C in your build setup and call @ref THREADING_setup() <b>after</b> 
 * the RTOS is initialized and before <b>before</b> calling any mbed TLS function.
 *
 * \{
 ******************************************************************************/

#include "mbedtls/threading.h"


#define SL_THREADING_ALT

//#include "em_assert.h"
#include "FreeRTOS.h"
#include "semphr.h"
#include "task.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef SemaphoreHandle_t mbedtls_threading_mutex_t;

static inline void THREADING_InitMutex( mbedtls_threading_mutex_t *mutex )
{
  *mutex = (SemaphoreHandle_t) xSemaphoreCreateMutex();
//  EFM_ASSERT(*mutex != NULL);
  configASSERT(*mutex != NULL);
}

static inline void THREADING_FreeMutex( mbedtls_threading_mutex_t *mutex )
{
  (void) mutex;
  /*
    Removed call to
    vSemaphoreDelete( (SemaphoreHandle_t) *pComp );

    Mutex semaphores can not be deleted with default heap management of the
    current port. The following comment is from the vPortFree function of
    FreeRTOS which is called from vSemaphoreDelete (and subsequently
    vQueueDelete).
  */
  /* Memory cannot be freed using this scheme.  See heap_2.c, heap_3.c and
     heap_4.c for alternative implementations, and the memory management pages
     of http://www.FreeRTOS.org for more information. */
}

static inline int THREADING_TakeMutexBlocking( mbedtls_threading_mutex_t *mutex )
{
  BaseType_t status =
    xSemaphoreTake( *mutex, (TickType_t) portMAX_DELAY );
  return (status == pdTRUE ? 0 : MBEDTLS_ERR_THREADING_MUTEX_ERROR);
}

static inline int THREADING_TakeMutexNonBlocking( mbedtls_threading_mutex_t *mutex )
{
  BaseType_t status =
    xSemaphoreTake( *mutex, (TickType_t) 0 );
  return (status == pdTRUE ? 0 : MBEDTLS_ERR_THREADING_MUTEX_ERROR);
}

static inline int THREADING_GiveMutex( mbedtls_threading_mutex_t *mutex )
{
  BaseType_t status = xSemaphoreGive( *mutex );
//  EFM_ASSERT(status == pdTRUE);
  configASSERT(status == pdTRUE);
  return (status == pdTRUE ? 0 : MBEDTLS_ERR_THREADING_MUTEX_ERROR);
}

#ifdef __cplusplus
}
#endif

#endif /* MBEDTLS_FREERTOS */

#ifdef __cplusplus
extern "C" {
#endif

/* Forward declaration of threading_set_alt */
void mbedtls_threading_set_alt( void (*mutex_init)( mbedtls_threading_mutex_t * ),
                       void (*mutex_free)( mbedtls_threading_mutex_t * ),
                       int (*mutex_lock)( mbedtls_threading_mutex_t * ),
                       int (*mutex_unlock)( mbedtls_threading_mutex_t * ) );

/**
 * \brief          Helper function for setting up the mbed TLS threading subsystem
 */
//static inline void THREADING_setup( void )
//{
//  mbedtls_threading_set_alt(&THREADING_InitMutex,
//                            &THREADING_FreeMutex,
//                            &THREADING_TakeMutexBlocking,
//                            &THREADING_GiveMutex);
//}

#ifdef __cplusplus
}
#endif

