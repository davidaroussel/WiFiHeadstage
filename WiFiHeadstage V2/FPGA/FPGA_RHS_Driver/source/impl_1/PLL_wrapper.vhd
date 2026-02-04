-- pll_25_100_wrapper.vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pll_25_100_wrapper is
    port (
        clock_in  : in std_logic;  -- 12 MHz input clock
        global_clock : out std_logic  -- 100 MHz output clock
    );
end entity pll_25_100_wrapper;

architecture Behavioral of pll_25_100_wrapper is
    -- Internal signal for PLL
    signal pll_internal_clock : std_logic;
begin

    -- Instantiation of the PLL module
    pll_inst : entity work.pll_25_100  -- Use the Verilog PLL module
        port map (
            clock_in     => clock_in,
            global_clock => pll_internal_clock
        );

    -- Output the global clock signal
    global_clock <= pll_internal_clock;
end architecture Behavioral;