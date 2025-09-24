library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity top_level_tb;

architecture Testbench of top_level_tb is

    -- Constants
    constant CLK_PERIOD : time := 10 ns;  -- 100 MHz Clock

    -- DUT Signals
    signal i_clk               : std_logic := '0';
	
    signal pll_clk               : std_logic := '0';

	signal o_reset : std_logic;

    -- STM32 SPI Signals
    signal o_STM32_SPI_Clk      : std_logic;
    signal i_STM32_SPI_MISO     : std_logic;
    signal o_STM32_SPI_MOSI     : std_logic;
    signal o_STM32_SPI_CS_n     : std_logic;

    -- RHD SPI Signals
    signal o_RHD_SPI_Clk      : std_logic;
    signal i_RHD_SPI_MISO     : std_logic;
    signal o_RHD_SPI_MOSI     : std_logic;
    signal o_RHD_SPI_CS_n     : std_logic;
	
	signal o_reset_counter : std_logic_vector(7 downto 0);
	signal o_controller_mode : std_logic_vector(3 downto 0);

		
begin
	i_clk <= not i_clk after CLK_PERIOD;
	i_RHD_SPI_MISO <= o_RHD_SPI_MOSI;
	  

    -- Instantiate the DUT
    uut: entity work.top_level
        generic map (
            STM32_SPI_NUM_BITS_PER_PACKET => 512,
            STM32_CLKS_PER_HALF_BIT       => 16,
            STM32_CS_INACTIVE_CLKS        => 64,
            RHD_SPI_NUM_BITS_PER_PACKET => 16,
            RHD_CLKS_PER_HALF_BIT       => 32,
            RHD_CS_INACTIVE_CLKS        => 64
        )
        port map (
            -- Control Signals
            i_clk             => i_clk,
			--pll_clk             => pll_clk,
			--o_reset => o_reset,
            -- STM32 SPI
            o_STM32_SPI_Clk   => o_STM32_SPI_Clk,
            i_STM32_SPI_MISO  => i_STM32_SPI_MISO,
            o_STM32_SPI_MOSI  => o_STM32_SPI_MOSI,
            o_STM32_SPI_CS_n  => o_STM32_SPI_CS_n,
			
			--o_Controller_Mode => o_controller_mode,
			--o_reset_Counter => o_reset_counter,
			
            -- RHD SPI
            o_RHD_SPI_Clk   => o_RHD_SPI_Clk,
            i_RHD_SPI_MISO  => i_RHD_SPI_MISO,
            o_RHD_SPI_MOSI  => o_RHD_SPI_MOSI,
            o_RHD_SPI_CS_n  => o_RHD_SPI_CS_n
			
        );

    -- Simple stimulus process
    Testing : process
    begin

        -- Wait for 4000 clock cycles
        wait for 400000 * CLK_PERIOD;

        wait for 5000 ns;
        assert false report "Test Complete" severity failure;
    end process Testing;

end architecture Testbench;
