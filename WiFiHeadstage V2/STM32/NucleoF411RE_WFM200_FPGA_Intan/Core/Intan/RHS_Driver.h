/*
 * Init_RHS.h
 *
 *  Created on: Feb 21, 2025
 *      Author: david
 */

#ifndef APPS_RHS_DRIVER_H_
#define APPS_RHS_DRIVER_H_

#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include "Task_Apps_Start.h"

char* binary_string(uint32_t value);

void print_debug_binary(uint16_t *rx_vector);
void print_configuration(uint8_t cmd_selector, uint8_t reg_address, uint16_t lsb_value);

void RHS2116_Read_Register(SPI_HandleTypeDef *hspi, uint8_t Register);
void RHS2116_Clear_Command(SPI_HandleTypeDef *hspi);
void RHS2116_Disable_Stim(SPI_HandleTypeDef *hspi, uint8_t Register);
void RHS2116_PowerUp_DCCouple_LowGain_Amp(SPI_HandleTypeDef *hspi, uint8_t Register);
void RHS2116_Configure_ADC_Sampling_Rate(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t adc_buffer_bias, uint8_t mux_bias);

void RHS2116_ADCFormat_DSPSetting_AuxOutput(SPI_HandleTypeDef *hspi, uint8_t Register,
											uint8_t DSPcutoffFreq, uint8_t DSPenable, uint8_t ABSmode, uint8_t TWOScomp, uint8_t weakMISO,
											uint8_t digout1_HiZ, uint8_t digout1, uint8_t digout2_HiZ, uint8_t digout2, uint8_t digoutOD);

void RHS2116_Impedance_Check_Control(SPI_HandleTypeDef *hspi, uint8_t Register,
									uint8_t Zcheck_en, uint8_t Zcheck_scale, uint8_t Zcheck_load,
									uint8_t Zcheck_DAC_power, uint8_t Zcheck_select);

void RHS2116_Impedence_Check_DAC(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t Zcheck_DAC);
void RHS2116_Amplifier_Bandwidth_Select_Upper(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t RH_sel1, uint8_t RH_sel2);
void RHS2116_Amplifier_Bandwidth_Select_Lower(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t RL_sel1, uint8_t RL_sel2, uint8_t RL_sel3);
void RHS2116_Amplifier_Power_Up(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t AC_amp_power);
void RHS2116_Fast_Settle(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t amp_fast_settle);
void RHS2116_Amplifier_Lower_Cutoff(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t amp_fL_select);
void RHS2116_Stimulation_Step_Size(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t step_sel1, uint8_t step_sel2, uint8_t step_sel3);
void RHS2116_Stimulation_Bias(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t stim_nbias, uint8_t stim_pbias);
void RHS2116_Voltage_Charge_Recovery(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t charge_recovery_DAC);
void RHS2116_Current_Charge_Recovery(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t Imax_sel1, uint8_t Imax_sel2, uint8_t Imax_sel3);
void RHS2116_Stimulation_Turn_ON_OFF(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t stim_status);
void RHS2116_Stimulator_Polarity(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t stim_pol);
void RHS2116_Charge_Recovery_Switches(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t charge_recovery_switch);
void RHS2116_Current_Limited_Charge_Recovery(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t CL_charge_recovery_enable);
void RHS2116_Negative_Stimulation_Current_Magnitude(SPI_HandleTypeDef *hspi, uint8_t negative_current_trim, uint8_t negative_current_magnitude);
void RHS2116_Positive_Stimulation_Current_Magnitude(SPI_HandleTypeDef *hspi, uint8_t positive_current_trim, uint8_t positive_current_magnitude);

void RHS2116_Read_INTAN(SPI_HandleTypeDef *hspi);
uint16_t RHS2116_Read_NumChannel_DieRevision(SPI_HandleTypeDef *hspi, uint8_t Register);
uint8_t RHS2116_Read_Chip_ID(SPI_HandleTypeDef *hspi, uint8_t Register);

void INIT_RHS(SPI_HandleTypeDef *hspi);

#define CONVERT_CMD  0b00000
#define WRITE_CMD    0b10000000
#define READ_CMD     0b11000000
#define CLEAR_CMD    0b01101010

#define M_FLAG  4
#define U_FLAG  5


#define REGISTER_0   0b00000000
#define REGISTER_1   0b00000001
#define REGISTER_2   0b00000010
#define REGISTER_3   0b00000011
#define REGISTER_4   0b00000100
#define REGISTER_5   0b00000101
#define REGISTER_6   0b00000110
#define REGISTER_7   0b00000111
#define REGISTER_8   0b00001000

#define REGISTER_10  0b00001010

#define REGISTER_12  0b00001100

#define REGISTER_32  0b00100000
#define REGISTER_33  0b00100001
#define REGISTER_34  0b00100010
#define REGISTER_35  0b00100011
#define REGISTER_36  0b00100100
#define REGISTER_37  0b00100101
#define REGISTER_38  0b00100110
#define REGISTER_39  0b00100111
#define REGISTER_40  0b00101000
#define REGISTER_41  0b00101001
#define REGISTER_42  0b00101010
#define REGISTER_43  0b00101011
#define REGISTER_44  0b00101100
#define REGISTER_45  0b00101101
#define REGISTER_46  0b00101110
#define REGISTER_47  0b00101111
#define REGISTER_48  0b00110000
#define REGISTER_49  0b00110001
#define REGISTER_50  0b00110010

#define REGISTER_63  0b00111111

#define REGISTER_64  0b01000000
#define REGISTER_65  0b01000001
#define REGISTER_66  0b01000010
#define REGISTER_67  0b01000011
#define REGISTER_68  0b01000100
#define REGISTER_69  0b01000101
#define REGISTER_70  0b01000110
#define REGISTER_71  0b01000111
#define REGISTER_72  0b01001000
#define REGISTER_73  0b01001001
#define REGISTER_74  0b01001010
#define REGISTER_75  0b01001011
#define REGISTER_76  0b01001100
#define REGISTER_77  0b01001101
#define REGISTER_78  0b01001110
#define REGISTER_79  0b01001111

#define REGISTER_96  0b01100000
#define REGISTER_97  0b01100001
#define REGISTER_98  0b01100010
#define REGISTER_99  0b01100011
#define REGISTER_100 0b01100100
#define REGISTER_101 0b01100101
#define REGISTER_102 0b01100110
#define REGISTER_103 0b01100111
#define REGISTER_104 0b01101000
#define REGISTER_105 0b01101001
#define REGISTER_106 0b01101010
#define REGISTER_107 0b01101011
#define REGISTER_108 0b01101100
#define REGISTER_109 0b01101101
#define REGISTER_110 0b01101110
#define REGISTER_111 0b01101111

#define REGISTER_251 0b11111011
#define REGISTER_252 0b11111100
#define REGISTER_253 0b11111101
#define REGISTER_254 0b11111110
#define REGISTER_255 0b11111111

#endif /* APPS_RHS_DRIVER_H_ */
