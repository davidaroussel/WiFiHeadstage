library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    generic (
        STM32_SPI_NUM_BITS_PER_PACKET : integer := 512;
        STM32_CLKS_PER_HALF_BIT       : integer := 8;
        STM32_CS_INACTIVE_CLKS        : integer := 32;
			
		RHD2132_SPI_DDR_MODE            : integer := 0;
		
        RHD2132_SPI_NUM_BITS_PER_PACKET : integer := 32;
        RHD2132_CLKS_PER_HALF_BIT       : integer := 8;
        RHD2132_CS_INACTIVE_CLKS        : integer := 32;

        RHD2216_SPI_NUM_BITS_PER_PACKET : integer := 16;
        RHD2216_CLKS_PER_HALF_BIT       : integer := 64;    -- 32 for around 2.5KHz
        RHD2216_CS_INACTIVE_CLKS        : integer := 64;
		
		-- 0: Neuro Only 
		-- 1: EMG Only 
		-- 2: EMG + Neuro
		RHD_SAMPLING_MODE : integer := 0

		---- MAIN_CLK : 24MHz -- Stable EMG 2.9KHz-
		--   HALF_BIT : 8 
		--   CS_CLK : 256
		---  11.20 packets / xxxx Mbps
				
		---- MAIN_CLK : 42MHz -- Stable Neuro 25.74KHz
		--   HALF_BIT : 2 
		--   CS_CLK : 32
		---  xxx packets / 6.06Mbps		
		
		
		---- MAIN_CLK : 42MHz
		--   HALF_BIT : 1 
		--   CS_CLK : 16
		---  N/A packets / 12.6Mbps
		
		---- MAIN_CLK : 36MHz
		--   HALF_BIT : 2 
		--   CS_CLK : 4
		---  118.75 packets / 7.782Mbps
		
		---- MAIN_CLK : 36MHz
		--   HALF_BIT : 2 
		--   CS_CLK : 8 
		---  112.9 packets / 7.398Mbps
		
		---- MAIN_CLK : 36MHz
		--   HALF_BIT : 4 
		--   CS_CLK : 8 
		---  60 packets / 3.932Mbps
		
    );
    port (
        -- Clock and Reset

        -- External 12 MHz clock input
        i_clk     : in  STD_LOGIC;

        -- STM32 SPI Interface
        o_STM32_SPI4_MOSI : inout STD_LOGIC; 
        i_STM32_SPI4_MISO : inout STD_LOGIC; 
        o_STM32_SPI4_Clk  : inout STD_LOGIC; 
        o_STM32_SPI4_CS_n : inout STD_LOGIC; 

        -- RHD SPI Interface 
        o_RHS_TOP_SPI_MOSI   : out STD_LOGIC; 
        o_RHS_TOP_SPI_Clk    : out STD_LOGIC; 
        i_RHS_TOP_SPI_MISO_1 : in  STD_LOGIC; 
		o_RHS_TOP_SPI_CS_n_1 : out STD_LOGIC; 
		
		o_RHS_TOP_SPI_MOSI_2   : out STD_LOGIC; --FOR DK
		i_RHS_TOP_SPI_MISO_2 : in  STD_LOGIC; 
		o_RHS_TOP_SPI_CS_n_2 : out STD_LOGIC; --FOR HEADSTAGE
		
		--o_RHS_BOTTOM_SPI_MOSI : out STD_LOGIC; 
        --o_RHS_BOTTOM_SPI_Clk  : out STD_LOGIC; 
        --i_RHS_BOTTOM_SPI_MISO_1 : in  STD_LOGIC; 
		--o_RHS_BOTTOM_SPI_CS_n_1 : out STD_LOGIC; 
		
		--i_RHS_BOTTOM_SPI_MISO_2 : in  STD_LOGIC; 
		--o_RHS_BOTTOM_SPI_CS_n_2 : out STD_LOGIC;
		
		CTRL0_IN     : in STD_LOGIC;
		RHS_SEL     : in STD_LOGIC;
		
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

    signal w_FIFO_RHD2132_Data           : std_logic_vector(31 downto 0);
    signal w_FIFO_RHD2132_COUNT          : std_logic_vector(8 downto 0);
    signal w_FIFO_RHD2132_WE             : std_logic;
	
    signal w_FIFO_RHD2216_Data           : std_logic_vector(31 downto 0);
    signal w_FIFO_RHD2216_COUNT          : std_logic_vector(8 downto 0);
    signal w_FIFO_RHD2216_WE             : std_logic;
	
	signal led1_sig : std_logic := '1';
    signal led2_sig : std_logic := '1';
    signal led3_sig : std_logic := '1';
    signal led4_sig : std_logic := '1';

    signal rgb_sig_red   : std_logic := '1';
    signal rgb_sig_green : std_logic := '1';
    signal rgb_sig_blue  : std_logic := '1';
	
    signal stop_counting : std_logic := '0';
	
	signal pll_clk_int : std_logic;
	
	signal int_RHS_TOP_SPI_MOSI : std_logic;
	signal int_RHS_TOP_SPI_Clk  : std_logic;
	signal int_RHS_TOP_SPI_MISO_1 : std_logic;
	signal int_RHS_TOP_SPI_CS_n_1 : std_logic;
	signal int_RHS_TOP_SPI_MISO_2 : std_logic;
	signal int_RHS_TOP_SPI_CS_n_2 : std_logic;

    signal int_STM32_SPI_MOSI : std_logic;
	signal int_STM32_SPI_MISO : std_logic;
	signal int_STM32_SPI_Clk  : std_logic;
	signal int_STM32_SPI_CS_n : std_logic;
	
	signal int_BOOST_ENABLE    : std_logic;
	signal int_LED_SYNC 	   : std_logic;

	
	
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
			
			RHD2132_SPI_DDR_MODE            => RHD2132_SPI_DDR_MODE,
            RHD2132_SPI_NUM_BITS_PER_PACKET => RHD2132_SPI_NUM_BITS_PER_PACKET,
            RHD2132_CLKS_PER_HALF_BIT       => RHD2132_CLKS_PER_HALF_BIT,
            RHD2132_CS_INACTIVE_CLKS        => RHD2132_CS_INACTIVE_CLKS,
		
            RHD2216_SPI_NUM_BITS_PER_PACKET => RHD2216_SPI_NUM_BITS_PER_PACKET,
            RHD2216_CLKS_PER_HALF_BIT       => RHD2216_CLKS_PER_HALF_BIT,
            RHD2216_CS_INACTIVE_CLKS        => RHD2216_CS_INACTIVE_CLKS,
			
			RHD_SAMPLING_MODE               => RHD_SAMPLING_MODE
        )
        port map (
            -- Global
            i_Clk               => pll_clk_int,
            i_Rst_L             => w_reset,
            i_Controller_Mode   => w_Controller_Mode,

			rgb_info_red   => rgb_sig_red,
			rgb_info_blue   => rgb_sig_blue,
			--rgb_info_green   => rgb_sig_green,

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
            o_FIFO_RHD2132_Data    => w_FIFO_RHD2132_Data,
            o_FIFO_RHD2132_COUNT   => w_FIFO_RHD2132_COUNT,
            o_FIFO_RHD2132_WE      => w_FIFO_RHD2132_WE,
				
            -- RHD SPI
            o_RHD2132_SPI_Clk     => int_RHS_TOP_SPI_Clk,
            i_RHD2132_SPI_MISO    => int_RHS_TOP_SPI_MISO_1,
            o_RHD2132_SPI_MOSI    => int_RHS_TOP_SPI_MOSI,
            o_RHD2132_SPI_CS_n    => int_RHS_TOP_SPI_CS_n_1,
		
            -- RHD SPI
            i_RHD2216_SPI_MISO    => int_RHS_TOP_SPI_MISO_2,
            o_RHD2216_SPI_CS_n    => int_RHS_TOP_SPI_CS_n_2
        );
	o_reset <= w_reset;
	o_Controller_Mode <= w_Controller_Mode;

	
	Mode_Process : process(pll_clk_int)
		begin
			if w_Controller_Mode = x"0" then
				-- Passthrough: STM32 directly drives RHD
				o_RHS_TOP_SPI_Clk    <= o_STM32_SPI4_Clk;
				o_RHS_TOP_SPI_MOSI   <= o_STM32_SPI4_MOSI;
				o_RHS_TOP_SPI_CS_n_1 <= o_STM32_SPI4_CS_n;
				i_STM32_SPI4_MISO    <= i_RHS_TOP_SPI_MISO_1;  
				o_STM32_SPI4_Clk  <= 'Z';                                                                                                                                                                                                                                                 
				o_STM32_SPI4_MOSI <= 'Z';
				o_STM32_SPI4_CS_n <= 'Z';
				
			elsif w_Controller_Mode = x"1" then
				o_RHS_TOP_SPI_Clk    <= o_STM32_SPI4_Clk;
				--IF DEVKIT
				--o_RHS_TOP_SPI_MOSI_2 <= o_STM32_SPI4_MOSI;
				--o_RHS_TOP_SPI_CS_n_1 <= o_STM32_SPI4_CS_n;				
				--IF HEADSTAGE
				o_RHS_TOP_SPI_MOSI   <= o_STM32_SPI4_MOSI;
				o_RHS_TOP_SPI_CS_n_2 <= o_STM32_SPI4_CS_n;
				i_STM32_SPI4_MISO    <= i_RHS_TOP_SPI_MISO_2 ;  
				o_STM32_SPI4_Clk  <= 'Z';                                                                                                                                                                                                                                                 
				o_STM32_SPI4_MOSI <= 'Z';
				o_STM32_SPI4_CS_n <= 'Z';
			else
				-- Normal mode: controller handles communication
				o_STM32_SPI4_Clk    <= int_STM32_SPI_Clk;
				o_STM32_SPI4_MOSI   <= int_STM32_SPI_MOSI;
				o_STM32_SPI4_CS_n   <= int_STM32_SPI_CS_n;
				int_STM32_SPI_MISO <= i_STM32_SPI4_MISO;

				o_RHS_TOP_SPI_Clk    <= int_RHS_TOP_SPI_Clk;
				o_RHS_TOP_SPI_MOSI   <= int_RHS_TOP_SPI_MOSI;
				o_RHS_TOP_SPI_CS_n_1 <= int_RHS_TOP_SPI_CS_n_1;
				int_RHS_TOP_SPI_MISO_1 <= i_RHS_TOP_SPI_MISO_1; 
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
				--rgb_sig_green <= '1';
            else
                w_reset <= '0';
				
				if CTRL0_IN = '0' then
					if RHS_SEL = '0' then
						w_Controller_Mode <= x"0";
						rgb_sig_green <= '1';
					elsif RHS_SEL = '1' then
						w_Controller_Mode <= x"1";
						rgb_sig_green <= '0';
					end if;
				elsif CTRL0_IN = '1' then
					w_Controller_Mode <= x"2";
				end if;


				--Controller mode sequencing
				--case reset_counter is
					--when 36000000 =>
						--w_Controller_Mode <= x"1";
					--when 72000000 =>
						--stop_counting <= '1';
						
						--if CTRL0_IN = '1' then
							--w_Controller_Mode <= x"1";
						--elsif CTRL0_IN = '0' then
							--w_Controller_Mode <= x"2";
						--end if;
						
						
					--when others =>
						--null;
				--end case;
				
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
