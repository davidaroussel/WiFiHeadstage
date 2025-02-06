/*
  Intan Technologies RHD STM32 Firmware Framework
  Version 1.1

  Copyright (c) 2024 Intan Technologies

  This file is part of the Intan Technologies RHD STM32 Firmware Framework.

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the “Software”), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.


  See <http://www.intantech.com> for documentation and product information.
  
 */

#include "userfunctions.h"
#include <stdlib.h>
#include <math.h>

volatile uint16_t command_sequence_MOSI[CONVERT_COMMANDS_PER_SEQUENCE + AUX_COMMANDS_PER_SEQUENCE] = {0};
volatile uint16_t command_sequence_MISO[CONVERT_COMMANDS_PER_SEQUENCE + AUX_COMMANDS_PER_SEQUENCE] = {0};

volatile uint16_t sample_counter = 0;
uint16_t *sample_memory = NULL;
uint32_t per_channel_sample_memory_capacity = 20000;

volatile uint16_t aux_command_list[AUX_COMMANDS_PER_SEQUENCE][AUX_COMMAND_LIST_LENGTH] = {{0}};
volatile uint8_t aux_command_index = 0;

volatile int zcheck_DAC_command_slot_position = -1;
volatile int zcheck_DAC_command_list_length = -1;
volatile uint8_t zcheck_DAC_command_index = 0;

volatile uint32_t command_transfer_state = TRANSFER_COMPLETE;

volatile uint8_t reception_in_progress = 0;
volatile uint8_t main_loop_active = 0;
volatile uint8_t uart_ready = 1;


// Function that executes every time the INTERRUPT_TIM timer reaches its target value,
// which governs the sample rate, and should trigger reading from all active channels once.
// To monitor how much time is spent executing this interrupt routine, at the beginning of this function
// Main_Monitor_Pin is written Low (indicating that main loop is not processing),
// and Interrupt_Monitor_Pin is written High (so that the frequency of the square wave on this pin should
// correspond to the sample rate).
// If the next TIM interrupt triggers before the previous execution completes (interrupt clipping), this
// will be reported via handle_comm_error, and program execution will enter an infinite loop.
// This is a critical error, because the TIM interrupt can no longer be a reliable sample rate trigger.
// If this occurs, either the period must be increased (decreasing sample rate), or the processing within
// each interrupt iteration must be reduced so that it can finish before the next TIM period occurs.
// Due to use of DMA in this example (which is very efficient for large data transfers), processing is not
// the likely bottleneck, but rather the rate of SPI communication itself. Shorter SPI command sequences
// (default is 32 CONVERT commands + 3 AUX commands) and/or faster Baud rate will allow SPI communication to
// finish faster.
void sample_interrupt_routine()
{
	// Check if condition specified in loop_escape (e.g. target number of samples have been acquired) is true.
	// If so, keep from continuing interrupt execution and return to main loop so it can be escaped.
	if (loop_escape()) return;

	// Indicate main loop is not currently processing by writing Main_Monitor_Pin Low.
	// Main loop will write Main_Monitor_Pin when processing returns to main, so the duty cycle of this pin
	// can be measured to estimate what percentage of clock cycles are available for main processing.
	write_pin(Main_Monitor_GPIO_Port, Main_Monitor_Pin, 0);

	// Write aux commands to command_sequence_MOSI, advancing one sample through aux_command_list.
	cycle_aux_commands();

	// If previous DMA transfer has not completed, SPI communication from previous sample has not finished.
	// This is a critical error that will halt execution. To avoid this, all processing from previous interrupt
	// must conclude sooner (most likely, this would be waiting on SPI transfer completion, in which case
	// fewer channels can be included in the command sequence, or the SPI communication itself must be sped up).
	if (command_transfer_state == TRANSFER_WAIT) {
		handle_comm_error(ITClip);
	}

	// Indicate start of timer interrupt by writing Interrupt_Monitor_Pin High.
	// At the end of this function, Interrupt_Monitor_Pin will be written Low (though, keep in mind that
	// this only indicates that the DMA transfer has been initiated - DMA will continue running either until
	// its SPI command sequence concludes, or the next interrupt occurs, causing an ITClip error).
	write_pin(Interrupt_Monitor_GPIO_Port, Interrupt_Monitor_Pin, 1);

	// Update variable indicate to wait until SPI DMA transfer completes.
	command_transfer_state = TRANSFER_WAIT;

	transfer_sequence_spi_dma();

	// SPI DMA transfer has begun, so write Interrupt_Monitor_Pin Low and exit interrupt function,
	// returning to processing main loop.
	write_pin(Interrupt_Monitor_GPIO_Port, Interrupt_Monitor_Pin, 0);
}


// Every sample period, cycle circularly through aux_command_list, adding this sample's AUX commands to the end of
// command_sequence_MOSI array which will be transmitted via SPI.
void cycle_aux_commands()
{
	for (int i = 0; i < AUX_COMMANDS_PER_SEQUENCE; i++) {
		command_sequence_MOSI[CONVERT_COMMANDS_PER_SEQUENCE + i] = aux_command_list[i][aux_command_index];
	}
	if (++aux_command_index >= AUX_COMMAND_LIST_LENGTH) {
		aux_command_index = 0;
	}

	// Note that if any command(s) are to be used with a command list different from AUX_COMMAND_LIST_LENGTH,
	// the above code should be commented out, and the last AUX_COMMANDS_PER_SEQUENCE of command_sequence_MOSI
	// should be written here. For example, if impedance check DAC control is used, zcheck_DAC_command_list_length
	// should replace AUX_COMMAND_LIST_LENGTH and zcheck_DAC_command_slot_position should be used to correctly index
	// commands from the proper aux_command_list slot.
}


// Begin receiving MISO data (RHD -> SPI -> DMA -> memory) and transmitting MOSI data (memory -> DMA -> SPI -> RHD).
void transfer_sequence_spi_dma()
{
#ifdef USE_HAL
	// HAL handles all of SPI DMA transfer with this single function call.

	// Note: this HAL function call seems to not be consistent in how long it takes, causing some jitter between Interrupt_Monitor_Pin (GPIO) and SPI signals.
	// However, SPI/DMA signals seem to be consistent with each other, so this shouldn't affect functionality.

	if (HAL_SPI_TransmitReceive_DMA(&SPI, (uint8_t*)command_sequence_MOSI, (uint8_t*)command_sequence_MISO,
			CONVERT_COMMANDS_PER_SEQUENCE + AUX_COMMANDS_PER_SEQUENCE) != HAL_OK)
	{
		Error_Handler();
	}

#else
	begin_spi_rx(LL_DMA_DEST_INCREMENT, (uint32_t) command_sequence_MISO, CONVERT_COMMANDS_PER_SEQUENCE + AUX_COMMANDS_PER_SEQUENCE);
	begin_spi_tx(LL_DMA_SRC_INCREMENT, (uint32_t) command_sequence_MOSI, CONVERT_COMMANDS_PER_SEQUENCE + AUX_COMMANDS_PER_SEQUENCE);
#endif
}


// Calculate suitable size for sample_memory array and allocate memory.
// Note, free_sample_memory() should be called after this function and when memory allocation is no longer needed.
void allocate_sample_memory()
{
	per_channel_sample_memory_capacity = calculate_sample_rate() * NUMBER_OF_SECONDS_TO_ACQUIRE;
	uint32_t total_sample_memory_capacity = NUM_SAMPLED_CHANNELS * per_channel_sample_memory_capacity;
	sample_memory = (uint16_t *)malloc(total_sample_memory_capacity * sizeof(uint16_t));
}


// Free memory previously allocated for sample_memory array.
// Note, this should be called after allocate_sample_memory() and when memory allocation is no longer needed.
void free_sample_memory()
{
	free(sample_memory);
}


// Set up general SPI/DMA configuration.
// HAL automatically does this for each Send/Receive with SPI/DMA,
// so this function only has an LL implementation.
// Some of these settings (data length, memory location, and memory increment state)
// will be overwritten on a transfer-by-transfer basis, but the general configurations
// like transfer directions, peripheral addresses, and DMAMUX request ID can be permanently set here.
void initialize_spi_with_dma()
{
#ifdef USE_HAL
	return;
#else
	// Specify 4 SCLK cycles between each 16-bit SPI word in which NSS is driven high
	// (necessary to conform to RHD chip datasheet).
	// NOTE - Changing SPI setting Master Inter-Data Idleness in .ioc does NOT
	// seem to actually cause initialiation to set this parameter for LL, so
	// it's important to specify this here.
	// In contrast, HAL does seem to correctly initialize based on .ioc.
	LL_SPI_SetInterDataIdleness(SPI, LL_SPI_ID_IDLENESS_04CYCLE);

	// Specify that NSS (CS) should remain high between each command sequence.
	LL_SPI_EnableGPIOControl(SPI);

	// Specify direction for SPI bus.
	LL_SPI_SetTransferDirection(SPI, LL_SPI_FULL_DUPLEX);


	// Configure TX DMA stream
	LL_DMA_ConfigAddresses(DMA, DMA_TX_CHANNEL,
			(uint32_t) command_sequence_MOSI, // Default to transfer data from command_sequence_MOSI array's memory address - may be overwritten for individual transfers
			LL_SPI_DMA_GetTxRegAddr(SPI)); // Transfer data to SPI data register

	// Default to increment memory address after each transfer to iterate through array - may be overwritten for individual transfers
	LL_DMA_SetSrcIncMode(DMA, DMA_TX_CHANNEL, LL_DMA_SRC_INCREMENT);

	// Default to data length of full command sequence - may be overwritten for individual transfers
	LL_DMA_SetBlkDataLength(DMA, DMA_TX_CHANNEL, (CONVERT_COMMANDS_PER_SEQUENCE + AUX_COMMANDS_PER_SEQUENCE) * 2);

	// Configure RX DMA stream
	LL_DMA_ConfigAddresses(DMA, DMA_RX_CHANNEL,
			LL_SPI_DMA_GetRxRegAddr(SPI), // Transfer data from SPI data register
			(uint32_t) command_sequence_MISO); // Default to transfer data to command_sequence_MISO array's memory address - may be overwritten for individual transfers

	// Default to increment memory address after each transfer to iterate through array - may be overwritten for individual transfers
	LL_DMA_SetDestIncMode(DMA, DMA_RX_CHANNEL, LL_DMA_DEST_INCREMENT);

	// Default to data length of full command sequence - may be overwritten for individual transfers
	LL_DMA_SetBlkDataLength(DMA, DMA_RX_CHANNEL, (CONVERT_COMMANDS_PER_SEQUENCE + AUX_COMMANDS_PER_SEQUENCE) * 2);
#endif
}

// Write SPI/DMA registers to cleanly disable once DMA transfer ends.
// HAL automatically does this for each Send/Receive with SPI/DMA,
// so this function only has an LL implementation.
void end_spi_with_dma()
{
#ifdef USE_HAL
#else
	end_spi_rx();
	end_spi_tx();
#endif
}


// Handle communication error.
// Write ERROR_DETECTED_PIN (by default, red LED) High.
// Write each bit of a 4-bit error code to a pin so that by measuring pins, user can determine the error code.
// Enter an infinite loop, halting execution and allowing user to measure error pins.
void handle_comm_error(CommErrorStatus error_code)
{
	// No error, just return.
	if (error_code == 0) return;

	// Write ERROR_DETECTED_PIN (by default red LED) to communicate that an error occurred.
	write_pin(ERROR_DETECTED_PORT, ERROR_DETECTED_PIN, 1);

	// Write 4 bits of error code to 4 pins.
	uint8_t error_code_bit_0 = (error_code & 0b0001) >> 0;
	uint8_t error_code_bit_1 = (error_code & 0b0010) >> 1;
	uint8_t error_code_bit_2 = (error_code & 0b0100) >> 2;
	uint8_t error_code_bit_3 = (error_code & 0b1000) >> 3;
	if (error_code_bit_0) write_pin(ErrorCode_Bit_0_GPIO_Port, ErrorCode_Bit_0_Pin, 1);
	if (error_code_bit_1) write_pin(ErrorCode_Bit_1_GPIO_Port, ErrorCode_Bit_1_Pin, 1);
	if (error_code_bit_2) write_pin(ErrorCode_Bit_2_GPIO_Port, ErrorCode_Bit_2_Pin, 1);
	if (error_code_bit_3) write_pin(ErrorCode_Bit_3_GPIO_Port, ErrorCode_Bit_3_Pin, 1);

	// Enter infinite loop.
	while(1);
}


// Callback function that executes when both Transmission and Reception of SPI have completed.
void spi_txrx_cplt_callback()
{
	// If main loop is active, drive Main_Monitor_Pin low, write data to memory, transmit data in realtime, and update command_transfer_state
	if (main_loop_active) {
		// Indicate main loop is not currently processing by writing Main_Monitor_Pin Low.
		write_pin(Main_Monitor_GPIO_Port, Main_Monitor_Pin, 0);

		// User-specified function - here is where specified channel(s) can be written to memory.
		write_data_to_memory();

		// User-specified function - here is where user can transmit data in real time every sample period.
		transmit_data_realtime();

		// Update state variable to show that transfer has completed.
		command_transfer_state = TRANSFER_COMPLETE;
	}

	// If main loop is not active, that indicates just a single SPI DMA transfer has occurred, so set reception_in_progress to 0
	else {
#ifdef USE_HAL
#else
		end_spi_rx();
#endif
		reception_in_progress = 0;
	}
}


// Callback function to show that an SPI error occurred.
void spi_error_callback()
{
	command_transfer_state = TRANSFER_ERROR;
}


// Determine suitable values to be written to registers
// (based on default acquisition values from RHX software).
// These suitable default values are saved to RHDConfigParameters argument.
// Write these values to registers, and calibrate and run for 9 commands to fully initialize chip.
void write_initial_reg_values(RHDConfigParameters *p)
{
	// Determine suitable values to be written for each of the registers.
	p->sample_rate = calculate_sample_rate();
	set_default_rhd_settings(p);

	uint16_t registers[18];
	for (int i = 0; i < 18; i++) {
		registers[i] = get_register_value(p, i);
	}

	// Send a few dummy commands in case chip is still powering up.
	send_spi_command(read_command(63));
	send_spi_command(read_command(63));


	// Write suitable default values for RHD registers.
	for (int i = 0; i < 18; i++) {
		send_spi_command(write_command(i, registers[i]));
	}

	// Calibrate and run for 9 commands.
	send_spi_command(calibrate_command());
	for (int i = 0; i < 9; i++) {
		send_spi_command(read_command(40));
	}
}


// Check timer clock input, clock division, prescaling, and counter period
// to determine the rate at which INTERRUPT_TIM interrupts occur (sample rate).
// Note that this reads clock and timer configuration register values during runtime,
// so this function should adapt to any changes made to the .ioc.
double calculate_sample_rate()
{
	uint32_t apb1_timer_freq, ckd_value, psc_value, counter_period;

#ifdef USE_HAL
	apb1_timer_freq = HAL_RCC_GetPCLK1Freq();
	ckd_value = INTERRUPT_TIM.Init.ClockDivision;
	psc_value = INTERRUPT_TIM.Init.Prescaler;
	counter_period = INTERRUPT_TIM.Init.Period;
#else
	LL_RCC_ClocksTypeDef RCC_Clocks;
	LL_RCC_GetSystemClocksFreq(&RCC_Clocks);
	apb1_timer_freq = RCC_Clocks.PCLK1_Frequency;
	ckd_value = LL_TIM_GetClockDivision(INTERRUPT_TIM);
	psc_value = LL_TIM_GetPrescaler(INTERRUPT_TIM);
	counter_period = LL_TIM_GetAutoReload(INTERRUPT_TIM);
#endif

	double ckd_factor = 1.0;
	if (ckd_value == 0b01) {
		ckd_factor = 2;
	} else if (ckd_value == 0b10) {
		ckd_factor = 4;
	}

	double psc_factor = psc_value + 1;

	double input_frequency = apb1_timer_freq / (ckd_factor * psc_factor);
	return input_frequency / counter_period;
}


// Create a list of CONVERT_COMMANDS_PER_SEQUENCE (default 32) CONVERT commands,
// and load them into command_sequence_MOSI.
// If the channel_numbers_to_convert parameter is NULL,
// create CONVERT_COMMANDS_PER_SEQUENCE commands from channel 0 (default 0 - 31).
// Otherwise, populate the CONVERT commands in the order specified by channel_numbers_to_convert.
void create_convert_sequence(uint8_t* channel_numbers_to_convert)
{
	// If no list of channel numbers is provided,
	// then assume CONVERT should occur for channels 0 - CONVERT_COMMANDS_PER_SEQUENCE.
	if (channel_numbers_to_convert == NULL) {
		for (int i = 0; i < CONVERT_COMMANDS_PER_SEQUENCE; i++) {
			command_sequence_MOSI[i] = convert_command(i, 0);
		}
	}

	// Otherwise, assume CONVERT should occur for only the channel numbers listed
	// in channel_numbers_to_convert, in the order they appear in the list.
	else {
		for (int i = 0; i < CONVERT_COMMANDS_PER_SEQUENCE; i++) {
			command_sequence_MOSI[i] = convert_command(channel_numbers_to_convert[i], 0);
		}
	}
}


// Create a list of num_commands commands to program most RAM registers on an RHD2000 chip, read those values
// back to confirm programming, read ROM registers, and (if calibrate == true) run ADC calibration.
// Return the number of populated commands. num_commands must be 60 or greater.
int create_command_list_RHD_register_config(RHDConfigParameters *p, uint16_t *command_list, uint8_t calibrate, int num_commands)
{
	int command_index = 0;
	// Start with a few dummy commands in case chip is still powering up.
	command_list[command_index++] = read_command(63);
	command_list[command_index++] = read_command(63);


	// Program RAM registers.
	for (int reg = 0; reg < 18; ++reg) {
		// Don't program Register 3 (MUX Load, Temperature Sensor, and Auxiliary Digital Output)
		// or 6 (Impedance Check DAC) here;
		// control temperature sensor and DAC waveforms in other command streams.
		if (reg == 3 || reg == 6) continue;
		command_list[command_index++] = write_command(reg, get_register_value(p, reg));
	}


	// Read ROM registers.
	command_list[command_index++] = read_command(63);
	command_list[command_index++] = read_command(62);
	command_list[command_index++] = read_command(61);
	command_list[command_index++] = read_command(60);
	command_list[command_index++] = read_command(59);

	// Read chip name from ROM.
	command_list[command_index++] = read_command(48);
	command_list[command_index++] = read_command(49);
	command_list[command_index++] = read_command(50);
	command_list[command_index++] = read_command(51);
	command_list[command_index++] = read_command(52);
	command_list[command_index++] = read_command(53);
	command_list[command_index++] = read_command(54);
	command_list[command_index++] = read_command(55);

	// Read Intan name from ROM.
	command_list[command_index++] = read_command(40);
	command_list[command_index++] = read_command(41);
	command_list[command_index++] = read_command(42);
	command_list[command_index++] = read_command(43);
	command_list[command_index++] = read_command(44);

	// Read back RAM registers to confirm programming.
	for (int reg = 0; reg < 18; ++reg) {
		command_list[command_index++] = read_command(reg);
	}

	// Optionally, run ADC calibration (should only be run once after board is plugged in).
	if (calibrate) {
		command_list[command_index++] = calibrate_command();
	} else {
		command_list[command_index++] = read_command(63);
	}

	// Program amplifier 31-63 power up/down registers in case a RHD2164 is connected.
	// Note: We don't read these registers back, since they are only 'visible' on MISO B.
	command_list[command_index++] = write_command(18, get_register_value(p, 18));
	command_list[command_index++] = write_command(19, get_register_value(p, 19));
	command_list[command_index++] = write_command(20, get_register_value(p, 20));
	command_list[command_index++] = write_command(21, get_register_value(p, 21));

	// End with a dummy command.
	command_list[command_index++] = read_command(63);

	for (int i = 0; i < (num_commands - 60); ++i) {
		command_list[command_index++] = read_command(63);
	}
	return command_index;
}


// Create a list of RHD commands to sample auxiliary ADC inputs 1-3 at 1/4 the amplifier sampling rate.
// The reading of a ROM register is interleaved to allow for data frame alignment.
// Return the length of the command list. num_commands should be evenly divisible by four.
int create_command_list_RHD_sample_aux_ins(uint16_t *command_list, int num_commands)
{
	if (num_commands < 4) return -1;

	int command_index = 0;

	for (int i = 0; i < (num_commands / 4) - 2; ++i) {
		command_list[command_index++] = convert_command(32, 0); // sample AuxIn1.
		command_list[command_index++] = convert_command(33, 0); // sample AuxIn2.
		command_list[command_index++] = convert_command(34, 0); // sample AuxIn3.
		command_list[command_index++] = read_command(40); // read ROM register; should return 0x0049.
	}

	// Last two times:
	command_list[command_index++] = convert_command(32, 0); // sample AuxIn1.
	command_list[command_index++] = convert_command(33, 0); // sample AuxIn2.
	command_list[command_index++] = convert_command(34, 0); // sample AuxIn3.
	command_list[command_index++] = read_command(48); // read supply voltage sensor.

	command_list[command_index++] = convert_command(32, 0); // sample AuxIn1.
	command_list[command_index++] = convert_command(33, 0); // sample AuxIn2.
	command_list[command_index++] = convert_command(34, 0); // sample AuxIn3.
	command_list[command_index++] = convert_command(40, 0); // read ROM register; should return 0x0049.
	return command_index;
}


// Create a list of commands to update RHD Register 3 (controlling the auxiliary
// digital output pin) every sampling period.
// Return the length of the command list.
int create_command_list_RHD_update_DigOut(RHDConfigParameters *p, uint16_t *command_list, int num_commands)
{
	if (num_commands < 1) return -1;

	int command_index = 0;

	for (int i = 0; i < num_commands; i++) {
		command_list[command_index++] = write_command(3, get_register_value(p, 3));
	}

	return command_index;
}


// Create a list of dummy commands with a specific command.
// Return the length of the command list (which should be n).
int create_command_list_dummy(RHDConfigParameters *p, uint16_t *command_list, int n, uint16_t cmd)
{
	int command_index = 0;

	for (int i = 0; i < n; i++) {
		command_list[command_index++] = cmd;
	}

	return command_index;
}


// Create a list of up to AUX_COMMAND_LIST_LENGTH commands to generate a sine wave of particular frequency (in Hz) and
// amplitude (in DAC steps, 0-128) using the on-chip impedance testing voltage DAC.  If frequency is set to zero,
// a DC baseline waveform is created.
// Return the length of the command list.
int create_command_list_zcheck_DAC(RHDConfigParameters *p, uint16_t *command_list, double frequency, double amplitude)
{
	int command_index = 0;

	if ((amplitude < 0.0) || (amplitude > 128.0)) {
		// Error: Amplitude out of range
		return -1;
	}
	if (frequency < 0.0) {
		// Error: Negative frequency not allowed
		return -1;
	} else if (frequency > p->sample_rate / 4.0) {
		// Error: Frequency too high relative to sampling rate
		return -1;
	}

	unsigned int dac_register = 6;
	if (frequency == 0.0) {
		for (int i = 0; i < AUX_COMMAND_LIST_LENGTH; ++i) {
			command_list[command_index++] = write_command(dac_register, 128);
		}
	} else {
		int period = (int) floor(p->sample_rate / frequency + 0.5);
		if (period > AUX_COMMAND_LIST_LENGTH) {
			// Error: Frequency too low
			return -1;
		} else {
			double t = 0.0;
			for (int i = 0; i < period; ++i) {
				int value = (int) floor(amplitude * sin((2 * M_PI) * frequency * t) + 128.0 + 0.5);
				if (value < 0) {
					value = 0;
				} else if (value > 255) {
					value = 255;
				}
				command_list[command_index++] = write_command(dac_register, value);
				t += 1.0 / p->sample_rate;
			}
		}
	}

	return command_index;
}


// Send provided 16-bit word 'tx_data' over SPI, ignoring resultant 16-bit received word.
void send_spi_command(uint16_t tx_data)
{
	uint16_t dummy_data = 0;
	send_receive_spi_command(tx_data, &dummy_data);
}


// Send provided 16-bit word 'tx_data' over SPI, and pass resultant 16-bit received work by reference.
// Note that the pipelined nature of the SPI communication has a 2-command delay,
// so the obtained result corresponds to the command from 2 transactions earlier.
void send_receive_spi_command(uint16_t tx_data, uint16_t *rx_data)
{
	reception_in_progress = 1;
#ifdef USE_HAL

	if (HAL_SPI_TransmitReceive_DMA(&SPI, (uint8_t*) &tx_data, (uint8_t*)rx_data, 1) != HAL_OK)
	{
		Error_Handler();
	}

#else
	begin_spi_rx(LL_DMA_DEST_FIXED, (uint32_t) rx_data, 1);
	begin_spi_tx(LL_DMA_SRC_FIXED, (uint32_t) &tx_data, 1);
#endif
	while (reception_in_progress == 1) {}
}


#ifdef USE_HAL
// HAL calls this function when both Tx and Rx have completed.
void HAL_SPI_TxRxCpltCallback(SPI_HandleTypeDef *hspi)
{
	if (hspi == &SPI) {
		spi_txrx_cplt_callback();
	}
}


// HAL calls this function when an error in the SPI communication has been detected.
void HAL_SPI_ErrorCallback(SPI_HandleTypeDef *hspi)
{
	spi_error_callback();
}


// HAL calls this function when UART Tx has completed.
void HAL_UART_TxCpltCallback(UART_HandleTypeDef *UartHandle)
{
	uart_ready = 1;
}


#else
// Begin receive transfer from SPI to memory.
void begin_spi_rx(uint32_t mem_increment, uint32_t mem_address, uint32_t num_words)
{
	LL_SPI_DisableDMAReq_RX(SPI);
	LL_DMA_DisableChannel(DMA, DMA_RX_CHANNEL);

	LL_DMA_SetDestIncMode(DMA, DMA_RX_CHANNEL, mem_increment);
	LL_DMA_SetDestAddress(DMA, DMA_RX_CHANNEL, mem_address);

	LL_DMA_SetBlkDataLength(DMA, DMA_RX_CHANNEL, num_words * 2);

	// Clear DMA flags for Rx channel.
	// The following ClearFlag functions can be replaced with the single WriteReg call below for faster execution.
	//	LL_DMA_ClearFlag_TC(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_HT(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_DTE(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_ULE(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_USE(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_SUSP(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_TO(DMA, DMA_RX_CHANNEL);
	LL_DMA_WriteReg((DMA_Channel_TypeDef *)(LL_DMA_GET_CHANNEL_INSTANCE(DMA, DMA_RX_CHANNEL)), CFCR,
			DMA_CFCR_TCF   |
			DMA_CFCR_HTF   |
			DMA_CFCR_DTEF  |
			DMA_CFCR_ULEF  |
			DMA_CFCR_USEF  |
			DMA_CFCR_SUSPF |
			DMA_CFCR_TOF);
	// Note that this is a WriteReg, not a ModifyReg function, so if user changed any other fields in this
	// register, they will be overwritten. If this is not intended, then use MODIFY_REG or individual
	// ClearFlag calls instead.

	// Enable various interrupts for SPI Rx DMA channel, and enable the channel itself.
	// The following EnableIT and EnableChannel functions can be
	// replaced with the single WriteReg call below for faster execution.
//	LL_DMA_EnableIT_TC(DMA, DMA_RX_CHANNEL);
//	LL_DMA_EnableIT_DTE(DMA, DMA_RX_CHANNEL);
//	LL_DMA_EnableIT_ULE(DMA, DMA_RX_CHANNEL);
//	LL_DMA_EnableIT_USE(DMA, DMA_RX_CHANNEL);
//	LL_DMA_EnableIT_TO(DMA, DMA_RX_CHANNEL);
//	LL_DMA_EnableChannel(DMA, DMA_RX_CHANNEL);
	LL_DMA_WriteReg((DMA_Channel_TypeDef *)(LL_DMA_GET_CHANNEL_INSTANCE(DMA, DMA_RX_CHANNEL)), CCR,
			DMA_CCR_TCIE  |
			DMA_CCR_DTEIE |
			DMA_CCR_ULEIE |
			DMA_CCR_USEIE |
			DMA_CCR_TOIE  |
			DMA_CCR_EN);
	// Note that this is a WriteReg, not a ModifyReg function, so if user changed any other fields in this
	// register, they will be overwritten. If this is not intended, then use MODIFY_REG or individual
	// EnableIT and EnableChannel calls instead.

	// Enable SPI interacting with DMA Rx requests.
	LL_SPI_EnableDMAReq_RX(SPI);

	LL_SPI_EnableIT_OVR(SPI);

	LL_SPI_SetTransferSize(SPI, num_words);
	LL_SPI_Enable(SPI);
}

// Begin transmit transfer from memory to SPI
void begin_spi_tx(uint32_t mem_increment, uint32_t mem_address, uint32_t num_words)
{
	LL_SPI_DisableDMAReq_TX(SPI);
	LL_DMA_DisableChannel(DMA, DMA_TX_CHANNEL);

	LL_DMA_SetSrcIncMode(DMA, DMA_TX_CHANNEL, mem_increment);
	LL_DMA_SetSrcAddress(DMA, DMA_TX_CHANNEL, mem_address);

	LL_DMA_SetBlkDataLength(DMA, DMA_TX_CHANNEL, num_words * 2);

	// Clear DMA flags for Tx channel.
	// The following ClearFlag functions can be replaced with the single WriteReg call below for faster execution.
	//	LL_DMA_ClearFlag_TC(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_HT(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_DTE(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_ULE(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_USE(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_SUSP(DMA, DMA_RX_CHANNEL);
	//	LL_DMA_ClearFlag_TO(DMA, DMA_RX_CHANNEL);
	LL_DMA_WriteReg((DMA_Channel_TypeDef *)(LL_DMA_GET_CHANNEL_INSTANCE(DMA, DMA_TX_CHANNEL)), CFCR,
			DMA_CFCR_TCF   |
			DMA_CFCR_HTF   |
			DMA_CFCR_DTEF  |
			DMA_CFCR_ULEF  |
			DMA_CFCR_USEF  |
			DMA_CFCR_SUSPF |
			DMA_CFCR_TOF);
	// Note that this is a WriteReg, not a ModifyReg function, so if user changed any other fields in this
	// register, they will be overwritten. If this is not intended, then use MODIFY_REG or individual
	// ClearFlag calls instead.

	// Enable various interrupts for SPI Tx DMA channel, and enable the channel itself.
	// The following EnableIT and EnableChannel functions can be
	// replaced with the single WriteReg call below for faster execution.
//	LL_DMA_EnableIT_TC(DMA, DMA_RX_CHANNEL);
//	LL_DMA_EnableIT_DTE(DMA, DMA_RX_CHANNEL);
//	LL_DMA_EnableIT_ULE(DMA, DMA_RX_CHANNEL);
//	LL_DMA_EnableIT_USE(DMA, DMA_RX_CHANNEL);
//	LL_DMA_EnableIT_TO(DMA, DMA_RX_CHANNEL);
//	LL_DMA_EnableChannel(DMA, DMA_RX_CHANNEL);
	LL_DMA_WriteReg((DMA_Channel_TypeDef *)(LL_DMA_GET_CHANNEL_INSTANCE(DMA, DMA_TX_CHANNEL)), CCR,
			DMA_CCR_TCIE  |
			DMA_CCR_DTEIE |
			DMA_CCR_ULEIE |
			DMA_CCR_USEIE |
			DMA_CCR_TOIE  |
			DMA_CCR_EN);
	// Note that this is a WriteReg, not a ModifyReg function, so if user changed any other fields in this
	// register, they will be overwritten. If this is not intended, then use MODIFY_REG or individual
	// EnableIT and EnableChannel calls instead.

	// Enable SPI interacting with DMA Tx requests.
	LL_SPI_EnableDMAReq_TX(SPI);

	LL_SPI_EnableIT_UDR(SPI);
	LL_SPI_EnableIT_MODF(SPI);

	LL_SPI_SetTransferSize(SPI, num_words);
	LL_SPI_Enable(SPI);
	LL_SPI_StartMasterTransfer(SPI);
}


// End receive transfer from SPI to memory
void end_spi_rx()
{
	// Clear EOT and SUSP flags in IFCR register.
	LL_SPI_ClearFlag_EOT(SPI);
	LL_SPI_ClearFlag_SUSP(SPI);
	LL_SPI_ClearFlag_TXTF(SPI);

	// Clear SPE bit in CR1 register.
	LL_SPI_Disable(SPI);

	// Disable SPI interrupts in IER register.
	LL_SPI_WriteReg(SPI, IER, 0U);

	// Clear RXDMAEN bit from CFG1 register.
	LL_SPI_DisableDMAReq_RX(SPI);

	// Disable DMA channel.
	LL_DMA_DisableChannel(DMA, DMA_RX_CHANNEL);
}


// End transmit transfer from memory to SPI
void end_spi_tx()
{
	// Clear EOT, TXTF, and SUSP flags in IFCR register.
	LL_SPI_ClearFlag_EOT(SPI);
	LL_SPI_ClearFlag_SUSP(SPI);
	LL_SPI_ClearFlag_TXTF(SPI);

	// Clear SPE bit in CR1 register.
	LL_SPI_Disable(SPI);

	// Disable SPI interrupts in IER register.
	LL_SPI_WriteReg(SPI, IER, 0U);

	// Clear TXDMAEN bit from CFG1 register.
	LL_SPI_DisableDMAReq_TX(SPI);

	// Disable DMA channel.
	LL_DMA_DisableChannel(DMA, DMA_TX_CHANNEL);
}


// When a DMA receive interrupt is triggered, this function executes.
// Writes Main Monitor pin low, detects communication errors, monitors non-error interrupt flags
// to enable EOT end of transfer interrupt when approaching finishing transfer.
void dma_interrupt_routine_rx()
{
	// Indicate main loop is not currently processing.
	write_pin(Main_Monitor_GPIO_Port, Main_Monitor_Pin, 0);

	// Check for DMA errors (DTE for Rx).
	// If any are found, set error LED and error code GPIOs.
	if (LL_DMA_IsActiveFlag_DTE(DMA, DMA_RX_CHANNEL)) {
		handle_comm_error(RxDMAError);
	}

	if (LL_DMA_IsActiveFlag_TC(DMA, DMA_RX_CHANNEL)) {
		if (LL_DMA_IsEnabledIT_TC(DMA, DMA_RX_CHANNEL)) {

			// U5: Write CBR1 0 (BNDT): Set block # of data bytes to transfer from source
			// H7: Write S0NDTR 0 (NDT): Set # of data items to transfer
			LL_DMA_SetBlkDataLength(DMA, DMA_RX_CHANNEL, 0);
			LL_DMA_ClearFlag_TC(DMA, DMA_RX_CHANNEL);
			LL_SPI_EnableIT_EOT(SPI);
		}
	}
}


// When a DMA transmit interrupt is triggered, this function executes.
// Writes Main Monitor pin low, detects communication errors, monitors non-error interrupt flags
// to enable EOT end of transfer interrupt when approaching finishing transfer.
void dma_interrupt_routine_tx()
{
	// Indicate main loop is not currently processing.
	write_pin(Main_Monitor_GPIO_Port, Main_Monitor_Pin, 0);

	// Check for DMA errors (DTE for Tx).
	// If any are found, set error LED and error code GPIOs.
	// Note that FE may be flagged at some point, but FIFO is not used so this can be ignored.
	if (LL_DMA_IsActiveFlag_DTE(DMA, DMA_TX_CHANNEL)) {
		handle_comm_error(TxDMAError);
	}

	if (LL_DMA_IsActiveFlag_TC(DMA, DMA_TX_CHANNEL)) {
		LL_DMA_ClearFlag_TC(DMA, DMA_TX_CHANNEL);
		LL_SPI_EnableIT_EOT(SPI);
	}
}


// When a DMA USART transmit interrupt is triggered, this function executes.
// Writes Main Monitor pin low, detects communication errors, monitors non-error interrupt flags
// and clears flags.
void dma_interrupt_routine_usart_tx()
{
	// Indicate main loop is not currently processing.
	write_pin(Main_Monitor_GPIO_Port, Main_Monitor_Pin, 0);

	// Check for DMA errors (DTE for Tx).
	// If any are found, set error LED and error code GPIOs.
	// Note that FE may be flagged at some point, but FIFO is not used so this can be ignored.
	if (LL_DMA_IsActiveFlag_DTE(DMA, DMA_USART_CHANNEL)) {
		handle_comm_error(TxDMAError);
	}

	if (LL_DMA_IsActiveFlag_ULE(DMA, DMA_USART_CHANNEL)) {
		handle_comm_error(TxDMAError);
	}

	if (LL_DMA_IsActiveFlag_USE(DMA, DMA_USART_CHANNEL)) {
		handle_comm_error(TxDMAError);
	}

	if (LL_DMA_IsActiveFlag_TO(DMA, DMA_USART_CHANNEL)) {
		handle_comm_error(TxDMAError);
	}

	if (LL_DMA_IsActiveFlag_HT(DMA, DMA_USART_CHANNEL)) {
		// Check if interrupt source is enabled
		if (LL_DMA_IsEnabledIT_HT(DMA, DMA_USART_CHANNEL)) {
			//Clear HT transfer flag
			LL_DMA_ClearFlag_HT(DMA, DMA_USART_CHANNEL);
		}
	}

	if (LL_DMA_IsActiveFlag_SUSP(DMA, DMA_USART_CHANNEL)) {
		handle_comm_error(TxDMAError);
	}

	if (LL_DMA_IsActiveFlag_TC(DMA, DMA_USART_CHANNEL)) {
		// Check if interrupt source is enabled
		if (LL_DMA_IsEnabledIT_TC(DMA, DMA_USART_CHANNEL)) {
			// Clear TC transfer flag
			LL_DMA_ClearFlag_TC(DMA, DMA_USART_CHANNEL);
		}
	}
}


// When a SPI interrupt is triggered, this function executes.
// Writes Main Monitor pin low, detects communication errors,
// and if transfer is complete cleanly exits transfer routine and calls user-facing callback function.
void spi_interrupt_routine()
{
	// Indicate main loop is not currenty processing.
	write_pin(Main_Monitor_GPIO_Port, Main_Monitor_Pin, 0);

	if (LL_SPI_IsActiveFlag_EOT(SPI)) {

		end_spi_tx();
		end_spi_rx();

		// Call transfer complete callback, user-facing function for both HAL and LL when transfer is complete.
		spi_txrx_cplt_callback();
	}

	// Check for any SPI errors.
	if (LL_SPI_IsActiveFlag_OVR(SPI)) {
		handle_comm_error(RxSPIError); // OVR - Overrun
	}

	// Check for any SPI errors.
	if (LL_SPI_IsActiveFlag_UDR(SPI) || LL_SPI_IsActiveFlag_MODF(SPI)) {
		handle_comm_error(TxSPIError); // UDR - Underrun ... MODF - Mode Fault
	}
}


// When a UART transmit interrupt is triggered, this function executes.
// If DMA becomes idle, set uart_ready variable to 1.
void uart_interrupt_routine()
{
	if (!LL_USART_IsActiveFlag_TC(USART)) {
		return;
	}

	LL_USART_ClearFlag_CM(USART);
	LL_USART_ClearFlag_EOB(USART);
	LL_USART_ClearFlag_FE(USART);
	LL_USART_ClearFlag_IDLE(USART);
	LL_USART_ClearFlag_LBD(USART);
	LL_USART_ClearFlag_NE(USART);
	LL_USART_ClearFlag_ORE(USART);
	LL_USART_ClearFlag_PE(USART);
	LL_USART_ClearFlag_RTO(USART);
	LL_USART_ClearFlag_TCBGT(USART);
	LL_USART_ClearFlag_TXFE(USART);
	LL_USART_ClearFlag_UDR(USART);
	LL_USART_ClearFlag_nCTS(USART);
	LL_USART_ClearFlag_TC(USART);

	if (LL_DMA_IsActiveFlag_IDLE(DMA, DMA_USART_CHANNEL)) {
		uart_ready = 1;
	}
}
#endif
