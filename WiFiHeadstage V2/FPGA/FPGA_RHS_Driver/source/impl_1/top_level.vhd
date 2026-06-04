library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    generic (
        STM32_SPI_NUM_BITS_PER_PACKET : integer := 512;
<<<<<<< HEAD
        STM32_CLKS_PER_HALF_BIT       : integer := 8;
        STM32_CS_INACTIVE_CLKS        : integer := 8;
		
        RHS_READ_SPI_NUM_BITS_PER_PACKET : integer := 32;
        RHS_READ_CLKS_PER_HALF_BIT       : integer := 8;
        RHS_READ_CS_INACTIVE_CLKS        : integer := 32;

        RHS_STIM_SPI_NUM_BITS_PER_PACKET : integer := 32;
        RHS_STIM_CLKS_PER_HALF_BIT       : integer := 8;    -- 32 for around 2.5KHz
=======
        STM32_CLKS_PER_HALF_BIT       : integer := 4;
        STM32_CS_INACTIVE_CLKS        : integer := 16;
		
        RHS_READ_SPI_NUM_BITS_PER_PACKET : integer := 32;
        RHS_READ_CLKS_PER_HALF_BIT       : integer := 4;
        RHS_READ_CS_INACTIVE_CLKS        : integer := 16;

        RHS_STIM_SPI_NUM_BITS_PER_PACKET : integer := 32;
        RHS_STIM_CLKS_PER_HALF_BIT       : integer := 4;    -- 32 for around 2.5KHz
>>>>>>> ed5c0376b362634e1e81d9a369ec4feb75cb968b
        RHS_STIM_CS_INACTIVE_CLKS        : integer := 32;
		
		-- 0: N/A 
		-- 1: N/A
		-- 2: N/A
		RHS_SAMPLING_MODE : integer := 0
		
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
		
		--o_RHS_TOP_SPI_MOSI_2   : out STD_LOGIC; --FOR DK
		i_RHS_TOP_SPI_MISO_2 : in  STD_LOGIC; 
		o_RHS_TOP_SPI_CS_n_2 : out STD_LOGIC; --FOR HEADSTAGE
		
		o_RHS_BOTTOM_SPI_MOSI : out STD_LOGIC; 
        o_RHS_BOTTOM_SPI_Clk  : out STD_LOGIC; 
        i_RHS_BOTTOM_SPI_MISO_1 : in  STD_LOGIC; 
		o_RHS_BOTTOM_SPI_CS_n_1 : out STD_LOGIC; 
		
		i_RHS_BOTTOM_SPI_MISO_2 : in  STD_LOGIC; 
		o_RHS_BOTTOM_SPI_CS_n_2 : out STD_LOGIC;
		
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


    signal w_STM32_TX_Byte       : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    signal w_STM32_TX_DV         : std_logic;
    signal w_STM32_TX_Ready      : std_logic;
    signal w_STM32_RX_Byte_Rising: std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    signal w_STM32_RX_DV         : std_logic;

    signal w_FIFO_RHS_READ_Data           : std_logic_vector(31 downto 0);
    signal w_FIFO_RHS_READ_COUNT          : std_logic_vector(8 downto 0);
    signal w_FIFO_RHS_READ_WE             : std_logic;
	
    signal w_FIFO_RHS_STIM_Data           : std_logic_vector(31 downto 0);
    signal w_FIFO_RHS_STIM_COUNT          : std_logic_vector(8 downto 0);
    signal w_FIFO_RHS_STIM_WE             : std_logic;
	
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
	
	signal int_RHS_TOP_CS_n : std_logic;
	
	signal int_RHS_BOTTOM_SPI_MOSI : std_logic;
	signal int_RHS_BOTTOM_SPI_Clk  : std_logic;
	signal int_RHS_BOTTOM_SPI_MISO_1 : std_logic;
	signal int_RHS_BOTTOM_SPI_CS_n_1 : std_logic;
	signal int_RHS_BOTTOM_SPI_MISO_2 : std_logic;
	signal int_RHS_BOTTOM_SPI_CS_n_2 : std_logic;

	signal int_RHS_BOTTOM_CS_n : std_logic;

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

            RHS_READ_SPI_NUM_BITS_PER_PACKET => RHS_READ_SPI_NUM_BITS_PER_PACKET,
            RHS_READ_CLKS_PER_HALF_BIT       => RHS_READ_CLKS_PER_HALF_BIT,
            RHS_READ_CS_INACTIVE_CLKS        => RHS_READ_CS_INACTIVE_CLKS,
		
            RHS_STIM_SPI_NUM_BITS_PER_PACKET => RHS_STIM_SPI_NUM_BITS_PER_PACKET,
            RHS_STIM_CLKS_PER_HALF_BIT       => RHS_STIM_CLKS_PER_HALF_BIT,
            RHS_STIM_CS_INACTIVE_CLKS        => RHS_STIM_CS_INACTIVE_CLKS
        )
        port map (
            -- Global
            i_Clk               => pll_clk_int,
            i_Rst_L             => w_reset,
            i_Controller_Mode   => w_Controller_Mode,

			rgb_info_red   => rgb_sig_red,
			rgb_info_blue   => rgb_sig_blue,
<<<<<<< HEAD
			--rgb_info_green   => rgb_sig_green,
=======
			rgb_info_green   => rgb_sig_green,
>>>>>>> ed5c0376b362634e1e81d9a369ec4feb75cb968b

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
            o_FIFO_RHS_READ_Data    => w_FIFO_RHS_READ_Data,
            o_FIFO_RHS_READ_COUNT   => w_FIFO_RHS_READ_COUNT,
            o_FIFO_RHS_READ_WE      => w_FIFO_RHS_READ_WE,
				
            -- RHD SPI
            o_RHS_READ_SPI_MOSI     => int_RHS_TOP_SPI_MOSI,
            i_RHS_READ_SPI_MISO_1   => int_RHS_TOP_SPI_MISO_1,
            i_RHS_READ_SPI_MISO_2   => int_RHS_TOP_SPI_MISO_2,
			o_RHS_READ_SPI_Clk      => int_RHS_TOP_SPI_Clk,
            o_RHS_READ_SPI_CS_n_1   => int_RHS_TOP_SPI_CS_n_1,
            o_RHS_READ_SPI_CS_n_2   => int_RHS_TOP_SPI_CS_n_2,
			
			            -- FIFO
            o_FIFO_RHS_STIM_Data    => w_FIFO_RHS_STIM_Data,
            o_FIFO_RHS_STIM_COUNT   => w_FIFO_RHS_STIM_COUNT,
            o_FIFO_RHS_STIM_WE      => w_FIFO_RHS_STIM_WE,
				
            -- RHD SPI
            o_RHS_STIM_SPI_MOSI     => int_RHS_BOTTOM_SPI_MOSI,
            i_RHS_STIM_SPI_MISO_1   => int_RHS_BOTTOM_SPI_MISO_1,
            i_RHS_STIM_SPI_MISO_2   => int_RHS_BOTTOM_SPI_MISO_2,
			o_RHS_STIM_SPI_Clk      => int_RHS_BOTTOM_SPI_Clk,
            o_RHS_STIM_SPI_CS_n_1   => int_RHS_BOTTOM_SPI_CS_n_1,
            o_RHS_STIM_SPI_CS_n_2   => int_RHS_BOTTOM_SPI_CS_n_2
        );
	o_reset <= w_reset;
	o_Controller_Mode <= w_Controller_Mode;

	
	Mode_Process : process(pll_clk_int)
	begin
<<<<<<< HEAD
		if rising_edge(pll_clk_int)then
=======

>>>>>>> ed5c0376b362634e1e81d9a369ec4feb75cb968b
			if w_Controller_Mode = x"0" then
				o_RHS_BOTTOM_SPI_Clk    <= o_STM32_SPI4_Clk;
				o_RHS_BOTTOM_SPI_MOSI   <= o_STM32_SPI4_MOSI;
				
				o_RHS_BOTTOM_SPI_CS_n_1 <= o_STM32_SPI4_CS_n;
				o_RHS_BOTTOM_SPI_CS_n_2 <= o_STM32_SPI4_CS_n;
				
				i_STM32_SPI4_MISO    <= i_RHS_BOTTOM_SPI_MISO_1;  
				o_STM32_SPI4_Clk  <= 'Z';                                                                                                                                                                                                                                                 
				o_STM32_SPI4_MOSI <= 'Z';
				o_STM32_SPI4_CS_n <= 'Z';
				
			elsif w_Controller_Mode = x"1" then
				--IF DEVKIT (TO REDO SINCE MODIFY !!)
				--o_RHS_TOP_SPI_MOSI_2 <= o_STM32_SPI4_MOSI;
				--o_RHS_TOP_SPI_CS_n_1 <= o_STM32_SPI4_CS_n;				
				--IF HEADSTAGE
				o_RHS_TOP_SPI_Clk    <= o_STM32_SPI4_Clk;
				o_RHS_TOP_SPI_MOSI   <= o_STM32_SPI4_MOSI;
				
				o_RHS_TOP_SPI_CS_n_1 <= o_STM32_SPI4_CS_n;
				o_RHS_TOP_SPI_CS_n_2 <= o_STM32_SPI4_CS_n;
				
				i_STM32_SPI4_MISO    <= i_RHS_TOP_SPI_MISO_1;  
				o_STM32_SPI4_Clk  <= 'Z';                                                                                                                                                                                                                                                 
				o_STM32_SPI4_MOSI <= 'Z';
				o_STM32_SPI4_CS_n <= 'Z';

			else
				-- Normal mode: controller handles communication
				o_STM32_SPI4_Clk    <= int_STM32_SPI_Clk;
				o_STM32_SPI4_MOSI   <= int_STM32_SPI_MOSI;
				o_STM32_SPI4_CS_n   <= int_STM32_SPI_CS_n;
				int_STM32_SPI_MISO  <= i_STM32_SPI4_MISO;

				o_RHS_BOTTOM_SPI_Clk    <= int_RHS_BOTTOM_SPI_Clk;
				o_RHS_BOTTOM_SPI_MOSI   <= int_RHS_BOTTOM_SPI_MOSI;

				o_RHS_BOTTOM_SPI_CS_n_1   <= int_RHS_BOTTOM_SPI_CS_n_1;
				int_RHS_BOTTOM_SPI_MISO_1 <= i_RHS_BOTTOM_SPI_MISO_1;

				o_RHS_BOTTOM_SPI_CS_n_2   <= int_RHS_BOTTOM_SPI_CS_n_2;
				int_RHS_BOTTOM_SPI_MISO_2 <= i_RHS_BOTTOM_SPI_MISO_2;
				
				o_RHS_TOP_SPI_Clk    <= int_RHS_TOP_SPI_Clk;
				o_RHS_TOP_SPI_MOSI   <= int_RHS_TOP_SPI_MOSI;

				o_RHS_TOP_SPI_CS_n_1   <= int_RHS_TOP_SPI_CS_n_1;
				int_RHS_TOP_SPI_MISO_1 <= i_RHS_TOP_SPI_MISO_1;

				o_RHS_TOP_SPI_CS_n_2   <= int_RHS_TOP_SPI_CS_n_2;
				int_RHS_TOP_SPI_MISO_2 <= i_RHS_TOP_SPI_MISO_2;
				
			end if;
<<<<<<< HEAD
		end if;
=======
>>>>>>> ed5c0376b362634e1e81d9a369ec4feb75cb968b
	end process;
	
	
	


	Reset_Process : process(pll_clk_int)

    begin
        if rising_edge(pll_clk_int) then
            -- Reset logic
            if reset_counter < 20 then
				w_Controller_Mode <= x"0";
                w_reset <= '1';  -- Hold reset active
				int_BOOST_ENABLE    <= '1';
<<<<<<< HEAD
				rgb_sig_green <= '0';
=======
				--rgb_sig_green <= '0';
>>>>>>> ed5c0376b362634e1e81d9a369ec4feb75cb968b
            else
                w_reset <= '0';
				
				if CTRL0_IN = '0' then
					if RHS_SEL = '0' then
						w_Controller_Mode <= x"0";
<<<<<<< HEAD
						rgb_sig_green <= '0';
					elsif RHS_SEL = '1' then
						w_Controller_Mode <= x"1";
						rgb_sig_green <= '1';
					end if;
				elsif CTRL0_IN = '1' then
					w_Controller_Mode <= x"2";
					rgb_sig_green <= '1';
=======
						--rgb_sig_green <= '0';
					elsif RHS_SEL = '1' then
						w_Controller_Mode <= x"1";
						--rgb_sig_green <= '1';
					end if;
				elsif CTRL0_IN = '1' then
					w_Controller_Mode <= x"2";
					--rgb_sig_green <= '1';
>>>>>>> ed5c0376b362634e1e81d9a369ec4feb75cb968b
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
