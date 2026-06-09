library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_RHD_Sampling_tb is
end entity;

architecture Testbench of Controller_RHD_Sampling_tb is

    --------------------------------------------------------------------
    -- CONSTANTS
    --------------------------------------------------------------------
    constant CLK_PERIOD : time := 10 ns;

    constant STM32_SPI_NUM_BITS_PER_PACKET : integer := 512;
	constant STM32_CLKS_PER_HALF_BIT : integer := 4;
	constant STM32_CS_INACTIVE_CLKS : integer := 16;

	constant RHS_READ_SPI_NUM_BITS_PER_PACKET : integer := 32;
	constant RHS_READ_CLKS_PER_HALF_BIT : integer := 4;   
    constant RHS_READ_CS_INACTIVE_CLKS : integer := 32;
   
	constant RHS_STIM_SPI_NUM_BITS_PER_PACKET : integer := 32;
    constant RHS_STIM_CLKS_PER_HALF_BIT : integer := 4;
    constant RHS_STIM_CS_INACTIVE_CLKS : integer := 32;

    --------------------------------------------------------------------
    -- DUT SIGNALS
    --------------------------------------------------------------------
    signal tb_Rst_L : std_logic := '1';
    signal tb_Clk   : std_logic := '0';

    signal tb_Controller_Mode : std_logic_vector(3 downto 0) := x"0";

    signal tb_NUM_DATA        : integer;
    signal tb_STM32_State     : integer;
    signal tb_stm32_counter   : integer;

    signal tb_rgb_info_red   : std_logic;
    signal tb_rgb_info_green : std_logic;
    signal tb_rgb_info_blue  : std_logic;

    --------------------------------------------------------------------
    -- STM32 SPI
    --------------------------------------------------------------------
    signal tb_STM32_SPI_Clk  : std_logic;
    signal tb_STM32_SPI_MISO : std_logic := '0';
    signal tb_STM32_SPI_MOSI : std_logic;
    signal tb_STM32_SPI_CS_n : std_logic;

    signal tb_STM32_TX_Byte : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    signal tb_STM32_TX_DV   : std_logic;
    signal tb_STM32_TX_Ready : std_logic;

    signal tb_STM32_RX_DV : std_logic;
    signal tb_STM32_RX_Byte_Rising : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);

    --------------------------------------------------------------------
    -- RHS READ FIFO
    --------------------------------------------------------------------
    signal tb_FIFO_RHS_READ_Data   : std_logic_vector(31 downto 0);
    signal tb_FIFO_RHS_READ_COUNT  : std_logic_vector(8 downto 0);
    signal tb_FIFO_RHS_READ_WE     : std_logic;
    signal tb_FIFO_RHS_READ_RE     : std_logic;
    signal tb_FIFO_RHS_READ_Q      : std_logic_vector(31 downto 0);
    signal tb_FIFO_RHS_READ_EMPTY  : std_logic;
    signal tb_FIFO_RHS_READ_FULL   : std_logic;
    signal tb_FIFO_RHS_READ_AEMPTY : std_logic;
    signal tb_FIFO_RHS_READ_AFULL  : std_logic;

    --------------------------------------------------------------------
    -- RHS READ SPI
    --------------------------------------------------------------------
    signal tb_RHS_READ_SPI_Clk    : std_logic;
    signal tb_RHS_READ_SPI_MISO_1 : std_logic := '0';
    signal tb_RHS_READ_SPI_MISO_2 : std_logic := '0';
    signal tb_RHS_READ_SPI_MOSI   : std_logic;
    signal tb_RHS_READ_SPI_CS_n_1 : std_logic;
    signal tb_RHS_READ_SPI_CS_n_2 : std_logic;

    signal tb_RHS_READ_TX_Byte :
        std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);

    signal tb_RHS_READ_TX_DV    : std_logic;
    signal tb_RHS_READ_TX_Ready : std_logic;

    signal tb_RHS_READ_RX_DV : std_logic;

    signal tb_RHS_READ_RX_Byte_Rising :std_logic_vector(31 downto 0);

    signal tb_RHS_READ_RX_Byte_Falling : std_logic_vector(31 downto 0);

    --------------------------------------------------------------------
    -- RHS STIM FIFO
    --------------------------------------------------------------------
    signal tb_FIFO_RHS_STIM_Data   : std_logic_vector(31 downto 0);
    signal tb_FIFO_RHS_STIM_COUNT  : std_logic_vector(8 downto 0);
    signal tb_FIFO_RHS_STIM_WE     : std_logic;
    signal tb_FIFO_RHS_STIM_RE     : std_logic;
    signal tb_FIFO_RHS_STIM_Q      : std_logic_vector(31 downto 0);
    signal tb_FIFO_RHS_STIM_EMPTY  : std_logic;
    signal tb_FIFO_RHS_STIM_FULL   : std_logic;
    signal tb_FIFO_RHS_STIM_AEMPTY : std_logic;
    signal tb_FIFO_RHS_STIM_AFULL  : std_logic;

    --------------------------------------------------------------------
    -- RHS STIM SPI
    --------------------------------------------------------------------
    signal tb_RHS_STIM_SPI_Clk    : std_logic;
    signal tb_RHS_STIM_SPI_MISO_1 : std_logic := '0';
    signal tb_RHS_STIM_SPI_MISO_2 : std_logic := '0';
    signal tb_RHS_STIM_SPI_MOSI   : std_logic;
    signal tb_RHS_STIM_SPI_CS_n_1 : std_logic;
    signal tb_RHS_STIM_SPI_CS_n_2 : std_logic;

    signal tb_RHS_STIM_TX_Byte : std_logic_vector(31 downto 0);

    signal tb_RHS_STIM_TX_DV    : std_logic;
    signal tb_RHS_STIM_TX_Ready : std_logic;

    signal tb_RHS_STIM_RX_DV : std_logic;

    signal tb_RHS_STIM_RX_Byte_Rising : std_logic_vector(31 downto 0);

    signal tb_RHS_STIM_RX_Byte_Falling : std_logic_vector(31 downto 0);
	
	signal stim_burst_counter_debug_tb      : std_logic_vector(7 downto 0);
	signal stim_train_counter_debug_tb      : std_logic_vector(7 downto 0);
	signal stim_1sec_counter_debug_tb       : std_logic_vector(31 downto 0);
	signal stim_10sec_counter_debug_tb      : std_logic_vector(31 downto 0);
	signal stim_pulse_counter_debug_tb      : std_logic_vector(7 downto 0);
	signal stim_sequence_phase_debug_tb     : std_logic_vector(7 downto 0);
	signal stim_delay_counter_debug_tb      : std_logic_vector(31 downto 0);
	signal stim_long_pause_count_debug_tb   : std_logic_vector(7 downto 0);
	signal rhs_STIM_state_debug_tb          : std_logic_vector(7 downto 0);
	signal rhs_STIM_index_debug_tb          : std_logic_vector(7 downto 0);
	signal stim_train_done_counter_debug_tb : std_logic_vector(31 downto 0);

begin

    --------------------------------------------------------------------
    -- CLOCK
    --------------------------------------------------------------------
    tb_Clk <= not tb_Clk after CLK_PERIOD/2;

    --------------------------------------------------------------------
    -- SIMPLE LOOPBACKS
    --------------------------------------------------------------------
    tb_STM32_SPI_MISO <= tb_STM32_SPI_MOSI;

    tb_RHS_READ_SPI_MISO_1 <= tb_RHS_READ_SPI_MOSI;
    tb_RHS_READ_SPI_MISO_2 <= tb_RHS_READ_SPI_MOSI;

    tb_RHS_STIM_SPI_MISO_1 <= tb_RHS_STIM_SPI_MOSI;
    tb_RHS_STIM_SPI_MISO_2 <= tb_RHS_STIM_SPI_MOSI;

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    DUT : entity work.Controller_RHD_Sampling
    generic map (
        STM32_CLKS_PER_HALF_BIT => STM32_CLKS_PER_HALF_BIT,
        STM32_SPI_NUM_BITS_PER_PACKET => STM32_SPI_NUM_BITS_PER_PACKET,
        STM32_CS_INACTIVE_CLKS => STM32_CS_INACTIVE_CLKS,

        RHS_READ_SPI_NUM_BITS_PER_PACKET => RHS_READ_SPI_NUM_BITS_PER_PACKET,
        RHS_READ_CLKS_PER_HALF_BIT => RHS_READ_CLKS_PER_HALF_BIT,
        RHS_READ_CS_INACTIVE_CLKS => RHS_READ_CS_INACTIVE_CLKS,

        RHS_STIM_SPI_NUM_BITS_PER_PACKET => RHS_STIM_SPI_NUM_BITS_PER_PACKET,
        RHS_STIM_CLKS_PER_HALF_BIT => RHS_STIM_CLKS_PER_HALF_BIT,
        RHS_STIM_CS_INACTIVE_CLKS => RHS_STIM_CS_INACTIVE_CLKS,

        RHS_SAMPLING_MODE => 0
    )
    port map (

        o_NUM_DATA => tb_NUM_DATA,
        o_STM32_State => tb_STM32_State,
        o_stm32_counter => tb_stm32_counter,

        i_Rst_L => tb_Rst_L,
        i_Clk   => tb_Clk,

        rgb_info_red   => tb_rgb_info_red,
        rgb_info_green => tb_rgb_info_green,
        rgb_info_blue  => tb_rgb_info_blue,

        i_Controller_Mode => tb_Controller_Mode,

        ----------------------------------------------------------------
        -- STM32
        ----------------------------------------------------------------
        o_STM32_SPI_Clk => tb_STM32_SPI_Clk,
        i_STM32_SPI_MISO => tb_STM32_SPI_MISO,
        o_STM32_SPI_MOSI => tb_STM32_SPI_MOSI,
        o_STM32_SPI_CS_n => tb_STM32_SPI_CS_n,

        o_STM32_TX_Byte => tb_STM32_TX_Byte,
        o_STM32_TX_DV => tb_STM32_TX_DV,
        o_STM32_TX_Ready => tb_STM32_TX_Ready,

        o_STM32_RX_DV => tb_STM32_RX_DV,
        o_STM32_RX_Byte_Rising => tb_STM32_RX_Byte_Rising,

        ----------------------------------------------------------------
        -- RHS READ FIFO
        ----------------------------------------------------------------
        o_FIFO_RHS_READ_Data => tb_FIFO_RHS_READ_Data,
        o_FIFO_RHS_READ_COUNT => tb_FIFO_RHS_READ_COUNT,
        o_FIFO_RHS_READ_WE => tb_FIFO_RHS_READ_WE,
        o_FIFO_RHS_READ_RE => tb_FIFO_RHS_READ_RE,
        o_FIFO_RHS_READ_Q => tb_FIFO_RHS_READ_Q,
        o_FIFO_RHS_READ_EMPTY => tb_FIFO_RHS_READ_EMPTY,
        o_FIFO_RHS_READ_FULL => tb_FIFO_RHS_READ_FULL,
        o_FIFO_RHS_READ_AEMPTY => tb_FIFO_RHS_READ_AEMPTY,
        o_FIFO_RHS_READ_AFULL => tb_FIFO_RHS_READ_AFULL,

        ----------------------------------------------------------------
        -- RHS READ SPI
        ----------------------------------------------------------------
        o_RHS_READ_SPI_Clk => tb_RHS_READ_SPI_Clk,
        i_RHS_READ_SPI_MISO_1 => tb_RHS_READ_SPI_MISO_1,
        i_RHS_READ_SPI_MISO_2 => tb_RHS_READ_SPI_MISO_2,
        o_RHS_READ_SPI_MOSI => tb_RHS_READ_SPI_MOSI,
        o_RHS_READ_SPI_CS_n_1 => tb_RHS_READ_SPI_CS_n_1,
        o_RHS_READ_SPI_CS_n_2 => tb_RHS_READ_SPI_CS_n_2,

        o_RHS_READ_TX_Byte => tb_RHS_READ_TX_Byte,
        o_RHS_READ_TX_DV => tb_RHS_READ_TX_DV,
        o_RHS_READ_TX_Ready => tb_RHS_READ_TX_Ready,

        o_RHS_READ_RX_DV => tb_RHS_READ_RX_DV,
        o_RHS_READ_RX_Byte_Rising => tb_RHS_READ_RX_Byte_Rising,
        o_RHS_READ_RX_Byte_Falling => tb_RHS_READ_RX_Byte_Falling,

        ----------------------------------------------------------------
        -- RHS STIM FIFO
        ----------------------------------------------------------------
        o_FIFO_RHS_STIM_Data => tb_FIFO_RHS_STIM_Data,
        o_FIFO_RHS_STIM_COUNT => tb_FIFO_RHS_STIM_COUNT,
        o_FIFO_RHS_STIM_WE => tb_FIFO_RHS_STIM_WE,
        o_FIFO_RHS_STIM_RE => tb_FIFO_RHS_STIM_RE,
        o_FIFO_RHS_STIM_Q => tb_FIFO_RHS_STIM_Q,
        o_FIFO_RHS_STIM_EMPTY => tb_FIFO_RHS_STIM_EMPTY,
        o_FIFO_RHS_STIM_FULL => tb_FIFO_RHS_STIM_FULL,
        o_FIFO_RHS_STIM_AEMPTY => tb_FIFO_RHS_STIM_AEMPTY,
        o_FIFO_RHS_STIM_AFULL => tb_FIFO_RHS_STIM_AFULL,

        ----------------------------------------------------------------
        -- RHS STIM SPI
        ----------------------------------------------------------------
        o_RHS_STIM_SPI_Clk => tb_RHS_STIM_SPI_Clk,
        i_RHS_STIM_SPI_MISO_1 => tb_RHS_STIM_SPI_MISO_1,
        i_RHS_STIM_SPI_MISO_2 => tb_RHS_STIM_SPI_MISO_2,
        o_RHS_STIM_SPI_MOSI => tb_RHS_STIM_SPI_MOSI,
        o_RHS_STIM_SPI_CS_n_1 => tb_RHS_STIM_SPI_CS_n_1,
        o_RHS_STIM_SPI_CS_n_2 => tb_RHS_STIM_SPI_CS_n_2,

        o_RHS_STIM_TX_Byte => tb_RHS_STIM_TX_Byte,
        o_RHS_STIM_TX_DV => tb_RHS_STIM_TX_DV,
        o_RHS_STIM_TX_Ready => tb_RHS_STIM_TX_Ready,

        o_RHS_STIM_RX_DV => tb_RHS_STIM_RX_DV,
        o_RHS_STIM_RX_Byte_Rising => tb_RHS_STIM_RX_Byte_Rising,
        o_RHS_STIM_RX_Byte_Falling => tb_RHS_STIM_RX_Byte_Falling,
		
		
		o_stim_1sec_counter_debug       => stim_1sec_counter_debug_tb,
		o_stim_10sec_counter_debug      => stim_10sec_counter_debug_tb,
		o_stim_burst_counter_debug      => stim_burst_counter_debug_tb,
		o_stim_train_counter_debug      => stim_train_counter_debug_tb,
		o_stim_pulse_counter_debug      => stim_pulse_counter_debug_tb,
		o_stim_sequence_phase_debug     => stim_sequence_phase_debug_tb,
		o_stim_delay_counter_debug      => stim_delay_counter_debug_tb,
		o_rhs_STIM_state_debug          => rhs_STIM_state_debug_tb,
		o_rhs_STIM_index_debug          => rhs_STIM_index_debug_tb
    );

    --------------------------------------------------------------------
    -- STIMULUS
    --------------------------------------------------------------------
    stim_proc : process
    begin

        ---------------------------------------------------------------
        -- RESET
        ---------------------------------------------------------------
        tb_Controller_Mode <= x"0";
        tb_Rst_L <= '1';

        wait for 100 ns;

        tb_Rst_L <= '0';

        wait for 200 ns;

        ---------------------------------------------------------------
        -- MODE 1
        ---------------------------------------------------------------
        report "Entering MODE 1";

        tb_Controller_Mode <= x"1";

        wait for 1000 ns;

        ---------------------------------------------------------------
        -- MODE 2
        ---------------------------------------------------------------
        report "Entering MODE 2";

        tb_Controller_Mode <= x"2";

        ---------------------------------------------------------------
        -- RUN LONG ENOUGH TO SEE:
        -- - RHS READ traffic
        -- - STM32 packets
        -- - STIM pulses
        ---------------------------------------------------------------
        wait for 20000 ms;

        ---------------------------------------------------------------
        -- END
        ---------------------------------------------------------------
        report "Simulation Finished";

        assert false
        report "TEST COMPLETE"
        severity failure;

    end process;


end architecture;