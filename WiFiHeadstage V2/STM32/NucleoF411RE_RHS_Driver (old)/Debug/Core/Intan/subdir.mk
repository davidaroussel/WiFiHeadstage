################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Intan/Intan_utils.c \
../Core/Intan/RHD_Driver.c \
../Core/Intan/RHS_Driver.c 

OBJS += \
./Core/Intan/Intan_utils.o \
./Core/Intan/RHD_Driver.o \
./Core/Intan/RHS_Driver.o 

C_DEPS += \
./Core/Intan/Intan_utils.d \
./Core/Intan/RHD_Driver.d \
./Core/Intan/RHS_Driver.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Intan/%.o Core/Intan/%.su Core/Intan/%.cyclo: ../Core/Intan/%.c Core/Intan/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Core-2f-Intan

clean-Core-2f-Intan:
	-$(RM) ./Core/Intan/Intan_utils.cyclo ./Core/Intan/Intan_utils.d ./Core/Intan/Intan_utils.o ./Core/Intan/Intan_utils.su ./Core/Intan/RHD_Driver.cyclo ./Core/Intan/RHD_Driver.d ./Core/Intan/RHD_Driver.o ./Core/Intan/RHD_Driver.su ./Core/Intan/RHS_Driver.cyclo ./Core/Intan/RHS_Driver.d ./Core/Intan/RHS_Driver.o ./Core/Intan/RHS_Driver.su

.PHONY: clean-Core-2f-Intan

