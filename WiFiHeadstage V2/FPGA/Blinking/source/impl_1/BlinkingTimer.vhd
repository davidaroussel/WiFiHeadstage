library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Blinker is
    Port (
        CLK    : in  std_logic;
        RGB_1  : out std_logic;
        RGB_2  : out std_logic;
        RGB_3  : out std_logic;
        LED_1  : out std_logic;
        LED_2  : out std_logic;
        LED_3  : out std_logic;
        LED_4  : out std_logic
    );
end Blinker;

architecture Behavioral of Blinker is
    constant CLOCK_FREQ   : integer := 12000000;
    constant TOGGLE_COUNT : integer := CLOCK_FREQ / 1;

    signal counter : integer := 0;
    signal step    : integer range 0 to 6 := 0;

    signal led1_sig : std_logic := '1';
    signal led2_sig : std_logic := '1';
    signal led3_sig : std_logic := '1';
    signal led4_sig : std_logic := '1';

    signal rgb1_sig : std_logic := '1';
    signal rgb2_sig : std_logic := '1';
    signal rgb3_sig : std_logic := '1';

begin
    -- Timing process
    process(CLK)
    begin
        if rising_edge(CLK) then
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
        led4_sig <= '1';
        rgb1_sig <= '1';
        rgb2_sig <= '1';
        rgb3_sig <= '1';

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

    -- Output assignments
    LED_1 <= led1_sig;
    LED_2 <= led2_sig;
    LED_3 <= led3_sig;
    LED_4 <= led4_sig;

    RGB_1 <= rgb1_sig;
    RGB_2 <= rgb2_sig;
    RGB_3 <= rgb3_sig;

end Behavioral;
