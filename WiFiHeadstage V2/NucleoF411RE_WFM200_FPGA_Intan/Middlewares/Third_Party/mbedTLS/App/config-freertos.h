
#ifndef MBEDTLS_CONFIG_FREERTOS_H
#define MBEDTLS_CONFIG_FREERTOS_H

#include "mbedtls_config.h"

/* Add FreeRTOS support */
#define MBEDTLS_THREADING_ALT
#define MBEDTLS_THREADING_C
#define MBEDTLS_FREERTOS
#undef MBEDTLS_NET_C
#undef MBEDTLS_TIMING_C
#undef MBEDTLS_FS_IO
#define MBEDTLS_NO_PLATFORM_ENTROPY

#endif //MBEDTLS_CONFIG_FREERTOS_H