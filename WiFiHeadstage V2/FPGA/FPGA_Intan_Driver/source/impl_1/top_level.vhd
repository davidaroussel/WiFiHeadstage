library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    generic (
        STM32_SPI_NUM_BITS_PER_PACKET : integer := 1024;
        STM32_CLKS_PER_HALF_BIT       : integer := 4;
        STM32_CS_INACTIVE_CLKS        : integer := 8;
        RHD64_SPI_NUM_BITS_PER_PACKET : integer := 16;
        RHD64_CLKS_PER_HALF_BIT       : integer := 8;
        RHD64_CS_INACTIVE_CLKS        : integer := 256
    );
    port (
        -- Clock and Reset
        i_Clk    : in  std_logic;

        -- STM32 SPI Interface
        o_STM32_SPI_Clk  : out std_logic;
        i_STM32_SPI_MISO : in  std_logic;
        o_STM32_SPI_MOSI : out std_logic;
        o_STM32_SPI_CS_n : out std_logic;

        -- RHD64 SPI Interface
        o_RHD64_SPI_Clk  : out std_logic;
        i_RHD64_SPI_MISO : in  std_logic;
        o_RHD64_SPI_MOSI : out std_logic;
        o_RHD64_SPI_CS_n : out std_logic
    );
end entity top_level;

architecture RTL of top_level is

	
    -- Internal signals
    signal w_Controller_Mode    : std_logic_vector(3 downto 0) := (others => '0');
	signal w_reset               : std_logic;
	signal reset_counter : integer range 0 to 10 := 0;

    signal w_STM32_TX_Byte       : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    signal w_STM32_TX_DV         : std_logic;
    signal w_STM32_TX_Ready      : std_logic;
    signal w_STM32_RX_Byte_Rising: std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    signal w_STM32_RX_DV         : std_logic;

    signal w_FIFO_Data           : std_logic_vector(31 downto 0);
    signal w_FIFO_COUNT          : std_logic_vector(10 downto 0);
    signal w_FIFO_WE             : std_logic;
    
begin
	w_Controller_Mode <=  x"2";
	
	
    -- Instance of Controller_RHD64_Sampling
    Controller_inst : entity work.Controller_RHD64_Sampling
        generic map (
            STM32_SPI_NUM_BITS_PER_PACKET => STM32_SPI_NUM_BITS_PER_PACKET,
            STM32_CLKS_PER_HALF_BIT       => STM32_CLKS_PER_HALF_BIT,
            STM32_CS_INACTIVE_CLKS        => STM32_CS_INACTIVE_CLKS,
            RHD64_SPI_NUM_BITS_PER_PACKET => RHD64_SPI_NUM_BITS_PER_PACKET,
            RHD64_CLKS_PER_HALF_BIT       => RHD64_CLKS_PER_HALF_BIT,
            RHD64_CS_INACTIVE_CLKS        => RHD64_CS_INACTIVE_CLKS
        )
        port map (
            -- Global
            i_Clk               => i_Clk,
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

            -- RHD64 SPI
            o_RHD64_SPI_Clk     => o_RHD64_SPI_Clk,
            i_RHD64_SPI_MISO    => i_RHD64_SPI_MISO,
            o_RHD64_SPI_MOSI    => o_RHD64_SPI_MOSI,
            o_RHD64_SPI_CS_n    => o_RHD64_SPI_CS_n
        );

	Reset_Process : process(i_Clk)
	begin
		if rising_edge(i_Clk) then
			if reset_counter < 10 then
				reset_counter <= reset_counter + 1;
				w_reset <= '1'; -- Hold reset active
			else
				w_reset <= '0'; -- Release reset after 10 cycles
			end if;
		end if;
	end process Reset_Process;

end architecture RTL;
