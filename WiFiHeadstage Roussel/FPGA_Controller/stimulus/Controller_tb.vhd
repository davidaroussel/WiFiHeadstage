library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity Controller_tb is
end entity Controller_tb;

architecture sim of Controller_tb is

  constant CLK_PERIOD   : time := 20.83 ns; -- Adjust as needed

  constant SPI_MODE           : integer := 0;  -- CPOL = 0 CPHA = 0
  constant CLKS_PER_HALF_BIT  : integer := 3;  -- (125/2)/CLK_PER_HALF_BIT MHz
  constant MAX_PACKET_PER_CS  : integer := 2;  -- 2 bytes per chip select
  constant CS_INACTIVE_CLKS   : integer := 4;  -- Adds delay between bytes

  signal tb_Rst_L           : std_logic := '1';
  signal tb_Clk             : std_logic := '0';
  
  signal tb_SPI_Clk         : std_logic;
  signal tb_SPI_MISO        : std_logic;
  signal tb_SPI_MOSI        : std_logic;
  signal tb_SPI_CS_n        : std_logic;
  
  signal tb_TX_Count        : std_logic_vector(1 downto 0)  := "01";
  signal tb_TX_Byte         : std_logic_vector(15 downto 0) := (others => '0');
  signal tb_TX_DV           : std_logic := '0';
  signal tb_TX_Ready        : std_logic;
  
  signal tb_RX_Count        : std_logic_vector(3 downto 0);
  signal tb_RX_DV           : std_logic;
  signal tb_RX_Byte_Rising  : std_logic_vector(15 downto 0) := (others => '0');
  signal tb_RX_Byte_Falling : std_logic_vector(15 downto 0) := (others => '0');
  
  signal tb_FIFO_Data       : std_logic_vector(31 downto 0);
  signal tb_FIFO_EMPTY      : std_logic;
  signal tb_FIFO_FULL       : std_logic;
  signal tb_FIFO_AEMPTY     : std_logic;
  signal tb_FIFO_AFULL      : std_logic;

  -- Sends a single byte from master. 
  procedure SendMessage (
    data          : in  std_logic_vector(15 downto 0);
    signal o_data : out std_logic_vector(15 downto 0);
    signal o_dv   : out std_logic) is
  begin
    wait until rising_edge(tb_Clk);
    o_data <= data;
    o_dv   <= '1';
    wait until rising_edge(tb_Clk);
    o_dv   <= '0';
    wait until rising_edge(tb_TX_Ready);
  end procedure SendMessage;

begin
 
  tb_Clk <= not tb_Clk after CLK_PERIOD;
  tb_SPI_MISO <= tb_SPI_MOSI;

  UUT: entity work.Controller
    generic map (
      SPI_MODE           => SPI_MODE,
      CLKS_PER_HALF_BIT  => CLKS_PER_HALF_BIT,
      MAX_PACKET_PER_CS  => MAX_PACKET_PER_CS,
      CS_INACTIVE_CLKS   => CS_INACTIVE_CLKS)
    port map (
      i_Rst_L           => tb_Rst_L,
      i_Clk             => tb_Clk,
      o_SPI_Clk         => tb_SPI_Clk,
      i_SPI_MISO        => tb_SPI_MISO,
      o_SPI_MOSI        => tb_SPI_MOSI,
      o_SPI_CS_n        => tb_SPI_CS_n,
      i_TX_Count        => tb_TX_Count,
      i_TX_Byte         => tb_TX_Byte,
      i_TX_DV           => tb_TX_DV,
      o_TX_Ready        => tb_TX_Ready,
      o_RX_Count        => tb_RX_Count,
      o_RX_DV           => tb_RX_DV,
      o_RX_Byte_Rising  => tb_RX_Byte_Rising,
      o_RX_Byte_Falling => tb_RX_Byte_Falling,
      o_FIFO_Data       => tb_FIFO_Data,
      o_FIFO_EMPTY      => tb_FIFO_EMPTY,
      o_FIFO_FULL       => tb_FIFO_FULL,
      o_FIFO_AEMPTY     => tb_FIFO_AEMPTY,
      o_FIFO_AFULL      => tb_FIFO_AFULL
    );


    Testing : process is
  begin
    wait for 100 ns;
    tb_Rst_L <= '1';
    wait for 100 ns;
    tb_Rst_L <= '0';

    -- Test single byte
    SendMessage(X"C1C2", tb_TX_Byte, tb_TX_DV);
    report "Sent out 0xC1C2, Received 0x" & to_hstring(unsigned(tb_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(tb_RX_Byte_Falling));
    -- Test double byte
    SendMessage(X"ADBC", tb_TX_Byte, tb_TX_DV);
    report "Sent out 0xADBC, Received 0x" & to_hstring(unsigned(tb_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(tb_RX_Byte_Falling));

    SendMessage(X"A1A2", tb_TX_Byte, tb_TX_DV);
    report "Sent out 0xA1A2, Received 0x" & to_hstring(unsigned(tb_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(tb_RX_Byte_Falling));   

    wait for 100 ns;
    assert false report "Test Complete" severity failure;
  end process Testing;
end architecture sim;