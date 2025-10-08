library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity top_level_tb;

architecture sim of top_level_tb is

    -- Clock period
    constant CLK_PERIOD : time := 83.333 ns; -- ~12 MHz

    -- DUT signals
    signal i_clk_tb           : std_logic := '0';
    signal pll_clk_tb         : std_logic;

    signal o_STM32_SPI_MOSI_tb : std_logic;
    signal i_STM32_SPI_MISO_tb : std_logic := '0';
    signal o_STM32_SPI_Clk_tb  : std_logic;
    signal o_STM32_SPI_CS_n_tb : std_logic;

    signal o_RHD_SPI_MOSI_tb   : std_logic;
    signal i_RHD_SPI_MISO_tb   : std_logic := '0';
    signal o_RHD_SPI_Clk_tb    : std_logic;
    signal o_RHD_SPI_CS_n_tb   : std_logic;

    signal RGB0_OUT_tb         : std_logic;
    signal RGB1_OUT_tb         : std_logic;
    signal RGB2_OUT_tb         : std_logic;

    signal LED1_OUT_tb         : std_logic;
    signal LED2_OUT_tb         : std_logic;
    signal LED3_OUT_tb         : std_logic;
    signal LED4_OUT_tb         : std_logic;

    signal o_Controller_Mode_tb : std_logic_vector(3 downto 0);
    signal o_reset_tb           : std_logic;
    signal o_reset_Counter_tb   : std_logic_vector(7 downto 0);

begin
	i_clk_tb <= not i_clk_tb after CLK_PERIOD;
	i_RHD_SPI_MISO_tb <= o_RHD_SPI_MOSI_tb;
	
	
    -- DUT instantiation
    DUT : entity work.top_level
        generic map (
            STM32_SPI_NUM_BITS_PER_PACKET => 512,
            STM32_CLKS_PER_HALF_BIT       => 16,
            STM32_CS_INACTIVE_CLKS        => 16,
            RHD_SPI_DDR_MODE              => 1,
            RHD_SPI_NUM_BITS_PER_PACKET   => 16,
            RHD_CLKS_PER_HALF_BIT         => 32,
            RHD_CS_INACTIVE_CLKS          => 32
        )
        port map (
            i_clk     => i_clk_tb,
            pll_clk   => pll_clk_tb,

            o_STM32_SPI_MOSI => o_STM32_SPI_MOSI_tb,
            i_STM32_SPI_MISO => i_STM32_SPI_MISO_tb,
            o_STM32_SPI_Clk  => o_STM32_SPI_Clk_tb,
            o_STM32_SPI_CS_n => o_STM32_SPI_CS_n_tb,

            o_RHD_SPI_MOSI   => o_RHD_SPI_MOSI_tb,
            i_RHD_SPI_MISO   => i_RHD_SPI_MISO_tb,
            o_RHD_SPI_Clk    => o_RHD_SPI_Clk_tb,
            o_RHD_SPI_CS_n   => o_RHD_SPI_CS_n_tb,

            RGB0_OUT => RGB0_OUT_tb,
            RGB1_OUT => RGB1_OUT_tb,
            RGB2_OUT => RGB2_OUT_tb,

            LED1_OUT => LED1_OUT_tb,
            LED2_OUT => LED2_OUT_tb,
            LED3_OUT => LED3_OUT_tb,
            LED4_OUT => LED4_OUT_tb,

            o_Controller_Mode => o_Controller_Mode_tb,
            o_reset           => o_reset_tb,
            o_reset_Counter   => o_reset_Counter_tb
        );


    Testing : process
    begin

        -- Wait for 4000 clock cycles
        wait for 400000 * CLK_PERIOD;

        wait for 5000 ns;
        assert false report "Test Complete" severity failure;
    end process Testing;

end architecture sim;

