################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Tools/wpa_supplicant-2.7/src/utils/common.c \
../Tools/wpa_supplicant-2.7/src/utils/wpabuf.c 

OBJS += \
./Tools/wpa_supplicant-2.7/src/utils/common.o \
./Tools/wpa_supplicant-2.7/src/utils/wpabuf.o 

C_DEPS += \
./Tools/wpa_supplicant-2.7/src/utils/common.d \
./Tools/wpa_supplicant-2.7/src/utils/wpabuf.d 


# Each subdirectory must supply rules for building sources it contributes
Tools/wpa_supplicant-2.7/src/utils/%.o Tools/wpa_supplicant-2.7/src/utils/%.su Tools/wpa_supplicant-2.7/src/utils/%.cyclo: ../Tools/wpa_supplicant-2.7/src/utils/%.c Tools/wpa_supplicant-2.7/src/utils/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE '-DMBEDTLS_CONFIG_FILE="mbedtls_config.h"' -c -I../Core/Inc -I../Core/Apps -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Drivers/wfx_fmac_driver -I../Drivers/wfx_fmac_driver/bus -I../Drivers/wfx_fmac_driver/firmware -I../Drivers/wfx_fmac_driver/secure_link -I../Drivers/PDS -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/mbedTLS/include/mbedtls -I../Middlewares/Third_Party/mbedTLS/include -I../Middlewares/Third_Party/mbedTLS/App -I../Middlewares/Third_Party/LwIP/src -I../Middlewares/Third_Party/LwIP/system -I../Middlewares/Third_Party/LwIP/src/include -I../Core/TraceAnalyser/config -I../Core/TraceAnalyser/include -I../Middlewares/Tools/wpa_supplicant-2.7/src -I../Middlewares/Tools/wpa_supplicant-2.7 -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Tools-2f-wpa_supplicant-2d-2-2e-7-2f-src-2f-utils

clean-Tools-2f-wpa_supplicant-2d-2-2e-7-2f-src-2f-utils:
	-$(RM) ./Tools/wpa_supplicant-2.7/src/utils/common.cyclo ./Tools/wpa_supplicant-2.7/src/utils/common.d ./Tools/wpa_supplicant-2.7/src/utils/common.o ./Tools/wpa_supplicant-2.7/src/utils/common.su ./Tools/wpa_supplicant-2.7/src/utils/wpabuf.cyclo ./Tools/wpa_supplicant-2.7/src/utils/wpabuf.d ./Tools/wpa_supplicant-2.7/src/utils/wpabuf.o ./Tools/wpa_supplicant-2.7/src/utils/wpabuf.su

.PHONY: clean-Tools-2f-wpa_supplicant-2d-2-2e-7-2f-src-2f-utils

