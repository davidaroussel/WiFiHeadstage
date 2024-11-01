library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration
entity passthrough is
    Port (
        data_in  : in  std_logic;  -- Input pin
        data_out : out std_logic   -- Output pin
    );
end passthrough;

-- Architecture body
architecture Behavioral of passthrough is
begin
    -- Simply pass the input data to the output
    data_out <= data_in;
end Behavioral;