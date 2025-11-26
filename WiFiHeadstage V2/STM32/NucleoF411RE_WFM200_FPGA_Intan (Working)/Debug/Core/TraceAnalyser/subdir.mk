################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/TraceAnalyser/trcAssert.c \
../Core/TraceAnalyser/trcCounter.c \
../Core/TraceAnalyser/trcDiagnostics.c \
../Core/TraceAnalyser/trcEntryTable.c \
../Core/TraceAnalyser/trcError.c \
../Core/TraceAnalyser/trcEvent.c \
../Core/TraceAnalyser/trcEventBuffer.c \
../Core/TraceAnalyser/trcExtension.c \
../Core/TraceAnalyser/trcHardwarePort.c \
../Core/TraceAnalyser/trcHeap.c \
../Core/TraceAnalyser/trcISR.c \
../Core/TraceAnalyser/trcInternalEventBuffer.c \
../Core/TraceAnalyser/trcInterval.c \
../Core/TraceAnalyser/trcKernelPort.c \
../Core/TraceAnalyser/trcMultiCoreEventBuffer.c \
../Core/TraceAnalyser/trcObject.c \
../Core/TraceAnalyser/trcPrint.c \
../Core/TraceAnalyser/trcSnapshotRecorder.c \
../Core/TraceAnalyser/trcStackMonitor.c \
../Core/TraceAnalyser/trcStateMachine.c \
../Core/TraceAnalyser/trcStaticBuffer.c \
../Core/TraceAnalyser/trcStreamingRecorder.c \
../Core/TraceAnalyser/trcString.c \
../Core/TraceAnalyser/trcTask.c \
../Core/TraceAnalyser/trcTimestamp.c 

OBJS += \
./Core/TraceAnalyser/trcAssert.o \
./Core/TraceAnalyser/trcCounter.o \
./Core/TraceAnalyser/trcDiagnostics.o \
./Core/TraceAnalyser/trcEntryTable.o \
./Core/TraceAnalyser/trcError.o \
./Core/TraceAnalyser/trcEvent.o \
./Core/TraceAnalyser/trcEventBuffer.o \
./Core/TraceAnalyser/trcExtension.o \
./Core/TraceAnalyser/trcHardwarePort.o \
./Core/TraceAnalyser/trcHeap.o \
./Core/TraceAnalyser/trcISR.o \
./Core/TraceAnalyser/trcInternalEventBuffer.o \
./Core/TraceAnalyser/trcInterval.o \
./Core/TraceAnalyser/trcKernelPort.o \
./Core/TraceAnalyser/trcMultiCoreEventBuffer.o \
./Core/TraceAnalyser/trcObject.o \
./Core/TraceAnalyser/trcPrint.o \
./Core/TraceAnalyser/trcSnapshotRecorder.o \
./Core/TraceAnalyser/trcStackMonitor.o \
./Core/TraceAnalyser/trcStateMachine.o \
./Core/TraceAnalyser/trcStaticBuffer.o \
./Core/TraceAnalyser/trcStreamingRecorder.o \
./Core/TraceAnalyser/trcString.o \
./Core/TraceAnalyser/trcTask.o \
./Core/TraceAnalyser/trcTimestamp.o 

C_DEPS += \
./Core/TraceAnalyser/trcAssert.d \
./Core/TraceAnalyser/trcCounter.d \
./Core/TraceAnalyser/trcDiagnostics.d \
./Core/TraceAnalyser/trcEntryTable.d \
./Core/TraceAnalyser/trcError.d \
./Core/TraceAnalyser/trcEvent.d \
./Core/TraceAnalyser/trcEventBuffer.d \
./Core/TraceAnalyser/trcExtension.d \
./Core/TraceAnalyser/trcHardwarePort.d \
./Core/TraceAnalyser/trcHeap.d \
./Core/TraceAnalyser/trcISR.d \
./Core/TraceAnalyser/trcInternalEventBuffer.d \
./Core/TraceAnalyser/trcInterval.d \
./Core/TraceAnalyser/trcKernelPort.d \
./Core/TraceAnalyser/trcMultiCoreEventBuffer.d \
./Core/TraceAnalyser/trcObject.d \
./Core/TraceAnalyser/trcPrint.d \
./Core/TraceAnalyser/trcSnapshotRecorder.d \
./Core/TraceAnalyser/trcStackMonitor.d \
./Core/TraceAnalyser/trcStateMachine.d \
./Core/TraceAnalyser/trcStaticBuffer.d \
./Core/TraceAnalyser/trcStreamingRecorder.d \
./Core/TraceAnalyser/trcString.d \
./Core/TraceAnalyser/trcTask.d \
./Core/TraceAnalyser/trcTimestamp.d 


# Each subdirectory must supply rules for building sources it contributes
Core/TraceAnalyser/%.o Core/TraceAnalyser/%.su Core/TraceAnalyser/%.cyclo: ../Core/TraceAnalyser/%.c Core/TraceAnalyser/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE '-DMBEDTLS_CONFIG_FILE="mbedtls_config.h"' -c -I../Core/Inc -I../Core/Apps -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I../Drivers/wfx_fmac_driver -I../Drivers/wfx_fmac_driver/bus -I../Drivers/wfx_fmac_driver/firmware -I../Drivers/wfx_fmac_driver/secure_link -I../Drivers/PDS -I../Middlewares/Third_Party/FreeRTOS/Source/include -I../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F -I../Middlewares/Third_Party/mbedTLS/include/mbedtls -I../Middlewares/Third_Party/mbedTLS/include -I../Middlewares/Third_Party/mbedTLS/App -I../Middlewares/Third_Party/LwIP/src -I../Middlewares/Third_Party/LwIP/system -I../Middlewares/Third_Party/LwIP/src/include -I../Core/TraceAnalyser/config -I../Core/TraceAnalyser/include -I../Middlewares/Tools/wpa_supplicant-2.7/src -I../Middlewares/Tools/wpa_supplicant-2.7 -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Core-2f-TraceAnalyser

clean-Core-2f-TraceAnalyser:
	-$(RM) ./Core/TraceAnalyser/trcAssert.cyclo ./Core/TraceAnalyser/trcAssert.d ./Core/TraceAnalyser/trcAssert.o ./Core/TraceAnalyser/trcAssert.su ./Core/TraceAnalyser/trcCounter.cyclo ./Core/TraceAnalyser/trcCounter.d ./Core/TraceAnalyser/trcCounter.o ./Core/TraceAnalyser/trcCounter.su ./Core/TraceAnalyser/trcDiagnostics.cyclo ./Core/TraceAnalyser/trcDiagnostics.d ./Core/TraceAnalyser/trcDiagnostics.o ./Core/TraceAnalyser/trcDiagnostics.su ./Core/TraceAnalyser/trcEntryTable.cyclo ./Core/TraceAnalyser/trcEntryTable.d ./Core/TraceAnalyser/trcEntryTable.o ./Core/TraceAnalyser/trcEntryTable.su ./Core/TraceAnalyser/trcError.cyclo ./Core/TraceAnalyser/trcError.d ./Core/TraceAnalyser/trcError.o ./Core/TraceAnalyser/trcError.su ./Core/TraceAnalyser/trcEvent.cyclo ./Core/TraceAnalyser/trcEvent.d ./Core/TraceAnalyser/trcEvent.o ./Core/TraceAnalyser/trcEvent.su ./Core/TraceAnalyser/trcEventBuffer.cyclo ./Core/TraceAnalyser/trcEventBuffer.d ./Core/TraceAnalyser/trcEventBuffer.o ./Core/TraceAnalyser/trcEventBuffer.su ./Core/TraceAnalyser/trcExtension.cyclo ./Core/TraceAnalyser/trcExtension.d ./Core/TraceAnalyser/trcExtension.o ./Core/TraceAnalyser/trcExtension.su ./Core/TraceAnalyser/trcHardwarePort.cyclo ./Core/TraceAnalyser/trcHardwarePort.d ./Core/TraceAnalyser/trcHardwarePort.o ./Core/TraceAnalyser/trcHardwarePort.su ./Core/TraceAnalyser/trcHeap.cyclo ./Core/TraceAnalyser/trcHeap.d ./Core/TraceAnalyser/trcHeap.o ./Core/TraceAnalyser/trcHeap.su ./Core/TraceAnalyser/trcISR.cyclo ./Core/TraceAnalyser/trcISR.d ./Core/TraceAnalyser/trcISR.o ./Core/TraceAnalyser/trcISR.su ./Core/TraceAnalyser/trcInternalEventBuffer.cyclo ./Core/TraceAnalyser/trcInternalEventBuffer.d ./Core/TraceAnalyser/trcInternalEventBuffer.o ./Core/TraceAnalyser/trcInternalEventBuffer.su ./Core/TraceAnalyser/trcInterval.cyclo ./Core/TraceAnalyser/trcInterval.d ./Core/TraceAnalyser/trcInterval.o ./Core/TraceAnalyser/trcInterval.su ./Core/TraceAnalyser/trcKernelPort.cyclo ./Core/TraceAnalyser/trcKernelPort.d ./Core/TraceAnalyser/trcKernelPort.o ./Core/TraceAnalyser/trcKernelPort.su ./Core/TraceAnalyser/trcMultiCoreEventBuffer.cyclo ./Core/TraceAnalyser/trcMultiCoreEventBuffer.d ./Core/TraceAnalyser/trcMultiCoreEventBuffer.o ./Core/TraceAnalyser/trcMultiCoreEventBuffer.su ./Core/TraceAnalyser/trcObject.cyclo ./Core/TraceAnalyser/trcObject.d ./Core/TraceAnalyser/trcObject.o ./Core/TraceAnalyser/trcObject.su ./Core/TraceAnalyser/trcPrint.cyclo ./Core/TraceAnalyser/trcPrint.d ./Core/TraceAnalyser/trcPrint.o ./Core/TraceAnalyser/trcPrint.su ./Core/TraceAnalyser/trcSnapshotRecorder.cyclo ./Core/TraceAnalyser/trcSnapshotRecorder.d ./Core/TraceAnalyser/trcSnapshotRecorder.o ./Core/TraceAnalyser/trcSnapshotRecorder.su ./Core/TraceAnalyser/trcStackMonitor.cyclo ./Core/TraceAnalyser/trcStackMonitor.d ./Core/TraceAnalyser/trcStackMonitor.o ./Core/TraceAnalyser/trcStackMonitor.su ./Core/TraceAnalyser/trcStateMachine.cyclo ./Core/TraceAnalyser/trcStateMachine.d ./Core/TraceAnalyser/trcStateMachine.o ./Core/TraceAnalyser/trcStateMachine.su ./Core/TraceAnalyser/trcStaticBuffer.cyclo ./Core/TraceAnalyser/trcStaticBuffer.d ./Core/TraceAnalyser/trcStaticBuffer.o ./Core/TraceAnalyser/trcStaticBuffer.su ./Core/TraceAnalyser/trcStreamingRecorder.cyclo ./Core/TraceAnalyser/trcStreamingRecorder.d ./Core/TraceAnalyser/trcStreamingRecorder.o ./Core/TraceAnalyser/trcStreamingRecorder.su ./Core/TraceAnalyser/trcString.cyclo ./Core/TraceAnalyser/trcString.d ./Core/TraceAnalyser/trcString.o ./Core/TraceAnalyser/trcString.su ./Core/TraceAnalyser/trcTask.cyclo ./Core/TraceAnalyser/trcTask.d ./Core/TraceAnalyser/trcTask.o ./Core/TraceAnalyser/trcTask.su ./Core/TraceAnalyser/trcTimestamp.cyclo ./Core/TraceAnalyser/trcTimestamp.d ./Core/TraceAnalyser/trcTimestamp.o ./Core/TraceAnalyser/trcTimestamp.su

.PHONY: clean-Core-2f-TraceAnalyser

