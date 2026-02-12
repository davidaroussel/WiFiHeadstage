library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_RHD_Sampling is
  generic (
      STM32_CLKS_PER_HALF_BIT 		: integer := 4;
      STM32_SPI_NUM_BITS_PER_PACKET : integer := 64;
	  STM32_CS_INACTIVE_CLKS		: integer := 4;
	  
	  RHD2132_SPI_DDR_MODE 				: integer := 1;
	  
      RHD2132_SPI_NUM_BITS_PER_PACKET 	: integer := 16;
      RHD2132_CLKS_PER_HALF_BIT 		: integer := 8;
	  RHD2132_CS_INACTIVE_CLKS			: integer := 4;
	  
	  RHD2216_SPI_NUM_BITS_PER_PACKET 	: integer := 16;
      RHD2216_CLKS_PER_HALF_BIT 		: integer := 8;
	  RHD2216_CS_INACTIVE_CLKS			: integer := 4;
	  
	  RHD_SAMPLING_MODE 		: integer := 0
    );
  port (
	o_NUM_DATA       : out integer;
	o_STM32_State    : out integer;
	o_stm32_counter  : out integer;
	
    i_Rst_L        : in std_logic;
    i_Clk          : in std_logic;
	
	rgb_info_red   : out std_logic;
	rgb_info_green : out std_logic;
	rgb_info_blue  : out std_logic;

  	-- Controller Modes
	i_Controller_Mode  : in std_logic_vector(3 downto 0);

    -- STM32 SPI Interface
    o_STM32_SPI_Clk      : out std_logic;
    i_STM32_SPI_MISO     : in  std_logic;
    o_STM32_SPI_MOSI     : out std_logic;
    o_STM32_SPI_CS_n     : out std_logic;

    -- TX (MOSI) Signals
    o_STM32_TX_Byte      : out  std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    o_STM32_TX_DV        : out  std_logic;
    o_STM32_TX_Ready     : out std_logic;

    -- RX (MISO) Signals
    o_STM32_RX_DV        : out std_logic;
    o_STM32_RX_Byte_Rising  : out std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);


    -- FIFO Signals
    o_FIFO_RHD2132_Data    : out std_logic_vector(31 downto 0);
	o_FIFO_RHD2132_COUNT   : out std_logic_vector(7 downto 0);
    o_FIFO_RHD2132_WE      : out std_logic;
    o_FIFO_RHD2132_RE      : out std_logic;
    o_FIFO_RHD2132_Q       : out std_logic_vector(31 downto 0);
    o_FIFO_RHD2132_EMPTY   : out std_logic;
    o_FIFO_RHD2132_FULL    : out std_logic;
    o_FIFO_RHD2132_AEMPTY  : out std_logic;
    o_FIFO_RHD2132_AFULL   : out std_logic;

    -- RHD SPI Interface
    o_RHD2132_SPI_Clk      : out std_logic;
    i_RHD2132_SPI_MISO     : in  std_logic;
    o_RHD2132_SPI_MOSI     : out std_logic;
    o_RHD2132_SPI_CS_n     : out std_logic;

    -- TX (MOSI) Signals
    o_RHD2132_TX_Byte      : out  std_logic_vector(15 downto 0);
    o_RHD2132_TX_DV        : out  std_logic;
    o_RHD2132_TX_Ready     : out  std_logic;

    -- RX (MISO) Signals
    o_RHD2132_RX_DV        : out std_logic;
    o_RHD2132_RX_Byte_Rising  : out std_logic_vector(15 downto 0);
    o_RHD2132_RX_Byte_Falling : out std_logic_vector(15 downto 0);
	
	o_FIFO_RHD2216_Data    : out std_logic_vector(31 downto 0);
	o_FIFO_RHD2216_COUNT   : out std_logic_vector(7 downto 0);
    o_FIFO_RHD2216_WE      : out std_logic;
    o_FIFO_RHD2216_RE      : out std_logic;
    o_FIFO_RHD2216_Q       : out std_logic_vector(31 downto 0);
    o_FIFO_RHD2216_EMPTY   : out std_logic;
    o_FIFO_RHD2216_FULL    : out std_logic;
    o_FIFO_RHD2216_AEMPTY  : out std_logic;
    o_FIFO_RHD2216_AFULL   : out std_logic;

    -- RHD SPI Interface
    o_RHD2216_SPI_Clk      : out std_logic;
    i_RHD2216_SPI_MISO     : in  std_logic;
    o_RHD2216_SPI_MOSI     : out std_logic;
    o_RHD2216_SPI_CS_n     : out std_logic;

    -- TX (MOSI) Signals
    o_RHD2216_TX_Byte      : out  std_logic_vector(15 downto 0);
    o_RHD2216_TX_DV        : out  std_logic;
    o_RHD2216_TX_Ready     : out  std_logic;

    -- RX (MISO) Signals
    o_RHD2216_RX_DV        : out std_logic;
    o_RHD2216_RX_Byte_Rising  : out std_logic_vector(15 downto 0);
    o_RHD2216_RX_Byte_Falling : out std_logic_vector(15 downto 0)
  );
end entity Controller_RHD_Sampling;

architecture RTL of Controller_RHD_Sampling is

  component Controller_RHD_FIFO is
    generic (
      SPI_MODE               : integer := 0;
      CLKS_PER_HALF_BIT      : integer := RHD2132_CLKS_PER_HALF_BIT;
      NUM_OF_BITS_PER_PACKET : integer := RHD2132_SPI_NUM_BITS_PER_PACKET;
      CS_INACTIVE_CLKS       : integer := RHD2132_CS_INACTIVE_CLKS
    );
    port (
      i_Rst_L            : in std_logic;
      i_Clk              : in std_logic;
      o_SPI_Clk          : out std_logic;
      i_SPI_MISO         : in  std_logic;
      o_SPI_MOSI         : out std_logic;
      o_SPI_CS_n         : out std_logic;
      i_TX_Byte          : in  std_logic_vector(15 downto 0);
      i_TX_DV            : in  std_logic;
      o_TX_Ready         : out std_logic;
      o_RX_DV            : out std_logic;
      o_RX_Byte_Rising   : out std_logic_vector(15 downto 0);
      o_RX_Byte_Falling  : out std_logic_vector(15 downto 0);
      o_FIFO_RHD2132_Data        : out std_logic_vector(31 downto 0);
      o_FIFO_RHD2132_COUNT       : out std_logic_vector(7 downto 0);
	  o_FIFO_RHD2132_WE          : out std_logic;
      i_FIFO_RHD2132_RE          : in std_logic;
      o_FIFO_RHD2132_Q           : out std_logic_vector(31 downto 0);
      o_FIFO_RHD2132_EMPTY       : out std_logic;
      o_FIFO_RHD2132_FULL        : out std_logic;
      o_FIFO_RHD2132_AEMPTY      : out std_logic;
      o_FIFO_RHD2132_AFULL       : out std_logic
    );
  end component;

  -- Component declaration for SPI_Master_CS
  component SPI_Master_CS is
    generic (
      SPI_MODE               : integer := 0;
      CLKS_PER_HALF_BIT      : integer := STM32_CLKS_PER_HALF_BIT;
      NUM_OF_BITS_PER_PACKET : integer := STM32_SPI_NUM_BITS_PER_PACKET;
      CS_INACTIVE_CLKS       : integer := STM32_CS_INACTIVE_CLKS
    );
    port (
      i_Rst_L    : in std_logic;     -- FPGA Reset
      i_Clk      : in std_logic;     -- FPGA Clock
      -- TX (MOSI) Signals
      i_TX_Byte  : in  std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);  -- Byte to transmit on MOSI
      i_TX_DV    : in  std_logic;     -- Data Valid Pulse with i_TX_Byte
      o_TX_Ready : out std_logic;     -- Transmit Ready for next byte
      -- RX (MISO) Signals
      o_RX_DV           : out std_logic;  -- Data Valid pulse (1 clock cycle)
      o_RX_Byte_Rising  : out std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);   -- Byte received on MISO Rising  CLK Edge
      o_RX_Byte_Falling : out std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);  -- Byte received on MISO Falling CLK Edge
      -- SPI Interface
      o_SPI_Clk  : out std_logic;
      i_SPI_MISO : in  std_logic;
      o_SPI_MOSI : out std_logic;
      o_SPI_CS_n : out std_logic
    );
  end component; 
	signal int_FIFO_RHD2132_Data    : std_logic_vector(31 downto 0);
	signal int_FIFO_RHD2132_COUNT   : std_logic_vector(7 downto 0);
	signal int_FIFO_RHD2132_WE      : std_logic;
	signal int_FIFO_RHD2132_RE      : std_logic;
	signal int_FIFO_RHD2132_Q       : std_logic_vector(31 downto 0);
	signal int_FIFO_RHD2132_EMPTY   : std_logic;
	signal int_FIFO_RHD2132_FULL    : std_logic;
	signal int_FIFO_RHD2132_AEMPTY  : std_logic;
	signal int_FIFO_RHD2132_AFULL   : std_logic;

	signal int_RHD2132_SPI_Clk      : std_logic;
	signal int_RHD2132_SPI_MISO     : std_logic;
	signal int_RHD2132_SPI_MOSI     : std_logic;
	signal int_RHD2132_SPI_CS_n     : std_logic;
	signal int_RHD2132_TX_Byte      : std_logic_vector(15 downto 0);
	signal int_RHD2132_TX_DV        : std_logic;
	signal int_RHD2132_TX_Ready     : std_logic;
	signal int_RHD2132_RX_DV        : std_logic;
	signal int_RHD2132_RX_Byte_Rising  : std_logic_vector(15 downto 0);
	signal int_RHD2132_RX_Byte_Falling : std_logic_vector(15 downto 0);

	signal int_STM32_SPI_Clk      : std_logic;
	signal int_STM32_SPI_MISO     : std_logic;
	signal int_STM32_SPI_MOSI     : std_logic;
	signal int_STM32_SPI_CS_n     : std_logic;
	signal int_STM32_TX_Byte      : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	signal int_STM32_TX_DV        : std_logic;
	signal int_STM32_TX_Ready     : std_logic;
	signal int_STM32_RX_DV        : std_logic;
	signal int_STM32_RX_Byte_Rising  : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);

	signal int_FIFO_RHD2216_Data    : std_logic_vector(31 downto 0);
	signal int_FIFO_RHD2216_COUNT   : std_logic_vector(7 downto 0);
	signal int_FIFO_RHD2216_WE      : std_logic;
	signal int_FIFO_RHD2216_RE      : std_logic;
	signal int_FIFO_RHD2216_Q       : std_logic_vector(31 downto 0);
	signal int_FIFO_RHD2216_EMPTY   : std_logic;
	signal int_FIFO_RHD2216_FULL    : std_logic;
	signal int_FIFO_RHD2216_AEMPTY  : std_logic;
	signal int_FIFO_RHD2216_AFULL   : std_logic;

	signal int_RHD2216_SPI_Clk      : std_logic;
	signal int_RHD2216_SPI_MISO     : std_logic;
	signal int_RHD2216_SPI_MOSI     : std_logic;
	signal int_RHD2216_SPI_CS_n     : std_logic;
	signal int_RHD2216_TX_Byte      : std_logic_vector(15 downto 0);
	signal int_RHD2216_TX_DV        : std_logic;
	signal int_RHD2216_TX_Ready     : std_logic;
	signal int_RHD2216_RX_DV        : std_logic;
	signal int_RHD2216_RX_Byte_Rising  : std_logic_vector(15 downto 0);
	signal int_RHD2216_RX_Byte_Falling : std_logic_vector(15 downto 0);

	signal stm32_counter : integer := 0; -- Counter to keep track of bits stored in temporary buffer
	signal counter      : integer := 0; -- Counter to control SendDataToRHDSPI

	signal stm32_state : integer := 0;

	signal SAMPLING_MODE : std_logic_vector(1 downto 0) := std_logic_vector(to_unsigned(RHD_SAMPLING_MODE, 2)); -- 0: Neuro Only - 1: EMG Only - 2: EMG + Neuro

	signal NUM_DATA : integer := 0;
	constant WORD_WIDTH : integer := 16;
	constant NUM_WORDS : integer := STM32_SPI_NUM_BITS_PER_PACKET / WORD_WIDTH;
	constant TOTAL_BITS : integer := STM32_SPI_NUM_BITS_PER_PACKET;
	signal temp_buffer : std_logic_vector(TOTAL_BITS-1 downto 0);
	signal word_count  : integer range 0 to NUM_WORDS := 0;
	--signal temp_buffer : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	
	signal init_FIFO_RHD2132_Read : std_logic;
	signal init_FIFO_RHD2216_Read : std_logic;
	
	type word_array_t is array (0 to 31) of std_logic_vector(15 downto 0); -- Adjust size
	
	signal first_rhd2132_packet : std_logic;
	signal first_rhd2216_packet : std_logic;
	signal rhd_index    : integer := 0;
	signal rhd_state    : integer := 0;
	
	signal alt_counter : integer := 0;
	
	signal RHD_Interval  : integer :=0;
		signal data_array_send_count : integer range 0 to 100 := 0;

	type t_data_array is array (0 to 63) of std_logic_vector(15 downto 0);
	
	signal temp_array : word_array_t := (others => (others => '0'));
	
	signal rgd_info_sig_red   : std_logic;
	signal rgd_info_sig_green : std_logic;
	signal rgd_info_sig_blue  : std_logic;


	signal data_array : t_data_array := (
		-- Registers 40–63
		0  => x"E800",  -- REG40
		1  => x"E900",  -- REG41
		2  => x"EA00",  -- REG42
		3  => x"EB00",  -- REG43
		4  => x"EC00",  -- REG44
		5  => x"FC00",  -- REG60
		6  => x"FD00",  -- REG61
		7  => x"FF00",  -- REG63

		-- Registers 0–7
		8  => x"80DE",
		9  => x"8120",
		10 => x"8228",
		11 => x"8302",
		12 => x"84D6",
		13 => x"8500",
		14 => x"8600",
		15 => x"8700",

		-- Bandwidth registers
		16 => x"881E",
		17 => x"8905",
		18 => x"8A2B",
		19 => x"8B06",
		20 => x"8C36",
		21 => x"8D00",

		-- Amp power
		22 => x"8EFF",
		23 => x"8FFF",
		24 => x"90FF",
		25 => x"91FF",
		26 => x"92FF",
		27 => x"93FF",
		28 => x"94FF",
		29 => x"95FF",

		-- Calibrate ADC
		30 => x"5500",

		-- Dummy reads (9 entries)
		31 => x"FF00",
		32 => x"FF00",
		33 => x"FF00",
		34 => x"FF00",
		35 => x"FF00",
		36 => x"FF00",
		37 => x"FF00",
		38 => x"FF00",
		39 => x"FF00",

		-- Repeat block 1
		40 => x"E800",
		41 => x"E900",
		42 => x"EA00",
		43 => x"EB00",
		44 => x"EC00",
		45 => x"FC00",
		46 => x"FD00",
		47 => x"FF00",

		-- Repeat block 2
		48 => x"E800",
		49 => x"E900",
		50 => x"EA00",
		51 => x"EB00",
		52 => x"EC00",
		53 => x"FC00",
		54 => x"FD00",
		55 => x"FF00",

		-- Repeat block 3
		56 => x"E800",
		57 => x"E900",
		58 => x"EA00",
		59 => x"EB00",
		60 => x"EC00",
		61 => x"FC00",
		62 => x"FD00",
		63 => x"FF00"
	);
	
	
	type t_channel_array is array (0 to 63) of std_logic_vector(15 downto 0);
	
	-- 16 CHANNEL VERSION
	signal channel_array : t_channel_array := (
		0  => x"0000",  -- CH0
		1  => x"0100",  -- CH1
		2  => x"0200",  -- CH2
		3  => x"0300",  -- CH3
		4  => x"0400",  -- CH4
		5  => x"0500",  -- CH5
		6  => x"0600",  -- CH6
		7  => x"0700",  -- CH7
		8  => x"0800",  -- CH8
		9  => x"0900",  -- CH9
		10 => x"0A00",  -- CH10
		11 => x"0B00",  -- CH11
		12 => x"0C00",  -- CH12
		13 => x"0D00",  -- CH13
		14 => x"E800",  -- CH14
		15 => x"0F00",  -- CH15
		
		16 => x"0000",  -- CH0
		17 => x"0100",  -- CH1
		18 => x"0200",  -- CH2
		19 => x"0300",  -- CH3
		20 => x"0400",  -- CH4
		21 => x"0500",  -- CH5
		22 => x"0600",  -- CH6
		23 => x"0700",  -- CH7
		24 => x"0800",  -- CH8
		25 => x"0900",  -- CH9
		26 => x"0A00",  -- CH10
		27 => x"0B00",  -- CH11
		28 => x"0C00",  -- CH12
		29 => x"0D00",  -- CH13
		30 => x"E800",  -- CH14
		31 => x"0F00",  -- CH15

		-- CH0–CH31 repeated again for indices 32–63
		32 => x"0000",  -- CH0 repeat
		33 => x"0100",  -- CH1 repeat
		34 => x"0200",  -- CH2 repeat
		35 => x"0300",  -- CH3 repeat
		36 => x"0400",  -- CH4 repeat
		37 => x"0500",  -- CH5 repeat
		38 => x"0600",  -- CH6 repeat
		39 => x"0700",  -- CH7 repeat
		40 => x"0800",  -- CH8 repeat
		41 => x"0900",  -- CH9 repeat
		42 => x"0A00",  -- CH10 repeat
		43 => x"0B00",  -- CH11 repeat
		44 => x"0C00",  -- CH12 repeat
		45 => x"0D00",  -- CH13 repeat
		46 => x"E800",  -- CH14 repeat
		47 => x"0F00",  -- CH15 repeat
		
		48 => x"0000",  -- CH0 repeat
		49 => x"0100",  -- CH1 repeat
		50 => x"0200",  -- CH2 repeat
		51 => x"0300",  -- CH3 repeat
		52 => x"0400",  -- CH4 repeat
		53 => x"0500",  -- CH5 repeat
		54 => x"0600",  -- CH6 repeat
		55 => x"0700",  -- CH7 repeat
		56 => x"0800",  -- CH8 repeat
		57 => x"0900",  -- CH9 repeat
		58 => x"0A00",  -- CH10 repeat
		59 => x"0B00",  -- CH11 repeat
		60 => x"0C00",  -- CH12 repeat
		61 => x"0D00",  -- CH13 repeat
		62 => x"E800",  -- CH14 repeat
		63 => x"0F00"   -- CH15 repeat
	);
	
	signal channel_array_rhd2216 : t_channel_array := (
		0  => x"E800",  -- CH0
		1  => x"E900",  -- CH1
		2  => x"EA00",  -- CH2
		3  => x"EB00",  -- CH3
		4  => x"EC00",  -- CH4
		5  => x"FC00",  -- CH5
		6  => x"FD00",  -- CH6
		7  => x"FF00",  -- CH7
		8  => x"E800",  -- CH8
		9  => x"E900",  -- CH9
		10 => x"EA00",  -- CH10
		11 => x"EB00",  -- CH11
		12 => x"EC00",  -- CH12
		13 => x"FC00",  -- CH13
		14 => x"FD00",  -- CH14
		15 => x"FF00",  -- CH15
		
		16 => x"0000",  -- CH0
		17 => x"0100",  -- CH1
		18 => x"0200",  -- CH2
		19 => x"0300",  -- CH3
		20 => x"0400",  -- CH4
		21 => x"0500",  -- CH5
		22 => x"0600",  -- CH6
		23 => x"0700",  -- CH7
		24 => x"0800",  -- CH8
		25 => x"0900",  -- CH9
		26 => x"0A00",  -- CH10
		27 => x"0B00",  -- CH11
		28 => x"0C00",  -- CH12
		29 => x"0D00",  -- CH13
		30 => x"E800",  -- CH14
		31 => x"0F00",  -- CH15

		-- CH0–CH31 repeated again for indices 32–63
		32 => x"0000",  -- CH0 repeat
		33 => x"0100",  -- CH1 repeat
		34 => x"0200",  -- CH2 repeat
		35 => x"0300",  -- CH3 repeat
		36 => x"0400",  -- CH4 repeat
		37 => x"0500",  -- CH5 repeat
		38 => x"0600",  -- CH6 repeat
		39 => x"0700",  -- CH7 repeat
		40 => x"0800",  -- CH8 repeat
		41 => x"0900",  -- CH9 repeat
		42 => x"0A00",  -- CH10 repeat
		43 => x"0B00",  -- CH11 repeat
		44 => x"0C00",  -- CH12 repeat
		45 => x"0D00",  -- CH13 repeat
		46 => x"E800",  -- CH14 repeat
		47 => x"0F00",  -- CH15 repeat
		
		48 => x"E800",  -- CH0 repeat
		49 => x"E900",  -- CH1 repeat
		50 => x"EA00",  -- CH2 repeat
		51 => x"EB00",  -- CH3 repeat
		52 => x"EC00",  -- CH4 repeat
		53 => x"FC00",  -- CH5 repeat
		54 => x"FD00",  -- CH6 repeat
		55 => x"FF00",  -- CH7 repeat
		56 => x"E800",  -- CH8 repeat
		57 => x"E900",  -- CH9 repeat
		58 => x"EA00",  -- CH10 repeat
		59 => x"EB00",  -- CH11 repeat
		60 => x"EC00",  -- CH12 repeat
		61 => x"FC00",  -- CH13 repeat
		62 => x"FD00",  -- CH14 repeat
		63 => x"FF00"   -- CH15 repeat
	);

	signal rhd_done_config : std_logic := '0';
	signal full_cycle_count  : integer := 0;


	begin
	  Controller_RHD_FIFO_1 : entity work.Controller_RHD_FIFO
		generic map (
		  SPI_MODE               => 0,
		  CLKS_PER_HALF_BIT      => RHD2132_CLKS_PER_HALF_BIT,
		  NUM_OF_BITS_PER_PACKET => RHD2132_SPI_NUM_BITS_PER_PACKET,
		  CS_INACTIVE_CLKS       => RHD2132_CS_INACTIVE_CLKS
		)
		port map (
		  i_Rst_L        	=> i_Rst_L,
		  i_Clk          	=> i_Clk,
		  i_Controller_Mode => i_Controller_Mode,
		  o_SPI_Clk      	=> o_RHD2132_SPI_Clk,
		  i_SPI_MISO     	=> i_RHD2132_SPI_MISO,
		  o_SPI_MOSI     	=> o_RHD2132_SPI_MOSI,
		  o_SPI_CS_n     	=> o_RHD2132_SPI_CS_n,
		  i_TX_Byte      	=> int_RHD2132_TX_Byte,
		  i_TX_DV        	=> int_RHD2132_TX_DV,
		  o_TX_Ready     	=> int_RHD2132_TX_Ready,
		  o_RX_DV        	=> o_RHD2132_RX_DV,
		  o_RX_Byte_Rising  => o_RHD2132_RX_Byte_Rising,
		  o_RX_Byte_Falling => o_RHD2132_RX_Byte_Falling,
		  o_FIFO_Data    => o_FIFO_RHD2132_Data,
		  o_FIFO_COUNT   => int_FIFO_RHD2132_COUNT,
		  o_FIFO_WE      => o_FIFO_RHD2132_WE,
		  i_FIFO_RE      => int_FIFO_RHD2132_RE,
		  o_FIFO_Q       => int_FIFO_RHD2132_Q,
		  o_FIFO_EMPTY   => int_FIFO_RHD2132_EMPTY,
		  o_FIFO_FULL    => int_FIFO_RHD2132_FULL,
		  o_FIFO_AEMPTY  => int_FIFO_RHD2132_AEMPTY,
		  o_FIFO_AFULL   => int_FIFO_RHD2132_AFULL
		);
		
		
		Controller_RHD_FIFO_2 : entity work.Controller_RHD_FIFO
		generic map (
		  SPI_MODE               => 0,
		  CLKS_PER_HALF_BIT      => RHD2216_CLKS_PER_HALF_BIT,
		  NUM_OF_BITS_PER_PACKET => RHD2216_SPI_NUM_BITS_PER_PACKET,
		  CS_INACTIVE_CLKS       => RHD2216_CS_INACTIVE_CLKS
		)
		port map (
		  i_Rst_L        	=> i_Rst_L,
		  i_Clk          	=> i_Clk,
		  i_Controller_Mode => i_Controller_Mode,
		  o_SPI_Clk      	=> o_RHD2216_SPI_Clk,
		  i_SPI_MISO     	=> i_RHD2216_SPI_MISO,
		  o_SPI_MOSI     	=> o_RHD2216_SPI_MOSI,
		  o_SPI_CS_n     	=> o_RHD2216_SPI_CS_n,
		  i_TX_Byte      	=> int_RHD2216_TX_Byte,
		  i_TX_DV        	=> int_RHD2216_TX_DV,
		  o_TX_Ready     	=> int_RHD2216_TX_Ready,
		  o_RX_DV        	=> o_RHD2216_RX_DV,
		  o_RX_Byte_Rising  => o_RHD2216_RX_Byte_Rising,
		  o_RX_Byte_Falling => o_RHD2216_RX_Byte_Falling,
		  o_FIFO_Data    => o_FIFO_RHD2216_Data,
		  o_FIFO_COUNT   => int_FIFO_RHD2216_COUNT,
		  o_FIFO_WE      => o_FIFO_RHD2216_WE,
		  i_FIFO_RE      => int_FIFO_RHD2216_RE,
		  o_FIFO_Q       => int_FIFO_RHD2216_Q,
		  o_FIFO_EMPTY   => int_FIFO_RHD2216_EMPTY,
		  o_FIFO_FULL    => int_FIFO_RHD2216_FULL,
		  o_FIFO_AEMPTY  => int_FIFO_RHD2216_AEMPTY,
		  o_FIFO_AFULL   => int_FIFO_RHD2216_AFULL
		);

	  -- SPI_Master_CS instantiation
	  SPI_Master_CS_STM32_1 : entity work.SPI_Master_CS
		generic map (
		  SPI_MODE               => 0,
		  CLKS_PER_HALF_BIT      => STM32_CLKS_PER_HALF_BIT,
		  NUM_OF_BITS_PER_PACKET => STM32_SPI_NUM_BITS_PER_PACKET,
		  CS_INACTIVE_CLKS       => STM32_CS_INACTIVE_CLKS
		)
		port map (
		  i_Rst_L            => i_Rst_L,
		  i_Clk              => i_Clk,
		  i_TX_Byte          => int_STM32_TX_Byte,
		  i_TX_DV            => int_STM32_TX_DV,
		  o_TX_Ready         => int_STM32_TX_Ready,
		  o_RX_DV            => o_STM32_RX_DV,
		  o_RX_Byte_Rising   => int_STM32_RX_Byte_Rising,  -- WILL ALWAYS BE EMPTY SINCE ITS ONLY A MOSI COMMUNNICATION
		  o_RX_Byte_Falling  => open,                      -- FALLING EDGE NOT BEING USE SINCE WE ARE NOT DOING DUAL DATA RATE FOR THIS COMMUNICATION

		  o_SPI_Clk  => o_STM32_SPI_CLK,
		  i_SPI_MISO => i_STM32_SPI_MISO,
		  o_SPI_MOSI => o_STM32_SPI_MOSI,
		  o_SPI_CS_n => o_STM32_SPI_CS_n
		);




	 --STM32 PROCESS, GETTING DATA FROM THE FIFO OF THE CONTROLER_RHD MODULE
	process (i_Clk)
	begin
	  if i_Rst_L = '1' then
		temp_buffer <= (others => '0');
		temp_array <= (others => (others => '0'));
		
		int_FIFO_RHD2132_RE <= '0';  -- Toggle back to '0'
		int_FIFO_RHD2216_RE <= '0';  -- Toggle back to '0'
		stm32_counter <= 0;  -- Reset counter on reset
		stm32_state <= 0;    -- Reset state
		int_STM32_TX_Byte <= (others => '0');
		int_STM32_TX_DV <= '0';
		init_FIFO_RHD2132_Read <= '0';
		init_FIFO_RHD2216_Read <= '0';
		alt_counter   <= 0;  
		first_rhd2132_packet <= '0';
		first_rhd2216_packet <= '0';
		
		RHD_Interval <= 0;
		
		if RHD2132_SPI_DDR_MODE = 1 then
			NUM_DATA <= (STM32_SPI_NUM_BITS_PER_PACKET / (2*RHD2132_SPI_NUM_BITS_PER_PACKET));
		else
			NUM_DATA <= (STM32_SPI_NUM_BITS_PER_PACKET / RHD2132_SPI_NUM_BITS_PER_PACKET);
		end if;
		
	  elsif rising_edge(i_Clk) then
		
		if i_Controller_Mode = x"0" then
			-- INIT RHD2132s FIFO
			if (SAMPLING_MODE = "00") or (SAMPLING_MODE = "10") then
				if init_FIFO_RHD2132_Read = '0' then
					int_FIFO_RHD2132_RE <= '1';
					init_FIFO_RHD2132_Read <= '1';
				else
					int_FIFO_RHD2132_RE <= '0';
				end if;
			end if;
			-- INIT RHD2216s FIFO
			if (SAMPLING_MODE = "01") or (SAMPLING_MODE = "10") then
				if init_FIFO_RHD2216_Read = '0' then
					int_FIFO_RHD2216_RE <= '1';
					init_FIFO_RHD2216_Read <= '1';
				else
					int_FIFO_RHD2216_RE <= '0';
				end if;
			end if;

		elsif i_Controller_Mode = x"2" then
			case stm32_state is
				when 0 =>
					if (SAMPLING_MODE = "00") or (SAMPLING_MODE = "10") then	
						if first_rhd2132_packet = '0' then
							if to_integer(unsigned(int_FIFO_RHD2132_COUNT)) >= (NUM_DATA + 2) then
								stm32_state <= 1; -- Move to next state
								int_FIFO_RHD2132_RE <= '1'; -- Enable FIFO data
								first_rhd2132_packet <= '1';
							else
								stm32_state <= 0;
							end if;
						else
							if to_integer(unsigned(int_FIFO_RHD2132_COUNT)) >= NUM_DATA then
								stm32_state <= 3; -- Move to next state
								int_FIFO_RHD2132_RE <= '1'; -- Enable FIFO data
							else
								stm32_state <= 0;
							end if;
						end if;
					
					elsif (SAMPLING_MODE = "01") or (SAMPLING_MODE = "10") then
						if first_rhd2216_packet = '0' then
							if to_integer(unsigned(int_FIFO_RHD2216_COUNT)) >= (NUM_DATA + 2) then
								stm32_state <= 14; -- Move to next state
								int_FIFO_RHD2216_RE <= '1'; -- Enable FIFO data
								first_rhd2216_packet <= '1';
							else
								stm32_state <= 0;
							end if;
						else
							if to_integer(unsigned(int_FIFO_RHD2216_COUNT)) >= NUM_DATA then
								stm32_state <= 16;           -- Move to next state
								int_FIFO_RHD2216_RE <= '1'; -- Enable FIFO data
							else
								stm32_state <= 0;
							end if;
						end if; 
					end if;
					
				when 1 =>
					stm32_state <= 2;
				when 2 =>
					stm32_state <= 3;
				when 3 =>
					stm32_state <= 4;
				when 4 =>
					stm32_state <= 5;
					 
				when 5 =>
					if stm32_counter < NUM_WORDS then
						if (stm32_counter mod 16) = 0 then
							--temp_buffer <= temp_buffer(TOTAL_BITS-WORD_WIDTH-1 downto 0) & (int_FIFO_RHD2132_Q(15 downto 0) OR x"0001");
							temp_buffer <= temp_buffer(TOTAL_BITS-WORD_WIDTH-1 downto 0) & x"0000";
						else
							temp_buffer <= temp_buffer(TOTAL_BITS-WORD_WIDTH-1 downto 0) & (int_FIFO_RHD2132_Q(15 downto 0) AND x"FFFE");
						end if;
						--temp_buffer <= temp_buffer(TOTAL_BITS-WORD_WIDTH-1 downto 0) & int_FIFO_RHD2132_Q(15 downto 0);

						stm32_counter <= stm32_counter + 1;
						int_FIFO_RHD2132_RE <= '1';
					else
						int_FIFO_RHD2132_RE <= '0';
						stm32_counter <= 0;
						stm32_state <= 6;
					end if;
					
				when 14 =>
					stm32_state <= 15;
				when 15 =>
					stm32_state <= 16;
				when 16 =>
					stm32_state <= 17;
				when 17 =>
					stm32_state <= 18;

				when 18 => 	 
					if stm32_counter < NUM_WORDS then
						if (stm32_counter mod 16) = 0 then
							--temp_buffer <= temp_buffer(TOTAL_BITS-WORD_WIDTH-1 downto 0) & (int_FIFO_RHD2216_Q(15 downto 0) OR x"0001");
							temp_buffer <= temp_buffer(TOTAL_BITS-WORD_WIDTH-1 downto 0) & x"0001";
						else
							temp_buffer <= temp_buffer(TOTAL_BITS-WORD_WIDTH-1 downto 0) & (int_FIFO_RHD2216_Q(15 downto 0) AND x"FFFE");
						end if;
						--temp_buffer <= temp_buffer(TOTAL_BITS-WORD_WIDTH-1 downto 0) & int_FIFO_RHD2132_Q(15 downto 0);

						stm32_counter <= stm32_counter + 1;
						int_FIFO_RHD2216_RE <= '1';
					else
						int_FIFO_RHD2216_RE <= '0';
						stm32_counter <= 0;
						stm32_state <= 6;
					end if;
			
				when 6 => 	 
					stm32_state <= 8;
			
				when 8 =>
					int_STM32_TX_Byte <= temp_buffer;
					int_STM32_TX_DV <= '1';
					stm32_state <= 9;
					
				when 9 =>

					int_STM32_TX_DV <= '0';
					stm32_state <= 10;
				
				when 10 =>
					if int_STM32_TX_Ready = '1' then
						stm32_state <= 11;
					else
						stm32_state <= 10;
					end if;
				when 11 => 
					stm32_state <= 0;
				when others =>
					null;
				end case;
			end if;
		  end if;
		end process;
	
	
	process (i_Clk)
	begin
		if i_Rst_L = '1' then
			int_RHD2132_TX_Byte     <= (others => '0');
			int_RHD2132_TX_DV       <= '0';
			int_RHD2216_TX_Byte     <= (others => '0');
			int_RHD2216_TX_DV       <= '0';
			rhd_index           <= 0;
			rhd_done_config     <= '0';
			data_array_send_count <= 0;
			rgd_info_sig_blue   <= '1';
			rgd_info_sig_green  <= '1';
			rgd_info_sig_red    <= '1';
			rhd_state           <= 0;
			
			full_cycle_count     <= 0;  -- reset new counter
		elsif rising_edge(i_Clk) then
			if i_Controller_Mode = x"1" then
				rgd_info_sig_blue <= '0';
				rgd_info_sig_green <= '1';
			elsif i_Controller_Mode = x"2" then
				rgd_info_sig_blue <= '1';
				case rhd_state is

					----------------------------------------------------------------
					-- STATE 0 : PREPARE NEXT BYTE
					----------------------------------------------------------------
					when 0 =>
						--if rhd_done_config = '0' then
							---- Configuration phase
							--int_RHD_TX_Byte <= data_array(rhd_index);
						--else
							--int_RHD_TX_Byte <= channel_array(rhd_index);
						--end if;
						
						--if rhd_index = 0 then
							---- Only change CH0 after 10,000 full loops
							--int_RHD_TX_Byte <= x"E800";
						--else
							--int_RHD_TX_Byte <= channel_array(rhd_index);
						--end if;
						if SAMPLING_MODE = "00" then
							int_RHD2132_TX_Byte <= channel_array(rhd_index);
							-- Wait until SPI/FIFO ready before sending
							if int_RHD2132_TX_Ready = '1' then
								int_RHD2132_TX_DV <= '1';   -- pulse DV for one cycle
								rhd_state <= 1;
							else
								int_RHD2132_TX_DV <= '0';
							end if;
							
						elsif SAMPLING_MODE = "01" then
							int_RHD2216_TX_Byte <= channel_array(rhd_index);
							-- Wait until SPI/FIFO ready before sending
							if int_RHD2216_TX_Ready = '1' then
								int_RHD2216_TX_DV <= '1';   -- pulse DV for one cycle
								rhd_state <= 1;
							else
								int_RHD2216_TX_DV <= '0';
							end if;
						end if;
						
						
					
					----------------------------------------------------------------
					-- STATE 1 : PULSE DV (ONE CYCLE)
					----------------------------------------------------------------
					when 1 =>
						if SAMPLING_MODE = "00" then
							int_RHD2132_TX_DV <= '0';
							-- Wait for Ready to drop (indicating transfer start)
							if int_RHD2132_TX_Ready = '0' then
								rhd_state <= 2;
							else
								rhd_state <= 1;
							end if;
						elsif SAMPLING_MODE = "01" then	
							int_RHD2216_TX_DV <= '0';
							-- Wait for Ready to drop (indicating transfer start)
							if int_RHD2216_TX_Ready = '0' then
								rhd_state <= 2;
							else
								rhd_state <= 1;
							end if;
						end if;
					----------------------------------------------------------------
					-- STATE 2 : WAIT FOR TRANSFER COMPLETE
					----------------------------------------------------------------
					when 2 =>
						-- Wait for Ready to return high (transfer complete)
						if (int_RHD2216_TX_Ready = '1') or (int_RHD2132_TX_Ready = '1')then
							if rhd_index < 63 then
								rhd_index <= rhd_index + 1;
							else
								rhd_index <= 0;
								-- USELESS FOR NOW BUT KEEPING IT JUST IN CASE
								if rhd_done_config = '0' then
									if data_array_send_count < 9 then
										data_array_send_count <= data_array_send_count + 1;
									else
										rhd_done_config <= '1'; 
									end if;
								else
									-- LOOP FOR LED BLINK STATUS
									if full_cycle_count < 9999 then
										full_cycle_count <= full_cycle_count + 1;
										rgd_info_sig_green <= '1';
									else
										full_cycle_count <= 0;
										rgd_info_sig_green <= '0';								
									end if;
								end if;
							end if;

							rhd_state <= 0;  -- Prepare next byte
						else
							rhd_state <= 2;  -- still busy
						end if;
					----------------------------------------------------------------
					-- DEFAULT
					----------------------------------------------------------------
					when others =>
						rhd_state <= 0;

				end case;

			else
				-- Inactive controller mode: keep DV low
				if SAMPLING_MODE = "00" then
					int_RHD2132_TX_DV <= '0';
				elsif SAMPLING_MODE = "01" then
					int_RHD2216_TX_DV <= '0';
				end if;
			end if;
		end if;
	end process;

	rgb_info_red   <= rgd_info_sig_red;
	rgb_info_green <= rgd_info_sig_green;
	rgb_info_blue  <= rgd_info_sig_blue;

	o_NUM_DATA      <= NUM_DATA;
	o_STM32_State   <= stm32_state;
	o_stm32_counter <= stm32_counter;
	
	o_STM32_RX_Byte_Rising <= int_STM32_RX_Byte_Rising;
	o_STM32_TX_Byte  <= int_STM32_TX_Byte;
	o_STM32_TX_DV    <= int_STM32_TX_DV;
	o_STM32_TX_Ready <= int_STM32_TX_Ready;
	
	o_RHD2132_TX_Byte  <= int_RHD2132_TX_Byte;
	o_RHD2132_TX_DV    <= int_RHD2132_TX_DV;
	o_RHD2132_TX_Ready <= int_RHD2132_TX_Ready;
	

	o_RHD2216_TX_Byte  <= int_RHD2216_TX_Byte;	
	o_RHD2216_TX_DV    <= int_RHD2216_TX_DV;
	o_RHD2216_TX_Ready <= int_RHD2216_TX_Ready;

	o_FIFO_RHD2132_RE 	   <= int_FIFO_RHD2132_RE;  
	o_FIFO_RHD2132_COUNT   <= int_FIFO_RHD2132_COUNT;
	o_FIFO_RHD2132_Q       <= int_FIFO_RHD2132_Q;
	o_FIFO_RHD2132_EMPTY   <= int_FIFO_RHD2132_EMPTY;
	o_FIFO_RHD2132_FULL    <= int_FIFO_RHD2132_FULL;
	o_FIFO_RHD2132_AEMPTY  <= int_FIFO_RHD2132_AEMPTY;
	o_FIFO_RHD2132_AFULL   <= int_FIFO_RHD2132_AFULL;
	
	o_FIFO_RHD2216_RE 	   <= int_FIFO_RHD2216_RE;
	o_FIFO_RHD2216_COUNT   <= int_FIFO_RHD2216_COUNT;
	o_FIFO_RHD2216_Q       <= int_FIFO_RHD2216_Q;
	o_FIFO_RHD2216_EMPTY   <= int_FIFO_RHD2216_EMPTY;
	o_FIFO_RHD2216_FULL    <= int_FIFO_RHD2216_FULL;
	o_FIFO_RHD2216_AEMPTY  <= int_FIFO_RHD2216_AEMPTY;
	o_FIFO_RHD2216_AFULL   <= int_FIFO_RHD2216_AFULL;

end architecture RTL;