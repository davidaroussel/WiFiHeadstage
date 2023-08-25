----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Thu Aug 24 09:49:18 2023
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: SPI_Master_tb.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::IGLOO> <Die::AGLN250V2> <Package::100 VQFP>
-- Author: <Name>
--
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPI_Master_TB is
end entity SPI_Master_TB;

architecture TB of SPI_Master_TB is

  constant SPI_MODE               : integer := 0; -- CPOL = 1, CPHA = 1
  constant CLKS_PER_HALF_BIT      : integer := 4;  -- 6.25 MHz
  constant NUM_OF_BYTE_PER_PACKET : integer := 2; -- Messages are 2 bytes each

  signal r_Rst_L    : std_logic := '0';
  signal w_SPI_Clk  : std_logic;
  signal r_Clk      : std_logic := '0';
  signal w_SPI_MOSI : std_logic;
  
  -- Master Specific
  signal r_Master_TX_Byte  : std_logic_vector(15 downto 0) := X"0000";
  signal r_Master_TX_DV    : std_logic := '0';
  signal r_Master_CS_n     : std_logic := '1';
  signal w_Master_TX_Ready : std_logic;
  signal r_Master_RX_DV    : std_logic := '0';
  signal r_Master_RX_Byte_Rising   : std_logic_vector(15 downto 0) := X"0000";
  signal r_Master_RX_Byte_Falling  : std_logic_vector(15 downto 0) := X"0000";
    

  -- Sends a single byte from master. 
  procedure SendMessage (
    data          : in  std_logic_vector(15 downto 0);
    signal o_data : out std_logic_vector(15 downto 0);
    signal o_dv   : out std_logic) is
  begin
    wait until rising_edge(r_Clk);
    o_data <= data;
    o_dv   <= '1';
    wait until rising_edge(r_Clk);
    o_dv   <= '0';
    wait until rising_edge(w_Master_TX_Ready);
  end procedure SendMessage;

begin  -- architecture TB

   -- Clock Generators:
  r_Clk <= not r_Clk after 20.83 ns;

  -- Instantiate Master
  UUT : entity work.SPI_Master
    generic map (
      SPI_MODE          => SPI_MODE,
      CLKS_PER_HALF_BIT => CLKS_PER_HALF_BIT,
      NUM_OF_BYTE_PER_PACKET => NUM_OF_BYTE_PER_PACKET)
    port map (
      -- Control/Data Signals,
      i_Rst_L    => r_Rst_L,            -- FPGA Reset
      i_Clk      => r_Clk,              -- FPGA Clock
      -- TX (MOSI) Signals
      i_TX_Byte  => r_Master_TX_Byte,          -- Byte to transmit
      i_TX_DV    => r_Master_TX_DV,            -- Data Valid pulse
      o_TX_Ready => w_Master_TX_Ready,         -- Transmit Ready for Byte
      -- RX (MISO) Signals
      o_RX_DV    => r_Master_RX_DV,            -- Data Valid pulse
      o_RX_Byte_Rising   => r_Master_RX_Byte_Rising,      -- Byte received on MISO Rising Edge
      o_RX_Byte_Falling  => r_Master_RX_Byte_Falling,     -- Byte received on MISO Falling Edge
      -- SPI Interface
      o_SPI_Clk  => w_SPI_Clk, 
      i_SPI_MISO => w_SPI_MOSI,
      o_SPI_MOSI => w_SPI_MOSI
      );
      
  Testing : process is
  begin
    wait for 100 ns;
    r_Rst_L <= '0';
    wait for 100 ns;
    r_Rst_L <= '1';
    
    -- Test single byte
    SendMessage(X"C1C2", r_Master_TX_Byte, r_Master_TX_DV);
    report "Sent out 0xC1C2, Received 0x" & to_hstring(unsigned(r_Master_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(r_Master_RX_Byte_Falling));
    -- Test double byte
    SendMessage(X"ADBC", r_Master_TX_Byte, r_Master_TX_DV);
    report "Sent out 0xADBC, Received 0x" & to_hstring(unsigned(r_Master_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(r_Master_RX_Byte_Falling));

    SendMessage(X"A1A2", r_Master_TX_Byte, r_Master_TX_DV);
    report "Sent out 0xA1A2, Received 0x" & to_hstring(unsigned(r_Master_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(r_Master_RX_Byte_Falling));    
    
    wait for 50 ns;
    assert false report "Test Complete" severity failure;
  end process Testing;

end architecture TB;

