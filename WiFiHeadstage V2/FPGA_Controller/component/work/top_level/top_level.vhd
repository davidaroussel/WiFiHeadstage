----------------------------------------------------------------------
-- Created by SmartDesign Mon Feb 05 13:14:11 2024
-- Version: v11.9 11.9.0.4
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library igloo;
use igloo.all;
----------------------------------------------------------------------
-- top_level entity declaration
----------------------------------------------------------------------
entity top_level is
    -- Port list
    port(
        -- Inputs
        CLK100           : in  std_logic;
        i_RHD64_SPI_MISO : in  std_logic;
        i_Rst_L          : in  std_logic;
        i_STM32_SPI_MISO : in  std_logic;
        -- Outputs
        o_RHD64_SPI_CS_n : out std_logic;
        o_RHD64_SPI_Clk  : out std_logic;
        o_RHD64_SPI_MOSI : out std_logic;
        o_STM32_SPI_CS_n : out std_logic;
        o_STM32_SPI_Clk  : out std_logic;
        o_STM32_SPI_MOSI : out std_logic
        );
end top_level;
----------------------------------------------------------------------
-- top_level architecture body
----------------------------------------------------------------------
architecture RTL of top_level is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- Controller_Dual_SPI
component Controller_Dual_SPI
    -- Port list
    port(
        -- Inputs
        i_Clk            : in  std_logic;
        i_RHD64_SPI_MISO : in  std_logic;
        i_Rst_L          : in  std_logic;
        i_STM32_SPI_MISO : in  std_logic;
        -- Outputs
        o_RHD64_SPI_CS_n : out std_logic;
        o_RHD64_SPI_Clk  : out std_logic;
        o_RHD64_SPI_MOSI : out std_logic;
        o_STM32_SPI_CS_n : out std_logic;
        o_STM32_SPI_Clk  : out std_logic;
        o_STM32_SPI_MOSI : out std_logic
        );
end component;
-- PLL_100
component PLL_100
    -- Port list
    port(
        -- Inputs
        CLKA      : in  std_logic;
        POWERDOWN : in  std_logic;
        -- Outputs
        GLA       : out std_logic;
        LOCK      : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal o_RHD64_SPI_Clk_net_0  : std_logic;
signal o_RHD64_SPI_CS_n_net_0 : std_logic;
signal o_RHD64_SPI_MOSI_net_0 : std_logic;
signal o_STM32_SPI_Clk_net_0  : std_logic;
signal o_STM32_SPI_CS_n_net_0 : std_logic;
signal o_STM32_SPI_MOSI_net_0 : std_logic;
signal PLL_100_0_GLA          : std_logic;
signal o_STM32_SPI_Clk_net_1  : std_logic;
signal o_RHD64_SPI_Clk_net_1  : std_logic;
signal o_RHD64_SPI_CS_n_net_1 : std_logic;
signal o_RHD64_SPI_MOSI_net_1 : std_logic;
signal o_STM32_SPI_MOSI_net_1 : std_logic;
signal o_STM32_SPI_CS_n_net_1 : std_logic;
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal VCC_net                : std_logic;

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 VCC_net <= '1';
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 o_STM32_SPI_Clk_net_1  <= o_STM32_SPI_Clk_net_0;
 o_STM32_SPI_Clk        <= o_STM32_SPI_Clk_net_1;
 o_RHD64_SPI_Clk_net_1  <= o_RHD64_SPI_Clk_net_0;
 o_RHD64_SPI_Clk        <= o_RHD64_SPI_Clk_net_1;
 o_RHD64_SPI_CS_n_net_1 <= o_RHD64_SPI_CS_n_net_0;
 o_RHD64_SPI_CS_n       <= o_RHD64_SPI_CS_n_net_1;
 o_RHD64_SPI_MOSI_net_1 <= o_RHD64_SPI_MOSI_net_0;
 o_RHD64_SPI_MOSI       <= o_RHD64_SPI_MOSI_net_1;
 o_STM32_SPI_MOSI_net_1 <= o_STM32_SPI_MOSI_net_0;
 o_STM32_SPI_MOSI       <= o_STM32_SPI_MOSI_net_1;
 o_STM32_SPI_CS_n_net_1 <= o_STM32_SPI_CS_n_net_0;
 o_STM32_SPI_CS_n       <= o_STM32_SPI_CS_n_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- Controller_Dual_SPI_0
Controller_Dual_SPI_0 : Controller_Dual_SPI
    port map( 
        -- Inputs
        i_Rst_L          => i_Rst_L,
        i_Clk            => PLL_100_0_GLA,
        i_STM32_SPI_MISO => i_STM32_SPI_MISO,
        i_RHD64_SPI_MISO => i_RHD64_SPI_MISO,
        -- Outputs
        o_STM32_SPI_Clk  => o_STM32_SPI_Clk_net_0,
        o_STM32_SPI_MOSI => o_STM32_SPI_MOSI_net_0,
        o_STM32_SPI_CS_n => o_STM32_SPI_CS_n_net_0,
        o_RHD64_SPI_Clk  => o_RHD64_SPI_Clk_net_0,
        o_RHD64_SPI_MOSI => o_RHD64_SPI_MOSI_net_0,
        o_RHD64_SPI_CS_n => o_RHD64_SPI_CS_n_net_0 
        );
-- PLL_100_0
PLL_100_0 : PLL_100
    port map( 
        -- Inputs
        POWERDOWN => VCC_net,
        CLKA      => CLK100,
        -- Outputs
        LOCK      => OPEN,
        GLA       => PLL_100_0_GLA 
        );

end RTL;
