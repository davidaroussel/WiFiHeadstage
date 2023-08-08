################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (10.3-2021.10)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/wfx_fmac_driver/bus/sl_wfx_bus.c \
../Drivers/wfx_fmac_driver/bus/sl_wfx_bus_spi.c 

OBJS += \
./Drivers/wfx_fmac_driver/bus/sl_wfx_bus.o \
./Drivers/wfx_fmac_driver/bus/sl_wfx_bus_spi.o 

C_DEPS += \
./Drivers/wfx_fmac_driver/bus/sl_wfx_bus.d \
./Drivers/wfx_fmac_driver/bus/sl_wfx_bus_spi.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/wfx_fmac_driver/bus/%.o Drivers/wfx_fmac_driver/bus/%.su: ../Drivers/wfx_fmac_driver/bus/%.c Drivers/wfx_fmac_driver/bus/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE '-DMBEDTLS_CONFIG_FILE="mbedtls_config.h"' -c -I../Core/Inc -I../Core/Apps -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Drivers/wfx_fmac_driver -I../Drivers/wfx_fmac_driver/bus -I../Drivers/wfx_fmac_driver/firmware -I../Drivers/wfx_fmac_driver/secure_link -I../Drivers/PDS -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/mbedTLS/include/mbedtls -I../Middlewares/Third_Party/mbedTLS/include -I../Middlewares/Third_Party/mbedTLS/App -I../Middlewares/Third_Party/LwIP/src -I../Middlewares/Third_Party/LwIP/system -I../Middlewares/Third_Party/LwIP/src/include -I../Core/TraceAnalyser/config -I../Core/TraceAnalyser/include -I../Middlewares/Tools/wpa_supplicant-2.7/src -I../Middlewares/Tools/wpa_supplicant-2.7 -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-wfx_fmac_driver-2f-bus

clean-Drivers-2f-wfx_fmac_driver-2f-bus:
	-$(RM) ./Drivers/wfx_fmac_driver/bus/sl_wfx_bus.d ./Drivers/wfx_fmac_driver/bus/sl_wfx_bus.o ./Drivers/wfx_fmac_driver/bus/sl_wfx_bus.su ./Drivers/wfx_fmac_driver/bus/sl_wfx_bus_spi.d ./Drivers/wfx_fmac_driver/bus/sl_wfx_bus_spi.o ./Drivers/wfx_fmac_driver/bus/sl_wfx_bus_spi.su

.PHONY: clean-Drivers-2f-wfx_fmac_driver-2f-bus

