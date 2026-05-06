library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Controller_RHD64_Config is
    Port (
        -- SPI Master Interface FROM STM32 
        o_STM32_SPI4_MOSI : in  STD_LOGIC;
        i_STM32_SPI4_MISO : out STD_LOGIC;
        o_STM32_SPI4_Clk  : in  STD_LOGIC; 
        o_STM32_SPI4_CS_n : in  STD_LOGIC; 
		

		o_RHS_TOP_SPI_MOSI   : out STD_LOGIC; 
        i_RHS_TOP_SPI_MISO_1 : in  STD_LOGIC;
        o_RHS_TOP_SPI_Clk    : out STD_LOGIC; 
        o_RHS_TOP_SPI_CS_n_1 : out STD_LOGIC;

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

        --case step is
            --when 0 => 
				--rgb1_sig <= '0';
				--rgb2_sig <= '0';
				--rgb3_sig <= '0';
            --when 1 => 
				--rgb1_sig <= '0';
				--rgb2_sig <= '1';
				--rgb3_sig <= '1';
            --when 2 => 

				--rgb1_sig <= '1';
				--rgb2_sig <= '0';
				--rgb3_sig <= '1';
            --when 3 => 
				--rgb1_sig <= '1';
				--rgb2_sig <= '1';
				--rgb3_sig <= '0';
            --when others => 
				--null;
        --end case;
    end process;


    -- Connect SPI master signals to SPI slave signals
    o_RHS_TOP_SPI_Clk     <= o_STM32_SPI4_Clk;
    o_RHS_TOP_SPI_MOSI    <= o_STM32_SPI4_MOSI;
    i_STM32_SPI4_MISO     <= i_RHS_TOP_SPI_MISO_1;
    o_RHS_TOP_SPI_CS_n_1  <= o_STM32_SPI4_CS_n;

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