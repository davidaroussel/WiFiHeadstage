################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Middlewares/Third_Party/mbedTLS/library/subdir.mk
-include Middlewares/Third_Party/mbedTLS/App/subdir.mk
-include Middlewares/Third_Party/LwIP/system/OS/subdir.mk
-include Middlewares/Third_Party/LwIP/src/netif/ppp/polarssl/subdir.mk
-include Middlewares/Third_Party/LwIP/src/netif/ppp/subdir.mk
-include Middlewares/Third_Party/LwIP/src/netif/subdir.mk
-include Middlewares/Third_Party/LwIP/src/core/ipv6/subdir.mk
-include Middlewares/Third_Party/LwIP/src/core/ipv4/subdir.mk
-include Middlewares/Third_Party/LwIP/src/core/subdir.mk
-include Middlewares/Third_Party/LwIP/src/apps/tftp/subdir.mk
-include Middlewares/Third_Party/LwIP/src/apps/sntp/subdir.mk
-include Middlewares/Third_Party/LwIP/src/apps/snmp/subdir.mk
-include Middlewares/Third_Party/LwIP/src/apps/smtp/subdir.mk
-include Middlewares/Third_Party/LwIP/src/apps/netbiosns/subdir.mk
-include Middlewares/Third_Party/LwIP/src/apps/mqtt/subdir.mk
-include Middlewares/Third_Party/LwIP/src/apps/mdns/subdir.mk
-include Middlewares/Third_Party/LwIP/src/apps/lwiperf/subdir.mk
-include Middlewares/Third_Party/LwIP/src/apps/http/subdir.mk
-include Middlewares/Third_Party/LwIP/src/apps/altcp_tls/subdir.mk
-include Middlewares/Third_Party/LwIP/src/api/subdir.mk
-include Middlewares/Third_Party/FreeRTOS/Source/portable/MemMang/subdir.mk
-include Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F/subdir.mk
-include Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS/subdir.mk
-include Middlewares/Third_Party/FreeRTOS/Source/subdir.mk
-include Drivers/wfx_fmac_driver/sl_wfx_host/subdir.mk
-include Drivers/wfx_fmac_driver/secure_link/subdir.mk
-include Drivers/wfx_fmac_driver/bus/subdir.mk
-include Drivers/wfx_fmac_driver/subdir.mk
-include Drivers/STM32F4xx_HAL_Driver/Src/subdir.mk
-include Core/TraceAnalyser/subdir.mk
-include Core/Startup/subdir.mk
-include Core/Src/subdir.mk
-include Core/Apps/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

OPTIONAL_TOOL_DEPS := \
$(wildcard ../makefile.defs) \
$(wildcard ../makefile.init) \
$(wildcard ../makefile.targets) \


BUILD_ARTIFACT_NAME := NucleoF411RE_WFM200_FPGA_Intan
BUILD_ARTIFACT_EXTENSION := elf
BUILD_ARTIFACT_PREFIX :=
BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
NucleoF411RE_WFM200_FPGA_Intan.elf \

MAP_FILES += \
NucleoF411RE_WFM200_FPGA_Intan.map \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
NucleoF411RE_WFM200_FPGA_Intan.list \


# All Target
all: main-build

# Main-build Target
main-build: NucleoF411RE_WFM200_FPGA_Intan.elf secondary-outputs

# Tool invocations
NucleoF411RE_WFM200_FPGA_Intan.elf NucleoF411RE_WFM200_FPGA_Intan.map: $(OBJS) $(USER_OBJS) C:\Users\david\Desktop\WiFi\ Headstage\WiFiHeadstage\ V2\STM32\NucleoF411RE_WFM200_FPGA_Intan\STM32F411RETX_FLASH.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-gcc -o "NucleoF411RE_WFM200_FPGA_Intan.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m4 -T"C:\Users\david\Desktop\WiFi Headstage\WiFiHeadstage V2\STM32\NucleoF411RE_WFM200_FPGA_Intan\STM32F411RETX_FLASH.ld" --specs=nosys.specs -Wl,-Map="NucleoF411RE_WFM200_FPGA_Intan.map" -Wl,--gc-sections -static --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -u _printf_float -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

NucleoF411RE_WFM200_FPGA_Intan.list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "NucleoF411RE_WFM200_FPGA_Intan.list"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) NucleoF411RE_WFM200_FPGA_Intan.elf NucleoF411RE_WFM200_FPGA_Intan.list NucleoF411RE_WFM200_FPGA_Intan.map default.size.stdout
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST)

fail-specified-linker-script-missing:
	@echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
	@exit 2

warn-no-linker-script-specified:
	@echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

.PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified

-include ../makefile.targets
