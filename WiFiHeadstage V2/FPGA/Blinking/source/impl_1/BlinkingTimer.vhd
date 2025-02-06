library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Blinker is
    Port (
        CLK  : in  std_logic;    
        LED  : out std_logic     
    );
end Blinker;

architecture Behavioral of Blinker is
    constant CLOCK_FREQ : integer := 12000000; -- 50 MHz clock
    constant TOGGLE_COUNT : integer := CLOCK_FREQ / 1; 

    signal counter : integer := 0; 
    signal led_state : std_logic := '1';
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if counter < TOGGLE_COUNT - 1 then
                counter <= counter + 1;
            else
                counter <= 0;
                led_state <= not led_state;
            end if;
        end if;
    end process;

    LED <= led_state; 
end Behavioral;