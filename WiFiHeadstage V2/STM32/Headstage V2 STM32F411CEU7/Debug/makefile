################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Drivers/STM32F4xx_HAL_Driver/Src/subdir.mk
-include Core/Startup/subdir.mk
-include Core/Src/subdir.mk
-include Core/Intan/subdir.mk
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


BUILD_ARTIFACT_NAME := Headstage V2 STM32F411CEU7
BUILD_ARTIFACT_EXTENSION := elf
BUILD_ARTIFACT_PREFIX :=
BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
Headstage\ V2\ STM32F411CEU7.elf \

MAP_FILES += \
Headstage\ V2\ STM32F411CEU7.map \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
Headstage\ V2\ STM32F411CEU7.list \


# All Target
all: main-build

# Main-build Target
main-build: Headstage\ V2\ STM32F411CEU7.elf secondary-outputs

# Tool invocations
Headstage\ V2\ STM32F411CEU7.elf Headstage\ V2\ STM32F411CEU7.map: $(OBJS) $(USER_OBJS) C:\Users\david\Desktop\WiFiHeadstage\WiFiHeadstage\ V2\STM32\Headstage\ V2\ STM32F411CEU7\STM32F411CEUX_FLASH.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-gcc -o "Headstage V2 STM32F411CEU7.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m4 -T"C:\Users\david\Desktop\WiFiHeadstage\WiFiHeadstage V2\STM32\Headstage V2 STM32F411CEU7\STM32F411CEUX_FLASH.ld" --specs=nosys.specs -Wl,-Map="Headstage V2 STM32F411CEU7.map" -Wl,--gc-sections -static --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

Headstage\ V2\ STM32F411CEU7.list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "Headstage V2 STM32F411CEU7.list"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) Headstage\ V2\ STM32F411CEU7.elf Headstage\ V2\ STM32F411CEU7.list Headstage\ V2\ STM32F411CEU7.map Headstage\\ V2\\ STM32F411CEU7.elf default.size.stdout
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST)

fail-specified-linker-script-missing:
	@echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
	@exit 2

warn-no-linker-script-specified:
	@echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

.PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified

-include ../makefile.targets
