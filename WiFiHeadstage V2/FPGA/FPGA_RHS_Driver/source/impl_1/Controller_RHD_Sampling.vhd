library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_RHD_Sampling is
  generic (
      STM32_CLKS_PER_HALF_BIT 		: integer := 256;
      STM32_SPI_NUM_BITS_PER_PACKET : integer := 1;
	  STM32_CS_INACTIVE_CLKS		: integer := 4;
	  
	  RHD2132_SPI_DDR_MODE 				: integer := 1;
	  
      RHD2132_SPI_NUM_BITS_PER_PACKET 	: integer := 16;
      RHD2132_CLKS_PER_HALF_BIT 		: integer := 1;
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
	o_FIFO_RHD2132_COUNT   : out std_logic_vector(8 downto 0);
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
    o_RHD2132_TX_Byte      : out  std_logic_vector(RHD2132_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    o_RHD2132_TX_DV        : out  std_logic;
    o_RHD2132_TX_Ready     : out  std_logic;

    -- RX (MISO) Signals
    o_RHD2132_RX_DV        : out std_logic;
    o_RHD2132_RX_Byte_Rising  : out std_logic_vector(RHD2132_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    o_RHD2132_RX_Byte_Falling : out std_logic_vector(RHD2132_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	
	o_FIFO_RHD2216_Data    : out std_logic_vector(31 downto 0);
	o_FIFO_RHD2216_COUNT   : out std_logic_vector(8 downto 0);
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
      i_TX_Byte          : in  std_logic_vector(RHD2132_SPI_NUM_BITS_PER_PACKET-1 downto 0);
      i_TX_DV            : in  std_logic;
      o_TX_Ready         : out std_logic;
      o_RX_DV            : out std_logic;
      o_RX_Byte_Rising   : out std_logic_vector(RHD2132_SPI_NUM_BITS_PER_PACKET-1 downto 0);
      o_RX_Byte_Falling  : out std_logic_vector(RHD2132_SPI_NUM_BITS_PER_PACKET-1 downto 0);
      o_FIFO_RHD2132_Data        : out std_logic_vector(31 downto 0);
      o_FIFO_RHD2132_COUNT       : out std_logic_vector(8 downto 0);
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
	signal int_FIFO_RHD2132_COUNT   : std_logic_vector(8 downto 0);
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
	signal int_RHD2132_TX_Byte      : std_logic_vector(RHD2132_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	signal int_RHD2132_TX_DV        : std_logic;
	signal int_RHD2132_TX_Ready     : std_logic;
	signal int_RHD2132_RX_DV        : std_logic;
	signal int_RHD2132_RX_Byte_Rising  : std_logic_vector(RHD2132_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	signal int_RHD2132_RX_Byte_Falling : std_logic_vector(RHD2132_SPI_NUM_BITS_PER_PACKET-1 downto 0);

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
	signal int_FIFO_RHD2216_COUNT   : std_logic_vector(8 downto 0);
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
	signal Sampling_Mode_State_1 : integer := RHD_SAMPLING_MODE;
	signal Sampling_Mode_State_2 : integer := RHD_SAMPLING_MODE;
	signal Sampling_Mode_State_3 : integer := RHD_SAMPLING_MODE;

	signal SAMPLING_MODE : std_logic_vector(1 downto 0) := std_logic_vector(to_unsigned(RHD_SAMPLING_MODE, 2)); -- 0: Neuro Only - 1: EMG Only - 2: EMG + Neuro

	signal NUM_DATA : integer := 0;
	constant WORD_WIDTH : integer := 16;
	constant NUM_WORDS : integer := STM32_SPI_NUM_BITS_PER_PACKET / WORD_WIDTH;
	constant TOTAL_BITS : integer := STM32_SPI_NUM_BITS_PER_PACKET;
	signal temp_buffer : std_logic_vector(TOTAL_BITS-1 downto 0);
	signal word_count  : integer range 0 to NUM_WORDS := 0;
	--signal temp_buffer : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	
	signal init_FIFO_RHD2132_Counter : integer := 0;
	signal init_FIFO_RHD2132_Read : std_logic;
	signal init_FIFO_RHD2216_Read : std_logic;
	
	signal first_rhd2132_packet : std_logic;
	signal first_rhd2216_packet : std_logic;
	
	signal rhd_index    : integer := 0;
	signal rhd_state    : integer := 0;
	signal rhd2216_index    : integer := 0;
	signal rhd2216_state    : integer := 0;
	
	signal alt_counter : integer := 0;
	
	signal RHD_Interval_Counter  : integer :=0;
	
	signal rgd_info_sig_red   : std_logic;
	signal rgd_info_sig_green : std_logic;
	signal rgd_info_sig_blue  : std_logic;
		
	signal tx_buffer : std_logic_vector(TOTAL_BITS-1 downto 0);
	
	signal chip_toggle : std_logic := '0';

	
	
	type t_channel_array is array (0 to 63) of std_logic_vector(RHD2132_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	
	-- READ INTAN ASCII
	signal channel_array_intan : t_channel_array := (
		0  => x"C0FB0000",  -- I and N
		1  => x"C0FC0000",  -- T and A
		2  => x"C0FD0000",  -- N and 0
		3  => x"C0FE0000",  -- #CH and Die Rev.
		4  => x"C0FB0000",  -- I and N
		5  => x"C0FC0000",  -- T and A
		6  => x"C0FD0000",  -- N and 0
		7  => x"C0FF0000",  -- 0 and Chip ID(32)

		8  => x"C0FB0000",  -- I and N
		9  => x"C0FC0000",  -- T and A
		10 => x"C0FD0000",  -- N and 0
		11 => x"C0FE0000",  -- #CH and Die Rev.
		12 => x"C0FB0000",  -- I and N
		13 => x"C0FC0000",  -- T and A
		14 => x"C0FD0000",  -- N and 0
		15 => x"C0FF0000",  -- 0 and Chip ID(32)

		16 => x"C0FB0000",  -- I and N
		17 => x"C0FC0000",  -- T and A
		18 => x"C0FD0000",  -- N and 0
		19 => x"C0FE0000",  -- #CH and Die Rev.
		20 => x"C0FB0000",  -- I and N
		21 => x"C0FC0000",  -- T and A
		22 => x"C0FD0000",  -- N and 0
		23 => x"C0FF0000",  -- 0 and Chip ID(32)

		24 => x"C0FB0000",  -- I and N
		25 => x"C0FC0000",  -- T and A
		26 => x"C0FD0000",  -- N and 0
		27 => x"C0FE0000",  -- #CH and Die Rev.
		28 => x"C0FB0000",  -- I and N
		29 => x"C0FC0000",  -- T and A
		30 => x"C0FD0000",  -- N and 0
		31 => x"C0FF0000",  -- 0 and Chip ID(32)

		32 => x"C0FB0000",  -- I and N
		33 => x"C0FC0000",  -- T and A
		34 => x"C0FD0000",  -- N and 0
		35 => x"C0FE0000",  -- #CH and Die Rev.
		36 => x"C0FB0000",  -- I and N
		37 => x"C0FC0000",  -- T and A
		38 => x"C0FD0000",  -- N and 0
		39 => x"C0FF0000",  -- 0 and Chip ID(32)

		40 => x"C0FB0000",  -- I and N
		41 => x"C0FC0000",  -- T and A
		42 => x"C0FD0000",  -- N and 0
		43 => x"C0FE0000",  -- #CH and Die Rev.
		44 => x"C0FB0000",  -- I and N
		45 => x"C0FC0000",  -- T and A
		46 => x"C0FD0000",  -- N and 0
		47 => x"C0FF0000",  -- 0 and Chip ID(32)

		48 => x"C0FB0000",  -- I and N
		49 => x"C0FC0000",  -- T and A
		50 => x"C0FD0000",  -- N and 0
		51 => x"C0FE0000",  -- #CH and Die Rev.
		52 => x"C0FB0000",  -- I and N
		53 => x"C0FC0000",  -- T and A
		54 => x"C0FD0000",  -- N and 0
		55 => x"C0FF0000",  -- 0 and Chip ID(32)

		56 => x"C0FB0000",  -- I and N
		57 => x"C0FC0000",  -- T and A
		58 => x"C0FD0000",  -- N and 0
		59 => x"C0FE0000",  -- #CH and Die Rev.
		60 => x"C0FB0000",  -- I and N
		61 => x"C0FC0000",  -- T and A
		62 => x"C0FD0000",  -- N and 0
		63 => x"C0FF0000"   -- 0 and Chip ID(32)
	);
	
	-- READ CHANNELS
	signal channel_array : t_channel_array := (
		0  => x"00000000",  -- CH0
		1  => x"00010000",  -- CH1
		2  => x"00020000",  -- CH2
		3  => x"00030000",  -- CH3
		4  => x"00040000",  -- CH4
		5  => x"00050000",  -- CH5
		6  => x"00060000",  -- CH6
		7  => x"00070000",  -- CH7
		8  => x"00080000",  -- CH8
		9  => x"00090000",  -- CH9
		10 => x"000A0000",  -- CH10
		11 => x"000B0000",  -- CH11
		12 => x"000C0000",  -- CH12
		13 => x"000D0000",  -- CH13
		14 => x"000E0000",  -- CH14
		15 => x"000F0000",  -- CH15

		16 => x"00000000",  -- CH0
		17 => x"00010000",  -- CH1
		18 => x"00020000",  -- CH2
		19 => x"00030000",  -- CH3
		20 => x"00040000",  -- CH4
		21 => x"00050000",  -- CH5
		22 => x"00060000",  -- CH6
		23 => x"00070000",  -- CH7
		24 => x"00080000",  -- CH8
		25 => x"00090000",  -- CH9
		26 => x"000A0000",  -- CH10
		27 => x"000B0000",  -- CH11
		28 => x"000C0000",  -- CH12
		29 => x"000D0000",  -- CH13
		30 => x"000E0000",  -- CH14
		31 => x"000F0000",  -- CH15

		32 => x"00000000",  -- CH0
		33 => x"00010000",  -- CH1
		34 => x"00020000",  -- CH2
		35 => x"00030000",  -- CH3
		36 => x"00040000",  -- CH4
		37 => x"00050000",  -- CH5
		38 => x"00060000",  -- CH6
		39 => x"00070000",  -- CH7
		40 => x"00080000",  -- CH8
		41 => x"00090000",  -- CH9
		42 => x"000A0000",  -- CH10
		43 => x"000B0000",  -- CH11
		44 => x"000C0000",  -- CH12
		45 => x"000D0000",  -- CH13
		46 => x"000E0000",  -- CH14
		47 => x"000F0000",  -- CH15

		48 => x"00000000",  -- CH0
		49 => x"00010000",  -- CH1
		50 => x"00020000",  -- CH2
		51 => x"00030000",  -- CH3
		52 => x"00040000",  -- CH4
		53 => x"00050000",  -- CH5
		54 => x"00060000",  -- CH6
		55 => x"00070000",  -- CH7
		56 => x"00080000",  -- CH8
		57 => x"00090000",  -- CH9
		58 => x"000A0000",  -- CH10
		59 => x"000B0000",  -- CH11
		60 => x"000C0000",  -- CH12
		61 => x"000D0000",  -- CH13
		62 => x"000E0000",  -- CH14
		63 => x"000F0000"   -- CH15
	);
	
	signal channel_array_test : t_channel_array := (
		0  => x"C0FB0000",  -- CH0
		1  => x"00010000",  -- CH1
		2  => x"00020000",  -- CH2
		3  => x"00030000",  -- CH3
		4  => x"00040000",  -- CH4
		5  => x"00050000",  -- CH5
		6  => x"00060000",  -- CH6
		7  => x"00070000",  -- CH7
		8  => x"00080000",  -- CH8
		9  => x"00090000",  -- CH9
		10 => x"000A0000",  -- CH10
		11 => x"000B0000",  -- CH11
		12 => x"000C0000",  -- CH12
		13 => x"000D0000",  -- CH13
		14 => x"000E0000",  -- CH14
		15 => x"000F0000",  -- CH15

		16 => x"C0FC0000",  -- CH0
		17 => x"00010000",  -- CH1
		18 => x"00020000",  -- CH2
		19 => x"00030000",  -- CH3
		20 => x"00040000",  -- CH4
		21 => x"00050000",  -- CH5
		22 => x"00060000",  -- CH6
		23 => x"00070000",  -- CH7
		24 => x"00080000",  -- CH8
		25 => x"00090000",  -- CH9
		26 => x"000A0000",  -- CH10
		27 => x"000B0000",  -- CH11
		28 => x"000C0000",  -- CH12
		29 => x"000D0000",  -- CH13
		30 => x"000E0000",  -- CH14
		31 => x"000F0000",  -- CH15

		32 => x"C0FD0000",  -- CH0
		33 => x"00010000",  -- CH1
		34 => x"00020000",  -- CH2
		35 => x"00030000",  -- CH3
		36 => x"00040000",  -- CH4
		37 => x"00050000",  -- CH5
		38 => x"00060000",  -- CH6
		39 => x"00070000",  -- CH7
		40 => x"00080000",  -- CH8
		41 => x"00090000",  -- CH9
		42 => x"000A0000",  -- CH10
		43 => x"000B0000",  -- CH11
		44 => x"000C0000",  -- CH12
		45 => x"000D0000",  -- CH13
		46 => x"000E0000",  -- CH14
		47 => x"000F0000",  -- CH15

		48 => x"C0FE0000",  -- CH0
		49 => x"00010000",  -- CH1
		50 => x"00020000",  -- CH2
		51 => x"00030000",  -- CH3
		52 => x"00040000",  -- CH4
		53 => x"00050000",  -- CH5
		54 => x"00060000",  -- CH6
		55 => x"00070000",  -- CH7
		56 => x"00080000",  -- CH8
		57 => x"00090000",  -- CH9
		58 => x"000A0000",  -- CH10
		59 => x"000B0000",  -- CH11
		60 => x"000C0000",  -- CH12
		61 => x"000D0000",  -- CH13
		62 => x"000E0000",  -- CH14
		63 => x"000F0000"   -- CH15
	);

	
	signal mux_RHD2132_SPI_MISO : STD_LOGIC;
	signal mux_RHD2132_SPI_CS_n : STD_LOGIC;
	signal use_rhd2132 : std_logic;

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
		  i_SPI_MISO     	=> mux_RHD2132_SPI_MISO,
		  o_SPI_MOSI     	=> o_RHD2132_SPI_MOSI,
		  o_SPI_CS_n     	=> mux_RHD2132_SPI_CS_n,

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
	--local variable (declare at top of process!)
	begin
	  if i_Rst_L = '1' then
		temp_buffer <= (others => '0');
		
		int_FIFO_RHD2132_RE <= '0';  -- Toggle back to '0'
		int_FIFO_RHD2216_RE <= '0';  -- Toggle back to '0'
		stm32_counter <= 0;  -- Reset counter on reset
		stm32_state <= 0;    -- Reset state
		int_STM32_TX_Byte <= (others => '0');
		int_STM32_TX_DV <= '0';
		init_FIFO_RHD2132_Read <= '0';
		init_FIFO_RHD2132_Counter <= 0;
		init_FIFO_RHD2216_Read <= '0';
		first_rhd2132_packet <= '0';
		first_rhd2216_packet <= '0';
		
		chip_toggle <= '0';
		RHD_Interval_Counter <= 0;
		
		alt_counter   <= 0;  
		
		rgd_info_sig_blue   <= '1';
		

	    NUM_DATA <= 2*(STM32_SPI_NUM_BITS_PER_PACKET / RHD2132_SPI_NUM_BITS_PER_PACKET);
	
		
	  elsif rising_edge(i_Clk) then
		--int_FIFO_RHD2132_RE <= '0'; 
		if i_Controller_Mode = x"0" then
			-- INIT RHD2132s FIFO
			if init_FIFO_RHD2132_Read = '0' then
				int_FIFO_RHD2132_RE <= '1';
				init_FIFO_RHD2132_Read <= '1';
			else
				int_FIFO_RHD2132_RE <= '0';
			end if;
			rgd_info_sig_blue   <= '1';
						
		elsif i_Controller_Mode = x"2" then 
			case stm32_state is
				when 0 =>
					rgd_info_sig_blue   <= '0';
					int_FIFO_RHD2132_RE <= '0';
				
					if (to_integer(unsigned(int_FIFO_RHD2132_COUNT)) >= ((NUM_DATA) + 2)) and (first_rhd2132_packet = '0') then
						stm32_state <= 1;
						int_FIFO_RHD2132_RE <= '1'; -- START READ
						first_rhd2132_packet <= '1';
					elsif (to_integer(unsigned(int_FIFO_RHD2132_COUNT)) >= (NUM_DATA)) and (first_rhd2132_packet = '1') then
						stm32_state <= 3;
						int_FIFO_RHD2132_RE <= '1'; 
					else
						stm32_state <= 0;
					end if;
				
				when 1 =>
					stm32_state <= 2;
					int_FIFO_RHD2132_RE <= '1'; -- START READ
				when 2 =>
					stm32_state <= 3;
					int_FIFO_RHD2132_RE <= '1'; -- START READ
				when 3 =>
					stm32_state <= 4;
				when 4 =>
					stm32_state <= 5;
					
				when 5 =>
					if stm32_counter > (NUM_WORDS-2) then 
						int_FIFO_RHD2132_RE <= '0'; 
					end if;
				
					if stm32_counter < (NUM_WORDS) then
						if (stm32_counter mod 16) = 0 then
						    temp_buffer(TOTAL_BITS - (stm32_counter*16) - 1 downto TOTAL_BITS - ((stm32_counter+1)*16)) <= std_logic_vector(to_unsigned(RHD_Interval_Counter, 16)) or x"0001"; -- set LSB
							--temp_buffer(TOTAL_BITS - (stm32_counter*16) - 1 downto TOTAL_BITS - ((stm32_counter+1)*16)) <= int_FIFO_RHD2132_Q(31 downto 16) or x"0001"; -- set LSB
						else
							temp_buffer(TOTAL_BITS - (stm32_counter*16) - 1 downto TOTAL_BITS - ((stm32_counter+1)*16)) <= int_FIFO_RHD2132_Q(31 downto 16) and x"FFFE"; -- clear LSB
						end if;	
		
						alt_counter <= alt_counter + 1;
						stm32_counter <= stm32_counter + 1;
					else
						if alt_counter > 14 then
							alt_counter <= 0;
							if RHD_Interval_Counter > 62 then
								RHD_Interval_Counter <= 0;
							else
								RHD_Interval_Counter <= RHD_Interval_Counter + 1;
							end if;	
						end if;
						stm32_state <= 6;				
					end if;
			
				when 6 =>
					stm32_state <= 7;
					int_FIFO_RHD2132_RE <= '0';
					int_FIFO_RHD2216_RE <= '0'; 					
				when 7 =>
					stm32_counter <= 0;				
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
						stm32_state <= 0;
					else
						stm32_state <= 10;
					end if;
				
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
			rhd_index           <= 0;
			rhd_state           <= 0;
			rgd_info_sig_red   <= '1';
			rgd_info_sig_green   <= '1';
			use_rhd2132 <= '1';
			
		elsif rising_edge(i_Clk) then
			if i_Controller_Mode = x"1" then
				rgd_info_sig_red   <= '0';
				rgd_info_sig_green   <= '0';
				
			elsif i_Controller_Mode = x"2" then
				rgd_info_sig_red   <= '1';
				rgd_info_sig_green   <= '1';
				if SAMPLING_MODE = "00" or SAMPLING_MODE = "10" then
					case rhd_state is
						----------------------------------------------------------------
						-- STATE 0 : PREPARE NEXT BYTE
						----------------------------------------------------------------
						when 0 =>

							int_RHD2132_TX_Byte <= channel_array(rhd_index);

							if int_RHD2132_TX_Ready = '1' then
								int_RHD2132_TX_DV <= '1';   -- pulse DV for one cycle
								rhd_state <= 1;
							else
								int_RHD2132_TX_DV <= '0';
							end if;

						----------------------------------------------------------------
						-- STATE 1 : PULSE DV (ONE CYCLE)
						----------------------------------------------------------------
						when 1 =>
							int_RHD2132_TX_DV <= '0';
							-- Wait for Ready to drop (indicating transfer start)
							if int_RHD2132_TX_Ready = '0' then
								rhd_state <= 2;
							else
								rhd_state <= 1;
							end if;

						----------------------------------------------------------------
						-- STATE 2 : WAIT FOR TRANSFER COMPLETE
						----------------------------------------------------------------
						when 2 =>
							if int_RHD2132_TX_Ready = '1' then

								if rhd_index < 63 then
									rhd_index <= rhd_index + 1;
								else
									rhd_index <= 0;
								end if;

								---- CHIP SELECTION LOGIC
								if (rhd_index < 16) or ((rhd_index >= 32) and (rhd_index < 48)) then
									use_rhd2132 <= '1';
								else
									use_rhd2132 <= '0';
								end if;

								rhd_state <= 0;
							end if;

						when others =>
							rhd_state <= 0;
					end case;
				end if;
			else
				-- Inactive controller mode: keep DV low
				int_RHD2132_TX_DV <= '0';

			end if;
		end if;
	end process;
	
	
	mux_RHD2132_SPI_MISO <= i_RHD2132_SPI_MISO when use_rhd2132 = '1'
                       else i_RHD2216_SPI_MISO;
	
	o_RHD2132_SPI_CS_n <= mux_RHD2132_SPI_CS_n when use_rhd2132 = '1' else '1';

	o_RHD2216_SPI_CS_n <= mux_RHD2132_SPI_CS_n when use_rhd2132 = '0' else '1';

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