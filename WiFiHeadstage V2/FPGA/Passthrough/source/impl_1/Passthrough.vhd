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

        LED_CTL     : in  STD_LOGIC;
        LED_OUT     : out STD_LOGIC;

        -- External 12 MHz clock input
        ext_clk     : in  STD_LOGIC;
        -- PLL output clock
        pll_clk     : out STD_LOGIC
    );
end Controller_RHD64_Config;


architecture Behavioral of Controller_RHD64_Config is

    -- Signal for PLL lock indication
    signal pll_lock : STD_LOGIC;

    -- PLL instantiation
    component SB_PLL40_PAD
        generic (
            FEEDBACK_PATH : string := "SIMPLE";
            DIVR          : integer := 0;  -- DIVR =  0
            DIVF          : integer := 63; -- DIVF = 63
            DIVQ          : integer := 3;  -- DIVQ =  3
            FILTER_RANGE  : integer := 1   -- FILTER_RANGE = 1
        );
        port (
            PACKAGEPIN    : in  STD_LOGIC; -- External clock input
            PLLOUTGLOBAL  : out STD_LOGIC; -- Global clock output
            LOCK          : out STD_LOGIC; -- PLL lock status
            RESETB        : in  STD_LOGIC; -- Active low reset
            BYPASS        : in  STD_LOGIC  -- PLL bypass
        );
    end component;

begin
	--fVCO = fIN × (DIVF/(DIVR+1))
	--fout = fvco /2^DIVQ
	
    -- PLL instantiation
    pll_inst : SB_PLL40_PAD
        generic map (
            FEEDBACK_PATH => "SIMPLE",
            DIVR          => 0,
            DIVF          => 63,
            DIVQ          => 3,
            FILTER_RANGE  => 1
        )
        port map (
            PACKAGEPIN    => ext_clk,
            PLLOUTGLOBAL  => pll_clk,
            LOCK          => pll_lock,
            RESETB        => '1',
            BYPASS        => '0'
        );

    -- Connect SPI master signals to SPI slave signals
    SCLK_slave  <= SCLK_master;
    MOSI_slave  <= MOSI_master;
    MISO_master <= MISO_slave;
    SS_slave    <= SS_master;

    LED_OUT <= LED_CTL;

end Behavioral;