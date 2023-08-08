################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (10.3-2021.10)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MBEDTLS/App/mbedtls.c \
../MBEDTLS/App/net_sockets.c 

OBJS += \
./MBEDTLS/App/mbedtls.o \
./MBEDTLS/App/net_sockets.o 

C_DEPS += \
./MBEDTLS/App/mbedtls.d \
./MBEDTLS/App/net_sockets.d 


# Each subdirectory must supply rules for building sources it contributes
MBEDTLS/App/%.o MBEDTLS/App/%.su: ../MBEDTLS/App/%.c MBEDTLS/App/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE '-DMBEDTLS_CONFIG_FILE="mbedtls_config.h"' -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Drivers/wfx_fmac_driver -I../Drivers/wfx_fmac_driver/bus -I../Drivers/wfx_fmac_driver/firmware -I../Drivers/wfx_fmac_driver/secure_link -I../MBEDTLS/App -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/mbedTLS/include/mbedtls -I../Middlewares/Third_Party/mbedTLS/include -I../Middlewares/Third_Party/LwIP/src -I../Middlewares/Third_Party/LwIP/system -I../Middlewares/Third_Party/LwIP/src/include -I../PDS -I../Core/TraceAnalyser/config -I../Core/TraceAnalyser/include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MBEDTLS-2f-App

clean-MBEDTLS-2f-App:
	-$(RM) ./MBEDTLS/App/mbedtls.d ./MBEDTLS/App/mbedtls.o ./MBEDTLS/App/mbedtls.su ./MBEDTLS/App/net_sockets.d ./MBEDTLS/App/net_sockets.o ./MBEDTLS/App/net_sockets.su

.PHONY: clean-MBEDTLS-2f-App

