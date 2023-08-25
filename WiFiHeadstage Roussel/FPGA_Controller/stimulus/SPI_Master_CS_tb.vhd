----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Thu Aug 24 10:19:20 2023
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: SPI_Master_CS_tb.vhd
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

entity SPI_Master_CS_TB is
end entity SPI_Master_CS_TB;

architecture TB of SPI_Master_CS_TB is

  constant SPI_MODE           : integer := 0;           -- CPOL = 0 CPHA = 0
  constant CLKS_PER_HALF_BIT  : integer := 3;  -- (125/2) /CLK_PER_HALF_BIT MHz
  constant MAX_PACKET_PER_CS  : integer := 2;   -- 2 bytes per chip select
  constant CS_INACTIVE_CLKS   : integer := 4;  -- Adds delay between bytes
  
  signal  r_Rst_L    : std_logic := '0';
  signal  w_SPI_Clk  : std_logic;
  signal  r_Clk      : std_logic := '0';
  signal  w_SPI_CS_n : std_logic;
  signal  w_SPI_MOSI : std_logic;
  
  -- Master Specific
  signal r_Master_TX_Byte         : std_logic_vector(15 downto 0) := X"0000";
  signal r_Master_TX_DV           : std_logic := '0';
  signal w_Master_TX_Ready        : std_logic;
  signal w_Master_RX_DV           : std_logic;
  signal w_Master_RX_Byte_Rising  : std_logic_vector(15 downto 0);
  signal w_Master_RX_Byte_Falling : std_logic_vector(15 downto 0);
  signal w_Master_RX_Count        : std_logic_vector(1 downto 0);
  signal r_Master_TX_Count        : std_logic_vector(1 downto 0) := "01";

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

  -- Instantiate UUT
  UUT : entity work.SPI_Master_CS
    generic map (
      SPI_MODE           => SPI_MODE,
      CLKS_PER_HALF_BIT  => CLKS_PER_HALF_BIT,
      MAX_PACKET_PER_CS  => MAX_PACKET_PER_CS,
      CS_INACTIVE_CLKS   => CS_INACTIVE_CLKS)
    port map (
      i_Rst_L    => r_Rst_L,
      i_Clk      => r_Clk,
      -- TX (MOSI) Signals
      i_TX_Count => r_Master_TX_Count,  -- Number of bytes per CS         
      i_TX_Byte  => r_Master_TX_Byte,   -- Byte to transmit on MOSI       
      i_TX_DV    => r_Master_TX_DV,     -- Data Valid Pulse with i_TX_Byte
      o_TX_Ready => w_Master_TX_Ready,  -- Transmit Ready for Byte        
      -- RX (MISO) Signals
      o_RX_Count => w_Master_RX_Count,  -- Index of RX'd byte              
      o_RX_DV    => w_Master_RX_DV,     -- Data Valid pulse (1 clock cycle)
      o_RX_Byte_Rising  => w_Master_RX_Byte_Rising,   -- Byte received on MISO
      o_RX_Byte_Falling => w_Master_RX_Byte_Falling,  -- Byte received on MISO                   
      -- SPI Interface
      o_SPI_Clk  => w_SPI_Clk,
      i_SPI_MISO => w_SPI_MOSI,
      o_SPI_MOSI => w_SPI_MOSI,
      o_SPI_CS_n => w_SPI_CS_n
      );

  Testing : process is
  begin
    wait for 100 ns;
    r_Rst_L <= '0';
    wait for 100 ns;
    r_Rst_L <= '1';

    -- Test single byte
    SendMessage(X"C1C2", r_Master_TX_Byte, r_Master_TX_DV);
    report "Sent out 0xC1C2, Received 0x" & to_hstring(unsigned(w_Master_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(w_Master_RX_Byte_Falling));
    -- Test double byte
    SendMessage(X"ADBC", r_Master_TX_Byte, r_Master_TX_DV);
    report "Sent out 0xADBC, Received 0x" & to_hstring(unsigned(w_Master_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(w_Master_RX_Byte_Falling));

    SendMessage(X"A1A2", r_Master_TX_Byte, r_Master_TX_DV);
    report "Sent out 0xA1A2, Received 0x" & to_hstring(unsigned(w_Master_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(w_Master_RX_Byte_Falling));   


    wait for 100 ns;
    assert false report "Test Complete" severity failure;
  end process Testing;

end architecture TB;  
