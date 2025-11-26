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

        -- SPI Slave Interface TO RHD BOARD (FOR PoC STM-WFM200-FPGA)
        --MOSI_slave  : out STD_LOGIC; -- IO 36B --> PIN 25
        --MISO_slave  : in  STD_LOGIC; -- IO 39A --> PIN 26
        --SCLK_slave  : out STD_LOGIC; -- IO 38B --> PIN 27
        --SS_slave    : out STD_LOGIC; -- IO 43A --> PIN 32
		
		-- SPI Slave Interface TO LVDS BOARD - RHD (FOR FPGA PoC Programmer)
		MOSI_slave  : out STD_LOGIC; -- IO 9B --> PIN 3
        MISO_slave  : in  STD_LOGIC; -- IO 4A --> PIN 48
        SCLK_slave  : out STD_LOGIC; -- IO 5B --> PIN 45
        SS_slave    : out STD_LOGIC; -- IO 2A --> PIN 47

        LED_CTL     : in  STD_LOGIC;		--> PIN 23
		
        RGB0_OUT     : out STD_LOGIC;		--> PIN 39
        RGB1_OUT     : out STD_LOGIC;		--> PIN 40
        RGB2_OUT     : out STD_LOGIC;		--> PIN 41

		LED1_OUT     : out STD_LOGIC;  -- IO 44B --> PIN 34
		LED2_OUT     : out STD_LOGIC;  -- IO 42B --> PIN 31
		LED3_OUT     : out STD_LOGIC;  -- IO 48B --> PIN 36
		

        -- External 12 MHz clock input
        ext_clk     : in  STD_LOGIC

    );
end Controller_RHD64_Config;


architecture Behavioral of Controller_RHD64_Config is
    constant CLOCK_FREQ   : integer := 12000000;
    constant TOGGLE_COUNT : integer := CLOCK_FREQ / 1;
    signal counter : integer := 0;
    signal step    : integer range 0 to 6 := 0;
	
	signal led1_sig : std_logic := '1';
    signal led2_sig : std_logic := '1';
    signal led3_sig : std_logic := '1';
    signal led4_sig : std_logic := '1';

    signal rgb1_sig : std_logic := '0';
    signal rgb2_sig : std_logic := '0';
    signal rgb3_sig : std_logic := '0';
	
    -- Signal for PLL lock indication
    signal pll_lock : STD_LOGIC;


begin

    -- Timing process
    process(ext_clk)
    begin
        if rising_edge(ext_clk) then
            if counter < TOGGLE_COUNT - 1 then
                counter <= counter + 1;
            else
                counter <= 0;
                step <= (step + 1) mod 7;
            end if;
        end if;
    end process;
	

	-- LED/RGB control process
    process(step)
    begin
        -- Default states
        led1_sig <= '1';
        led2_sig <= '1';
        led3_sig <= '1';
        rgb1_sig <= '0';
        rgb2_sig <= '0';
        rgb3_sig <= '0';

        case step is
            when 0 => 
				rgb1_sig <= '0';
				rgb2_sig <= '0';
				rgb3_sig <= '0';
            when 1 => 
				rgb1_sig <= '0';
				rgb2_sig <= '1';
				rgb3_sig <= '1';
            when 2 => 

				rgb1_sig <= '1';
				rgb2_sig <= '0';
				rgb3_sig <= '1';
            when 3 => 
				rgb1_sig <= '1';
				rgb2_sig <= '1';
				rgb3_sig <= '0';
            when others => 
				null;
        end case;
    end process;
	

    -- Connect SPI master signals to SPI slave signals
    SCLK_slave  <= SCLK_master;
    MOSI_slave  <= MOSI_master;
    MISO_master <= MISO_slave;
    SS_slave    <= SS_master;

	--LED_OUT <= LED_CTL;

    --RGB1_OUT <= '0';
    --LED1_OUT <= '1';
    --LED2_OUT <= '1';
    --LED3_OUT <= '1';
	
	LED1_OUT <= led1_sig;
    LED2_OUT <= led2_sig;
    LED3_OUT <= led3_sig;

    RGB0_OUT <= rgb1_sig;
    RGB1_OUT <= rgb2_sig;
    RGB2_OUT <= rgb3_sig;

end Behavioral;