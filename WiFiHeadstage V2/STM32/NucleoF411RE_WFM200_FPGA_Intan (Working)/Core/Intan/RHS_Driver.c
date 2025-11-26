
/*
 * Init_RHS.c
 *
 *  Created on: Feb 21, 2025
 *      Author: david
 */
#include "RHS_Driver.h"

#define PRINT_COMMAND_INFO false
#define PRINT_DEBUG_BINARY false

uint16_t tx_vector[2];
uint16_t rx_vector[2];
uint8_t data_size = 2; //Number of 16bit word to send
uint8_t reg_address;
uint8_t cmd_selector;
uint16_t lsb_value;


char* binary_string(uint32_t value) {
    static char buffer[40];  // 32 bits + 7 spaces + null terminator
    int index = 0;

    for (int i = 31; i >= 0; i--) {
        buffer[index++] = (value & (1 << i)) ? '1' : '0';
        if (i % 8 == 0 && i != 0) {
            buffer[index++] = ' ';
        }
    }
    buffer[index] = '\0';

    return buffer;
}

void print_debug_binary(uint16_t *rx_vector){
	if (PRINT_DEBUG_BINARY){
		printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
		printf("------------------------------------------------  \r\n");
	}
}

void print_configuration(uint16_t tx_vector, uint8_t reg_address, uint16_t lsb_value) {
    uint8_t cmd_selector = tx_vector >> 8; // Extract the upper 8 bits for command selector
    const char *cmd_type = "Unknown";
    if ((cmd_selector & 0b11000000) == CONVERT_CMD) {
        cmd_type = "CONVERT";
    } else if ((cmd_selector & 0b11000000) == WRITE_CMD) {
        cmd_type = "WRITE";
    } else if ((cmd_selector & 0b11000000) == READ_CMD) {
        cmd_type = "READ";
    } else if (cmd_selector == CLEAR_CMD) {
        cmd_type = "CLEAR";
    }

    char flag_info[50] = "";
    if (cmd_selector & 0b00100000) { // U_FLAG
        strcat(flag_info, "U_FLAG");
    }
    if (cmd_selector & 0b00010000) { // M_FLAG
        if (flag_info[0]) strcat(flag_info, " | ");
        strcat(flag_info, "M_FLAG");
    }
    if (cmd_selector & 0b00001000) { // D_FLAG
        if (flag_info[0]) strcat(flag_info, " | ");
        strcat(flag_info, "D_FLAG");
    }
    if (cmd_selector & 0b00000100) { // H_FLAG
        if (flag_info[0]) strcat(flag_info, " | ");
        strcat(flag_info, "H_FLAG");
    }
    if (flag_info[0] == '\0') {
        strcpy(flag_info, "None");
    }

    if (PRINT_COMMAND_INFO){
    	printf("Command: %s | Register: %d | LSB : 0x%04X | Flags: %s \r\n", cmd_type, reg_address, lsb_value, flag_info);
		printf("------------------------------------------------  \r\n");
    }

}


void RHS2116_Read_Register(SPI_HandleTypeDef *hspi, uint8_t Register){
	// Register 255 - Read Dummy
	cmd_selector = READ_CMD;
	reg_address = Register;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}


void RHS2116_Clear_Command(SPI_HandleTypeDef *hspi){
	// Clear Command
	cmd_selector = CLEAR_CMD;
	reg_address = 0b00000000;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}


void RHS2116_Disable_Stim(SPI_HandleTypeDef *hspi, uint8_t Register){
	// Register 32 - Write Disable Stim A
	// Register 33 - Write Disable Stim B
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void RHS2116_Enable_Stim(SPI_HandleTypeDef *hspi){
	// Register 32 - Write Disable Stim A
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_32;
	lsb_value = 0b1010101010101010;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);

	// Register 33 - Write Disable Stim B
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_33;
	lsb_value = 0b0000000011111111 ;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}


void RHS2116_PowerUp_DCCouple_LowGain_Amp(SPI_HandleTypeDef *hspi, uint8_t Register){
	// Register 38 - Power Up DC-couple low-gain amplifiers
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = 0b1111111111111111;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}


void RHS2116_Configure_ADC_Sampling_Rate(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t adc_buffer_bias, uint8_t mux_bias){
	// Register 0 - Configure the ADC and analog MUX for a total ADC sampling rate of... EXEMPLE : 480 kS/s ( 16 × 30 kS/s)
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = (adc_buffer_bias << 6) | mux_bias;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}


void RHS2116_ADCFormat_DSPSetting_AuxOutput(SPI_HandleTypeDef *hspi, uint8_t Register,
		uint8_t DSPcutoffFreq, uint8_t DSPenable, uint8_t ABSmode, uint8_t TWOScomp, uint8_t weakMISO,
		uint8_t digout1_HiZ, uint8_t digout1, uint8_t digout2_HiZ, uint8_t digout2, uint8_t digoutOD){

	// Register 1 - Set all auxiliary digital outputs to a high-impedance state. Set DSP high-pass filter to 4.665 Hz.
	// IN EXEMPLE : 0x051A --> 0bxxx 0 0 1 0 1 0 0 0 1 1010
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = (digoutOD << 12) | (digout2 << 11)    | (digout2_HiZ << 10)
			  | (digout1 << 9)   | (digout1_HiZ << 8) | (weakMISO << 7)
			  | (TWOScomp << 6)  | (ABSmode << 5)  | (DSPenable << 4) | DSPcutoffFreq;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);


}


void RHS2116_Impedance_Check_Control(SPI_HandleTypeDef *hspi, uint8_t Register,
									uint8_t Zcheck_en, uint8_t Zcheck_scale, uint8_t Zcheck_load,
									uint8_t Zcheck_DAC_power, uint8_t Zcheck_select){
	// Register 2 - Power up DAC used for impedance testing, but disable impedance testing for now.
	// IN EXEMPLE : 0x0040 --> 0bxx 000000 x 1 0 00 xx 0
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = (Zcheck_select << 8)  | (Zcheck_DAC_power << 6)  | (Zcheck_load << 5)  | (Zcheck_scale << 4) | Zcheck_en;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}


void RHS2116_Impedence_Check_DAC(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t Zcheck_DAC){
	// Register 3 - Initialize impedance check DAC to midrange value
	// IN EXEMPLE : 0x0080 --> 0bxxxxxxxx 10000000
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = Zcheck_DAC;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}


void RHS2116_Amplifier_Bandwidth_Select_Upper(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t RH_sel1, uint8_t RH_sel2){
	// Register 4 - Set upper cutoff frequency of AC-coupled high-gain amplifiers to 7.5 kHz.
	// IN EXEMPLE : 0x0016 --> 0bxxxxx 00000 010110

	// Register 5 - Set upper cutoff frequency of AC-coupled high-gain amplifiers to 7.5 kHz.
	// IN EXEMPLE : 0x0017 --> 0bxxxxx 00000 010111
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = (RH_sel2 << 6) | RH_sel1;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}


void RHS2116_Amplifier_Bandwidth_Select_Lower(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t RL_sel1, uint8_t RL_sel2, uint8_t RL_sel3){
	// Register 6 - Set lower cutoff frequency of AC-coupled high-gain amplifiers to 5 Hz
	// IN EXEMPLE : 0x00A8 --> 0bxx 0 000001 0101000
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = (RL_sel3 << 13) | (RL_sel2 << 7) | RL_sel1;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void  RHS2116_Amplifier_Power_Up(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t AC_amp_power){
	// Register 8 - Power up all AC-coupled high-gain amplifiers.
	// IN EXEMPLE : 0xFFFF
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = AC_amp_power;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void RHS2116_Fast_Settle(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t amp_fast_settle){
	// Register 10 - Turn off fast settle function on all channels. (This command does not take effect until the U flag is asserted since Register 10 is a triggered register.)
	// IN EXEMPLE : 0x0000
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = amp_fast_settle;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[0] |= (1 << U_FLAG); // TRIGGERING U_FLAG
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);

}


void RHS2116_Amplifier_Lower_Cutoff(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t amp_fL_select){
	// Register 12 - Set all amplifiers to the lower cutoff frequency set by Register 6. Bits in this register can be set to zero during and immediately following stimulation
	// pulses to rapidly recover from stimulation artifacts. (This command does not take effect until the U flag is asserted since Register 10 is a triggered register.)
	// IN EXEMPLE : 0xFFFF --> 0xFFFF
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = amp_fL_select;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[0] |= (1 << U_FLAG); // TRIGGERING U_FLAG
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}


void RHS2116_Stimulation_Step_Size(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t step_sel1, uint8_t step_sel2, uint8_t step_sel3){
	// Register 34 - Set up a stimulation step size of 1 µA, giving us a stimulation range of ±255 µA on each channel.
	//IN EXEMPLE : 0x00E2 --> Obx 00 000001 1100010
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = (step_sel3 << 13) | (step_sel2 << 7) | (step_sel1);
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void RHS2116_Stimulation_Bias(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t stim_nbias, uint8_t stim_pbias){
	// Register 35 - Set stimulation bias voltages appropriate for a 1 µA step size.
	//IN EXEMPLE : 0x00AA --> Obxxxxxxxx 1010 1010
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = (stim_pbias << 4) | (stim_nbias);
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void RHS2116_Voltage_Charge_Recovery(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t charge_recovery_DAC){
	// Register 36 - Set current-limited charge recovery target voltage to zero.
	//IN EXEMPLE : 0x0080 --> Obxxxxxxxx 10000000
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = charge_recovery_DAC;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void RHS2116_Current_Charge_Recovery(SPI_HandleTypeDef *hspi, uint8_t Register, uint8_t Imax_sel1, uint8_t Imax_sel2, uint8_t Imax_sel3){
	// Register 37 - Set charge recovery current limit to 1 nA.
	//IN EXEMPLE : 0x4F00 --> Obx 10 011110 0000000
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = (Imax_sel3 << 13) | (Imax_sel2 << 7) | (Imax_sel1);
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void RHS2116_Stimulation_Turn_ON_OFF(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t stim_status){
	// Register 42 - Turn all stimulators off. (This command does not take effect until the U flag is asserted since Register 42 is a triggered register.)
	//IN EXEMPLE : 0x0000
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = stim_status;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[0] |= (1 << U_FLAG); // TRIGGERING U_FLAG
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void RHS2116_Stimulator_Polarity(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t stim_pol){
	// Register 44 - Set all stimulators to negative polarity. (This command does not take effect until the U flag is asserted since Register 44 is a triggered register.)
	//IN EXEMPLE : 0x0000
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = stim_pol;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[0] |= (1 << U_FLAG); // TRIGGERING U_FLAG
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void RHS2116_Charge_Recovery_Switches(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t charge_recovery_switch){
	// Register 46 - Open all charge recovery switches. (This command does not take effect until the U flag is asserted since Register 46 is a triggered register.)
	//IN EXEMPLE : 0x0000
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = charge_recovery_switch;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[0] |= (1 << U_FLAG); // TRIGGERING U_FLAG
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void RHS2116_Current_Limited_Charge_Recovery(SPI_HandleTypeDef *hspi, uint8_t Register, uint16_t CL_charge_recovery_enable){
	// Register 48 - Disable all current-limited charge recovery circuits. (This command does not take effect until the U flag is asserted since Register 48 is a triggered register.)
	//IN EXEMPLE : 0x0000
	cmd_selector = WRITE_CMD;
	reg_address = Register;
	lsb_value = CL_charge_recovery_enable;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[0] |= (1 << U_FLAG); // TRIGGERING U_FLAG
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
}

void RHS2116_Negative_Stimulation_Current_Magnitude(SPI_HandleTypeDef *hspi, uint8_t negative_current_trim, uint8_t negative_current_magnitude){
	// Write to registers 64-79, setting the negative stimulation current magnitudes to zero and the current
	// trims to the center point. (These commands do not take effect until the U flag is asserted since Registers 64-79 are triggered registers.)
	// Register 64
	//IN EXEMPLE : 0x8000 --> 0b1000000000000000
	uint16_t register_addresses[] = {
		REGISTER_64, REGISTER_65, REGISTER_66, REGISTER_67, REGISTER_68, REGISTER_69,
		REGISTER_70, REGISTER_71, REGISTER_72, REGISTER_73, REGISTER_74, REGISTER_75,
		REGISTER_76, REGISTER_77, REGISTER_78, REGISTER_79
	};

	for (int i = 0; i < sizeof(register_addresses) / sizeof(register_addresses[0]); i++) {
	    reg_address = register_addresses[i];
	    cmd_selector = WRITE_CMD;
	    lsb_value = (negative_current_trim << 8) | negative_current_magnitude;
	    tx_vector[0] = (cmd_selector << 8) | reg_address;
	    tx_vector[0] |= (1 << U_FLAG); // TRIGGERING U_FLAG
	    tx_vector[1] = lsb_value;
	    SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	    print_debug_binary(rx_vector);
	    print_configuration(tx_vector[0], reg_address, lsb_value);
	}
}

void RHS2116_Positive_Stimulation_Current_Magnitude(SPI_HandleTypeDef *hspi, uint8_t positive_current_trim, uint8_t positive_current_magnitude){
	// Write to registers 96-111, setting the positive stimulation current magnitudes to zero and the current
	// trims to the center point. (These commands do not take effect until the U flag is asserted since Registers 96-111 are triggered registers.)
	//IN EXEMPLE : 0x8000 --> 0b1000000000000000
	uint16_t register_addresses[] = {
		REGISTER_96,  REGISTER_97,  REGISTER_98,  REGISTER_99,  REGISTER_100, REGISTER_101,
		REGISTER_102, REGISTER_103, REGISTER_104, REGISTER_105, REGISTER_106, REGISTER_107,
		REGISTER_108, REGISTER_109, REGISTER_110, REGISTER_111
	};

	for (int i = 0; i < sizeof(register_addresses) / sizeof(register_addresses[0]); i++) {
	    reg_address = register_addresses[i];
	    cmd_selector = WRITE_CMD;
	    lsb_value = (positive_current_trim << 8) | positive_current_magnitude;
	    tx_vector[0] = (cmd_selector << 8) | reg_address;
	    tx_vector[0] |= (1 << U_FLAG); // TRIGGERING U_FLAG
	    tx_vector[1] = lsb_value;
	    SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	    print_debug_binary(rx_vector);
	    print_configuration(tx_vector[0], reg_address, lsb_value);
	}
}

void RHS2116_Read_INTAN(SPI_HandleTypeDef *hspi){
	// Register 251 - Read I and N
	cmd_selector = READ_CMD;
	reg_address = REGISTER_251;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);

	// Register 252 - Read T and A
	cmd_selector = READ_CMD;
	reg_address = REGISTER_252;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);

	// Register 253 - Read N and 0
	cmd_selector = READ_CMD;
	reg_address = REGISTER_253;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
	printf("Should be I and N:  %c   %c\r\n", (rx_vector[1] >> 8) & 0xFF, rx_vector[1] & 0xFF);
	printf("------------------------------------------------  \r\n");

	// Register 255 - Read Number of Channel and Die Revision (Read Dummy)
	cmd_selector = READ_CMD;
	reg_address = REGISTER_255;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
	printf("Should be T and A:  %c   %c\r\n", (rx_vector[1] >> 8) & 0xFF, rx_vector[1] & 0xFF);
	printf("------------------------------------------------  \r\n");

	// Register 255 - Read Number of Channel and Die Revision (Read Dummy)
	cmd_selector = READ_CMD;
	reg_address = REGISTER_255;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
	printf("Should be N and 0:  %c   %01X\r\n", (rx_vector[1] >> 8) & 0xFF, rx_vector[1] & 0xFF);
	printf("------------------------------------------------  \r\n");
}

uint16_t RHS2116_Read_NumChannel_DieRevision(SPI_HandleTypeDef *hspi, uint8_t Register){
	// Register 254 - Read Number of Channel and Die Revision
	cmd_selector = READ_CMD;
	reg_address = Register;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);

	// Register 255 - Read Dummy
	cmd_selector = READ_CMD;
	reg_address = REGISTER_255;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);

	// Register 255 - Read Dummy
	cmd_selector = READ_CMD;
	reg_address = REGISTER_255;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);

    // Combine values into a 16-bit return value
    uint8_t die_revision = (rx_vector[1] >> 8) & 0xFF;
    uint8_t num_channels = rx_vector[1] & 0xFF;

    printf("Die Revision : %d | #channel: %d\r\n", die_revision, num_channels);
    printf("------------------------------------------------  \r\n");

    return ((uint16_t)die_revision << 8) | num_channels;
}

uint8_t RHS2116_Read_Chip_ID(SPI_HandleTypeDef *hspi, uint8_t Register){
    // Register 255 - Read Dummy
    cmd_selector = READ_CMD;
    reg_address = Register;
    lsb_value = 0b0000000000000000;
    tx_vector[0] = (cmd_selector << 8) | (reg_address);
    tx_vector[1] = lsb_value;
    SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
    print_debug_binary(rx_vector);
    print_configuration(tx_vector[0], reg_address, lsb_value);

    // Register 255 - Read Dummy
    cmd_selector = READ_CMD;
    reg_address = Register;
    lsb_value = 0b0000000000000000;
    tx_vector[0] = (cmd_selector << 8) | (reg_address);
    tx_vector[1] = lsb_value;
    SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
    print_debug_binary(rx_vector);
    print_configuration(tx_vector[0], reg_address, lsb_value);

    // Register 255 - Read Dummy
    cmd_selector = READ_CMD;
    reg_address = Register;
    lsb_value = 0b0000000000000000;
    tx_vector[0] = (cmd_selector << 8) | (reg_address);
    tx_vector[1] = lsb_value;
    SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
    print_debug_binary(rx_vector);
    print_configuration(tx_vector[0], reg_address, lsb_value);

    // Extract Chip ID (lower 8 bits)
    uint8_t chip_id = rx_vector[1] & 0xFF;

    printf("Char Receiving Data - CHIP ID : %d \r\n", chip_id);
    printf("------------------------------------------------  \r\n");

    return chip_id;
}


void RHS2116_Convert_Register(SPI_HandleTypeDef *hspi){
	for (int loop = 0 ; loop < 1; loop ++){
		// Register 0
		cmd_selector = CONVERT_CMD;
		reg_address = REGISTER_0;
		lsb_value = 0b0000000000000000;
		tx_vector[0] = (cmd_selector << 12) | (reg_address);
		tx_vector[1] = lsb_value;
		SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	print_debug_binary(rx_vector);
	//	print_configuration(tx_vector[0], reg_address, lsb_value);
	//	printf("For CH %u Receiving Data : 0x%04X%04X | %s\r\n", REGISTER_0, rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");

		for (int i = 1; i<15; i++){
			reg_address = REGISTER_63;
			lsb_value = 0b0000000000000000;
			tx_vector[0] = (cmd_selector << 12) | (reg_address);
			tx_vector[1] = lsb_value;
			SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//		print_debug_binary(rx_vector);
	//		print_configuration(tx_vector[0], reg_address, lsb_value);
	//		printf("For CH %u Receiving Data : 0x%04X%04X | %s\r\n", i, rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//		printf("------------------------------------------------  \r\n");
		}
	}
}


void INIT_RHS(SPI_HandleTypeDef *hspi){

	//SET CS_PIN
	RHS_SPI_CS_Port->BSRR = RHS_SPI_CS_Pin;

	RHS2116_Read_Register(hspi, REGISTER_255);
	RHS2116_Disable_Stim(hspi, REGISTER_32);
	RHS2116_Disable_Stim(hspi, REGISTER_33);
	RHS2116_PowerUp_DCCouple_LowGain_Amp(hspi, REGISTER_38);
	RHS2116_Clear_Command(hspi);
	RHS2116_Configure_ADC_Sampling_Rate(hspi, REGISTER_0, 32, 40);

	// Register 1 - Set all auxiliary digital outputs to a high-impedance state. Set DSP high-pass filter to 4.665 Hz.
	// IN EXEMPLE : 0x051A --> 0bxxx 0 0 1 0 1 0 0 0 1 1010
	uint8_t DSPcutoffFreq = 0b1010;
	uint8_t DSPenable = 0b1;
	uint8_t ABSmode = 0b0;
	uint8_t TWOScomp = 0b0;
	uint8_t weakMISO = 0b0;
	uint8_t digout1_HiZ = 0b1;
	uint8_t digout1 = 0b0;
	uint8_t digout2_HiZ = 0b1;
	uint8_t digout2 = 0b0;
	uint8_t digoutOD = 0b0;
	RHS2116_ADCFormat_DSPSetting_AuxOutput(hspi, REGISTER_1,
											DSPcutoffFreq, DSPenable,ABSmode, TWOScomp,weakMISO,
											digout1_HiZ, digout1, digout2_HiZ, digout2, digoutOD);
	// Register 2 - Power up DAC used for impedance testing, but disable impedance testing for now.
	// IN EXEMPLE : 0x0040 --> 0bxx 000000 x 1 0 00 xx 0
	uint8_t Zcheck_en = 0b0;
	uint8_t Zcheck_scale = 0b00;
	uint8_t Zcheck_load = 0b0;
	uint8_t Zcheck_DAC_power = 0b1;
	uint8_t Zcheck_select = 0b000000;
	RHS2116_Impedance_Check_Control(hspi, REGISTER_2, Zcheck_en, Zcheck_scale, Zcheck_load, Zcheck_DAC_power, Zcheck_select);

	// Register 3 - Initialize impedance check DAC to midrange value
	// IN EXEMPLE : 0x0080 --> 0bxxxxxxxx 10000000
	uint8_t Zcheck_DAC = 0b10000000;
	RHS2116_Impedence_Check_DAC(hspi, REGISTER_3, Zcheck_DAC);

	// Register 4 - Set upper cutoff frequency of AC-coupled high-gain amplifiers to 7.5 kHz.
	// IN EXEMPLE : 0x0016 --> 0bxxxxx 00000 010110
	uint8_t RH1_sel1  = 0b010110;
	uint8_t RH1_sel2  = 0b00000;
	RHS2116_Amplifier_Bandwidth_Select_Upper(hspi, REGISTER_4, RH1_sel1, RH1_sel2);

	// Register 5 - Set upper cutoff frequency of AC-coupled high-gain amplifiers to 7.5 kHz.
	// IN EXEMPLE : 0x0017 --> 0bxxxxx 00000 010111
	uint8_t RH2_sel1  = 0b010111;
	uint8_t RH2_sel2  = 0b00000;
	RHS2116_Amplifier_Bandwidth_Select_Upper(hspi, REGISTER_5, RH2_sel1, RH2_sel2);

	// Register 6 - Set lower cutoff frequency of AC-coupled high-gain amplifiers to 5 Hz
	// IN EXEMPLE : 0x00A8 --> 0bxx 0 000001 0101000
	uint8_t RL_Asel1  = 0b0101000;
	uint8_t RL_Asel2  = 0b000001;
	uint8_t RL_Asel3  = 0b0;
	RHS2116_Amplifier_Bandwidth_Select_Lower(hspi, REGISTER_6, RL_Asel1, RL_Asel2, RL_Asel3);

	// Register 7 - Set alternate lower cutoff frequency (to be used for stimulation artifact recovery) to 1000 Hz
	// IN EXEMPLE : 0x000A --> 0bxx 0 000000 0001010
	uint8_t RL_Bsel1  = 0b0001010;
	uint8_t RL_Bsel2  = 0b000000;
	uint8_t RL_Bsel3  = 0b0;
	RHS2116_Amplifier_Bandwidth_Select_Lower(hspi, REGISTER_7, RL_Bsel1, RL_Bsel2, RL_Bsel3);

	// Register 8 - Power up all AC-coupled high-gain amplifiers.
	// IN EXEMPLE : 0xFFFF
	uint16_t AC_amp_power  = 0b1111111111111111;
	RHS2116_Amplifier_Power_Up(hspi, REGISTER_8, AC_amp_power);

	// Register 10 - Turn off fast settle function on all channels. (This command does not take effect until the U flag is asserted since Register 10 is a triggered register.)
	// IN EXEMPLE : 0x0000
	uint16_t amp_fast_settle  = 0b0000000000000000;
	RHS2116_Fast_Settle(hspi, REGISTER_10, amp_fast_settle);

	// Register 12 - Set all amplifiers to the lower cutoff frequency set by Register 6. Bits in this register can be set to zero during and immediately following stimulation
	// pulses to rapidly recover from stimulation artifacts. (This command does not take effect until the U flag is asserted since Register 10 is a triggered register.)
	// IN EXEMPLE : 0xFFFF --> 0xFFFF
	uint16_t amp_fL_select  = 0b1111111111111111;
	RHS2116_Amplifier_Lower_Cutoff(hspi, REGISTER_12, amp_fL_select);

	// Register 34 - Set up a stimulation step size of 1 µA, giving us a stimulation range of ±255 µA on each channel.
	//IN EXEMPLE : 0x00E2 --> Obx 00 000001 1100010
	uint8_t step_sel1 = 0b1100010;
	uint8_t step_sel2 = 0b000001;
	uint8_t step_sel3 = 0b00;
	RHS2116_Stimulation_Step_Size(hspi, REGISTER_34, step_sel1, step_sel2, step_sel3);

	// Register 35 - Set stimulation bias voltages appropriate for a 1 µA step size.
	//IN EXEMPLE : 0x00AA --> Obxxxxxxxx 1010 1010
	uint8_t stim_nbias = 0b1010;
	uint8_t stim_pbias = 0b1010;
	RHS2116_Stimulation_Bias(hspi, REGISTER_35, stim_nbias, stim_pbias);

	// Register 36 - Set current-limited charge recovery target voltage to zero.
	//IN EXEMPLE : 0x0080 --> Obxxxxxxxx 10000000
	uint8_t charge_recovery_DAC = 0b10000000;
	RHS2116_Voltage_Charge_Recovery(hspi, REGISTER_36, charge_recovery_DAC);

	// Register 37 - Set charge recovery current limit to 1 nA.
	//IN EXEMPLE : 0x4F00 --> Obx 10 011110 0000000
	uint8_t Imax_sel1 = 0b0000000;
	uint8_t Imax_sel2 = 0b011110;
	uint8_t Imax_sel3 = 0b10;
	RHS2116_Current_Charge_Recovery(hspi, REGISTER_37, Imax_sel1, Imax_sel2, Imax_sel3);

	// Register 42 - Turn all stimulators off. (This command does not take effect until the U flag is asserted since Register 42 is a triggered register.)
	//IN EXEMPLE : 0x0000
	uint16_t stim_status = 0x0000;
	RHS2116_Stimulation_Turn_ON_OFF(hspi, REGISTER_42, stim_status);

	// Register 44 - Set all stimulators to negative polarity. (This command does not take effect until the U flag is asserted since Register 44 is a triggered register.)
	//IN EXEMPLE : 0x0000
	uint16_t stim_pol = 0x0000;
	RHS2116_Stimulator_Polarity(hspi, REGISTER_44, stim_pol);

	// Register 46 - Open all charge recovery switches. (This command does not take effect until the U flag is asserted since Register 46 is a triggered register.)
	//IN EXEMPLE : 0x0000
	uint16_t charge_recovery_switch = 0x0000;
	RHS2116_Charge_Recovery_Switches(hspi, REGISTER_46, charge_recovery_switch);

	// Register 48 - Disable all current-limited charge recovery circuits. (This command does not take effect until the U flag is asserted since Register 48 is a triggered register.)
	//IN EXEMPLE : 0x0000
	uint16_t CL_charge_recovery_enable = 0x0000;
	RHS2116_Current_Limited_Charge_Recovery(hspi, REGISTER_48, CL_charge_recovery_enable);

	// Write to registers 64-79, setting the negative stimulation current magnitudes to zero and the current
	// trims to the center point. (These commands do not take effect until the U flag is asserted since Registers 64-79 are triggered registers.)
	//IN EXEMPLE : 0x8000 --> 0b1000000000000000
	// Define the common values for negative current trim and magnitude
	uint8_t negative_current_trim = 0b10000000;
	uint8_t negative_current_magnitude = 0b00000000;
	RHS2116_Negative_Stimulation_Current_Magnitude(hspi, negative_current_trim, negative_current_magnitude);

	// Write to registers 96-111, setting the negative stimulation current magnitudes to zero and the current
	// trims to the center point. (These commands do not take effect until the U flag is asserted since Registers 96-111 are triggered registers.)
	//IN EXEMPLE : 0x8000 --> 0b1000000000000000
	// Define the common values for negative current trim and magnitude
	uint8_t positive_current_trim = 0b10000000;
	uint8_t positive_current_magnitude = 0b00000000;
	RHS2116_Positive_Stimulation_Current_Magnitude(hspi, positive_current_trim, positive_current_magnitude);

	// Should Return ascii character INTAN
	RHS2116_Read_INTAN(hspi);

	// Should Return Number Of channels and Die Revision of the chip
	uint16_t result = RHS2116_Read_NumChannel_DieRevision(hspi, REGISTER_254);
	uint8_t die_revision = (result >> 8) & 0xFF;
	uint8_t num_channels = result & 0xFF;
	printf("Extracted: Die Revision : %d | Num Channels : %d \r\n", die_revision, num_channels);

	// Should Return Chip ID
	uint8_t chip_id = RHS2116_Read_Chip_ID(hspi, REGISTER_255);
	printf("Extracted CHIP ID: %d \r\n", chip_id);

	// Register 0
	cmd_selector = CONVERT_CMD;
	reg_address = REGISTER_0;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 12) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
//	printf("Receiving Data : 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");


	// Register 0
	cmd_selector = CONVERT_CMD;
	reg_address = REGISTER_63;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 12) | (reg_address);
	tx_vector[0] |= (1 << D_FLAG);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
//	printf("Receiving Data : 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");


	// Register 0
	cmd_selector = CONVERT_CMD;
	reg_address = REGISTER_63;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 12) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
	printf("Receiving Data - Should be 16bits on MSB: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	printf("------------------------------------------------  \r\n");

	// Register 0
	cmd_selector = CONVERT_CMD;
	reg_address = REGISTER_63;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 12) | (reg_address);
	tx_vector[0] |= (1 << D_FLAG);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
	printf("Receiving Data - Should be 10bits on LSB: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	printf("------------------------------------------------  \r\n");

	// Register 0
	cmd_selector = CONVERT_CMD;
	reg_address = REGISTER_63;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 12) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
	printf("Receiving Data - Should be 16bits on MSB: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	printf("------------------------------------------------  \r\n");

	// Register 0
	cmd_selector = CONVERT_CMD;
	reg_address = REGISTER_63;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 12) | (reg_address);
	tx_vector[0] |= (1 << D_FLAG);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	print_debug_binary(rx_vector);
	print_configuration(tx_vector[0], reg_address, lsb_value);
	printf("Receiving Data - Should be 10bits on LSB: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	printf("------------------------------------------------  \r\n");

	RHS2116_Convert_Register(hspi);

}
