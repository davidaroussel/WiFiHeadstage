library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controller_RHD64_Modes_TB is
end Controller_RHD64_Modes_TB;

architecture Behavioral of Controller_RHD64_Modes_TB is
    -- Constants for simulation parameters
    constant CLK_PERIOD : time := 10 ns;
    
    -- Signals for connecting to the DUT
    signal i_Rst_L              : std_logic := '0';
    signal i_Clk                : std_logic := '0';
    signal i_Controller_Mode    : std_logic_vector(3 downto 0) := "0000";
    signal inout_STM32_SPI_Clk  : std_logic := '0';
    signal inout_STM32_SPI_MISO : std_logic;
    signal inout_STM32_SPI_MOSI : std_logic := '0';
    signal inout_STM32_SPI_CS_n : std_logic := '1';
    signal out_RHD64_SPI_Clk    : std_logic;
    signal in_RHD64_SPI_MISO    : std_logic;
    signal out_RHD64_SPI_MOSI   : std_logic;
    signal out_RHD64_SPI_CS_n   : std_logic;
    
begin
	i_Clk <= not i_Clk after CLK_PERIOD;
    
	-- Instantiate the DUT (Device Under Test)
    DUT : entity work.Controller_RHD64_Modes
        generic map (
            STM32_SPI_NUM_BITS_PER_PACKET => 1024,
            STM32_CLKS_PER_HALF_BIT       => 2,
            STM32_CS_INACTIVE_CLKS        => 4,
            RHD64_SPI_NUM_BITS_PER_PACKET => 16,
            RHD64_CLKS_PER_HALF_BIT       => 4,
            RHD64_CS_INACTIVE_CLKS        => 4
        )
        port map (
            i_Rst_L              => i_Rst_L,
            i_Clk                => i_Clk,
            i_Controller_Mode    => i_Controller_Mode,
            inout_STM32_SPI_Clk  => inout_STM32_SPI_Clk,
            inout_STM32_SPI_MISO => inout_STM32_SPI_MISO,
            inout_STM32_SPI_MOSI => inout_STM32_SPI_MOSI,
            inout_STM32_SPI_CS_n => inout_STM32_SPI_CS_n,
            out_RHD64_SPI_Clk    => out_RHD64_SPI_Clk,
            in_RHD64_SPI_MISO    => in_RHD64_SPI_MISO,
            out_RHD64_SPI_MOSI   => out_RHD64_SPI_MOSI,
            out_RHD64_SPI_CS_n   => out_RHD64_SPI_CS_n
        );



    -- Stimulus process
    process
    begin
        i_Rst_L <= '1';
        wait for 20 ns;
        i_Rst_L <= '0';

        -- Mode 0: idle
        i_Controller_Mode <= "0000";
        wait for 4 * CLK_PERIOD;

        -- Mode 1: connect STM32 to RHD64
        i_Controller_Mode <= "0001";
        wait for 40 * CLK_PERIOD;

        -- Mode 2: use sampling module
        i_Controller_Mode <= "0010";
        wait for 4000 * CLK_PERIOD;

        -- Add more test cases for other modes if needed
        
        wait;
    end process;

end Behavioral;
