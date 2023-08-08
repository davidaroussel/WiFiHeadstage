################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (10.3-2021.10)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/arc4.c \
../Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/des.c \
../Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md4.c \
../Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md5.c \
../Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/sha1.c 

OBJS += \
./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/arc4.o \
./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/des.o \
./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md4.o \
./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md5.o \
./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/sha1.o 

C_DEPS += \
./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/arc4.d \
./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/des.d \
./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md4.d \
./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md5.d \
./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/sha1.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/%.o Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/%.su: ../Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/%.c Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE '-DMBEDTLS_CONFIG_FILE="mbedtls_config.h"' -c -I../Core/Inc -I../Core/Apps -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Drivers/wfx_fmac_driver -I../Drivers/wfx_fmac_driver/bus -I../Drivers/wfx_fmac_driver/firmware -I../Drivers/wfx_fmac_driver/secure_link -I../Drivers/PDS -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/mbedTLS/include/mbedtls -I../Middlewares/Third_Party/mbedTLS/include -I../Middlewares/Third_Party/mbedTLS/App -I../Middlewares/Third_Party/LwIP/src -I../Middlewares/Third_Party/LwIP/system -I../Middlewares/Third_Party/LwIP/src/include -I../Core/TraceAnalyser/config -I../Core/TraceAnalyser/include -I../Middlewares/Tools/wpa_supplicant-2.7/src -I../Middlewares/Tools/wpa_supplicant-2.7 -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Middlewares-2f-Third_Party-2f-LwIP-2f-src-2f-netif-2f-ppp-2f-polarssl

clean-Middlewares-2f-Third_Party-2f-LwIP-2f-src-2f-netif-2f-ppp-2f-polarssl:
	-$(RM) ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/arc4.d ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/arc4.o ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/arc4.su ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/des.d ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/des.o ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/des.su ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md4.d ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md4.o ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md4.su ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md5.d ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md5.o ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/md5.su ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/sha1.d ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/sha1.o ./Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/sha1.su

.PHONY: clean-Middlewares-2f-Third_Party-2f-LwIP-2f-src-2f-netif-2f-ppp-2f-polarssl

