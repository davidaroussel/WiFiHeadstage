library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_RHD_Sampling_tb is
end entity Controller_RHD_Sampling_tb;

architecture Testbench of Controller_RHD_Sampling_tb is
  -- Constants
  constant CLK_PERIOD                    : time := 10 ns;
  constant STM32_SPI_NUM_BITS_PER_PACKET : integer := 512; 
  constant RHD_SPI_NUM_BITS_PER_PACKET : integer := 16;  
  
  constant STM32_CLKS_PER_HALF_BIT : integer := 2;  -- Adds delay between bytes
  constant RHD_CLKS_PER_HALF_BIT : integer := 2;  -- Adds delay between bytes
  
  constant STM32_CS_INACTIVE_CLKS : integer := 4;
  constant RHD_CS_INACTIVE_CLKS : integer := 4;
  
  constant RHD_SPI_DDR_MODE : integer := 0;
  
-- Signals
  signal tb_Controller_Mode : std_logic_vector (3 downto 0);
  signal tb_Rst_L        	: std_logic := '1';
  signal tb_Clk          	: std_logic := '0';
  signal tb_NUM_DATA         : integer;
  signal tb_STM32_State      : integer;
  signal tb_stm32_counter   : integer;
 

  -- STM32 SPI Interface
  signal tb_STM32_SPI_Clk         : std_logic;
  signal tb_STM32_SPI_MISO        : std_logic;
  signal tb_STM32_SPI_MOSI        : std_logic;
  signal tb_STM32_SPI_CS_n        : std_logic := '1';
  signal tb_STM32_TX_Byte         : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0) := (others => '0');
  signal tb_STM32_TX_DV           : std_logic := '0';
  signal tb_STM32_TX_Ready        : std_logic;
  signal tb_STM32_RX_DV           : std_logic ;
  signal tb_STM32_RX_Byte_Rising  : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);

  -- FIFO Signals
  signal tb_FIFO_RHD2132_Data    : std_logic_vector(31 downto 0);
  signal tb_FIFO_RHD2132_WE      : std_logic;
  signal tb_FIFO_RHD2132_RE      : std_logic;
  signal tb_FIFO_RHD2132_COUNT   : std_logic_vector(7 downto 0);
  signal tb_FIFO_RHD2132_Q       : std_logic_vector(31 downto 0) ;
  signal tb_FIFO_RHD2132_EMPTY   : std_logic;
  signal tb_FIFO_RHD2132_FULL    : std_logic;
  signal tb_FIFO_RHD2132_AEMPTY  : std_logic;
  signal tb_FIFO_RHD2132_AFULL   : std_logic;

  -- RHD SPI Interface
  signal tb_RHD2132_SPI_Clk          : std_logic;
  signal tb_RHD2132_SPI_MISO         : std_logic;
  signal tb_RHD2132_SPI_MOSI         : std_logic;
  signal tb_RHD2132_SPI_CS_n         : std_logic;
  signal tb_RHD2132_TX_Byte          : std_logic_vector(RHD_SPI_NUM_BITS_PER_PACKET-1 downto 0) := (others => '0');
  signal tb_RHD2132_TX_DV            : std_logic := '0';
  signal tb_RHD2132_TX_Ready         : std_logic;
  signal tb_RHD2132_RX_DV            : std_logic;
  signal tb_RHD2132_RX_Byte_Rising   : std_logic_vector(RHD_SPI_NUM_BITS_PER_PACKET-1 downto 0);
  signal tb_RHD2132_RX_Byte_Falling  : std_logic_vector(RHD_SPI_NUM_BITS_PER_PACKET-1 downto 0);
  

  -- FIFO Signals
  signal tb_FIFO_RHD2216_Data    : std_logic_vector(31 downto 0);
  signal tb_FIFO_RHD2216_WE      : std_logic;
  signal tb_FIFO_RHD2216_RE      : std_logic;
  signal tb_FIFO_RHD2216_COUNT   : std_logic_vector(7 downto 0);
  signal tb_FIFO_RHD2216_Q       : std_logic_vector(31 downto 0) ;
  signal tb_FIFO_RHD2216_EMPTY   : std_logic;
  signal tb_FIFO_RHD2216_FULL    : std_logic;
  signal tb_FIFO_RHD2216_AEMPTY  : std_logic;
  signal tb_FIFO_RHD2216_AFULL   : std_logic;

  -- RHD SPI Interface
  signal tb_RHD2216_SPI_Clk          : std_logic;
  signal tb_RHD2216_SPI_MISO         : std_logic;
  signal tb_RHD2216_SPI_MOSI         : std_logic;
  signal tb_RHD2216_SPI_CS_n         : std_logic;
  signal tb_RHD2216_TX_Byte          : std_logic_vector(RHD_SPI_NUM_BITS_PER_PACKET-1 downto 0) := (others => '0');
  signal tb_RHD2216_TX_DV            : std_logic := '0';
  signal tb_RHD2216_TX_Ready         : std_logic;
  signal tb_RHD2216_RX_DV            : std_logic;
  signal tb_RHD2216_RX_Byte_Rising   : std_logic_vector(RHD_SPI_NUM_BITS_PER_PACKET-1 downto 0);
  signal tb_RHD2216_RX_Byte_Falling  : std_logic_vector(RHD_SPI_NUM_BITS_PER_PACKET-1 downto 0);


begin

  tb_Clk <= not tb_Clk after CLK_PERIOD;
  tb_RHD2132_SPI_MISO <= tb_RHD2132_SPI_MOSI;
  tb_RHD2216_SPI_MISO <= tb_RHD2216_SPI_MOSI;
  tb_STM32_SPI_MISO <= tb_STM32_SPI_MOSI;
  

  -- Instantiate the Controller_Headstage
  UUT : entity work.Controller_RHD_Sampling
    generic map (
      STM32_SPI_NUM_BITS_PER_PACKET => STM32_SPI_NUM_BITS_PER_PACKET,
      STM32_CLKS_PER_HALF_BIT       => STM32_CLKS_PER_HALF_BIT,
	  STM32_CS_INACTIVE_CLKS        => STM32_CS_INACTIVE_CLKS,
	  
	  RHD2132_SPI_DDR_MODE            => RHD_SPI_DDR_MODE,
      RHD2132_SPI_NUM_BITS_PER_PACKET => RHD_SPI_NUM_BITS_PER_PACKET,
      RHD2132_CLKS_PER_HALF_BIT       => RHD_CLKS_PER_HALF_BIT,
	  RHD2132_CS_INACTIVE_CLKS        => RHD_CS_INACTIVE_CLKS
	  )
    port map (
	  o_NUM_DATA           => tb_NUM_DATA,
	  o_STM32_State        => tb_STM32_State,
	  o_stm32_counter      => tb_stm32_counter,
      i_Rst_L 			=> tb_Rst_L,
      i_Clk             => tb_Clk,
	  i_Controller_Mode => tb_Controller_Mode,
      o_FIFO_RHD2132_Data    => tb_FIFO_RHD2132_Data,
	  o_FIFO_RHD2132_COUNT   => tb_FIFO_RHD2132_COUNT,
      o_FIFO_RHD2132_WE      => tb_FIFO_RHD2132_WE,
      o_FIFO_RHD2132_RE      => tb_FIFO_RHD2132_RE,
      o_FIFO_RHD2132_Q       => tb_FIFO_RHD2132_Q,
      o_FIFO_RHD2132_EMPTY   => tb_FIFO_RHD2132_EMPTY,
      o_FIFO_RHD2132_FULL    => tb_FIFO_RHD2132_FULL,
      o_FIFO_RHD2132_AEMPTY  => tb_FIFO_RHD2132_AEMPTY,
      o_FIFO_RHD2132_AFULL   => tb_FIFO_RHD2132_AFULL,
      o_RHD2132_SPI_Clk          => tb_RHD2132_SPI_Clk,
      i_RHD2132_SPI_MISO         => tb_RHD2132_SPI_MISO,
      o_RHD2132_SPI_MOSI         => tb_RHD2132_SPI_MOSI,
      o_RHD2132_SPI_CS_n         => tb_RHD2132_SPI_CS_n,
      o_RHD2132_TX_Byte          => tb_RHD2132_TX_Byte,
      o_RHD2132_TX_DV            => tb_RHD2132_TX_DV,
      o_RHD2132_TX_Ready         => tb_RHD2132_TX_Ready,
      o_RHD2132_RX_DV            => tb_RHD2132_RX_DV,
      o_RHD2132_RX_Byte_Rising   => tb_RHD2132_RX_Byte_Rising,
      o_RHD2132_RX_Byte_Falling  => tb_RHD2132_RX_Byte_Falling,
	  
	  o_FIFO_RHD2216_Data    => tb_FIFO_RHD2216_Data,
	  o_FIFO_RHD2216_COUNT   => tb_FIFO_RHD2216_COUNT,
      o_FIFO_RHD2216_WE      => tb_FIFO_RHD2216_WE,
      o_FIFO_RHD2216_RE      => tb_FIFO_RHD2216_RE,
      o_FIFO_RHD2216_Q       => tb_FIFO_RHD2216_Q,
      o_FIFO_RHD2216_EMPTY   => tb_FIFO_RHD2216_EMPTY,
      o_FIFO_RHD2216_FULL    => tb_FIFO_RHD2216_FULL,
      o_FIFO_RHD2216_AEMPTY  => tb_FIFO_RHD2216_AEMPTY,
      o_FIFO_RHD2216_AFULL   => tb_FIFO_RHD2216_AFULL,
      o_RHD2216_SPI_Clk          => tb_RHD2216_SPI_Clk,
      i_RHD2216_SPI_MISO         => tb_RHD2216_SPI_MISO,
      o_RHD2216_SPI_MOSI         => tb_RHD2216_SPI_MOSI,
      o_RHD2216_SPI_CS_n         => tb_RHD2216_SPI_CS_n,
      o_RHD2216_TX_Byte          => tb_RHD2216_TX_Byte,
      o_RHD2216_TX_DV            => tb_RHD2216_TX_DV,
      o_RHD2216_TX_Ready         => tb_RHD2216_TX_Ready,
      o_RHD2216_RX_DV            => tb_RHD2216_RX_DV,
      o_RHD2216_RX_Byte_Rising   => tb_RHD2216_RX_Byte_Rising,
      o_RHD2216_RX_Byte_Falling  => tb_RHD2216_RX_Byte_Falling
    );

  Testing : process is
  begin
    tb_Controller_Mode <= x"0";
	
    wait for 100 ns;
    tb_Rst_L <= '1';
    wait for 100 ns;
    tb_Rst_L <= '0';
	
	wait for 100 * CLK_PERIOD;
	tb_Controller_Mode <= x"1";
	
	wait for 100 * CLK_PERIOD;
	tb_Controller_Mode <= x"2";
	
    -- Wait for 4000 clock cycles
    wait for 400000 * CLK_PERIOD;


    -- TODO:
    -- Wait FOR DATA TO COME SO JUST LOOP IN THE STM32 MESSAGE AND SEE THE RESULTS


    wait for 5000 ns;
    assert false report "Test Complete" severity failure;
  end process Testing;
end architecture Testbench;
