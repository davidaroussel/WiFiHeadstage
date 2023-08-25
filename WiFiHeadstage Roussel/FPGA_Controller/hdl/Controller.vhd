--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Controller.vhd
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

library IEEE;

use IEEE.std_logic_1164.all;

entity Controller is
port (
    --<port_name> : <direction> <type>;
	port_name1 : IN  std_logic; -- example
    port_name2 : OUT std_logic_vector(1 downto 0)  -- example
    --<other_ports>;
);
end Controller;


architecture architecture_Controller of Controller is
   -- Control/Data Signals,
   i_uC_Rst_L : in std_logic;     -- FPGA Reset
   i_uC_Clk   : in std_logic;     -- FPGA Clock
   -- TX (MOSI) Signals
   i_uC_TX_Count : in  std_logic_vector;  -- # bytes per CS low
   i_uC_TX_Byte  : in  std_logic_vector(7 downto 0);  -- Byte to transmit on MOSI
   i_uC_TX_DV    : in  std_logic;     -- Data Valid Pulse with i_TX_Byte
   o_uC_TX_Ready : out std_logic;     -- Transmit Ready for next byte
   -- RX (MISO) Signals
   o_uC_RX_Count : out std_logic_vector;  -- Index RX byte
   o_uC_RX_DV    : out std_logic;  -- Data Valid pulse (1 clock cycle)
   o_uC_RX_Byte_Rising  : out std_logic_vector(7 downto 0);   -- Byte received on MISO Rising  CLK Edge
   o_uC_RX_Byte_Falling  : out std_logic_vector(7 downto 0);  -- Byte received on MISO Falling CLK Edge
   -- SPI Interface
   o_uC_SPI_Clk  : out std_logic;
   i_uC_SPI_MISO : in  std_logic;
   o_uC_SPI_MOSI : out std_logic;
   o_uC_SPI_CS_n : out std_logic;


  -- Control/Data Signals,
   i_RHD64_Rst_L : in std_logic;     -- FPGA Reset
   i_RHD64_uC_Clk   : in std_logic;     -- FPGA Clock   
   -- TX (MOSI) Signals
   i_RHD64_uC_TX_Count : in  std_logic_vector;  -- # bytes per CS low
   i_RHD64_uC_TX_Byte  : in  std_logic_vector(7 downto 0);  -- Byte to transmit on MOSI
   i_RHD64_uC_TX_DV    : in  std_logic;     -- Data Valid Pulse with i_TX_Byte
   o_RHD64_uC_TX_Ready : out std_logic;     -- Transmit Ready for next byte
   -- RX (MISO) Signals
   o_RHD64_uC_RX_Count : out std_logic_vector;  -- Index RX byte
   o_RHD64_uC_RX_DV    : out std_logic;  -- Data Valid pulse (1 clock cycle)
   o_RHD64_uC_RX_Byte_Rising  : out std_logic_vector(7 downto 0);   -- Byte received on MISO Rising  CLK Edge
   o_RHD64_uC_RX_Byte_Falling  : out std_logic_vector(7 downto 0);  -- Byte received on MISO Falling CLK Edge
   -- SPI Interface
   o_RHD64_uC_SPI_Clk  : out std_logic;
   i_RHD64_uC_SPI_MISO : in  std_logic;
   o_RHD64_uC_SPI_MOSI : out std_logic;
   o_RHD64_uC_SPI_CS_n : out std_logic


   i_FIFO_DATA   : in    std_logic_vector(31 downto 0);
   o_FIFO_Q      : out   std_logic_vector(31 downto 0);
   i_FIFO_WE     : in    std_logic;
   i_FIFO_RE     : in    std_logic;
   i_FIFO_WCLOCK : in    std_logic;
   i_FIFO_RCLOCK : in    std_logic;
   o_FIFO_FULL   : out   std_logic;
   o_FIFO_EMPTY  : out   std_logic;
   i_FIFO_RESET  : in    std_logic;
   o_FIFO_AEMPTY : out   std_logic;
   o_FIFO_AFULL  : out   std_logic


begin

  -- Instantiate Master
  SPI_Master_CS_1 : entity work.SPI_Master_CS
    generic map (
      SPI_MODE          => integer := 0,
      CLKS_PER_HALF_BIT => integer := 2,
      MAX_BYTES_PER_CS  => integer := 2,
      CS_INACTIVE_CLKS  => integer := 1)
    port map (
      -- Control/Data Signals,
      i_Rst_L    => i_uC_Rst_L,            -- FPGA Reset
      i_Clk      => i_uC_Clk,              -- FPGA Clock
      -- TX (MOSI) Signals
      i_TX_Count => i_uC_TX_Count,         -- Index Tx byte
      i_TX_Byte  => i_uC_TX_Byte,          -- Byte to transmit
      i_TX_DV    => i_uC_TX_DV,            -- Data Valid pulse
      o_TX_Ready => w_uC_Master_Ready,     -- Transmit Ready for Byte
      -- RX (MISO) Signals
      o_RX_Count        => o_uC_RX_Count          -- Index RX byte
      o_RX_DV           => o_uC_RX_DV,            -- Data Valid pulse
      o_RX_Byte_Rising  => o_uC_RX_Byte_Rising,   -- Byte received on MISO Rising  CLK Edge 
      o_RX_Byte_Falling => o_uC_RX_Byte_Falling,  -- Byte received on MISO Falling CLK Edge       
       -- SPI Interface
      o_SPI_Clk  => o_uC_SPI_Clk, 
      i_SPI_MISO => i_uC_SPI_MISO,
      o_SPI_MOSI => o_uC_SPI_MOSI,
      o_SPI_CS_n => o_uC_SPI_CS_n
      );

  -- Instantiate Master
  SPI_Master_CS_2 : entity work.SPI_Master_CS
    generic map (
      SPI_MODE          => integer := 0,
      CLKS_PER_HALF_BIT => integer := 2,
      MAX_BYTES_PER_CS  => integer := 2,
      CS_INACTIVE_CLKS  => integer := 1)
    port map (
      -- Control/Data Signals,
      i_Rst_L    => i_RHD64_Rst_L,            -- FPGA Reset
      i_Clk      => i_RHD64_Clk,              -- FPGA Clock
      -- TX (MOSI) Signals
      i_TX_Count => i_RHD64_TX_Count,         -- Index Tx byte
      i_TX_Byte  => i_RHD64_TX_Byte,          -- Byte to transmit
      i_TX_DV    => i_RHD64_TX_DV,            -- Data Valid pulse
      o_TX_Ready => w_RHD64_Master_Ready,     -- Transmit Ready for Byte
      -- RX (MISO) Signals
      o_RX_Count        => o_RHD64_RX_Count          -- Index RX byte
      o_RX_DV           => o_RHD64_RX_DV,            -- Data Valid pulse
      o_RX_Byte_Rising  => o_RHD64_RX_Byte_Rising,   -- Byte received on MISO Rising  CLK Edge 
      o_RX_Byte_Falling => o_RHD64_RX_Byte_Falling,  -- Byte received on MISO Falling CLK Edge       
       -- SPI Interface
      o_SPI_Clk  => o_RHD64_SPI_Clk, 
      i_SPI_MISO => i_RHD64_SPI_MISO,
      o_SPI_MOSI => o_RHD64_SPI_MOSI,
      o_SPI_CS_n => o_RHD64_SPI_CS_n
      );


    FIFO_1 : entity work.FIFO
    port map(
          DATA   => i_FIFO_DATA,
          Q      => o_FIFO_Q,
          WE     => o_FIFO_WE,
          RE     => o_FIFO_RE,
          WCLOCK => o_FIFO_WCLOCK,
          RCLOCK => o_FIFO_RCLOCK,
          FULL   => o_FIFO_FULL,
          EMPTY  => o_FIFO_EMPTY,
          RESET  => o_FIFO_RESET,
          AEMPTY => o_FIFO_AEMPTY,
          AFULL  => o_FIFO_AFULL
        );
    

end FIFO;


   -- architecture body
end architecture_Controller;
