################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (11.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls.c \
../Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls_mem.c 

OBJS += \
./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls.o \
./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls_mem.o 

C_DEPS += \
./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls.d \
./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls_mem.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/Third_Party/LwIP/src/apps/altcp_tls/%.o Middlewares/Third_Party/LwIP/src/apps/altcp_tls/%.su Middlewares/Third_Party/LwIP/src/apps/altcp_tls/%.cyclo: ../Middlewares/Third_Party/LwIP/src/apps/altcp_tls/%.c Middlewares/Third_Party/LwIP/src/apps/altcp_tls/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE '-DMBEDTLS_CONFIG_FILE="mbedtls_config.h"' -c -I../Core/Inc -I../Core/Apps -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Drivers/wfx_fmac_driver -I../Drivers/wfx_fmac_driver/bus -I../Drivers/wfx_fmac_driver/firmware -I../Drivers/wfx_fmac_driver/secure_link -I../Drivers/PDS -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/mbedTLS/include/mbedtls -I../Middlewares/Third_Party/mbedTLS/include -I../Middlewares/Third_Party/mbedTLS/App -I../Middlewares/Third_Party/LwIP/src -I../Middlewares/Third_Party/LwIP/system -I../Middlewares/Third_Party/LwIP/src/include -I../Core/TraceAnalyser/config -I../Core/TraceAnalyser/include -I../Middlewares/Tools/wpa_supplicant-2.7/src -I../Middlewares/Tools/wpa_supplicant-2.7 -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Middlewares-2f-Third_Party-2f-LwIP-2f-src-2f-apps-2f-altcp_tls

clean-Middlewares-2f-Third_Party-2f-LwIP-2f-src-2f-apps-2f-altcp_tls:
	-$(RM) ./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls.cyclo ./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls.d ./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls.o ./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls.su ./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls_mem.cyclo ./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls_mem.d ./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls_mem.o ./Middlewares/Third_Party/LwIP/src/apps/altcp_tls/altcp_tls_mbedtls_mem.su

.PHONY: clean-Middlewares-2f-Third_Party-2f-LwIP-2f-src-2f-apps-2f-altcp_tls

