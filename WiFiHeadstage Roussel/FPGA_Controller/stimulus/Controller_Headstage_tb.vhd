library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_Headstage_tb is
end entity Controller_Headstage_tb;

architecture Testbench of Controller_Headstage_tb is
  -- Constants
  constant CLK_PERIOD                    : time := 5.21 ns;
  constant STM32_SPI_NUM_BITS_PER_PACKET : integer := 32;  -- Adds delay between bytes
  constant RHD64_SPI_NUM_BITS_PER_PACKET : integer := 16;  -- Adds delay between bytes
  
  constant STM32_CLKS_PER_HALF_BIT : integer := 8;  -- Adds delay between bytes
  constant RHD64_CLKS_PER_HALF_BIT : integer := 16;  -- Adds delay between bytes
  
-- Signals
  signal tb_Rst_L        : std_logic := '1';
  signal tb_Clk          : std_logic := '0';

  -- STM32 SPI Interface
  signal tb_STM32_SPI_Clk         : std_logic;
  signal tb_STM32_SPI_MISO        : std_logic;
  signal tb_STM32_SPI_MOSI        : std_logic;
  signal tb_STM32_SPI_CS_n        : std_logic := '1';
  signal tb_STM32_TX_Count        : std_logic_vector(1 downto 0) := "01";
  signal tb_STM32_TX_Byte         : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0) := (others => '0');
  signal tb_STM32_TX_DV           : std_logic := '0';
  signal tb_STM32_TX_Ready        : std_logic;
  signal tb_STM32_RX_Count        : std_logic_vector(1 downto 0);
  signal tb_STM32_RX_DV           : std_logic ;
  signal tb_STM32_RX_Byte_Rising  : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);

  -- FIFO Signals
  signal tb_FIFO_Data    : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
  signal tb_FIFO_WE      : std_logic;
  signal tb_FIFO_RE      : std_logic;
  signal tb_FIFO_Q       : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
  signal tb_FIFO_EMPTY   : std_logic;
  signal tb_FIFO_FULL    : std_logic;
  signal tb_FIFO_AEMPTY  : std_logic;
  signal tb_FIFO_AFULL   : std_logic;

  -- RHD64 SPI Interface
  signal tb_RHD64_SPI_Clk          : std_logic;
  signal tb_RHD64_SPI_MISO         : std_logic;
  signal tb_RHD64_SPI_MOSI         : std_logic;
  signal tb_RHD64_SPI_CS_n         : std_logic;
  signal tb_RHD64_TX_Count         : std_logic_vector(1 downto 0) := "01";
  signal tb_RHD64_TX_Byte          : std_logic_vector(RHD64_SPI_NUM_BITS_PER_PACKET-1 downto 0) := (others => '0');
  signal tb_RHD64_TX_DV            : std_logic := '0';
  signal tb_RHD64_TX_Ready         : std_logic;
  signal tb_RHD64_RX_Count         : std_logic_vector(1 downto 0);
  signal tb_RHD64_RX_DV            : std_logic;
  signal tb_RHD64_RX_Byte_Rising   : std_logic_vector(RHD64_SPI_NUM_BITS_PER_PACKET-1 downto 0);
  signal tb_RHD64_RX_Byte_Falling  : std_logic_vector(RHD64_SPI_NUM_BITS_PER_PACKET-1 downto 0);
  

begin

  tb_Clk <= not tb_Clk after CLK_PERIOD;
  tb_RHD64_SPI_MISO <= tb_RHD64_SPI_MOSI;
  tb_STM32_SPI_MISO <= tb_STM32_SPI_MOSI;

  -- Instantiate the Controller_Headstage
  UUT : entity work.Controller_Headstage
    generic map (
      STM32_SPI_NUM_BITS_PER_PACKET => STM32_SPI_NUM_BITS_PER_PACKET,
      STM32_CLKS_PER_HALF_BIT      => STM32_CLKS_PER_HALF_BIT,
      RHD64_SPI_NUM_BITS_PER_PACKET => RHD64_SPI_NUM_BITS_PER_PACKET,
      RHD64_CLKS_PER_HALF_BIT       => RHD64_CLKS_PER_HALF_BIT)
    port map (
      i_Rst_L        => tb_Rst_L,
      i_Clk          => tb_Clk,
      o_STM32_SPI_Clk          => tb_STM32_SPI_Clk,
      i_STM32_SPI_MISO         => tb_STM32_SPI_MISO,
      o_STM32_SPI_MOSI         => tb_STM32_SPI_MOSI,
      o_STM32_SPI_CS_n         => tb_STM32_SPI_CS_n,
      i_STM32_TX_Count         => tb_STM32_TX_Count,
      o_STM32_TX_Byte          => tb_STM32_TX_Byte,
      o_STM32_TX_DV            => tb_STM32_TX_DV,
      o_STM32_TX_Ready         => tb_STM32_TX_Ready,
      o_STM32_RX_Count         => tb_STM32_RX_Count,
      o_STM32_RX_DV            => tb_STM32_RX_DV,
      o_STM32_RX_Byte_Rising   => tb_STM32_RX_Byte_Rising,
      o_FIFO_Data    => tb_FIFO_Data,
      o_FIFO_WE      => tb_FIFO_WE,
      o_FIFO_RE      => tb_FIFO_RE,
      o_FIFO_Q       => tb_FIFO_Q,
      o_FIFO_EMPTY   => tb_FIFO_EMPTY,
      o_FIFO_FULL    => tb_FIFO_FULL,
      o_FIFO_AEMPTY  => tb_FIFO_AEMPTY,
      o_FIFO_AFULL   => tb_FIFO_AFULL,
      o_RHD64_SPI_Clk          => tb_RHD64_SPI_Clk,
      i_RHD64_SPI_MISO         => tb_RHD64_SPI_MISO,
      o_RHD64_SPI_MOSI         => tb_RHD64_SPI_MOSI,
      o_RHD64_SPI_CS_n         => tb_RHD64_SPI_CS_n,
      i_RHD64_TX_Count         => tb_RHD64_TX_Count,
      o_RHD64_TX_Byte          => tb_RHD64_TX_Byte,
      o_RHD64_TX_DV            => tb_RHD64_TX_DV,
      o_RHD64_TX_Ready         => tb_RHD64_TX_Ready,
      o_RHD64_RX_Count         => tb_RHD64_RX_Count,
      o_RHD64_RX_DV            => tb_RHD64_RX_DV,
      io_RHD64_RX_Byte_Rising  => tb_RHD64_RX_Byte_Rising,
      io_RHD64_RX_Byte_Falling => tb_RHD64_RX_Byte_Falling
    );

  Testing : process is
  begin
    wait for 100 ns;
    tb_Rst_L <= '1';
    wait for 100 ns;
    tb_Rst_L <= '0';

    -- Wait for 4000 clock cycles
    wait for 4000 * CLK_PERIOD;


    -- TODO:
    -- Wait FOR DATA TO COME SO JUST LOOP IN THE STM32 MESSAGE AND SEE THE RESULTS






    wait for 5000 ns;
    assert false report "Test Complete" severity failure;
  end process Testing;
end architecture Testbench;
