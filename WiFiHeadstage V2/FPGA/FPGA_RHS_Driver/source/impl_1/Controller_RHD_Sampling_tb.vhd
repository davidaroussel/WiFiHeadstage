library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_RHD_Sampling_tb is
end entity Controller_RHD_Sampling_tb;

architecture Testbench of Controller_RHD_Sampling_tb is
  -- Constants
  constant CLK_PERIOD                    : time := 10 ns;
  constant STM32_SPI_NUM_BITS_PER_PACKET : integer := 512; 
  constant RHS_READ_SPI_NUM_BITS_PER_PACKET : integer := 16;  
  
  constant STM32_CLKS_PER_HALF_BIT : integer := 2;
  constant RHS_READ_CLKS_PER_HALF_BIT : integer := 2;
  
  constant STM32_CS_INACTIVE_CLKS : integer := 4;
  constant RHS_READ_CS_INACTIVE_CLKS : integer := 4;
  
  constant RHS_READ_SPI_DDR_MODE : integer := 0;
  
-- Signals
  signal tb_Controller_Mode : std_logic_vector (3 downto 0);
  signal tb_Rst_L           : std_logic := '1';
  signal tb_Clk             : std_logic := '0';
  signal tb_NUM_DATA        : integer;
  signal tb_STM32_State     : integer;
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
  signal tb_FIFO_RHS_READ_Data    : std_logic_vector(31 downto 0);
  signal tb_FIFO_RHS_READ_WE      : std_logic;
  signal tb_FIFO_RHS_READ_RE      : std_logic;
  signal tb_FIFO_RHS_READ_COUNT   : std_logic_vector(7 downto 0);
  signal tb_FIFO_RHS_READ_Q       : std_logic_vector(31 downto 0);
  signal tb_FIFO_RHS_READ_EMPTY   : std_logic;
  signal tb_FIFO_RHS_READ_FULL    : std_logic;
  signal tb_FIFO_RHS_READ_AEMPTY  : std_logic;
  signal tb_FIFO_RHS_READ_AFULL   : std_logic;

  -- RHS_READ SPI Interface
  signal tb_RHS_READ_SPI_Clk          : std_logic;
  signal tb_RHS_READ_SPI_MISO         : std_logic;
  signal tb_RHS_READ_SPI_MOSI         : std_logic;
  signal tb_RHS_READ_SPI_CS_n         : std_logic;
  signal tb_RHS_READ_TX_Byte          : std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0) := (others => '0');
  signal tb_RHS_READ_TX_DV            : std_logic := '0';
  signal tb_RHS_READ_TX_Ready         : std_logic;
  signal tb_RHS_READ_RX_DV            : std_logic;
  signal tb_RHS_READ_RX_Byte_Rising   : std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
  signal tb_RHS_READ_RX_Byte_Falling  : std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
  

  -- FIFO Signals
  signal tb_FIFO_RHS_STIM_Data    : std_logic_vector(31 downto 0);
  signal tb_FIFO_RHS_STIM_WE      : std_logic;
  signal tb_FIFO_RHS_STIM_RE      : std_logic;
  signal tb_FIFO_RHS_STIM_COUNT   : std_logic_vector(7 downto 0);
  signal tb_FIFO_RHS_STIM_Q       : std_logic_vector(31 downto 0);
  signal tb_FIFO_RHS_STIM_EMPTY   : std_logic;
  signal tb_FIFO_RHS_STIM_FULL    : std_logic;
  signal tb_FIFO_RHS_STIM_AEMPTY  : std_logic;
  signal tb_FIFO_RHS_STIM_AFULL   : std_logic;

  -- RHS_STIM SPI Interface
  signal tb_RHS_STIM_SPI_Clk          : std_logic;
  signal tb_RHS_STIM_SPI_MISO         : std_logic;
  signal tb_RHS_STIM_SPI_MOSI         : std_logic;
  signal tb_RHS_STIM_SPI_CS_n         : std_logic;
  signal tb_RHS_STIM_TX_Byte          : std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0) := (others => '0');
  signal tb_RHS_STIM_TX_DV            : std_logic := '0';
  signal tb_RHS_STIM_TX_Ready         : std_logic;
  signal tb_RHS_STIM_RX_DV            : std_logic;
  signal tb_RHS_STIM_RX_Byte_Rising   : std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
  signal tb_RHS_STIM_RX_Byte_Falling  : std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);


begin

  tb_Clk <= not tb_Clk after CLK_PERIOD;

  tb_RHS_READ_SPI_MISO <= tb_RHS_READ_SPI_MOSI;
  tb_RHS_STIM_SPI_MISO <= tb_RHS_STIM_SPI_MOSI;
  tb_STM32_SPI_MISO <= tb_STM32_SPI_MOSI;
  

  -- Instantiate the Controller_Headstage
  UUT : entity work.Controller_RHD_Sampling
    generic map (
      STM32_SPI_NUM_BITS_PER_PACKET => STM32_SPI_NUM_BITS_PER_PACKET,
      STM32_CLKS_PER_HALF_BIT       => STM32_CLKS_PER_HALF_BIT,
      STM32_CS_INACTIVE_CLKS        => STM32_CS_INACTIVE_CLKS,
      
      RHS_READ_SPI_NUM_BITS_PER_PACKET => RHS_READ_SPI_NUM_BITS_PER_PACKET,
      RHS_READ_CLKS_PER_HALF_BIT       => RHS_READ_CLKS_PER_HALF_BIT,
      RHS_READ_CS_INACTIVE_CLKS        => RHS_READ_CS_INACTIVE_CLKS
      )
    port map (
      o_NUM_DATA           => tb_NUM_DATA,
      o_STM32_State        => tb_STM32_State,
      o_stm32_counter      => tb_stm32_counter,
      i_Rst_L              => tb_Rst_L,
      i_Clk                => tb_Clk,
      i_Controller_Mode    => tb_Controller_Mode,

      o_FIFO_RHS_READ_Data    => tb_FIFO_RHS_READ_Data,
      o_FIFO_RHS_READ_COUNT   => tb_FIFO_RHS_READ_COUNT,
      o_FIFO_RHS_READ_WE      => tb_FIFO_RHS_READ_WE,
      o_FIFO_RHS_READ_RE      => tb_FIFO_RHS_READ_RE,
      o_FIFO_RHS_READ_Q       => tb_FIFO_RHS_READ_Q,
      o_FIFO_RHS_READ_EMPTY   => tb_FIFO_RHS_READ_EMPTY,
      o_FIFO_RHS_READ_FULL    => tb_FIFO_RHS_READ_FULL,
      o_FIFO_RHS_READ_AEMPTY  => tb_FIFO_RHS_READ_AEMPTY,
      o_FIFO_RHS_READ_AFULL   => tb_FIFO_RHS_READ_AFULL,

      o_RHS_READ_SPI_Clk          => tb_RHS_READ_SPI_Clk,
      i_RHS_READ_SPI_MISO_1       => tb_RHS_READ_SPI_MISO,
      o_RHS_READ_SPI_MOSI         => tb_RHS_READ_SPI_MOSI,
      o_RHS_READ_SPI_CS_n_1       => tb_RHS_READ_SPI_CS_n,
      o_RHS_READ_TX_Byte          => tb_RHS_READ_TX_Byte,
      o_RHS_READ_TX_DV            => tb_RHS_READ_TX_DV,
      o_RHS_READ_TX_Ready         => tb_RHS_READ_TX_Ready,
      o_RHS_READ_RX_DV            => tb_RHS_READ_RX_DV,
      o_RHS_READ_RX_Byte_Rising   => tb_RHS_READ_RX_Byte_Rising,
      o_RHS_READ_RX_Byte_Falling  => tb_RHS_READ_RX_Byte_Falling,
      
      o_FIFO_RHS_STIM_Data    => tb_FIFO_RHS_STIM_Data,
      o_FIFO_RHS_STIM_COUNT   => tb_FIFO_RHS_STIM_COUNT,
      o_FIFO_RHS_STIM_WE      => tb_FIFO_RHS_STIM_WE,
      o_FIFO_RHS_STIM_RE      => tb_FIFO_RHS_STIM_RE,
      o_FIFO_RHS_STIM_Q       => tb_FIFO_RHS_STIM_Q,
      o_FIFO_RHS_STIM_EMPTY   => tb_FIFO_RHS_STIM_EMPTY,
      o_FIFO_RHS_STIM_FULL    => tb_FIFO_RHS_STIM_FULL,
      o_FIFO_RHS_STIM_AEMPTY  => tb_FIFO_RHS_STIM_AEMPTY,
      o_FIFO_RHS_STIM_AFULL   => tb_FIFO_RHS_STIM_AFULL,

      o_RHS_STIM_SPI_Clk          => tb_RHS_STIM_SPI_Clk,
      i_RHS_STIM_SPI_MISO_1       => tb_RHS_STIM_SPI_MISO,
      o_RHS_STIM_SPI_MOSI         => tb_RHS_STIM_SPI_MOSI,
      o_RHS_STIM_SPI_CS_n_1       => tb_RHS_STIM_SPI_CS_n,
      o_RHS_STIM_TX_Byte          => tb_RHS_STIM_TX_Byte,
      o_RHS_STIM_TX_DV            => tb_RHS_STIM_TX_DV,
      o_RHS_STIM_TX_Ready         => tb_RHS_STIM_TX_Ready,
      o_RHS_STIM_RX_DV            => tb_RHS_STIM_RX_DV,
      o_RHS_STIM_RX_Byte_Rising   => tb_RHS_STIM_RX_Byte_Rising,
      o_RHS_STIM_RX_Byte_Falling  => tb_RHS_STIM_RX_Byte_Falling
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