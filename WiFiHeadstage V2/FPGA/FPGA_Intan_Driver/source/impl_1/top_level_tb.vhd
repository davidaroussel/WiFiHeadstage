library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity top_level_tb;

architecture Testbench of top_level_tb is

    -- Constants
    constant CLK_PERIOD : time := 10 ns;  -- 100 MHz Clock

    -- DUT Signals
    signal i_Clk               : std_logic := '0';
   
    -- STM32 SPI Signals
    signal o_STM32_SPI_Clk      : std_logic;
    signal i_STM32_SPI_MISO     : std_logic;
    signal o_STM32_SPI_MOSI     : std_logic;
    signal o_STM32_SPI_CS_n     : std_logic := '1';

    -- RHD64 SPI Signals
    signal o_RHD64_SPI_Clk      : std_logic;
    signal i_RHD64_SPI_MISO     : std_logic;
    signal o_RHD64_SPI_MOSI     : std_logic;
    signal o_RHD64_SPI_CS_n     : std_logic := '1';


begin
	i_Clk <= not i_Clk after CLK_PERIOD;
	i_RHD64_SPI_MISO <= o_RHD64_SPI_MOSI;
	i_STM32_SPI_MISO <= o_STM32_SPI_MOSI;
	  

    -- Instantiate the DUT
    uut: entity work.top_level
        generic map (
            STM32_SPI_NUM_BITS_PER_PACKET => 1024,
            STM32_CLKS_PER_HALF_BIT       => 2,
            STM32_CS_INACTIVE_CLKS        => 4,
            RHD64_SPI_NUM_BITS_PER_PACKET => 16,
            RHD64_CLKS_PER_HALF_BIT       => 4,
            RHD64_CS_INACTIVE_CLKS        => 4
        )
        port map (
            -- Control Signals
            i_Clk             => i_Clk,

            -- STM32 SPI
            o_STM32_SPI_Clk   => o_STM32_SPI_Clk,
            i_STM32_SPI_MISO  => i_STM32_SPI_MISO,
            o_STM32_SPI_MOSI  => o_STM32_SPI_MOSI,
            o_STM32_SPI_CS_n  => o_STM32_SPI_CS_n,
			
            -- RHD64 SPI
            o_RHD64_SPI_Clk   => o_RHD64_SPI_Clk,
            i_RHD64_SPI_MISO  => i_RHD64_SPI_MISO,
            o_RHD64_SPI_MOSI  => o_RHD64_SPI_MOSI,
            o_RHD64_SPI_CS_n  => o_RHD64_SPI_CS_n
        );

    -- Simple stimulus process
    Testing : process
    begin

        -- Wait for 4000 clock cycles
        wait for 40000 * CLK_PERIOD;

        wait for 5000 ns;
        assert false report "Test Complete" severity failure;
    end process Testing;

end architecture Testbench;
