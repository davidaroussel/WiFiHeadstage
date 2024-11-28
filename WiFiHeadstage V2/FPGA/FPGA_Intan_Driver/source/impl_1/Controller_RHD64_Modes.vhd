library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Controller_RHD64_Modes is
	generic (
		STM32_SPI_NUM_BITS_PER_PACKET : integer := 1024;
		STM32_CLKS_PER_HALF_BIT       : integer := 2;
		STM32_CS_INACTIVE_CLKS        : integer := 4;
		RHD64_SPI_NUM_BITS_PER_PACKET : integer := 16;
		RHD64_CLKS_PER_HALF_BIT       : integer := 4;
		RHD64_CS_INACTIVE_CLKS        : integer := 4
	);
	Port ( 
		i_Rst_L        : in std_logic;
		i_Clk          : in std_logic;

		-- Controller Modes
		i_Controller_Mode  : in std_logic_vector(3 downto 0);

		-- STM32 SPI Interface FPGA Passthrough 
		in_STM32_SPI_MOSI : in std_logic;
		out_STM32_SPI_MISO  : out std_logic;
	    in_STM32_SPI_Clk  : in std_logic;
		in_STM32_SPI_CS_n : in std_logic;

		-- STM32 SPI Interface FPGA Sampling 
		out_STM32_SPI_MOSI : out std_logic;
		in_STM32_SPI_MISO  : in std_logic;
	    out_STM32_SPI_Clk  : out std_logic;
		out_STM32_SPI_CS_n : out std_logic;

		-- STM32 SPI Interface
		out_RHD64_SPI_Clk    : out std_logic;
		in_RHD64_SPI_MISO    : in  std_logic;
		out_RHD64_SPI_MOSI   : out std_logic;
		out_RHD64_SPI_CS_n   : out std_logic

	);	
end Controller_RHD64_Modes;

architecture Behavioral of Controller_RHD64_Modes is

	-- Instantiate the Controller_RHD64_Sampling component
	component Controller_RHD64_Sampling is
	generic (
		STM32_SPI_NUM_BITS_PER_PACKET : integer := 1024;
		STM32_CLKS_PER_HALF_BIT       : integer := 2;
		STM32_CS_INACTIVE_CLKS        : integer := 4;
		RHD64_SPI_NUM_BITS_PER_PACKET : integer := 16;
		RHD64_CLKS_PER_HALF_BIT       : integer := 4;
		RHD64_CS_INACTIVE_CLKS        : integer := 4
	);
	port (
		-- Signals from top level
		i_Rst_L           : in  std_logic;
		i_Clk             : in  std_logic;
		i_Controller_Mode : in  std_logic_vector(3 downto 0);

		-- STM32 SPI Interface
		o_STM32_SPI_Clk      : out std_logic;
		i_STM32_SPI_MISO     : in  std_logic;
		o_STM32_SPI_MOSI     : out std_logic;
		o_STM32_SPI_CS_n     : out std_logic;

		-- TX (MOSI) Signals
		o_STM32_TX_Byte      : out std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
		o_STM32_TX_DV        : out std_logic;
		o_STM32_TX_Ready     : out std_logic;

		-- RX (MISO) Signals
		o_STM32_RX_DV        : out std_logic;
		o_STM32_RX_Byte_Rising  : out std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);

		-- FIFO Signals
		o_FIFO_Data    : out std_logic_vector(31 downto 0);
		o_FIFO_COUNT   : out std_logic_vector(10 downto 0);
		o_FIFO_WE      : out std_logic;
		o_FIFO_RE      : out std_logic;
		o_FIFO_Q       : out std_logic_vector(31 downto 0);
		o_FIFO_EMPTY   : out std_logic;
		o_FIFO_FULL    : out std_logic;
		o_FIFO_AEMPTY  : out std_logic;
		o_FIFO_AFULL   : out std_logic;

		-- RHD64 SPI Interface
		o_RHD64_SPI_Clk      : out std_logic;
		i_RHD64_SPI_MISO     : in  std_logic;
		o_RHD64_SPI_MOSI     : out std_logic;
		o_RHD64_SPI_CS_n     : out std_logic;

		-- TX (MOSI) Signals
		o_RHD64_TX_Byte      : out std_logic_vector(15 downto 0);
		o_RHD64_TX_DV        : out std_logic;
		o_RHD64_TX_Ready     : out std_logic;

		-- RX (MISO) Signals
		o_RHD64_RX_DV        : out std_logic;
		o_RHD64_RX_Byte_Rising  : out std_logic_vector(15 downto 0);
		o_RHD64_RX_Byte_Falling : out std_logic_vector(15 downto 0);

		-- Additional signals if required
		o_NUM_DATA           : out integer;
		o_STM32_State        : out integer;
		o_stm32_counter      : out integer
	);
	end component;

	-- SAMPLING
    signal o_STM32_SPI_Clk_int      : std_logic;
    signal i_STM32_SPI_MISO_int     : std_logic;
    signal o_STM32_SPI_MOSI_int     : std_logic;
    signal o_STM32_SPI_CS_n_int     : std_logic;
	 
	-- PASSTHROUGH
	signal i_STM32_SPI_Clk_int      : std_logic;
    signal o_STM32_SPI_MISO_int     : std_logic;
    signal i_STM32_SPI_MOSI_int     : std_logic;
    signal i_STM32_SPI_CS_n_int     : std_logic;
    
    signal o_RHD64_SPI_Clk_int      : std_logic;
    signal i_RHD64_SPI_MISO_int     : std_logic;
    signal o_RHD64_SPI_MOSI_int     : std_logic;
    signal o_RHD64_SPI_CS_n_int     : std_logic;
    
    
    signal SCLK_master_int : std_logic;
    signal MOSI_master_int : std_logic;
    signal MISO_master_int : std_logic;
    signal SS_master_int   : std_logic;
    signal SCLK_slave_int  : std_logic;
    signal MOSI_slave_int  : std_logic;
    signal MISO_slave_int  : std_logic;
    signal SS_slave_int    : std_logic;


begin
controller_RHD64_sampling_inst : Controller_RHD64_Sampling
    generic map (
      STM32_SPI_NUM_BITS_PER_PACKET => STM32_SPI_NUM_BITS_PER_PACKET,
      STM32_CLKS_PER_HALF_BIT       => STM32_CLKS_PER_HALF_BIT,
      STM32_CS_INACTIVE_CLKS        => STM32_CS_INACTIVE_CLKS,
      RHD64_SPI_NUM_BITS_PER_PACKET => RHD64_SPI_NUM_BITS_PER_PACKET,
      RHD64_CLKS_PER_HALF_BIT       => RHD64_CLKS_PER_HALF_BIT,
      RHD64_CS_INACTIVE_CLKS        => RHD64_CS_INACTIVE_CLKS
    )
    port map (
      i_Rst_L           => i_Rst_L,
      i_Clk             => i_Clk,
      i_Controller_Mode => i_Controller_Mode,
      o_STM32_SPI_Clk      => o_STM32_SPI_Clk_int,
      i_STM32_SPI_MISO     => i_STM32_SPI_MISO_int,
      o_STM32_SPI_MOSI     => o_STM32_SPI_MOSI_int,
      o_STM32_SPI_CS_n     => o_STM32_SPI_CS_n_int,
   
      o_RHD64_SPI_Clk      => o_RHD64_SPI_Clk_int,
      i_RHD64_SPI_MISO     => i_RHD64_SPI_MISO_int,
      o_RHD64_SPI_MOSI     => o_RHD64_SPI_MOSI_int,
      o_RHD64_SPI_CS_n     => o_RHD64_SPI_CS_n_int
    );
  

process(i_Controller_Mode)
begin
    if i_Rst_L = '1' then
        -- Reset condition
        -- Add reset behavior here if necessary
    else
        case i_Controller_Mode is
            when "0000" =>
				
			
				out_RHD64_SPI_MOSI <= o_RHD64_SPI_MOSI_int;
				out_RHD64_SPI_MISO <= o_RHD64_SPI_MISO_int;
				out_RHD64_SPI_CS_n <= o_RHD64_SPI_CS_n_int;
                out_RHD64_SPI_Clk <= o_RHD64_SPI_Clk_int;
                null;

            when "0001" =>
                -- Mode 1 behavior: PASSTHROUGH
                SCLK_master_int      <= inout_STM32_SPI_Clk;
                MOSI_master_int      <= inout_STM32_SPI_MOSI;
                inout_STM32_SPI_MISO <= MISO_master_int;
                SS_master_int        <= inout_STM32_SPI_CS_n;

                o_RHD64_SPI_Clk_int     <= SCLK_slave_int;
                o_RHD64_SPI_MOSI_int    <= MOSI_slave_int;
                MISO_slave_int       	<= i_RHD64_SPI_MISO_int; -- Assuming you want to connect the testbench signal here
                o_RHD64_SPI_CS_n_int    <= SS_slave_int;

            when "0010" =>
                -- Mode 2 behavior: SAMPLING
                -- Update the signals accordingly
                inout_STM32_SPI_Clk  <= o_STM32_SPI_Clk_int;
                inout_STM32_SPI_MOSI <= o_STM32_SPI_MOSI_int;
                i_STM32_SPI_MISO_int <= inout_STM32_SPI_MISO;
                inout_STM32_SPI_CS_n <= o_STM32_SPI_CS_n_int;

                out_RHD64_SPI_Clk    <= o_RHD64_SPI_Clk_int;
                out_RHD64_SPI_MOSI   <= o_RHD64_SPI_MOSI_int;
                i_RHD64_SPI_MISO_int <= in_RHD64_SPI_MISO;
                out_RHD64_SPI_CS_n   <= o_RHD64_SPI_CS_n_int;

            when others =>
                -- Handle other modes if necessary
                null;
        end case;
    end if;
end process;

end Behavioral;
