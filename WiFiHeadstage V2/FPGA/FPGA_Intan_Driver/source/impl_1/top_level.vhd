library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    generic (
        STM32_SPI_NUM_BITS_PER_PACKET : integer := 1024;
        STM32_CLKS_PER_HALF_BIT       : integer := 1;
        STM32_CS_INACTIVE_CLKS        : integer := 1;
		
		RHD_SPI_DDR_MODE            : integer := 0;
		
        RHD_SPI_NUM_BITS_PER_PACKET : integer := 16;
        RHD_CLKS_PER_HALF_BIT       : integer := 2;
        RHD_CS_INACTIVE_CLKS        : integer := 1
		
    );
    port (
        -- Clock and Reset

        -- External 12 MHz clock input
        i_clk     : in  STD_LOGIC;
        -- PLL output clock
        pll_clk     : out STD_LOGIC;

        -- STM32 SPI Interface
        o_STM32_SPI_Clk  : out std_logic;
        i_STM32_SPI_MISO : in  std_logic;
        o_STM32_SPI_MOSI : out std_logic;
        o_STM32_SPI_CS_n : out std_logic;

        -- RHD SPI Interface
        o_RHD_SPI_Clk  : out std_logic;
        i_RHD_SPI_MISO : in  std_logic;
        o_RHD_SPI_MOSI : out std_logic;
        o_RHD_SPI_CS_n : out std_logic
		
		--o_Controller_Mode : out std_logic_vector(3 downto 0);
		--o_reset_Counter : out std_logic_vector(7 downto 0)

    );
end entity top_level;

architecture RTL of top_level is
	
    -- Internal signals
    signal w_Controller_Mode    : std_logic_vector(3 downto 0) := (others => '0');
	signal w_reset              : std_logic;
	
	signal reset_counter : integer range 0 to 250 := 0;

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

begin


    -- Use pll_clk_internal in your SPI logic

	pll_spi_inst : entity work.PLL_SPI port map(
		ref_clk_i   => i_clk,
		rst_n_i     => '1',
		outcore_o   => open,
		outglobal_o => pll_clk_internal
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
            i_Clk               => pll_clk_internal,
            i_Rst_L             => w_reset,
            i_Controller_Mode   => w_Controller_Mode,

            -- STM32 SPI
            o_STM32_SPI_Clk     => o_STM32_SPI_Clk,
            i_STM32_SPI_MISO    => i_STM32_SPI_MISO,
            o_STM32_SPI_MOSI    => o_STM32_SPI_MOSI,
            o_STM32_SPI_CS_n    => o_STM32_SPI_CS_n,

            o_STM32_TX_Byte     => w_STM32_TX_Byte,
            o_STM32_TX_DV       => w_STM32_TX_DV,
            o_STM32_TX_Ready    => w_STM32_TX_Ready,
            o_STM32_RX_DV       => w_STM32_RX_DV,
            o_STM32_RX_Byte_Rising => w_STM32_RX_Byte_Rising,

            -- FIFO
            o_FIFO_Data         => w_FIFO_Data,
            o_FIFO_COUNT        => w_FIFO_COUNT,
            o_FIFO_WE           => w_FIFO_WE,

            -- RHD SPI
            o_RHD_SPI_Clk     => o_RHD_SPI_Clk,
            i_RHD_SPI_MISO    => i_RHD_SPI_MISO,
            o_RHD_SPI_MOSI    => o_RHD_SPI_MOSI,
            o_RHD_SPI_CS_n    => o_RHD_SPI_CS_n
        );


	--o_Controller_Mode <= w_Controller_Mode;
	--o_reset_Counter   <=  std_logic_vector(to_signed(reset_counter, 8));
	

	 Reset_Process : process(pll_clk_internal)
    begin
        if rising_edge(pll_clk_internal) then
            -- Reset logic
            if reset_counter < 10 then
                reset_counter <= reset_counter + 1;
				w_Controller_Mode <= x"0";
                w_reset <= '1';  -- Hold reset active
            else
                w_reset <= '0';  -- Release reset after 10 cycles

                -- Controller mode sequencing
                case reset_counter is
                    when 50 =>
                        w_Controller_Mode <= x"1";
                    when 100 =>
                        w_Controller_Mode <= x"2";
                    when others =>
                        null;
                end case;
				
                -- Increment counter beyond reset
                if reset_counter < 200 then  -- Prevent overflow
                    reset_counter <= reset_counter + 1;
                end if;
            end if;
        end if;
    end process Reset_Process;

end architecture RTL;
