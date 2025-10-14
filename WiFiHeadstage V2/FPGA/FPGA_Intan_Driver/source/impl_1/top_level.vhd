library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    generic (
        STM32_SPI_NUM_BITS_PER_PACKET : integer := 512;
        STM32_CLKS_PER_HALF_BIT       : integer := 1;
        STM32_CS_INACTIVE_CLKS        : integer := 2;
		
		RHD_SPI_DDR_MODE            : integer := 0;
		
        RHD_SPI_NUM_BITS_PER_PACKET : integer := 16;
        RHD_CLKS_PER_HALF_BIT       : integer := 1;
        RHD_CS_INACTIVE_CLKS        : integer := 2
		
    );
    port (
        -- Clock and Reset

        -- External 12 MHz clock input
        i_clk     : in  STD_LOGIC;

        -- STM32 SPI Interface
        o_STM32_SPI_MOSI : inout std_logic; -- IO 20A --> PIN 11
        i_STM32_SPI_MISO : inout std_logic; -- IO 18A --> PIN 10
        o_STM32_SPI_Clk  : inout std_logic; -- IO 16A --> PIN 9
        o_STM32_SPI_CS_n : inout std_logic; -- IO 13B --> PIN 6

		-- RHD SPI Interface (USBC - INTAN SPI1)
        -- SPI Slave Interface TO RHD BOARD (FOR PoC STM-WFM200-FPGA)
        --o_RHD_SPI_MOSI : out std_logic; -- IO 36B --> PIN 25
        --i_RHD_SPI_MISO : in  std_logic; -- IO 39A --> PIN 26 
        --o_RHD_SPI_Clk  : out std_logic; -- IO 38B --> PIN 27
        --o_RHD_SPI_CS_n : out std_logic; -- IO 43A --> PIN 32

        -- RHD SPI Interface (USBC - INTAN SPI2)
		-- SPI Slave Interface TO LVDS BOARD - RHD (FOR FPGA PoC Programmer)
        o_RHD_SPI_MOSI : out std_logic; -- IO 9B --> PIN 3
		i_RHD_SPI_MISO : in  std_logic; -- IO 4A --> PIN 48
        o_RHD_SPI_Clk  : out std_logic; -- IO 5B --> PIN 45
        o_RHD_SPI_CS_n : out std_logic; -- IO 2A --> PIN 47
		
		CTRL0_IN     : in STD_logic;
		
        RGB0_OUT     : out STD_LOGIC;		--> PIN 39
        RGB1_OUT     : out STD_LOGIC;		--> PIN 40
        RGB2_OUT     : out STD_LOGIC;		--> PIN 41

		LED1_OUT     : out STD_LOGIC;  -- IO 44B --> PIN 34
		LED2_OUT     : out STD_LOGIC;  -- IO 42B --> PIN 31
		LED3_OUT     : out STD_LOGIC;  -- IO 48B --> PIN 36
		LED4_OUT     : out STD_LOGIC;   -- IO 22A --> PIN 12
		
		o_Controller_Mode : out std_logic_vector(3 downto 0);
		o_reset : out std_logic;
		o_reset_Counter : out std_logic_vector(7 downto 0)

    );
end entity top_level;

architecture RTL of top_level is

	signal debug_MISO : std_logic;
	
    -- Internal signals
    signal w_Controller_Mode    : std_logic_vector(3 downto 0) := (others => '0');
	signal w_reset              : std_logic;
	
	signal reset_counter : integer range 0 to 250 := 0;
	
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

    signal rgb1_sig : std_logic := '1';
    signal rgb2_sig : std_logic := '1';
    signal rgb3_sig : std_logic := '1';
	
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
	o_reset_Counter   <=  std_logic_vector(to_signed(reset_counter, 8));
	
	
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
	


---- Timing process
    --process(pll_clk_int)
    --begin
        --if rising_edge(pll_clk_int) then
            --if counter < TOGGLE_COUNT - 1 then
                --counter <= counter + 1;
            --else
                --counter <= 0;
                --step <= (step + 1) mod 7;
            --end if;
        --end if;
    --end process;
	

	---- LED/RGB control process
    --process(step)
    --begin
        ---- Default states
        --led1_sig <= '1';
        --led2_sig <= '1';
        --led3_sig <= '1';
		--led4_sig <= '1';
        --rgb1_sig <= '0';
        --rgb2_sig <= '0';
        --rgb3_sig <= '0';

        --case step is
            --when 0 => 
				--rgb1_sig <= '0';
				--rgb2_sig <= '0';
				--rgb3_sig <= '0';
				
				--led1_sig <= '1';
				--led2_sig <= '0';
				--led3_sig <= '1';
				--led4_sig <= '0';
				
            --when 1 => 
				--rgb1_sig <= '0';
				--rgb2_sig <= '1';
				--rgb3_sig <= '1';
				
				--led1_sig <= '0';
				--led2_sig <= '1';
				--led3_sig <= '0';
				--led4_sig <= '1';
				
            --when 2 => 
				--rgb1_sig <= '1';
				--rgb2_sig <= '0';
				--rgb3_sig <= '1';
				
				--led1_sig <= '1';
				--led2_sig <= '0';
				--led3_sig <= '1';
				--led4_sig <= '0';
				
            --when 3 => 
				--rgb1_sig <= '1';
				--rgb2_sig <= '1';
				--rgb3_sig <= '0';
				
				--led1_sig <= '0';

				--led2_sig <= '1';
				--led3_sig <= '0';
				--led4_sig <= '1';
            --when others => 
				--null;
        --end case;
    --end process;

	--Reset_Process : process(pll_clk_int)
    --begin
        --if rising_edge(pll_clk_int) then
            ---- Reset logic
            --if reset_counter < 20 then
				--w_Controller_Mode <= x"0";
                --w_reset <= '1';  -- Hold reset active
            --else
                --w_reset <= '0';  -- Release reset after 10 cycles

				---- Controller mode sequencing
				--case reset_counter is
					--when 50 =>
						--w_Controller_Mode <= x"2";
						--stop_counting <= '1';
					----when 100 =>
						----w_Controller_Mode <= x"2";
						----stop_counting <= '1';
					--when others =>
						--null;
				--end case;
			--end if;
			
			--if stop_counting = '0' then
				--reset_counter <= reset_counter + 1;
			--end if;
			
        --end if;
    --end process Reset_Process;
	
	Reset_Process : process(pll_clk_int)
    begin
        if rising_edge(pll_clk_int) then
            -- Reset logic
            if reset_counter < 20 then
				w_Controller_Mode <= x"0";
                w_reset <= '1';  -- Hold reset active
            else
                w_reset <= '0';  -- Release reset after 10 cycles
				stop_counting <= '1';
				if CTRL0_IN = '0' then
					w_Controller_Mode <= x"1";
				elsif CTRL0_IN = '1' then
					w_Controller_Mode <= x"2";
				end if;
			end if;
			
			if stop_counting = '0' then
				reset_counter <= reset_counter + 1;
			end if;
			
        end if;
    end process Reset_Process;

	LED1_OUT <= led1_sig;
    LED2_OUT <= led2_sig;
    LED3_OUT <= led3_sig;
	LED4_OUT <= led4_sig;

    RGB0_OUT <= CTRL0_IN;
    RGB1_OUT <= rgb2_sig;
    RGB2_OUT <= rgb3_sig;

end architecture RTL;
