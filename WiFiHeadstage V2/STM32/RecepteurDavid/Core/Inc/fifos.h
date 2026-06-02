#ifndef FIFOS_H_
#define FIFOS_H_

#include "stdint.h"


typedef struct{
  volatile uint8_t *fifo_array;
  volatile int32_t tail;
  volatile int32_t availlable_space;
  //volatile int32_t elements_in_fifo;
  volatile int32_t head;
  volatile int32_t fifo_size;
}FIFO_STRUCTURE_BYTE;

/*The fifos*/

#define RX_UART_FIFO_SIZE 128

extern uint8_t rx_uart_fifo_array[RX_UART_FIFO_SIZE];
extern FIFO_STRUCTURE_BYTE rx_uart_fifo;

/*End the fifos*/


void initFIFO_byte(FIFO_STRUCTURE_BYTE * p_fifo, int32_t p_fifo_size);
uint8_t readFIFOhead_byte();
uint8_t readFIFOtail_byte();
void pushFIFO_byte(FIFO_STRUCTURE_BYTE * p_fifo, uint8_t p_elem);
uint8_t popFIFO_byte(FIFO_STRUCTURE_BYTE * p_fifo);
uint8_t isFIFOempty_byte(FIFO_STRUCTURE_BYTE * p_fifo);
uint8_t isFIFOfull_byte(FIFO_STRUCTURE_BYTE * p_fifo);
void pushFIFO_byte_4(FIFO_STRUCTURE_BYTE * p_fifo, int32_t p_elem1, int32_t p_elem2, int32_t p_elem3, int32_t p_elem4);

#endif
