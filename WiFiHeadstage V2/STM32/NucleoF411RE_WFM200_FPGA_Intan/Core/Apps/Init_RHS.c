
/*
 * Init_RHS.c
 *
 *  Created on: Feb 21, 2025
 *      Author: david
 */
#include "Init_RHS.h"

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

void print_configuration(uint8_t cmd_selector, uint8_t reg_address, uint16_t lsb_value) {
    // Determine the command type string
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

    // Determine flag status
    const char *flag_info = "";
    if (cmd_selector & 0b00010000) { // Binary equivalent for M_Flag
        flag_info = "M_FLAG";
    }
    if (cmd_selector & 0b00100000) { // Binary equivalent for U_Flag
        if (*flag_info) {
            flag_info = strcat(flag_info, " | U_FLAG");
        } else {
            flag_info = "U_FLAG";
        }
    }
    if (!*flag_info) {
        flag_info = "None";
    }

    // Single printf statement
    printf("Command: %s | Register: %d | LSB : 0x%04X | Flags: %s \r\n", cmd_type, reg_address, lsb_value, flag_info);
    printf("------------------------------------------------  \r\n");
}


void INIT_RHS(SPI_HandleTypeDef *hspi){
	uint16_t tx_vector[2];
	uint16_t rx_vector[2];
	uint8_t data_size = 2; //Number of 16bit word to send
	uint8_t reg_address;
	uint8_t cmd_selector;
	uint16_t lsb_value;

	//SET CS_PIN
	RHS_SPI_CS_Port->BSRR = RHS_SPI_CS_Pin;

	// Register 255 - Read Dummy
	cmd_selector = READ_CMD;
	reg_address = REGISTER_255;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 32 - Write Disable Stim A
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_32;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);


	// Register 33 - Write Disable Stim B
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_33;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);



	// Register 38 - Power Up DC-couple low-gain amplifiers
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_38;
	lsb_value = 0b1111111111111111;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);


	// Clear Command
	cmd_selector = CLEAR_CMD;
	reg_address = 0b00000000;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 0 - Configure the ADC and analog MUX for a total ADC sampling rate of... EXEMPLE : 480 kS/s ( 16 × 30 kS/s)
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_0;
	uint8_t adc_buffer_bias = 32;
	uint8_t mux_bias = 40;
	lsb_value = (adc_buffer_bias << 6) | mux_bias;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);


	// Register 1 - Set all auxiliary digital outputs to a high-impedance state. Set DSP high-pass filter to 4.665 Hz.
	// IN EXEMPLE : 0x051A --> 0bxxx 0 0 1 0 1 0 0 0 1 1010
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_1;
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
	lsb_value = (digoutOD << 12) | (digout2 << 11)    | (digout2_HiZ << 10)
			  | (digout1 << 9)   | (digout1_HiZ << 8) | (weakMISO << 7)
			  | (TWOScomp << 6)  | (ABSmode << 5)  | (DSPenable << 4) | DSPcutoffFreq;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);


	// Register 2 - Power up DAC used for impedance testing, but disable impedance testing for now.
	// IN EXEMPLE : 0x0040 --> 0bxx 000000 x 1 0 00 xx 0
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_2;
	uint8_t Zcheck_en = 0b0;
	uint8_t Zcheck_scale = 0b00;
	uint8_t Zcheck_load = 0b0;
	uint8_t Zcheck_DAC_power = 0b1;
	uint8_t Zcheck_select = 0b000000;
	lsb_value = (Zcheck_select << 8)  | (Zcheck_DAC_power << 6)  | (Zcheck_load << 5)  | (Zcheck_scale << 4) | Zcheck_en;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 3 - Initialize impedance check DAC to midrange value
	// IN EXEMPLE : 0x0080 --> 0bxxxxxxxx 10000000
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_3;
	uint8_t Zcheck_DAC = 0b10000000;
	lsb_value = Zcheck_DAC;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);


	// Register 4 - Set upper cutoff frequency of AC-coupled high-gain amplifiers to 7.5 kHz.
	// IN EXEMPLE : 0x0016 --> 0bxxxxx 00000 010110
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_4;
	uint8_t RH1_sel1  = 0b010110;
	uint8_t RH1_sel2  = 0b00000;
	lsb_value = (RH1_sel2 << 6) | RH1_sel1;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 5 - Set upper cutoff frequency of AC-coupled high-gain amplifiers to 7.5 kHz.
	// IN EXEMPLE : 0x0017 --> 0bxxxxx 00000 010111
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_5;
	uint8_t RH2_sel1  = 0b010111;
	uint8_t RH2_sel2  = 0b00000;
	lsb_value = (RH2_sel2 << 6) | RH2_sel1;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 6 - Set lower cutoff frequency of AC-coupled high-gain amplifiers to 5 Hz
	// IN EXEMPLE : 0x00A8 --> 0bxx 0 000001 0101000
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_6;
	uint8_t RL_Asel1  = 0b0101000;
	uint8_t RL_Asel2  = 0b000001;
	uint8_t RL_Asel3  = 0b0;
	lsb_value = (RL_Asel3 << 13) | (RL_Asel2 << 7) | RL_Asel1;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 7 - Set alternate lower cutoff frequency (to be used for stimulation artifact recovery) to 1000 Hz
	// IN EXEMPLE : 0x000A --> 0bxx 0 000000 0001010
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_7;
	uint8_t RL_Bsel1  = 0b0001010;
	uint8_t RL_Bsel2  = 0b000000;
	uint8_t RL_Bsel3  = 0b0;
	lsb_value = (RL_Bsel3 << 13) | (RL_Bsel2 << 7) | RL_Bsel1;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 8 - Power up all AC-coupled high-gain amplifiers.
	// IN EXEMPLE : 0xFFFF
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_8;
	uint16_t AC_amp_power  = 0b1111111111111111;
	lsb_value = AC_amp_power;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 10 - Turn off fast settle function on all channels. (This command does not take effect until the U flag is asserted since Register 10 is a triggered register.)
	// IN EXEMPLE : 0x0000
	cmd_selector = WRITE_CMD;
	cmd_selector |= (1 << U_FLAG);
	reg_address = REGISTER_10;
	uint16_t amp_fast_settle  = 0b0000000000000000;
	lsb_value = amp_fast_settle;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 12 - Set all amplifiers to the lower cutoff frequency set by Register 6. Bits in this register can be set to zero during and immediately following stimulation
	// pulses to rapidly recover from stimulation artifacts. (This command does not take effect until the U flag is asserted since Register 10 is a triggered register.)
	// IN EXEMPLE : 0xFFFF --> 0xFFFF
	cmd_selector = WRITE_CMD;
	cmd_selector |= (1 << U_FLAG);
	reg_address = REGISTER_12;
	uint16_t amp_fL_select  = 0b1111111111111111;
	lsb_value = amp_fL_select;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);



	// Register 34 - Set up a stimulation step size of 1 µA, giving us a stimulation range of ±255 µA on each channel.
	//IN EXEMPLE : 0x00E2 --> Obx 00 000001 1100010
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_34;
	uint8_t step_sel1 = 0b1100010;
	uint8_t step_sel2 = 0b000001;
	uint8_t step_sel3 = 0b00;
	lsb_value = (step_sel3 << 13) | (step_sel2 << 7) | (step_sel1);
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 35 - Set stimulation bias voltages appropriate for a 1 µA step size.
	//IN EXEMPLE : 0x00AA --> Obxxxxxxxx 1010 1010
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_35;
	uint8_t stim_nbias = 0b1010;
	uint8_t stim_Pbias = 0b1010;
	lsb_value = (stim_Pbias << 4) | (stim_nbias);
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 36 - Set stimulation bias voltages appropriate for a 1 µA step size.
	//IN EXEMPLE : 0x0080 --> Obxxxxxxxx 10000000
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_36;
	uint8_t charge_recovery_DAC = 0b10000000;
	lsb_value = charge_recovery_DAC;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 37 - Set charge recovery current limit to 1 nA.
	//IN EXEMPLE : 0x4F00 --> Obx 10 011110 0000000
	cmd_selector = WRITE_CMD;
	reg_address = REGISTER_37;
	uint8_t Imax_sel1 = 0b0000000;
	uint8_t Imax_sel2 = 0b011110;
	uint8_t Imax_sel3 = 0b10;
	lsb_value = (Imax_sel3 << 13) | (Imax_sel2 << 7) | (Imax_sel1);
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 42 - Turn all stimulators off. (This command does not take effect until the U flag is asserted since Register 42 is a triggered register.)
	//IN EXEMPLE : 0x0000
	cmd_selector = WRITE_CMD;
	cmd_selector |= (1 << U_FLAG);
	reg_address = REGISTER_42;
	uint16_t stim_on = 0x0000;
	lsb_value = stim_on;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 44 - Set all stimulators to negative polarity. (This command does not take effect until the U flag is asserted since Register 44 is a triggered register.)
	//IN EXEMPLE : 0x0000
	cmd_selector = WRITE_CMD;
	cmd_selector |= (1 << U_FLAG);
	reg_address = REGISTER_44;
	uint16_t stim_pol = 0x0000;
	lsb_value = stim_pol;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 46 - Open all charge recovery switches. (This command does not take effect until the U flag is asserted since Register 46 is a triggered register.)
	//IN EXEMPLE : 0x0000
	cmd_selector = WRITE_CMD;
	cmd_selector |= (1 << U_FLAG);
	reg_address = REGISTER_46;
	uint16_t charge_recovery_switch = 0x0000;
	lsb_value = charge_recovery_switch;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 48 - Disable all current-limited charge recovery circuits. (This command does not take effect until the U flag is asserted since Register 48 is a triggered register.)
	//IN EXEMPLE : 0x0000
	cmd_selector = WRITE_CMD;
	cmd_selector |= (1 << U_FLAG);
	reg_address = REGISTER_48;
	uint16_t CL_charge_recovery_enable = 0x0000;
	lsb_value = CL_charge_recovery_enable;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] =  lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	print_configuration(cmd_selector, reg_address, lsb_value);



	// Write to registers 64-79, setting the negative stimulation current magnitudes to zero and the current
	// trims to the center point. (These commands do not take effect until the U flag is asserted since Registers 64-79 are triggered registers.)
	// Register 64
	//IN EXEMPLE : 0x8000 --> 0b1000000000000000
	uint16_t register_addresses[] = {
		REGISTER_64, REGISTER_65, REGISTER_66, REGISTER_67, REGISTER_68, REGISTER_69,
		REGISTER_70, REGISTER_71, REGISTER_72, REGISTER_73, REGISTER_74, REGISTER_75,
		REGISTER_76, REGISTER_77, REGISTER_78, REGISTER_79,
		REGISTER_96,  REGISTER_97,  REGISTER_98,  REGISTER_99,  REGISTER_100, REGISTER_101,
		REGISTER_102, REGISTER_103, REGISTER_104, REGISTER_105, REGISTER_106, REGISTER_107,
		REGISTER_108, REGISTER_109, REGISTER_110, REGISTER_111
	};

	// Define the common values for negative current trim and magnitude
	uint8_t negative_current_trim = 0b10000000;
	uint8_t negative_current_magnitude = 0b00000000;

	for (int i = 0; i < sizeof(register_addresses) / sizeof(register_addresses[0]); i++) {
	    reg_address = register_addresses[i];
	    cmd_selector = WRITE_CMD | (1 << U_FLAG);
	    lsb_value = (negative_current_trim << 8) | negative_current_magnitude;
	    tx_vector[0] = (cmd_selector << 8) | reg_address;
	    tx_vector[1] = lsb_value;
	    SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	    print_configuration(cmd_selector, reg_address, lsb_value);
	}


	// Register 251 - Read I and N
	cmd_selector = READ_CMD;
	reg_address = REGISTER_251;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
//	print_configuration(cmd_selector, reg_address, lsb_value);


	// Register 252 - Read T and A
	cmd_selector = READ_CMD;
	reg_address = REGISTER_252;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
//	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 251 - Read N and 0
	cmd_selector = READ_CMD;
	reg_address = REGISTER_253;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	printf("Should be I and N:  %c   %c\r\n", (rx_vector[1] >> 8) & 0xFF, rx_vector[1] & 0xFF);
//	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 254 - Read Number of Channel and Die Revision
	cmd_selector = READ_CMD;
	reg_address = REGISTER_254;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
	//	printf("Receiving Data: 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
	//	printf("------------------------------------------------  \r\n");
	printf("Should be T and A:  %c   %c\r\n", (rx_vector[1] >> 8) & 0xFF, rx_vector[1] & 0xFF);
//	print_configuration(cmd_selector, reg_address, lsb_value);


	// Register 255 - Read Dummy
	cmd_selector = READ_CMD;
	reg_address = REGISTER_255;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
//	printf("Receiving Data : 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");
	printf("Should be N and 0:  %c   %01X\r\n", (rx_vector[1] >> 8) & 0xFF, rx_vector[1] & 0xFF);
//	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 255 - Read Dummy
	cmd_selector = READ_CMD;
	reg_address = REGISTER_255;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
//	printf("Receiving Data : 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");
	printf("Die Revision : %d | #channel: %d\r\n", (rx_vector[1] >> 8) & 0xFF, rx_vector[1] & 0xFF);
//	print_configuration(cmd_selector, reg_address, lsb_value);

	// Register 255 - Read Dummy
	cmd_selector = READ_CMD;
	reg_address = REGISTER_255;
	lsb_value = 0b0000000000000000;
	tx_vector[0] = (cmd_selector << 8) | (reg_address);
	tx_vector[1] = lsb_value;
	SPI_SEND_RECV(hspi, tx_vector, rx_vector, data_size);
//	printf("Receiving Data : 0x%04X%04X | %s\r\n", rx_vector[0], rx_vector[1], binary_string((uint32_t)(rx_vector[0] << 16 | rx_vector[1])));
//	printf("------------------------------------------------  \r\n");
	printf("Char Receiving Data - CHIP ID : %d \r\n", (rx_vector[1] & 0xFF));
//	print_configuration(cmd_selector, reg_address, lsb_value);


}
