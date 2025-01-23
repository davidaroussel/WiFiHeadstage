library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Controller_RHD64_Config is
    Port (
        -- SPI Master Interface
        SCLK_master : in  STD_LOGIC;
        MOSI_master : in  STD_LOGIC;
        MISO_master : out STD_LOGIC;
        SS_master   : in  STD_LOGIC;

        -- SPI Slave Interface
        SCLK_slave  : out STD_LOGIC;
        MOSI_slave  : out STD_LOGIC;
        MISO_slave  : in  STD_LOGIC;
        SS_slave    : out STD_LOGIC;
		
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
