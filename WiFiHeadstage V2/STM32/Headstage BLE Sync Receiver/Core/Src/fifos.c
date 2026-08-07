#include "fifos.h"


/*The fifos*/

FIFO_STRUCTURE_BYTE rx_uart_fifo;
uint8_t rx_uart_fifo_array[RX_UART_FIFO_SIZE];

/*End the fifos*/


void initFIFO_byte(FIFO_STRUCTURE_BYTE * p_fifo, int32_t p_fifo_size)
{
  p_fifo->head = 0;
  p_fifo->tail = 0;
  p_fifo->fifo_size = p_fifo_size;
  p_fifo->availlable_space = p_fifo->fifo_size;
  for(int i = 0; i < p_fifo->fifo_size; i++)
    p_fifo->fifo_array[i] = 0;
}

uint8_t readFIFOhead_byte(FIFO_STRUCTURE_BYTE * p_fifo)
{
    return p_fifo->fifo_array[p_fifo->head];
}

uint8_t readFIFOtail_byte(FIFO_STRUCTURE_BYTE * p_fifo)
{
    return p_fifo->fifo_array[p_fifo->tail];
}

void pushFIFO_byte(FIFO_STRUCTURE_BYTE * p_fifo, uint8_t p_elem)
{
	p_fifo->availlable_space--;
  p_fifo->fifo_array[p_fifo->tail++] = p_elem;
  if(p_fifo->tail >= p_fifo->fifo_size)
    p_fifo->tail = 0;
}

void pushFIFO_byte_4(FIFO_STRUCTURE_BYTE * p_fifo, int32_t p_elem1, int32_t p_elem2, int32_t p_elem3, int32_t p_elem4)
{
  p_fifo->fifo_array[p_fifo->tail++] = p_elem1;
  p_fifo->fifo_array[p_fifo->tail++] = p_elem2;
  p_fifo->fifo_array[p_fifo->tail++] = p_elem3;
  p_fifo->fifo_array[p_fifo->tail++] = p_elem4;
  if(p_fifo->tail >= p_fifo->fifo_size)
    p_fifo->tail = 0;
}

uint8_t popFIFO_byte(FIFO_STRUCTURE_BYTE * p_fifo)
{
  volatile uint8_t elem;
  p_fifo->availlable_space++;
  elem = p_fifo->fifo_array[p_fifo->head++];
  if(p_fifo->head >= p_fifo->fifo_size)
    p_fifo->head = 0;
  return elem;
}

uint8_t isFIFOempty_byte(FIFO_STRUCTURE_BYTE * p_fifo)
{
  if(p_fifo->availlable_space == p_fifo->fifo_size)
    return 1;
  return 0;
}

uint8_t isFIFOfull_byte(FIFO_STRUCTURE_BYTE * p_fifo)
{
	if(p_fifo->availlable_space == 0)
		return 1;
	return 0;
}
