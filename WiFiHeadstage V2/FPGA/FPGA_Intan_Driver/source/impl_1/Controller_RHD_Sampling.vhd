library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_RHD_Sampling is
  generic (
      STM32_CLKS_PER_HALF_BIT 		: integer := 4;
      STM32_SPI_NUM_BITS_PER_PACKET : integer := 64;
	  STM32_CS_INACTIVE_CLKS		: integer := 4;
	  
	  
	  RHD_SPI_DDR_MODE 				: integer := 1;
      RHD_SPI_NUM_BITS_PER_PACKET 	: integer := 16;
      RHD_CLKS_PER_HALF_BIT 		: integer := 8;
	  RHD_CS_INACTIVE_CLKS			: integer := 4
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
    o_FIFO_Data    : out std_logic_vector(31 downto 0);
	o_FIFO_COUNT   : out std_logic_vector(7 downto 0);
    o_FIFO_WE      : out std_logic;
    o_FIFO_RE      : out std_logic;
    o_FIFO_Q       : out std_logic_vector(31 downto 0);
    o_FIFO_EMPTY   : out std_logic;
    o_FIFO_FULL    : out std_logic;
    o_FIFO_AEMPTY  : out std_logic;
    o_FIFO_AFULL   : out std_logic;

    -- RHD SPI Interface
    o_RHD_SPI_Clk      : out std_logic;
    i_RHD_SPI_MISO     : in  std_logic;
    o_RHD_SPI_MOSI     : out std_logic;
    o_RHD_SPI_CS_n     : out std_logic;

    -- TX (MOSI) Signals
    o_RHD_TX_Byte      : out  std_logic_vector(15 downto 0);
    o_RHD_TX_DV        : out  std_logic;
    o_RHD_TX_Ready     : out  std_logic;

    -- RX (MISO) Signals
    o_RHD_RX_DV        : out std_logic;
    o_RHD_RX_Byte_Rising  : out std_logic_vector(15 downto 0);
    o_RHD_RX_Byte_Falling : out std_logic_vector(15 downto 0)
  );
end entity Controller_RHD_Sampling;

architecture RTL of Controller_RHD_Sampling is

  component Controller_RHD_FIFO is
    generic (
      SPI_MODE               : integer := 0;
      CLKS_PER_HALF_BIT      : integer := RHD_CLKS_PER_HALF_BIT;
      NUM_OF_BITS_PER_PACKET : integer := RHD_SPI_NUM_BITS_PER_PACKET;
      CS_INACTIVE_CLKS       : integer := RHD_CS_INACTIVE_CLKS
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
      o_FIFO_Data        : out std_logic_vector(31 downto 0);
      o_FIFO_COUNT       : out std_logic_vector(7 downto 0);
	  o_FIFO_WE          : out std_logic;
      i_FIFO_RE          : in std_logic;
      o_FIFO_Q           : out std_logic_vector(31 downto 0);
      o_FIFO_EMPTY       : out std_logic;
      o_FIFO_FULL        : out std_logic;
      o_FIFO_AEMPTY      : out std_logic;
      o_FIFO_AFULL       : out std_logic
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
  
	signal int_FIFO_Data    : std_logic_vector(31 downto 0);
	signal int_FIFO_COUNT   : std_logic_vector(7 downto 0);
	signal int_FIFO_WE      : std_logic;
	signal int_FIFO_RE      : std_logic;
	signal int_FIFO_Q       : std_logic_vector(31 downto 0);
	signal int_FIFO_EMPTY   : std_logic;
	signal int_FIFO_FULL    : std_logic;
	signal int_FIFO_AEMPTY  : std_logic;
	signal int_FIFO_AFULL   : std_logic;

	signal int_RHD_SPI_Clk      : std_logic;
	signal int_RHD_SPI_MISO     : std_logic;
	signal int_RHD_SPI_MOSI     : std_logic;
	signal int_RHD_SPI_CS_n     : std_logic;
	signal int_RHD_TX_Byte      : std_logic_vector(15 downto 0);
	signal int_RHD_TX_DV        : std_logic;
	signal int_RHD_TX_Ready     : std_logic;
	signal int_RHD_RX_DV        : std_logic;
	signal int_RHD_RX_Byte_Rising  : std_logic_vector(15 downto 0);
	signal int_RHD_RX_Byte_Falling : std_logic_vector(15 downto 0);

	signal int_STM32_SPI_Clk      : std_logic;
	signal int_STM32_SPI_MISO     : std_logic;
	signal int_STM32_SPI_MOSI     : std_logic;
	signal int_STM32_SPI_CS_n     : std_logic;
	signal int_STM32_TX_Byte      : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	signal int_STM32_TX_DV        : std_logic;
	signal int_STM32_TX_Ready     : std_logic;
	signal int_STM32_RX_DV        : std_logic;
	signal int_STM32_RX_Byte_Rising  : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);

	signal stm32_counter : integer := 0; -- Counter to keep track of bits stored in temporary buffer
	signal counter      : integer := 0; -- Counter to control SendDataToRHDSPI

	signal stm32_state : integer := 0;

	signal NUM_DATA : integer := 0;
	 
	signal temp_buffer : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	
	signal init_FIFO_State : std_logic;
	signal init_FIFO_Read : std_logic;
	
	type word_array_t is array (0 to 31) of std_logic_vector(15 downto 0); -- Adjust size
	
	signal first_packet : std_logic;
	signal rhd_index    : integer := 0;
	signal rhd_state    : integer := 0;
	
	signal alt_counter : integer range 0 to 3 := 0;
		signal data_array_send_count : integer range 0 to 100 := 0;

	type t_data_array is array (0 to 63) of std_logic_vector(15 downto 0);
	
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

	signal channel_array : t_channel_array := (
				-- Registers 40–63
		0  => x"E800",  -- REG40
		1  => x"E900",  -- REG41
		2  => x"EA00",  -- REG42
		3  => x"EB00",  -- REG43
		4  => x"EC00",  -- REG44
		5  => x"FD00",  -- REG61
		6  => x"FE00",  -- REG62
		7  => x"FF00",  -- REG63
		---- CH0–CH31 (first block)
		--0  => x"0000",  -- CH0
		--1  => x"0100",  -- CH1
		--2  => x"0200",  -- CH2
		--3  => x"0300",  -- CH3
		--4  => x"0400",  -- CH4
		--5  => x"0500",  -- CH5
		--6  => x"0600",  -- CH6
		--7  => x"0700",  -- CH7
		8  => x"0800",  -- CH8
		9  => x"0900",  -- CH9
		10 => x"0A00",  -- CH10
		11 => x"0B00",  -- CH11
		12 => x"0C00",  -- CH12
		13 => x"0D00",  -- CH13
		14 => x"0E00",  -- CH14
		15 => x"0F00",  -- CH15
		16 => x"1000",  -- CH16
		17 => x"1100",  -- CH17
		18 => x"1200",  -- CH18
		19 => x"1300",  -- CH19
		20 => x"1400",  -- CH20
		21 => x"1500",  -- CH21
		22 => x"1600",  -- CH22
		23 => x"1700",  -- CH23
		24 => x"1800",  -- CH24
		25 => x"1900",  -- CH25
		26 => x"1A00",  -- CH26
		27 => x"1B00",  -- CH27
		28 => x"1C00",  -- CH28
		29 => x"1D00",  -- CH29
		30 => x"1E00",  -- CH30
		31 => x"1F00",  -- CH31

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
		46 => x"0E00",  -- CH14 repeat
		47 => x"0F00",  -- CH15 repeat
		48 => x"1000",  -- CH16 repeat
		49 => x"1100",  -- CH17 repeat
		50 => x"1200",  -- CH18 repeat
		51 => x"1300",  -- CH19 repeat
		52 => x"1400",  -- CH20 repeat
		53 => x"1500",  -- CH21 repeat
		54 => x"1600",  -- CH22 repeat
		55 => x"1700",  -- CH23 repeat
		56 => x"1800",  -- CH24 repeat
		57 => x"1900",  -- CH25 repeat
		58 => x"1A00",  -- CH26 repeat
		59 => x"1B00",  -- CH27 repeat
		60 => x"1C00",  -- CH28 repeat
		61 => x"1D00",  -- CH29 repeat
		62 => x"1E00",  -- CH30 repeat
		63 => x"1F00"   -- CH31 repeat
	);


	
	signal rhd_done_config : std_logic := '0';
	signal full_cycle_count  : integer := 0;


begin
  Controller_RHD_FIFO_1 : entity work.Controller_RHD_FIFO
    generic map (
      SPI_MODE               => 0,
      CLKS_PER_HALF_BIT      => RHD_CLKS_PER_HALF_BIT,
      NUM_OF_BITS_PER_PACKET => RHD_SPI_NUM_BITS_PER_PACKET,
      CS_INACTIVE_CLKS       => RHD_CS_INACTIVE_CLKS
    )
    port map (
      i_Rst_L        	=> i_Rst_L,
      i_Clk          	=> i_Clk,
	  i_Controller_Mode => i_Controller_Mode,
      o_SPI_Clk      	=> o_RHD_SPI_Clk,
      i_SPI_MISO     	=> i_RHD_SPI_MISO,
      o_SPI_MOSI     	=> o_RHD_SPI_MOSI,
      o_SPI_CS_n     	=> o_RHD_SPI_CS_n,
      i_TX_Byte      	=> int_RHD_TX_Byte,
      i_TX_DV        	=> int_RHD_TX_DV,
      o_TX_Ready     	=> int_RHD_TX_Ready,
      o_RX_DV        	=> o_RHD_RX_DV,
      o_RX_Byte_Rising  => o_RHD_RX_Byte_Rising,
      o_RX_Byte_Falling => o_RHD_RX_Byte_Falling,
      o_FIFO_Data    => o_FIFO_Data,
	  o_FIFO_COUNT   => int_FIFO_COUNT,
      o_FIFO_WE      => o_FIFO_WE,
      i_FIFO_RE      => int_FIFO_RE,
      o_FIFO_Q       => int_FIFO_Q,
      o_FIFO_EMPTY   => int_FIFO_EMPTY,
      o_FIFO_FULL    => int_FIFO_FULL,
      o_FIFO_AEMPTY  => int_FIFO_AEMPTY,
      o_FIFO_AFULL   => int_FIFO_AFULL
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
	variable temp_array : word_array_t;
begin
  if i_Rst_L = '1' then
	temp_buffer <= (others => '0');
	temp_array := (others => (others => '0'));
	
    int_FIFO_RE <= '0';  -- Toggle back to '0'
    stm32_counter <= 0;  -- Reset counter on reset
    stm32_state <= 0;    -- Reset state
	int_STM32_TX_Byte <= (others => '0');
	int_STM32_TX_DV <= '0';
	rgd_info_sig_blue <= '1';
	init_FIFO_Read <= '0';
	init_FIFO_State <= '0';
	
	first_packet <= '0';
	
	if RHD_SPI_DDR_MODE = 1 then
		NUM_DATA <= (STM32_SPI_NUM_BITS_PER_PACKET / (2*RHD_SPI_NUM_BITS_PER_PACKET));
	else
		NUM_DATA <= (STM32_SPI_NUM_BITS_PER_PACKET / RHD_SPI_NUM_BITS_PER_PACKET);
	end if;
	
  elsif rising_edge(i_Clk) then
	
	if i_Controller_Mode = x"0" then
		if init_FIFO_Read = '0' then
			int_FIFO_RE <= '1';
			init_FIFO_Read <= '1';
		else
			int_FIFO_RE <= '0';
		end if;

	elsif i_Controller_Mode = x"2" then
		case stm32_state is
			when 0 =>
				if (NUM_DATA-1) < to_integer(unsigned(int_FIFO_COUNT)) then
					stm32_state <= 1; -- Move to next state
					int_FIFO_RE <= '1'; -- Enable FIFO data
				else
					stm32_state <= 0;
				end if;
			when 1 =>
				if first_packet = '0' then
					stm32_state <= 2;
					first_packet <= '1';
				else
					stm32_state <= 4;
				end if;
				stm32_state <= 2;
			when 2 =>
				stm32_state <= 3;
			when 3 =>
				stm32_state <= 4;
			when 4 =>
				stm32_state <= 5;
				
			when 5 =>
				if NUM_DATA > stm32_counter then
					if RHD_SPI_DDR_MODE = 1 then
						temp_buffer((NUM_DATA - 1 - stm32_counter)*32 + 31 downto (NUM_DATA - 1 - stm32_counter)*32) <= int_FIFO_Q;
					else
						temp_array(stm32_counter) := int_FIFO_Q(15 downto 0);
					end if;
					stm32_counter <= stm32_counter + 1;
					stm32_state <= 5;
				else
					int_FIFO_RE <= '0';

					temp_buffer <= temp_array(0)  & temp_array(1)  & temp_array(2)  & temp_array(3)  & temp_array(4)  & temp_array(5)  & temp_array(6)  & temp_array(7)  & 
							       temp_array(8)  & temp_array(9)  & temp_array(10) & temp_array(11) & temp_array(12) & temp_array(13) & temp_array(14) & temp_array(15) &
								   temp_array(16) & temp_array(17) & temp_array(18) & temp_array(19) & temp_array(20) & temp_array(21) & temp_array(22) & temp_array(23) & 
							       temp_array(24) & temp_array(25) & temp_array(26) & temp_array(27) & temp_array(28) & temp_array(29) & temp_array(30) & temp_array(31);
					--temp_buffer <= x"0123456789ABCDEF00000000000000000123456789ABCDEF11111111111111110123456789ABCDEF22222222222222220123456789ABCDEF3333333333333333";
					stm32_state <= 6;
				end if;
			
			when 6 => 	 
				stm32_state <= 7;
				
			when 7 =>
				int_STM32_TX_Byte <= temp_buffer;
				int_STM32_TX_DV <= '1';
				stm32_state <= 8;
				
			when 8 =>
				stm32_counter <= 0;
				int_STM32_TX_DV <= '0';
				stm32_state <= 9;
			
			when 9 =>
				if int_STM32_TX_Ready = '1' then
					stm32_state <= 10;
				else
					stm32_state <= 9;
				end if;
			when 10 => 
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
			int_RHD_TX_Byte     <= (others => '0');
			int_RHD_TX_DV       <= '0';
			rhd_index           <= 0;
			rhd_done_config     <= '0';
			data_array_send_count <= 0;
			rgd_info_sig_red      <= '1';
			rgd_info_sig_green    <= '1';
			rhd_state           <= 0;
			alt_counter         <= 0;  
			full_cycle_count     <= 0;  -- reset new counter
		elsif rising_edge(i_Clk) then
			if i_Controller_Mode = x"1" then
				rgd_info_sig_green <= '0';
			elsif i_Controller_Mode = x"2" then
				rgd_info_sig_green <= '1';
				case rhd_state is

					----------------------------------------------------------------
					-- STATE 0 : PREPARE NEXT BYTE
					----------------------------------------------------------------
					when 0 =>
						if rhd_done_config = '0' then
							-- Configuration phase
							int_RHD_TX_Byte <= data_array(rhd_index);
						else
							-- Acquisition phase: dynamically alternate CH0
							case alt_counter is
								when 0 => channel_array(0) <= x"E800";
								when 1 => channel_array(0) <= x"E900";
								when 2 => channel_array(0) <= x"E800";
								when 3 => channel_array(0) <= x"E900";
								when others => channel_array(0) <= x"E800";
							end case;


							int_RHD_TX_Byte <= channel_array(rhd_index);
						end if;

						-- Wait until SPI/FIFO ready before sending
						if int_RHD_TX_Ready = '1' then
							int_RHD_TX_DV <= '1';   -- pulse DV for one cycle
							rhd_state <= 1;
						else
							int_RHD_TX_DV <= '0';
						end if;

					----------------------------------------------------------------
					-- STATE 1 : PULSE DV (ONE CYCLE)
					----------------------------------------------------------------
					when 1 =>
						int_RHD_TX_DV <= '0';
						-- Wait for Ready to drop (indicating transfer start)
						if int_RHD_TX_Ready = '0' then
							rhd_state <= 2;
						else
							rhd_state <= 1;
						end if;

					----------------------------------------------------------------
					-- STATE 2 : WAIT FOR TRANSFER COMPLETE
					----------------------------------------------------------------
					when 2 =>
						-- Wait for Ready to return high (transfer complete)
						if int_RHD_TX_Ready = '1' then
							-- Increment index and handle sequence looping
							if rhd_index < 63 then
								rhd_index <= rhd_index + 1;
							else
								rhd_index <= 0;

								-- Finished one full loop of data_array or channel_array
								if rhd_done_config = '0' then
									-- Send data_array 100 times before switching
									if data_array_send_count < 99 then
										data_array_send_count <= data_array_send_count + 1;
									else
										rhd_done_config <= '1';  -- switch to channel_array
									end if;
								else
									-- Acquisition phase: count full channel_array loops
									if full_cycle_count < 9999 then
										full_cycle_count <= full_cycle_count + 1;
									else
										full_cycle_count <= 0;
										rgd_info_sig_red <= not rgd_info_sig_red;

										-- Only change CH0 after 10,000 full loops
										if alt_counter < 3 then
											alt_counter <= alt_counter + 1;
										else
											alt_counter <= 0;
										end if;

										-- Apply the new CH0 value
										case alt_counter is
											when 0 => channel_array(0) <= x"E800";
											when 1 => channel_array(0) <= x"E900";
											when 2 => channel_array(0) <= x"E800";
											when 3 => channel_array(0) <= x"E900";
											when others => channel_array(0) <= x"E800";
										end case;
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
				int_RHD_TX_DV <= '0';
			end if;
		end if;
	end process;

	rgb_info_red <= rgd_info_sig_red;
	rgb_info_green <= rgd_info_sig_green;
	rgb_info_blue <= rgd_info_sig_blue;

	o_NUM_DATA  <= NUM_DATA;
	o_STM32_State <= stm32_state;

	o_stm32_counter <= stm32_counter;
	o_FIFO_RE <= int_FIFO_RE;  

	o_STM32_TX_Byte <= int_STM32_TX_Byte;
	o_RHD_TX_Byte <= int_RHD_TX_Byte;

	o_STM32_TX_DV <= int_STM32_TX_DV;
	o_RHD_TX_DV <= int_RHD_TX_DV;

	o_STM32_RX_Byte_Rising <= int_STM32_RX_Byte_Rising;

	o_STM32_TX_Ready <= int_STM32_TX_Ready;
	o_RHD_TX_Ready <= int_RHD_TX_Ready;

	o_FIFO_COUNT   <= int_FIFO_COUNT;
	o_FIFO_Q       <= int_FIFO_Q;
	o_FIFO_EMPTY   <= int_FIFO_EMPTY;
	o_FIFO_FULL    <= int_FIFO_FULL;
	o_FIFO_AEMPTY  <= int_FIFO_AEMPTY;
	o_FIFO_AFULL   <= int_FIFO_AFULL;

end architecture RTL;