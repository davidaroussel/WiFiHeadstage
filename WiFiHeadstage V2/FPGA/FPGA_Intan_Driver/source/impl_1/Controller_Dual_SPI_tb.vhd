--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Controller_Dual_SPI_tb.vhd
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

entity Controller_Dual_SPI_tb is
end entity Controller_Dual_SPI_tb;

architecture TB of Controller_Dual_SPI_tb is

  constant CLK_PERIOD   : time := 5.21 ns; -- Adjust as needed

  constant STM32_SPI_NUM_BITS_PER_PACKET : integer := 32;  -- Adds delay between bytes
  constant RHD64_SPI_NUM_BITS_PER_PACKET : integer := 16;  -- Adds delay between bytes
  
  constant STM32_CLKS_PER_HALF_BIT : integer := 8;  -- Adds delay between bytes
  constant RHD64_CLKS_PER_HALF_BIT : integer := 16;  -- Adds delay between bytes

  signal tb_Clk : std_logic := '0';
  signal tb_Rst : std_logic := '1';

  signal tb_RHD64_SPI_MOSI : std_logic;
  signal tb_RHD64_SPI_MISO : std_logic;
  signal tb_RHD64_SPI_CS_n : std_logic;
  signal tb_RHD64_SPI_CLK : std_logic;

  signal tb_STM32_SPI_MOSI : std_logic;
  signal tb_STM32_SPI_MISO : std_logic;
  signal tb_STM32_SPI_CS_n : std_logic;
  signal tb_STM32_SPI_CLK : std_logic;

  -- Add signals for other inputs and outputs as needed

begin
  tb_Clk <= not tb_Clk after CLK_PERIOD;
  tb_RHD64_SPI_MISO <= tb_RHD64_SPI_MOSI;
  tb_STM32_SPI_MISO <= tb_STM32_SPI_MOSI;  

  -- Instantiate the Controller_Dual_SPI module
    UUT : entity work.Controller_Dual_SPI
    generic map (
      STM32_SPI_NUM_BITS_PER_PACKET => STM32_SPI_NUM_BITS_PER_PACKET,
      RHD64_SPI_NUM_BITS_PER_PACKET => RHD64_SPI_NUM_BITS_PER_PACKET,
      STM32_CLKS_PER_HALF_BIT => STM32_CLKS_PER_HALF_BIT,
      RHD64_CLKS_PER_HALF_BIT => RHD64_CLKS_PER_HALF_BIT)
    port map (
      i_Rst_L => tb_rst,
      i_Clk   => tb_clk,
      o_STM32_SPI_Clk => tb_STM32_SPI_CLK,
      i_STM32_SPI_MISO => tb_STM32_SPI_MISO,
      o_STM32_SPI_MOSI => tb_STM32_SPI_MOSI,
      o_STM32_SPI_CS_n => tb_STM32_SPI_CS_n,
      o_RHD64_SPI_Clk => tb_RHD64_SPI_CLK,
      i_RHD64_SPI_MISO => tb_RHD64_SPI_MISO,
      o_RHD64_SPI_MOSI => tb_RHD64_SPI_MOSI,
      o_RHD64_SPI_CS_n => tb_RHD64_SPI_CS_n
      -- Connect other signals here
    );

  -- Stimulus generation process
  Testing: process
  begin
    -- Initialize signals as needed

    -- Apply reset
    tb_Rst <= '1';
    wait for 10 ns;
    tb_Rst <= '0';
    wait for 10 ns;


    wait;
  end process Testing;

  -- Monitor and assert checks here if necessary

end architecture TB;
