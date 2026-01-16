library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    generic (
        STM32_SPI_NUM_BITS_PER_PACKET : integer := 512;
        STM32_CLKS_PER_HALF_BIT       : integer := 2;
        STM32_CS_INACTIVE_CLKS        : integer := 4;
			
		RHD_SPI_DDR_MODE            : integer := 0;
		
        RHD_SPI_NUM_BITS_PER_PACKET : integer := 16;
        RHD_CLKS_PER_HALF_BIT       : integer := 2;
        RHD_CS_INACTIVE_CLKS        : integer := 4
		
		---- MAIN_CLK : 38MHz
		--   HALF_BIT : 2 
		--   CS_CLK : 4
		---  118.75 packets / 7.782Mbps
		
		---- MAIN_CLK : 38MHz
		--   HALF_BIT : 2 
		--   CS_CLK : 8 
		---  112.9 packets / 7.398Mbps
		
		---- MAIN_CLK : 38MHz
		--   HALF_BIT : 4 
		--   CS_CLK : 8 
		---  60 packets / 3.932Mbps
		
		
    );
    port (
        -- Clock and Reset

        -- External 12 MHz clock input
        i_clk     : in  STD_LOGIC;

        -- STM32 SPI Interface
        o_STM32_SPI_MOSI : inout STD_LOGIC; 
        i_STM32_SPI_MISO : inout STD_LOGIC; 
        o_STM32_SPI_Clk  : inout STD_LOGIC; 
        o_STM32_SPI_CS_n : inout STD_LOGIC; 

        -- RHD SPI Interface 
        o_RHD_SPI_MOSI : out STD_LOGIC; 
		i_RHD_SPI_MISO : in  STD_LOGIC; 
        o_RHD_SPI_Clk  : out STD_LOGIC; 
        o_RHD_SPI_CS_n : out STD_LOGIC; 
		
		CTRL0_IN     : in STD_LOGIC;
		
		-- IR SYNCHRONIZATION INPUT 
		--i_LED_SYNC   : in STD_LOGIC;
		
		-- RHS BOOST Interface 
		o_BOOST_ENABLE    : out STD_LOGIC;
		
        RGB0_OUT     : out STD_LOGIC;		--> PIN 39
        RGB1_OUT     : out STD_LOGIC;		--> PIN 40
        RGB2_OUT     : out STD_LOGIC;		--> PIN 41

		LED1_OUT     : out STD_LOGIC;  -- IO 44B --> PIN 34
		LED2_OUT     : out STD_LOGIC;  -- IO 42B --> PIN 31
		LED3_OUT     : out STD_LOGIC;  -- IO 48B --> PIN 36
		LED4_OUT     : out STD_LOGIC;  -- IO 22A --> PIN 12
		
		o_Controller_Mode : out STD_LOGIC_VECTOR(3 downto 0);
		o_reset : out STD_LOGIC

    );
end entity top_level;

architecture RTL of top_level is

	signal debug_MISO : std_logic;
	
    -- Internal signals
    signal w_Controller_Mode    : std_logic_vector(3 downto 0) := (others => '0');
	signal w_reset              : std_logic;
	
	signal reset_counter : integer range 0 to 168000000 := 0;
	
	signal debug_STM32_SPI_MISO : std_logic;
	signal debug_RHD_SPI_MISO   : std_logic;

    signal w_STM32_TX_Byte       : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    signal w_STM32_TX_DV         : std_logic;
    signal w_STM32_TX_Ready      : std_logic;
    signal w_STM32_RX_Byte_Rising: std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    signal w_STM32_RX_DV         : std_logic;

    signal w_FIFO_Data           : std_logic_vector(31 downto 0);
    signal w_FIFO_COUNT          : std_logic_vector(7 downto 0);
    signal w_FIFO_WE             : std_logic;
	
    signal pll_clk_internal : std_logic;
    signal pll_locked       : std_logic;
	
	constant CLOCK_FREQ   : integer := 12000000;
    constant TOGGLE_COUNT : integer := CLOCK_FREQ / 1;
	signal counter : integer := 0;
    signal step    : integer range 0 to 4 := 0;
	
	signal led1_sig : std_logic := '1';
    signal led2_sig : std_logic := '1';
    signal led3_sig : std_logic := '1';
    signal led4_sig : std_logic := '1';

    signal rgb_sig_red   : std_logic := '1';
    signal rgb_sig_green : std_logic := '1';
    signal rgb_sig_blue  : std_logic := '1';
	
    signal stop_counting : std_logic := '0';
	
	signal pll_clk_int : std_logic;
	signal int_RHD_SPI_MOSI : std_logic;
	signal int_RHD_SPI_MISO : std_logic;
	signal int_RHD_SPI_CS_n : std_logic;
	signal int_RHD_SPI_Clk  : std_logic;

    signal int_STM32_SPI_MOSI : std_logic;
	signal int_STM32_SPI_MISO : std_logic;
	signal int_STM32_SPI_Clk  : std_logic;
	signal int_STM32_SPI_CS_n : std_logic;
	
	signal int_BOOST_ENABLE    : std_logic;
	signal int_LED_SYNC 	   : std_logic;
	
	signal ctrl_sync0, ctrl_sync1 : std_logic := '0';
	signal ctrl_counter : integer := 0;
	signal ctrl_stable  : std_logic := '0';
	constant DEBOUNCE_CYCLES : integer := 1000;
	
	signal int_MODE_STATUS : integer := 0;
	
	
begin
	pll_inst: entity CLK_48MHz port map(
		ref_clk_i=>i_clk,
		rst_n_i=>'1',
		outcore_o=>OPEN,
		outglobal_o=>pll_clk_int
	);
    -- Instance of Controller_RHD_Sampling
    Controller_inst : entity work.Controller_RHD_Sampling
        generic map (
            STM32_SPI_NUM_BITS_PER_PACKET => STM32_SPI_NUM_BITS_PER_PACKET,
            STM32_CLKS_PER_HALF_BIT       => STM32_CLKS_PER_HALF_BIT,
            STM32_CS_INACTIVE_CLKS        => STM32_CS_INACTIVE_CLKS,
			
			RHD_SPI_DDR_MODE            => RHD_SPI_DDR_MODE,
            RHD_SPI_NUM_BITS_PER_PACKET => RHD_SPI_NUM_BITS_PER_PACKET,
            RHD_CLKS_PER_HALF_BIT       => RHD_CLKS_PER_HALF_BIT,
            RHD_CS_INACTIVE_CLKS        => RHD_CS_INACTIVE_CLKS
        )
        port map (
            -- Global
            i_Clk               => pll_clk_int,
            i_Rst_L             => w_reset,
            i_Controller_Mode   => w_Controller_Mode,
			rgb_info_red   => rgb_sig_red,
			rgb_info_green => rgb_sig_green,
			rgb_info_blue  => rgb_sig_blue,

            -- STM32 SPI
            o_STM32_SPI_Clk     => int_STM32_SPI_Clk,
            i_STM32_SPI_MISO    => int_STM32_SPI_MISO,
            o_STM32_SPI_MOSI    => int_STM32_SPI_MOSI,
            o_STM32_SPI_CS_n    => int_STM32_SPI_CS_n,

            o_STM32_TX_Byte        => w_STM32_TX_Byte,
            o_STM32_TX_DV          => w_STM32_TX_DV,
            o_STM32_TX_Ready       => w_STM32_TX_Ready,
            o_STM32_RX_DV          => w_STM32_RX_DV,
            o_STM32_RX_Byte_Rising => w_STM32_RX_Byte_Rising,

            -- FIFO
            o_FIFO_Data         => w_FIFO_Data,
            o_FIFO_COUNT        => w_FIFO_COUNT,
            o_FIFO_WE           => w_FIFO_WE,

            -- RHD SPI
            o_RHD_SPI_Clk     => int_RHD_SPI_Clk,
            i_RHD_SPI_MISO    => int_RHD_SPI_MISO,
            o_RHD_SPI_MOSI    => int_RHD_SPI_MOSI,
            o_RHD_SPI_CS_n    => int_RHD_SPI_CS_n
        );
	o_reset <= w_reset;
	o_Controller_Mode <= w_Controller_Mode;
	
	
	Mode_Process : process(pll_clk_int)
	begin
		if w_Controller_Mode = x"1" then
			-- Passthrough: STM32 directly drives RHD
			o_RHD_SPI_Clk  <= o_STM32_SPI_Clk;
			o_RHD_SPI_MOSI <= o_STM32_SPI_MOSI;
			o_RHD_SPI_CS_n <= o_STM32_SPI_CS_n;
			i_STM32_SPI_MISO <= i_RHD_SPI_MISO;  -- MISO passthrough
			o_STM32_SPI_Clk  <= 'Z';
			o_STM32_SPI_MOSI <= 'Z';
			o_STM32_SPI_CS_n <= 'Z';

		else
			-- Normal mode: controller handles communication
			o_STM32_SPI_Clk    <= int_STM32_SPI_Clk;
			o_STM32_SPI_MOSI   <= int_STM32_SPI_MOSI;
			o_STM32_SPI_CS_n   <= int_STM32_SPI_CS_n;
			int_STM32_SPI_MISO <= i_STM32_SPI_MISO;


			o_RHD_SPI_Clk    <= int_RHD_SPI_Clk;
			o_RHD_SPI_MOSI   <= int_RHD_SPI_MOSI;
			o_RHD_SPI_CS_n   <= int_RHD_SPI_CS_n;
			int_RHD_SPI_MISO <= i_RHD_SPI_MISO; -- ? drive MISO back to STM32
		end if;

	end process;
	


	Reset_Process : process(pll_clk_int)
    begin
        if rising_edge(pll_clk_int) then
            -- Reset logic
            if reset_counter < 20 then
				w_Controller_Mode <= x"0";
                w_reset <= '1';  -- Hold reset active
				int_BOOST_ENABLE    <= '1';
            else
                w_reset <= '0';  

				--case int_MODE_STATUS is 
					--when 0 => 
						--if CTRL0_IN = '1' then
							--w_Controller_Mode <= x"2";
							--int_MODE_STATUS <= 0;
						--elsif CTRL0_IN = '0' then
							--int_MODE_STATUS <= 1;
						--end if;
					--when 1 =>
						--if CTRL0_IN = '1' then
							--int_MODE_STATUS <= 0;
						--elsif CTRL0_IN = '0' then
							--w_Controller_Mode <= x"1";
							--int_MODE_STATUS <= 1;
						--end if;

					--when others =>
						--null;
				--end case;
				--stop_counting <= '1';
				
				--Controller mode sequencing
				case reset_counter is
					when 50 =>
						w_Controller_Mode <= x"1";
						
					when 36000000 =>
						w_Controller_Mode <= x"2";
						stop_counting <= '1';

						
					when others =>
						null;
				end case;
				
			end if;
			
			if stop_counting = '0' then
				reset_counter <= reset_counter + 1;
			end if;
			
        end if;
    end process Reset_Process;
	
	o_BOOST_ENABLE    <= int_BOOST_ENABLE;

	LED1_OUT <= led1_sig;
    LED2_OUT <= led2_sig;
    LED3_OUT <= led3_sig;
	LED4_OUT <= led4_sig;

    RGB0_OUT <= rgb_sig_green;
    RGB1_OUT <= rgb_sig_blue;
    RGB2_OUT <= rgb_sig_red;

end architecture RTL;
