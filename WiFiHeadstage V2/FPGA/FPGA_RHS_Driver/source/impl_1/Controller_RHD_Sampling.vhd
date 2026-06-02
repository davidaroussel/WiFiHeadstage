library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_RHD_Sampling is
  generic (
	STM32_SPI_NUM_BITS_PER_PACKET : integer := 512;
	STM32_CLKS_PER_HALF_BIT       : integer := 4;
	STM32_CS_INACTIVE_CLKS        : integer := 16;
	
	RHS_READ_SPI_NUM_BITS_PER_PACKET : integer := 32;
	RHS_READ_CLKS_PER_HALF_BIT       : integer := 4;
	RHS_READ_CS_INACTIVE_CLKS        : integer := 32;

	RHS_STIM_SPI_NUM_BITS_PER_PACKET : integer := 32;
	RHS_STIM_CLKS_PER_HALF_BIT       : integer := 2;    -- 32 for around 2.5KHz
	RHS_STIM_CS_INACTIVE_CLKS        : integer := 32;
	  
	  RHS_SAMPLING_MODE 		: integer := 0
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
    o_FIFO_RHS_READ_Data    : out std_logic_vector(31 downto 0);
	o_FIFO_RHS_READ_COUNT   : out std_logic_vector(8 downto 0);
    o_FIFO_RHS_READ_WE      : out std_logic;
    o_FIFO_RHS_READ_RE      : out std_logic;
    o_FIFO_RHS_READ_Q       : out std_logic_vector(31 downto 0);
    o_FIFO_RHS_READ_EMPTY   : out std_logic;
    o_FIFO_RHS_READ_FULL    : out std_logic;
    o_FIFO_RHS_READ_AEMPTY  : out std_logic;
    o_FIFO_RHS_READ_AFULL   : out std_logic;

    -- RHD SPI Interface
    o_RHS_READ_SPI_Clk      : out std_logic;
    i_RHS_READ_SPI_MISO_1   : in  std_logic;
	i_RHS_READ_SPI_MISO_2   : in  std_logic;
    o_RHS_READ_SPI_MOSI     : out std_logic;
    o_RHS_READ_SPI_CS_n_1   : out std_logic;
	o_RHS_READ_SPI_CS_n_2   : out std_logic;

    -- TX (MOSI) Signals
    o_RHS_READ_TX_Byte      : out  std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    o_RHS_READ_TX_DV        : out  std_logic;
    o_RHS_READ_TX_Ready     : out  std_logic;

    -- RX (MISO) Signals
    o_RHS_READ_RX_DV        : out std_logic;
    o_RHS_READ_RX_Byte_Rising  : out std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    o_RHS_READ_RX_Byte_Falling : out std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	
	o_FIFO_RHS_STIM_Data    : out std_logic_vector(RHS_STIM_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	o_FIFO_RHS_STIM_COUNT   : out std_logic_vector(8 downto 0);
    o_FIFO_RHS_STIM_WE      : out std_logic;
    o_FIFO_RHS_STIM_RE      : out std_logic;
    o_FIFO_RHS_STIM_Q       : out std_logic_vector(RHS_STIM_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    o_FIFO_RHS_STIM_EMPTY   : out std_logic;
    o_FIFO_RHS_STIM_FULL    : out std_logic;
    o_FIFO_RHS_STIM_AEMPTY  : out std_logic;
    o_FIFO_RHS_STIM_AFULL   : out std_logic;

    -- RHD SPI Interface
    o_RHS_STIM_SPI_Clk      : out std_logic;
    i_RHS_STIM_SPI_MISO_1   : in  std_logic;
	i_RHS_STIM_SPI_MISO_2   : in  std_logic;
    o_RHS_STIM_SPI_MOSI     : out std_logic;
    o_RHS_STIM_SPI_CS_n_1   : out std_logic;
    o_RHS_STIM_SPI_CS_n_2   : out std_logic;

    -- TX (MOSI) Signals
    o_RHS_STIM_TX_Byte      : out  std_logic_vector(RHS_STIM_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    o_RHS_STIM_TX_DV        : out  std_logic;
    o_RHS_STIM_TX_Ready     : out  std_logic;

    -- RX (MISO) Signals
    o_RHS_STIM_RX_DV        : out std_logic;
    o_RHS_STIM_RX_Byte_Rising  : out std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
    o_RHS_STIM_RX_Byte_Falling : out std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	
	o_stim_burst_counter_debug       : out std_logic_vector(7 downto 0);
	o_stim_10sec_counter_debug : out std_logic_vector(31 downto 0);
	o_stim_1sec_counter_debug  : out std_logic_vector(31 downto 0);
	o_stim_train_counter_debug      : out std_logic_vector(7 downto 0);
	o_stim_pulse_counter_debug      : out std_logic_vector(7 downto 0);
	o_stim_sequence_phase_debug     : out std_logic_vector(7 downto 0);
	o_stim_delay_counter_debug      : out std_logic_vector(31 downto 0);
	o_rhs_STIM_state_debug          : out std_logic_vector(7 downto 0);
	o_rhs_STIM_index_debug          : out std_logic_vector(7 downto 0);
	o_stim_train_sector_counter_debug : out std_logic_vector(4 downto 0)
  );
end entity Controller_RHD_Sampling;

architecture RTL of Controller_RHD_Sampling is

  component Controller_RHD_FIFO is
    generic (
      SPI_MODE               : integer := 0;
      CLKS_PER_HALF_BIT      : integer := RHS_READ_CLKS_PER_HALF_BIT;
      NUM_OF_BITS_PER_PACKET : integer := RHS_READ_SPI_NUM_BITS_PER_PACKET;
      CS_INACTIVE_CLKS       : integer := RHS_READ_CS_INACTIVE_CLKS
    );
    port (
      i_Rst_L            : in std_logic;
      i_Clk              : in std_logic;
      o_SPI_Clk          : out std_logic;
      i_SPI_MISO         : in  std_logic;
      o_SPI_MOSI         : out std_logic;
      o_SPI_CS_n         : out std_logic;
      i_TX_Byte          : in  std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
      i_TX_DV            : in  std_logic;
      o_TX_Ready         : out std_logic;
      o_RX_DV            : out std_logic;
      o_RX_Byte_Rising   : out std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
      o_RX_Byte_Falling  : out std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
      o_FIFO_RHS_READ_Data        : out std_logic_vector(31 downto 0);
      o_FIFO_RHS_READ_COUNT       : out std_logic_vector(8 downto 0);
	  o_FIFO_RHS_READ_WE          : out std_logic;
      i_FIFO_RHS_READ_RE          : in std_logic;
      o_FIFO_RHS_READ_Q           : out std_logic_vector(31 downto 0);
      o_FIFO_RHS_READ_EMPTY       : out std_logic;
      o_FIFO_RHS_READ_FULL        : out std_logic;
      o_FIFO_RHS_READ_AEMPTY      : out std_logic;
      o_FIFO_RHS_READ_AFULL       : out std_logic
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
	signal int_FIFO_RHS_READ_Data    : std_logic_vector(31 downto 0);
	signal int_FIFO_RHS_READ_COUNT   : std_logic_vector(8 downto 0);
	signal int_FIFO_RHS_READ_WE      : std_logic;
	signal int_FIFO_RHS_READ_RE      : std_logic;
	signal int_FIFO_RHS_READ_Q       : std_logic_vector(31 downto 0);
	signal int_FIFO_RHS_READ_EMPTY   : std_logic;
	signal int_FIFO_RHS_READ_FULL    : std_logic;
	signal int_FIFO_RHS_READ_AEMPTY  : std_logic;
	signal int_FIFO_RHS_READ_AFULL   : std_logic;

	signal int_RHS_READ_SPI_Clk      : std_logic;
	signal int_RHS_READ_SPI_MISO     : std_logic;
	signal int_RHS_READ_SPI_MOSI     : std_logic;
	signal int_RHS_READ_SPI_CS_n     : std_logic;
	signal int_RHS_READ_TX_Byte      : std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	signal int_RHS_READ_TX_DV        : std_logic;
	signal int_RHS_READ_TX_Ready     : std_logic;
	signal int_RHS_READ_RX_DV        : std_logic;
	signal int_RHS_READ_RX_Byte_Rising  : std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	signal int_RHS_READ_RX_Byte_Falling : std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);

	signal int_STM32_SPI_Clk      : std_logic;
	signal int_STM32_SPI_MISO     : std_logic;
	signal int_STM32_SPI_MOSI     : std_logic;
	signal int_STM32_SPI_CS_n     : std_logic;
	signal int_STM32_TX_Byte      : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	signal int_STM32_TX_DV        : std_logic;
	signal int_STM32_TX_Ready     : std_logic;
	signal int_STM32_RX_DV        : std_logic;
	signal int_STM32_RX_Byte_Rising  : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);

	signal int_FIFO_RHS_STIM_Data    : std_logic_vector(31 downto 0);
	signal int_FIFO_RHS_STIM_COUNT   : std_logic_vector(8 downto 0);
	signal int_FIFO_RHS_STIM_WE      : std_logic;
	signal int_FIFO_RHS_STIM_RE      : std_logic;
	signal int_FIFO_RHS_STIM_Q       : std_logic_vector(31 downto 0);
	signal int_FIFO_RHS_STIM_EMPTY   : std_logic;
	signal int_FIFO_RHS_STIM_FULL    : std_logic;
	signal int_FIFO_RHS_STIM_AEMPTY  : std_logic;
	signal int_FIFO_RHS_STIM_AFULL   : std_logic;

	signal int_RHS_STIM_SPI_Clk      : std_logic;
	signal int_RHS_STIM_SPI_MISO     : std_logic;
	signal int_RHS_STIM_SPI_MOSI     : std_logic;
	signal int_RHS_STIM_SPI_CS_n     : std_logic;
	signal int_RHS_STIM_TX_Byte      : std_logic_vector(RHS_STIM_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	signal int_RHS_STIM_TX_DV        : std_logic;
	signal int_RHS_STIM_TX_Ready     : std_logic;
	signal int_RHS_STIM_RX_DV        : std_logic;
	signal int_RHS_STIM_RX_Byte_Rising  : std_logic_vector(RHS_STIM_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	signal int_RHS_STIM_RX_Byte_Falling : std_logic_vector(RHS_STIM_SPI_NUM_BITS_PER_PACKET-1 downto 0);

	signal stm32_counter : integer := 0; -- Counter to keep track of bits stored in temporary buffer
	signal counter      : integer := 0; -- Counter to control SendDataToRHDSPI

	signal stm32_state : integer := 0;

	signal SAMPLING_MODE : std_logic_vector(1 downto 0) := std_logic_vector(to_unsigned(RHS_SAMPLING_MODE, 2)); -- 0: Neuro Only - 1: EMG Only - 2: EMG + Neuro

	signal NUM_DATA : integer := 0;
	constant WORD_WIDTH : integer := 16;
	constant NUM_WORDS : integer := STM32_SPI_NUM_BITS_PER_PACKET / WORD_WIDTH;
	constant TOTAL_BITS : integer := STM32_SPI_NUM_BITS_PER_PACKET;
	signal temp_buffer : std_logic_vector(TOTAL_BITS-1 downto 0);
	signal word_count  : integer range 0 to NUM_WORDS := 0;

	signal init_FIFO_RHS_READ : std_logic;
	signal init_FIFO_RHS_STIM : std_logic;
	
	signal first_rhs_READ_packet : std_logic;
	signal first_rhs_STIM_packet : std_logic;
	
	signal rhd_state           : integer range 0 to 7   := 0;
	signal rhd_index           : integer range 0 to 63  := 0;
	signal rhs_STIM_index    : integer := 0;
	signal rhs_STIM_state : integer range 0 to 15 := 0;
	

	signal alt_counter : integer := 0;
	
	signal RHD_Interval_Counter  : integer := 0;
	
	signal rgd_info_sig_red   : std_logic;
	signal rgd_info_sig_green : std_logic;
	signal rgd_info_sig_blue  : std_logic;
	
	type t_channel_array is array (0 to 63) of std_logic_vector(RHS_READ_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	
	-- READ INTAN ASCII
	signal channel_array_intan : t_channel_array := (
		0  => x"C0FB0000",  -- I and N
		1  => x"C0FB0000",  -- T and A
		2  => x"C0FB0000",  -- N and 0
		3  => x"C0FB0000",  -- #CH and Die Rev.
		4  => x"C0FC0000",  -- I and N
		5  => x"C0FC0000",  -- T and A
		6  => x"C0FC0000",  -- N and 0
		7  => x"C0FC0000",  -- 0 and Chip ID(32)

		8  => x"C0FB0000",  -- I and N
		9  => x"C0FC0000",  -- T and A
		10 => x"C0FD0000",  -- N and 0
		11 => x"C0FE0000",  -- #CH and Die Rev.
		12 => x"C0FB0000",  -- I and N
		13 => x"C0FC0000",  -- T and A
		14 => x"C0FD0000",  -- N and 0
		15 => x"C0FF0000",  -- 0 and Chip ID(32)

		16 => x"C0FE0000",  -- I and N
		17 => x"C0FE0000",  -- T and A
		18 => x"C0FE0000",  -- N and 0
		19 => x"C0FE0000",  -- #CH and Die Rev.
		20 => x"C0FF0000",  -- I and N
		21 => x"C0FF0000",  -- T and A
		22 => x"C0FF0000",  -- N and 0
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
	
	-- STIMULATION SEQUENCE
	signal channel_array_STIM : t_channel_array := (

		-- STIMULATION LOOP
		0 => x"A0408003",  -- NEG STIM Current MAG		: WRITE+U - REG64 to REG79   | NEG_trim | NEG_MAG 
		1 => x"8020AAAA",  -- Enable STIM				: WRITE - REG32   | SPECIAL_VALUE (0b1010101010101010 OU 0xAAAA)
		2 => x"802100FF",  -- Enable STIM				: WRITE - REG33   | SPECIAL_VALUE (0b0000000011111111 OU 0x00FF)
		3 => x"A02C0000",  -- Stimulation Polarity      : WRITE+U - REG44 | stim_pol | (Starting with NEG - 0x0000)
		4 => x"A02A0001",  -- STIM ON/[OFF] 			: WRITE+U - REG42 |  CH_STAT | (SELECTED CHANNEL  - 0x0001)
		5 => x"8026FFFF",  -- PowerUp_LowGain_Amp		: WRITE - REG38
		-- 200uS Delay for NEGATIVE PHASE
		6 => x"A0608003",  -- POS STIM Current MAG		: WRITE+U - REG96 to REG101  | POS_trim | POS_MAG
		7 => x"A02CFFFF",  -- Stimulation Polarity      : WRITE+U - REG44 | stim_pol | (Next to POS - 0xFFFF)
		8 => x"A02A0001",  -- STIM ON/[OFF] 			: WRITE+U - REG42 |  CH_STAT | (SELECTED CHANNEL  - 0x0001)
		-- 200uS Delay for POSITIVE PHASE
		9  => x"80200000",  -- Disable Stim 			: WRITE - REG32
		10 => x"80210000",  -- Disable Stim				: WRITE - REG33
		11 => x"A02A0000",  -- STIM ON/[OFF] 			: WRITE+U - REG42 |  CH_STAT | (TURN OFF ALL CH - 0x0000)
		12 => x"000C0000",  -- NOT USED
		13 => x"000D0000",  -- NOT USED
		14 => x"000E0000",  -- NOT USED
		15 => x"000F0000",  -- NOT USED

		-- INITIALIZATION LOOP
		--0  => x"C0FB0000",  -- Disable Stim 			: WRITE - REG32
		--1  => x"00010000",  -- Disable Stim				: WRITE - REG33
		--2  => x"00020000",  -- PowerUp_LowGain_Amp		: WRITE - REG38
		--3  => x"00030000",  -- Stimulation Step Size	: WRITE - REG34   |   SEL1   |  SEL2  | SEL3
		--4  => x"00040000",  -- Stimulation Bias 		: WRITE - REG35   |  N_BIAS  | P_BIAS 
		--5  => x"00050000",  -- Volt Charge Recovery		: WRITE - REG36   |  Rec_DAC |
		--6  => x"00060000",  -- Amp  Charge Recovery     : WRITE - REG37   |   SEL1   |  SEL2  | SEL3
		--7  => x"00070000",  -- STIM ON/[OFF] 			: WRITE+U - REG42 |  CH_STAT | (TURN OFF ALL CH - 0x0000)
		--8  => x"00080000",  -- Stimulation Polarity     : WRITE+U - REG44 | stim_pol | (TURN OFF ALL CH - 0x0000)
		--9  => x"00090000",  -- Charge Recovery SW		: WRITE+U - REG46 | reco_SW  | (TURN OFF ALL CH - 0x0000)
		--10 => x"000A0000",  -- Amp Max Charge Recovery  : WRITE+U - REG48 | CL_reco  | (TURN OFF ALL CH - 0x0000)
		--11 => x"000B0000",  -- NEG STIM Current MAG		: WRITE+U - REG64 to REG79   | NEG_trim | NEG_MAG
		--12 => x"000C0000",  -- POS STIM Current MAG		: WRITE+U - REG96 to REG101  | POS_trim | POS_MAG
		--13 => x"000D0000",  -- Enable STIM				: WRITE - REG32   | SPECIAL_VALUE (0b1010101010101010)
		--14 => x"000E0000",  -- Enable STIM				: WRITE - REG33   | SPECIAL_VALUE (0b0000000011111111)
		--15 => x"000F0000",  -- CH15

		-- SAMPLING LOOP
		16 => x"A0408003",  -- CH0 - NEG PULSE
		17 => x"A0418003",  -- CH1 - NEG PULSE
		18 => x"A0428003",  -- CH2 - NEG PULSE
		19 => x"A0438003",  -- CH3 - NEG PULSE
		20 => x"A0448003",  -- CH4 - NEG PULSE
		21 => x"A0458003",  -- CH5 - NEG PULSE
		22 => x"A0468003",  -- CH6 - NEG PULSE
		23 => x"A0478003",  -- CH7 - NEG PULSE
		24 => x"A0488003",  -- CH8 - NEG PULSE
		25 => x"A0498003",  -- CH9 - NEG PULSE
		26 => x"A04A8003",  -- CH10 - NEG PULSE
		27 => x"A04B8003",  -- CH11 - NEG PULSE
		28 => x"A04C8003",  -- CH12 - NEG PULSE
		29 => x"A04D8003",  -- CH13 - NEG PULSE
		30 => x"A04E8003",  -- CH14 - NEG PULSE
		31 => x"A04F8003",  -- CH15 - NEG PULSE

		32 => x"A0608003",  -- CH0 - POS PULSE
		33 => x"A0618003",  -- CH1 - POS PULSE
		34 => x"A0628003",  -- CH2 - POS PULSE
		35 => x"A0638003",  -- CH3 - POS PULSE
		36 => x"A0648003",  -- CH4 - POS PULSE
		37 => x"A0658003",  -- CH5 - POS PULSE
		38 => x"A0668003",  -- CH6 - POS PULSE
		39 => x"A0678003",  -- CH7 - POS PULSE
		40 => x"A0688003",  -- CH8 - POS PULSE
		41 => x"A0698003",  -- CH9 - POS PULSE
		42 => x"A06A8003",  -- CH10 - POS PULSE
		43 => x"A06B8003",  -- CH11 - POS PULSE
		44 => x"A06C8003",  -- CH12 - POS PULSE
		45 => x"A06D8003",  -- CH13 - POS PULSE
		46 => x"A06E8003",  -- CH14 - POS PULSE
		47 => x"A06F8003",  -- CH15 - POS PULSE

		48 => x"A02A0001",  -- CH0
		49 => x"A02A0002",  -- CH1
		50 => x"A02A0004",  -- CH2
		51 => x"A02A0008",  -- CH3
		52 => x"A02A0010",  -- CH4
		53 => x"A02A0020",  -- CH5
		54 => x"A02A0040",  -- CH6
		55 => x"A02A0080",  -- CH7
		56 => x"A02A0100",  -- CH8
		57 => x"A02A0200",  -- CH9
		58 => x"A02A0400",  -- CH10
		59 => x"A02A0800",  -- CH11
		60 => x"A02A1000",  -- CH12
		61 => x"A02A2000",  -- CH13
		62 => x"A02A4000",  -- CH14
		63 => x"A02A8000"   -- CH15
	);

	
	signal mux_RHS_READ_SPI_MISO : STD_LOGIC;
	signal mux_RHS_READ_SPI_CS_n : STD_LOGIC;
	signal chip_select_RHS_READ : std_logic;
	
	signal mux_RHS_STIM_SPI_MISO : STD_LOGIC;
	signal mux_RHS_STIM_SPI_CS_n : STD_LOGIC;
	signal chip_select_RHS_STIM : std_logic;
	
	signal stim_delay_counter    	 : integer range 0 to 250000000 := 0;
	signal stim_1sec_counter     	 : integer range 0 to 250000000 := 0;
	signal stim_10sec_counter    	 : integer range 0 to 250000000 := 0;
	signal stim_burst_counter    	 : integer range 0 to 15  := 0;
	signal stim_sequence_phase   	 : integer range 0 to 3   := 0;
	signal stim_pulse_counter    	 : integer range 0 to 31  := 0;
	signal stim_train_counter    	 : integer range 0 to 63 := 0;
	signal stim_train_sector_counter : integer range 0 to 10 := 0;
	
	
	signal stim_channel_index : integer  range 0 to 31 := 0;

	
	signal stim_train_flag       	 : std_logic := '0';	
	signal stim_sector_flag       	 : std_logic := '0';	

	constant CLK_FREQ_HZ       : integer := 24000000;

	constant DELAY_200uS_CLKS  : integer := 4800;
	constant DELAY_3mS_CLKS    : integer := 84500;
	constant DELAY_1S_CLKS     : integer := 24000000;
	constant DELAY_10S_CLKS    : integer := 48000000;
	
	signal delay_10s_counter : integer range 0 to 10 := 0;

	constant STIM_FIRST_PACKET        : integer := 6;
	constant STIM_SECOND_PACKET       : integer := 3;
	constant STIM_THIRD_PACKET        : integer := 3;

	constant STIM_PULSE_NUM  : integer := 13;
	constant STIM_TRAIN_NUM  : integer := 1;
	constant STIM_TRAIN_SECTOR : integer := 4;
	
	signal blink_counter : integer := 0;
	
	signal tx_ready_d : std_logic := '0';
	signal tx_ready_rise : std_logic;
	
	signal one_second_done     : std_logic := '0';
	signal one_second_counter  : integer range 0 to DELAY_1S_CLKS := 0;

	signal ten_second_counter  : integer range 0 to 9 := 0;
	signal stim_ch : integer := 0;

	begin
	  Controller_RHD_FIFO_1 : entity work.Controller_RHD_FIFO
		generic map (
		  SPI_MODE               => 0,
		  CLKS_PER_HALF_BIT      => RHS_READ_CLKS_PER_HALF_BIT,
		  NUM_OF_BITS_PER_PACKET => RHS_READ_SPI_NUM_BITS_PER_PACKET,
		  CS_INACTIVE_CLKS       => RHS_READ_CS_INACTIVE_CLKS
		)
		port map (
		  i_Rst_L        	=> i_Rst_L,
		  i_Clk          	=> i_Clk,
		  i_Controller_Mode => i_Controller_Mode,
		  
		  o_SPI_Clk      	=> o_RHS_READ_SPI_Clk,
		  i_SPI_MISO     	=> mux_RHS_READ_SPI_MISO,
		  o_SPI_MOSI     	=> o_RHS_READ_SPI_MOSI,
		  o_SPI_CS_n     	=> mux_RHS_READ_SPI_CS_n,

		  i_TX_Byte      	=> int_RHS_READ_TX_Byte,
		  i_TX_DV        	=> int_RHS_READ_TX_DV,
		  o_TX_Ready     	=> int_RHS_READ_TX_Ready,
		  o_RX_DV        	=> o_RHS_READ_RX_DV,
		  o_RX_Byte_Rising  => o_RHS_READ_RX_Byte_Rising,
		  o_RX_Byte_Falling => o_RHS_READ_RX_Byte_Falling,
		  o_FIFO_Data    => o_FIFO_RHS_READ_Data,
		  o_FIFO_COUNT   => int_FIFO_RHS_READ_COUNT,
		  o_FIFO_WE      => o_FIFO_RHS_READ_WE,
		  i_FIFO_RE      => int_FIFO_RHS_READ_RE,
		  o_FIFO_Q       => int_FIFO_RHS_READ_Q,
		  o_FIFO_EMPTY   => int_FIFO_RHS_READ_EMPTY,
		  o_FIFO_FULL    => int_FIFO_RHS_READ_FULL,
		  o_FIFO_AEMPTY  => int_FIFO_RHS_READ_AEMPTY,
		  o_FIFO_AFULL   => int_FIFO_RHS_READ_AFULL
		);
		
	  Controller_RHD_FIFO_2 : entity work.Controller_RHD_FIFO
		generic map (
		  SPI_MODE               => 0,
		  CLKS_PER_HALF_BIT      => RHS_STIM_CLKS_PER_HALF_BIT,
		  NUM_OF_BITS_PER_PACKET => RHS_STIM_SPI_NUM_BITS_PER_PACKET,
		  CS_INACTIVE_CLKS       => RHS_STIM_CS_INACTIVE_CLKS
		)
		port map (
		  i_Rst_L        	=> i_Rst_L,
		  i_Clk          	=> i_Clk,
		  i_Controller_Mode => i_Controller_Mode,
		  
		  o_SPI_Clk      	=> o_RHS_STIM_SPI_Clk,
		  i_SPI_MISO     	=> mux_RHS_STIM_SPI_MISO,
		  o_SPI_MOSI     	=> o_RHS_STIM_SPI_MOSI,
		  o_SPI_CS_n     	=> mux_RHS_STIM_SPI_CS_n,

		  i_TX_Byte      	=> int_RHS_STIM_TX_Byte,
		  i_TX_DV        	=> int_RHS_STIM_TX_DV,
		  o_TX_Ready     	=> int_RHS_STIM_TX_Ready,
		  o_RX_DV        	=> o_RHS_STIM_RX_DV,
		  o_RX_Byte_Rising  => o_RHS_STIM_RX_Byte_Rising,
		  o_RX_Byte_Falling => o_RHS_STIM_RX_Byte_Falling,
		  o_FIFO_Data    => o_FIFO_RHS_STIM_Data,
		  o_FIFO_COUNT   => int_FIFO_RHS_STIM_COUNT,
		  o_FIFO_WE      => o_FIFO_RHS_STIM_WE,
		  i_FIFO_RE      => int_FIFO_RHS_STIM_RE,
		  o_FIFO_Q       => int_FIFO_RHS_STIM_Q,
		  o_FIFO_EMPTY   => int_FIFO_RHS_STIM_EMPTY,
		  o_FIFO_FULL    => int_FIFO_RHS_STIM_FULL,
		  o_FIFO_AEMPTY  => int_FIFO_RHS_STIM_AEMPTY,
		  o_FIFO_AFULL   => int_FIFO_RHS_STIM_AFULL
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
		
		int_FIFO_RHS_READ_RE <= '0';  -- Toggle back to '0'
		stm32_counter <= 0;  -- Reset counter on reset
		stm32_state <= 0;    -- Reset state
		int_STM32_TX_Byte <= (others => '0');
		int_STM32_TX_DV <= '0';
		init_FIFO_RHS_READ <= '0';
		first_rhs_READ_packet <= '0';
		
		RHD_Interval_Counter <= 0;
		
		alt_counter   <= 0;  
		
		rgd_info_sig_green   <= '1';
		

	    NUM_DATA <= 2*(STM32_SPI_NUM_BITS_PER_PACKET / RHS_READ_SPI_NUM_BITS_PER_PACKET);
	
		
	  elsif rising_edge(i_Clk) then
		--int_FIFO_RHS_READ_RE <= '0'; 
		if i_Controller_Mode = x"0" then
			-- INIT RHS_READs FIFO
			if init_FIFO_RHS_READ = '0' then
				int_FIFO_RHS_READ_RE <= '1';
				init_FIFO_RHS_READ <= '1';
			else
				int_FIFO_RHS_READ_RE <= '0';
			end if;
			rgd_info_sig_green   <= '0';
						
		elsif i_Controller_Mode = x"2" then 
			case stm32_state is
				when 0 =>
					rgd_info_sig_green   <= '1';
					int_FIFO_RHS_READ_RE <= '0';
				
					if (to_integer(unsigned(int_FIFO_RHS_READ_COUNT)) >= ((NUM_DATA) + 2)) and (first_rhs_READ_packet = '0') then
						stm32_state <= 1;
						int_FIFO_RHS_READ_RE <= '1'; -- START READ
						first_rhs_READ_packet <= '1';
					elsif (to_integer(unsigned(int_FIFO_RHS_READ_COUNT)) >= (NUM_DATA)) and (first_rhs_READ_packet = '1') then
						stm32_state <= 3;
						int_FIFO_RHS_READ_RE <= '1'; 
					else
						stm32_state <= 0;
					end if;
				
				when 1 =>
					stm32_state <= 2;
					int_FIFO_RHS_READ_RE <= '1'; -- START READ
				when 2 =>
					stm32_state <= 3;
					int_FIFO_RHS_READ_RE <= '1'; -- START READ
				when 3 =>
					stm32_state <= 4;
				when 4 =>
					stm32_state <= 5;
					
				when 5 =>
					if stm32_counter > (NUM_WORDS-3) then 
						int_FIFO_RHS_READ_RE <= '0'; 
					end if;
				
					if stm32_counter < (NUM_WORDS) then
						if (stm32_counter mod 16) = 0 then
						    --temp_buffer(TOTAL_BITS - (stm32_counter*16) - 1 downto TOTAL_BITS - ((stm32_counter+1)*16)) <= std_logic_vector(to_unsigned(RHD_Interval_Counter, 16)) or x"0001"; -- set LSB
							temp_buffer(TOTAL_BITS - (stm32_counter*16) - 1 downto TOTAL_BITS - ((stm32_counter+1)*16)) <= int_FIFO_RHS_READ_Q(31 downto 16) or x"0001"; -- set LSB
						elsif (stm32_counter mod 16) = 1 then
							if stim_train_flag = '1' then
								temp_buffer(TOTAL_BITS - (stm32_counter*16) - 1 downto TOTAL_BITS - ((stm32_counter+1)*16)) <= int_FIFO_RHS_READ_Q(31 downto 16) or x"0001"; -- set LSB
							else
								temp_buffer(TOTAL_BITS - (stm32_counter*16) - 1 downto TOTAL_BITS - ((stm32_counter+1)*16)) <= int_FIFO_RHS_READ_Q(31 downto 16) and x"FFFE"; -- clear LSB
							end if;
						else
							temp_buffer(TOTAL_BITS - (stm32_counter*16) - 1 downto TOTAL_BITS - ((stm32_counter+1)*16)) <= int_FIFO_RHS_READ_Q(31 downto 16) and x"FFFE"; -- clear LSB
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
					int_FIFO_RHS_READ_RE <= '0';				
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
			int_RHS_READ_TX_Byte     <= (others => '0');
			int_RHS_READ_TX_DV       <= '0';
			rhd_index           <= 0;
			rhd_state           <= 0;
			rgd_info_sig_red   <= '1';
			chip_select_RHS_READ <= '1';
			
		elsif rising_edge(i_Clk) then
			if i_Controller_Mode = x"1" then
				rgd_info_sig_red   <= '0';
				
			elsif i_Controller_Mode = x"2" then
				rgd_info_sig_red   <= '1';
				if SAMPLING_MODE = "00" or SAMPLING_MODE = "10" then
					case rhd_state is
						----------------------------------------------------------------
						-- STATE 0 : PREPARE NEXT BYTE
						----------------------------------------------------------------
						when 0 =>

							int_RHS_READ_TX_Byte <= channel_array(rhd_index);

							if int_RHS_READ_TX_Ready = '1' then
								int_RHS_READ_TX_DV <= '1';   -- pulse DV for one cycle
								rhd_state <= 1;
							else
								int_RHS_READ_TX_DV <= '0';
							end if;

						----------------------------------------------------------------
						-- STATE 1 : PULSE DV (ONE CYCLE)
						----------------------------------------------------------------
						when 1 =>
							int_RHS_READ_TX_DV <= '0';
							-- Wait for Ready to drop (indicating transfer start)
							if int_RHS_READ_TX_Ready = '0' then
								rhd_state <= 2;
							else
								rhd_state <= 1;
							end if;

						----------------------------------------------------------------
						-- STATE 2 : WAIT FOR TRANSFER COMPLETE
						----------------------------------------------------------------
						when 2 =>
							if int_RHS_READ_TX_Ready = '1' then

								if rhd_index < 31 then
									rhd_index <= rhd_index + 1;
								else
									rhd_index <= 0;
								end if;

								---- CHIP SELECTION LOGIC
								if (rhd_index < 16) then
									chip_select_RHS_READ <= '1';
								else
									chip_select_RHS_READ  <= '0';
								end if;

								rhd_state <= 0;
							end if;

						when others =>
							rhd_state <= 0;
					end case;
				end if;
			else
				-- Inactive controller mode: keep DV low
				int_RHS_READ_TX_DV <= '0';

			end if;
		end if;
	end process;
	
	


	process (i_Clk)
	begin
	  if i_Rst_L = '1' then
		int_RHS_STIM_TX_Byte   <= (others => '0');
		int_RHS_STIM_TX_DV     <= '0';
		rhs_STIM_state         <= 0;
		--chip_select_RHS_STIM   <= '1';
		stim_pulse_counter     <= 0;
		stim_delay_counter     <= 0;
		stim_1sec_counter  <= 0;
		stim_10sec_counter <= 0;
		stim_burst_counter     <= 0;
		stim_sequence_phase    <= 0;
		stim_train_flag        <= '0';
		stim_sector_flag        <= '0';
		stim_train_counter     <= 0;
		rgd_info_sig_blue     <= '1';
		stim_train_sector_counter <= 0;

	  elsif rising_edge(i_Clk) then

		-- Default
		int_RHS_STIM_TX_DV <= '0';

		if i_Controller_Mode = x"2" then
		  rgd_info_sig_blue <= '0';

		  case rhs_STIM_state is

			-- ============================================================
			-- STATE 0 : SELECT BYTE TO SEND
			-- ============================================================
			when 0 =>
			  -- Pick the correct SPI word based on phase and burst position
			  case stim_sequence_phase is
				when 0 =>   -- NEGATIVE PHASE (6 packets: indices 0..5)
				  if stim_burst_counter = 0 then
					-- index 1 + 16 = 17  (Enable STIM, special word from upper bank)
					int_RHS_STIM_TX_Byte <= channel_array_STIM(stim_ch + 16);
				  elsif stim_burst_counter = 4 then
					-- index 1 + 48 = 49  (CH_STAT select word)
					int_RHS_STIM_TX_Byte <= channel_array_STIM(stim_ch + 48); 
				  else
					-- indices 0,1,2,3,4,5 ? burst_counter directly
					int_RHS_STIM_TX_Byte <= channel_array_STIM(stim_burst_counter);
				  end if;

				when 1 =>   -- POSITIVE PHASE (3 packets: indices 6..8)
				  if stim_burst_counter = 0 then
					-- index 1 + 32 = 33
					int_RHS_STIM_TX_Byte <= channel_array_STIM(stim_ch + 32);
				  elsif stim_burst_counter = 2 then
					-- index 1 + 48 = 49
					int_RHS_STIM_TX_Byte <= channel_array_STIM(stim_ch + 48);
				  else
					-- 6 + burst_counter
					int_RHS_STIM_TX_Byte <= channel_array_STIM(6 + stim_burst_counter);
				  end if;

				when 2 =>   -- DISABLE PHASE (3 packets: indices 9..11)
				  int_RHS_STIM_TX_Byte <= channel_array_STIM(9 + stim_burst_counter);

				when others =>
				  int_RHS_STIM_TX_Byte <= channel_array_STIM(0);
			  end case;

			  rhs_STIM_state <= 1;   -- always proceed to send

			-- ============================================================
			-- STATE 1 : WAIT FOR TX READY, THEN ASSERT DV
			-- ============================================================
			when 1 =>
			  if int_RHS_STIM_TX_Ready = '1' then
				int_RHS_STIM_TX_DV <= '1';
				rhs_STIM_state <= 2;
			  end if;

			when 2 =>
			  int_RHS_STIM_TX_DV <= '0';
			  rhs_STIM_state <= 12;  -- immediately move on			  

			when 12 =>
				if int_RHS_STIM_TX_Ready = '0' then
					rhs_STIM_state <= 3;
				end if;


			-- ============================================================
			-- STATE 3 : WAIT FOR TX COMPLETE
			-- ============================================================
			when 3 =>
			  if int_RHS_STIM_TX_Ready = '1' then

				-- PHASE 0 : NEGATIVE
				if stim_sequence_phase = 0 then
				  stim_train_flag <= '1';
				  if stim_burst_counter < (STIM_FIRST_PACKET - 1) then
					stim_burst_counter <= stim_burst_counter + 1;
					rhs_STIM_state     <= 0;
				  else
					stim_burst_counter  <= 0;
					stim_sequence_phase <= 1;
					stim_delay_counter  <= 0;
					rhs_STIM_state      <= 4;
				  end if;

				-- PHASE 1 : POSITIVE
				elsif stim_sequence_phase = 1 then
				  if stim_burst_counter < (STIM_SECOND_PACKET - 1) then
					stim_burst_counter <= stim_burst_counter + 1;
					rhs_STIM_state     <= 0;
				  else
					stim_burst_counter  <= 0;
					stim_sequence_phase <= 2;
					stim_delay_counter  <= 0;
					rhs_STIM_state      <= 5;
				  end if;

				-- PHASE 2 : DISABLE
				elsif stim_sequence_phase = 2 then
				  if stim_burst_counter < (STIM_THIRD_PACKET - 1) then
					stim_burst_counter <= stim_burst_counter + 1;
					rhs_STIM_state     <= 0;
				  else
					-- One full pulse complete
					stim_burst_counter  <= 0;
					stim_sequence_phase <= 0;
					stim_train_flag     <= '0'; 
					stim_delay_counter <= 0;
					
					if stim_pulse_counter < (STIM_PULSE_NUM - 1) then
					  -- More pulses remain in this train
					  stim_pulse_counter <= stim_pulse_counter + 1;
					  rhs_STIM_state     <= 6;   -- 3ms inter-pulse gap

					else
						if stim_channel_index < 31 then
							stim_channel_index <= stim_channel_index + 1;
							rhs_STIM_state <= 7;
						else
							stim_channel_index <= 0;
							
							rhs_STIM_state <= 8;
						end if;
						-- Train complete
						stim_pulse_counter <= 0;
						stim_train_counter <= 0;


					end if;
				  end if;
				end if;
			  end if;

			-- ============================================================
			-- STATE 4 : 200 µs DELAY  (after negative phase)
			-- ============================================================
			when 4 =>
			  if stim_delay_counter < DELAY_200uS_CLKS then
				stim_delay_counter <= stim_delay_counter + 1;
			  else
				stim_delay_counter <= 0;
				rhs_STIM_state     <= 0;
			  end if;

			-- ============================================================
			-- STATE 5 : 200 µs DELAY  (after positive phase)
			-- ============================================================
			when 5 =>
			  if stim_delay_counter < DELAY_200uS_CLKS then
				stim_delay_counter <= stim_delay_counter + 1;
			  else
				stim_delay_counter <= 0;
				rhs_STIM_state     <= 0;
			  end if;

			-- ============================================================
			-- STATE 6 : 3 ms DELAY  (inter-pulse gap)
			-- ============================================================
			when 6 =>
			  if stim_delay_counter < DELAY_3mS_CLKS then
				stim_delay_counter <= stim_delay_counter + 1;
			  else
				stim_delay_counter <= 0;
				rhs_STIM_state     <= 0;
			  end if;

			-- ============================================================
			-- STATE 7 : 1s DELAY (inter-train gap)
			-- ============================================================
			when 7 =>
			  if stim_1sec_counter < DELAY_1S_CLKS then
				stim_1sec_counter <= stim_1sec_counter + 1;
			  else
				stim_1sec_counter  <= 0;
				rhs_STIM_state      <= 0;
			  end if;

			-- ============================================================
			-- STATE 8 : LONG PAUSE (after all trains)
			-- ============================================================
			when 8 =>
			  stim_train_flag <= '1';
			  if stim_10sec_counter < DELAY_10S_CLKS then
				stim_10sec_counter <= stim_10sec_counter + 1;
				rgd_info_sig_blue <= '1';
			  else
				rgd_info_sig_blue <= '0';
				stim_10sec_counter <= 0;
				stim_train_flag       <= '0';
				rhs_STIM_state        <= 0;

			  end if;
			  
			  

			when others =>
			  rhs_STIM_state <= 0;

		  end case;

		else
		  int_RHS_STIM_TX_DV <= '0';
		end if;

	  end if;
	end process;
	
	stim_ch <= stim_channel_index when stim_channel_index < 16
          else stim_channel_index - 16;

	chip_select_RHS_STIM <= '1' when stim_channel_index < 16
                       else '0';
	
	
	mux_RHS_READ_SPI_MISO <= i_RHS_READ_SPI_MISO_1 when chip_select_RHS_READ = '1'
                        else i_RHS_READ_SPI_MISO_2;
	
	o_RHS_READ_SPI_CS_n_1 <= mux_RHS_READ_SPI_CS_n when chip_select_RHS_READ = '1' else '1';
	o_RHS_READ_SPI_CS_n_2 <= mux_RHS_READ_SPI_CS_n when chip_select_RHS_READ = '0' else '1';
	

	mux_RHS_STIM_SPI_MISO <= i_RHS_STIM_SPI_MISO_1 when chip_select_RHS_STIM = '1'
                        else i_RHS_STIM_SPI_MISO_2;
	
	o_RHS_STIM_SPI_CS_n_1 <= mux_RHS_STIM_SPI_CS_n when chip_select_RHS_STIM = '1' else '1';
	o_RHS_STIM_SPI_CS_n_2 <= mux_RHS_STIM_SPI_CS_n when chip_select_RHS_STIM = '0' else '1';


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
	
	o_RHS_READ_TX_Byte  <= int_RHS_READ_TX_Byte;
	o_RHS_READ_TX_DV    <= int_RHS_READ_TX_DV;
	o_RHS_READ_TX_Ready <= int_RHS_READ_TX_Ready;
	

	o_RHS_STIM_TX_Byte  <= int_RHS_STIM_TX_Byte;	
	o_RHS_STIM_TX_DV    <= int_RHS_STIM_TX_DV;
	o_RHS_STIM_TX_Ready <= int_RHS_STIM_TX_Ready;

	o_FIFO_RHS_READ_RE 	   <= int_FIFO_RHS_READ_RE;  
	o_FIFO_RHS_READ_COUNT   <= int_FIFO_RHS_READ_COUNT;
	o_FIFO_RHS_READ_Q       <= int_FIFO_RHS_READ_Q;
	o_FIFO_RHS_READ_EMPTY   <= int_FIFO_RHS_READ_EMPTY;
	o_FIFO_RHS_READ_FULL    <= int_FIFO_RHS_READ_FULL;
	o_FIFO_RHS_READ_AEMPTY  <= int_FIFO_RHS_READ_AEMPTY;
	o_FIFO_RHS_READ_AFULL   <= int_FIFO_RHS_READ_AFULL;
	
	o_FIFO_RHS_STIM_RE 	   <= int_FIFO_RHS_STIM_RE;
	o_FIFO_RHS_STIM_COUNT   <= int_FIFO_RHS_STIM_COUNT;
	o_FIFO_RHS_STIM_Q       <= int_FIFO_RHS_STIM_Q;
	o_FIFO_RHS_STIM_EMPTY   <= int_FIFO_RHS_STIM_EMPTY;
	o_FIFO_RHS_STIM_FULL    <= int_FIFO_RHS_STIM_FULL;
	o_FIFO_RHS_STIM_AEMPTY  <= int_FIFO_RHS_STIM_AEMPTY;
	o_FIFO_RHS_STIM_AFULL   <= int_FIFO_RHS_STIM_AFULL;

	o_stim_10sec_counter_debug <= std_logic_vector(to_unsigned(stim_10sec_counter, 32));

	o_stim_1sec_counter_debug <= std_logic_vector(to_unsigned(stim_1sec_counter, 32));

	o_stim_burst_counter_debug <= std_logic_vector(to_unsigned(stim_burst_counter, 8));

	o_stim_train_counter_debug <= std_logic_vector(to_unsigned(stim_train_counter, 8));

	o_stim_pulse_counter_debug <= std_logic_vector(to_unsigned(stim_pulse_counter, 8));

	o_stim_sequence_phase_debug <= std_logic_vector(to_unsigned(stim_sequence_phase, 8));

	o_stim_delay_counter_debug <= std_logic_vector(to_unsigned(stim_delay_counter, 32));

	o_rhs_STIM_state_debug <= std_logic_vector(to_unsigned(rhs_STIM_state, 8));

	o_rhs_STIM_index_debug <= std_logic_vector(to_unsigned(rhs_STIM_index, 8));

	o_stim_train_sector_counter_debug <= std_logic_vector(to_unsigned(stim_train_sector_counter, 32));

end architecture RTL;