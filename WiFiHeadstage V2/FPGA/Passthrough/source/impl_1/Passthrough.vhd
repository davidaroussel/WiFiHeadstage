library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Controller_RHD64_Config is
    Port (
        -- SPI Master Interface FROM STM32
        MOSI_master : in  STD_LOGIC; -- IO 20A --> PIN 11
        MISO_master : out STD_LOGIC; -- IO 18A --> PIN 10
        SCLK_master : in  STD_LOGIC; -- IO 16A --> PIN 9
        SS_master   : in  STD_LOGIC; -- IO 13B --> PIN 6

        -- SPI Slave Interface TO RHD BOARD
        MOSI_slave  : out STD_LOGIC; -- IO 36B --> PIN 25
        MISO_slave  : in  STD_LOGIC; -- IO 39A --> PIN 26
        SCLK_slave  : out STD_LOGIC; -- IO 38B --> PIN 27
        SS_slave    : out STD_LOGIC; -- IO 43A --> PIN 32
		
		LED_CTL : in STD_LOGIC;
		LED_OUT : out STD_LOGIC
    );
end Controller_RHD64_Config;

architecture Behavioral of Controller_RHD64_Config is
begin

    -- Connect SPI master signals to SPI slave signals
    SCLK_slave  <= SCLK_master;
    MOSI_slave  <= MOSI_master;
    MISO_master <= MISO_slave;
    SS_slave    <= SS_master;
	
	LED_OUT <= LED_CTL;

end Behavioral;
