library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity SPI_Master_TB is
end entity SPI_Master_TB;

architecture tb_arch of SPI_Master_TB is
  -- Constants
  constant CLK_PERIOD : time := 10 ns;
  
  -- Signals
  signal s_clk           : std_logic := '0';
  signal s_reset         : std_logic := '0';
  signal s_tx_byte       : std_logic_vector(15 downto 0) := (others => '0');
  signal s_tx_dv         : std_logic := '0';
  signal s_rx_byte_rising  : std_logic_vector(15 downto 0) := (others => '0');
  signal s_rx_byte_falling : std_logic_vector(15 downto 0) := (others => '0');
  signal s_spi_miso      : std_logic := '0';
  signal s_spi_mosi      : std_logic;
  signal s_tx_ready      : std_logic;
  signal s_rx_dv         : std_logic;
  signal s_spi_clk       : std_logic;

  -- Component instantiation
  component SPI_Master
    generic (
      SPI_MODE               : integer := 0;
      CLKS_PER_HALF_BIT      : integer := 2;
      NUM_OF_BITS_PER_PACKET : integer := 16
    );
    port (
      i_Rst_L : in std_logic;        -- FPGA Reset
      i_Clk   : in std_logic;        -- FPGA Clock
      i_TX_Byte   : in std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);   -- Byte to transmit on MOSI
      i_TX_DV     : in std_logic;          -- Data Valid Pulse with i_TX_Byte
      o_TX_Ready  : out std_logic;        -- Transmit Ready for next byte
      o_RX_DV   : out std_logic;                      -- Data Valid pulse (1 clock cycle)
      o_RX_Byte_Rising  : out std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);    -- Byte received on MISO Rising Edge
      o_RX_Byte_Falling : out std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);   -- Byte received on MISO Falling Edge
      o_SPI_Clk  : out std_logic;
      i_SPI_MISO : in  std_logic;
      o_SPI_MOSI : out std_logic
    );
  end component;

begin
  -- DUT
  dut : SPI_Master
    generic map(
      SPI_MODE               => 0,
      CLKS_PER_HALF_BIT      => 2,
      NUM_OF_BITS_PER_PACKET => 16
    )
    port map(
      i_Rst_L            => s_reset,
      i_Clk              => s_clk,
      i_TX_Byte          => s_tx_byte,
      i_TX_DV            => s_tx_dv,
      o_TX_Ready         => s_tx_ready,
      o_RX_DV            => s_rx_dv,
      o_RX_Byte_Rising  => s_rx_byte_rising,
      o_RX_Byte_Falling => s_rx_byte_falling,
      o_SPI_Clk          => s_spi_clk,
      i_SPI_MISO         => s_spi_miso,
      o_SPI_MOSI         => s_spi_mosi
    );
    s_spi_miso <= s_spi_mosi;
  
  -- Clock process
  process
  begin
    while now < 1000 ns loop  -- Simulate for 1000 ns
      s_clk <= '0';
      wait for CLK_PERIOD / 2;
      s_clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  process
  begin
    s_reset <= '1';
    wait for 50 ns;  -- Reset for 50 ns
    s_reset <= '0';
    wait for 10 ns;

    -- Transmit a byte
    s_tx_byte <= "1010101010101010";
    s_tx_dv <= '1';
    wait for 10 ns;
    s_tx_dv <= '0';

    wait for 200 ns;

    -- Transmit another byte
    s_tx_byte <= "1011110101110101";
    s_tx_dv <= '1';
    wait for 10 ns;
    s_tx_dv <= '0';

    wait;
  end process;


end architecture tb_arch;
