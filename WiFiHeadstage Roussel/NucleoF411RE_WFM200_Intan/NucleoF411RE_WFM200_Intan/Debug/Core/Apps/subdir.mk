################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (10.3-2021.10)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Apps/Intan_utils.c \
../Core/Apps/SPI_communication.c \
../Core/Apps/Task_Apps_Start.c \
../Core/Apps/Task_RHD64_SPI_communication.c \
../Core/Apps/Task_UDP_Transmit.c \
../Core/Apps/Wifi_autoconnect.c 

OBJS += \
./Core/Apps/Intan_utils.o \
./Core/Apps/SPI_communication.o \
./Core/Apps/Task_Apps_Start.o \
./Core/Apps/Task_RHD64_SPI_communication.o \
./Core/Apps/Task_UDP_Transmit.o \
./Core/Apps/Wifi_autoconnect.o 

C_DEPS += \
./Core/Apps/Intan_utils.d \
./Core/Apps/SPI_communication.d \
./Core/Apps/Task_Apps_Start.d \
./Core/Apps/Task_RHD64_SPI_communication.d \
./Core/Apps/Task_UDP_Transmit.d \
./Core/Apps/Wifi_autoconnect.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Apps/%.o Core/Apps/%.su: ../Core/Apps/%.c Core/Apps/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE '-DMBEDTLS_CONFIG_FILE="mbedtls_config.h"' -c -I../Core/Inc -I../Core/Apps -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Drivers/wfx_fmac_driver -I../Drivers/wfx_fmac_driver/bus -I../Drivers/wfx_fmac_driver/firmware -I../Drivers/wfx_fmac_driver/secure_link -I../Drivers/PDS -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/mbedTLS/include/mbedtls -I../Middlewares/Third_Party/mbedTLS/include -I../Middlewares/Third_Party/mbedTLS/App -I../Middlewares/Third_Party/LwIP/src -I../Middlewares/Third_Party/LwIP/system -I../Middlewares/Third_Party/LwIP/src/include -I../Core/TraceAnalyser/config -I../Core/TraceAnalyser/include -I../Middlewares/Tools/wpa_supplicant-2.7/src -I../Middlewares/Tools/wpa_supplicant-2.7 -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Core-2f-Apps

clean-Core-2f-Apps:
	-$(RM) ./Core/Apps/Intan_utils.d ./Core/Apps/Intan_utils.o ./Core/Apps/Intan_utils.su ./Core/Apps/SPI_communication.d ./Core/Apps/SPI_communication.o ./Core/Apps/SPI_communication.su ./Core/Apps/Task_Apps_Start.d ./Core/Apps/Task_Apps_Start.o ./Core/Apps/Task_Apps_Start.su ./Core/Apps/Task_RHD64_SPI_communication.d ./Core/Apps/Task_RHD64_SPI_communication.o ./Core/Apps/Task_RHD64_SPI_communication.su ./Core/Apps/Task_UDP_Transmit.d ./Core/Apps/Task_UDP_Transmit.o ./Core/Apps/Task_UDP_Transmit.su ./Core/Apps/Wifi_autoconnect.d ./Core/Apps/Wifi_autoconnect.o ./Core/Apps/Wifi_autoconnect.su

.PHONY: clean-Core-2f-Apps

