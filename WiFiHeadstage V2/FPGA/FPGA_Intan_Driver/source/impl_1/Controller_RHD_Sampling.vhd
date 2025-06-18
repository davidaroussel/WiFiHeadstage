library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_RHD_Sampling is
  generic (
      STM32_SPI_NUM_BITS_PER_PACKET : integer := 64;
      STM32_CLKS_PER_HALF_BIT 		: integer := 2;
	  STM32_CS_INACTIVE_CLKS 		: integer := 4;
	  
	  
	  RHD_SPI_DDR_MODE 				: integer := 1;
      RHD_SPI_NUM_BITS_PER_PACKET 	: integer := 16;
      RHD_CLKS_PER_HALF_BIT 		: integer := 4;
	  RHD_CS_INACTIVE_CLKS 			: integer := 4
    );
  port (
	o_NUM_DATA       : out integer;
	o_STM32_State    : out integer;
	o_stm32_counter  : out integer;
	
    i_Rst_L        : in std_logic;
    i_Clk          : in std_logic;

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

  -- List of values for the pattern "00xxxxx00000000"
  type Pattern_List is array(0 to 31) of std_logic_vector(15 downto 0);
  constant PATTERNS : Pattern_List := (
    X"0000", X"0100", X"0200", X"0300", 
    X"0400", X"0500", X"0600", X"0700", 
    X"0800", X"0900", X"0A00", X"0B00", 
    X"0C00", X"0D00", X"0E00", X"0F00", 
    X"1000", X"1100", X"1200", X"1300", 
    X"1400", X"1500", X"1600", X"1700", 
    X"1800", X"1900", X"1A00", X"1B00", 
    X"1C00", X"1D00", X"1E00", X"1F00"
  );
	signal pattern_index : integer range 0 to 31 := 0;


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
  
	type Data_Array is array (0 to 31) of std_logic_vector(31 downto 0);
	signal data_matrix : Data_Array;
	signal array_index : integer := 0;

	signal stm32_state : integer := 0;

	signal NUM_DATA : integer := 0;
	 
	type t_data_array is array (0 to 7) of std_logic_vector(15 downto 0);
	
	signal temp_buffer : std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);
	
	signal init_FIFO_State : std_logic;
	signal init_FIFO_Read : std_logic;
	
	type word_array_t is array (0 to 31) of std_logic_vector(15 downto 0); -- Adjust size

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
	temp_buffer <= (others => '1');
	temp_array := (others => (others => '0'));
	
    int_FIFO_RE <= '0';  -- Toggle back to '0'
    stm32_counter <= 0;  -- Reset counter on reset
    stm32_state <= 0;    -- Reset state
	int_STM32_TX_Byte <= (others => '0');
	int_STM32_TX_DV <= '0';
	
	init_FIFO_Read <= '0';
	init_FIFO_State <= '0';
	
	if RHD_SPI_DDR_MODE = 1 then
		NUM_DATA <= (STM32_SPI_NUM_BITS_PER_PACKET / (2*RHD_SPI_NUM_BITS_PER_PACKET));
	else
		NUM_DATA <= (STM32_SPI_NUM_BITS_PER_PACKET / RHD_SPI_NUM_BITS_PER_PACKET);
	end if;
	
  elsif rising_edge(i_Clk) then
	
	if i_Controller_Mode = x"1" then
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
					--int_FIFO_RE <= '1'; -- Enable FIFO data
				else
					stm32_state <= 0;
				end if;
			when 1 =>
				int_FIFO_RE <= '1'; -- Enable FIFO data
				stm32_state <= 2;
			when 2 =>
				stm32_state <= 3;
			when 3 =>
				if NUM_DATA > stm32_counter then
					if RHD_SPI_DDR_MODE = 1 then
						temp_buffer((NUM_DATA - 1 - stm32_counter)*32 + 31 downto (NUM_DATA - 1 - stm32_counter)*32) <= int_FIFO_Q;
						--temp_buffer <= x"0123456789ABCDEF00000000000000000123456789ABCDEF0000000000000000";
					else
						--temp_buffer((NUM_DATA - 1 - stm32_counter)*16 + 15 downto (NUM_DATA - 1 - stm32_counter)*16) <= int_FIFO_Q(15 downto 0);
						--temp_buffer <= x"0123456789ABCDEF00000000000000000123456789ABCDEF00000000000000000123456789ABCDEF00000000000000000123456789ABCDEF0000000000000000";
						temp_array(stm32_counter) := int_FIFO_Q(15 downto 0);
						
					end if;
					stm32_counter <= stm32_counter + 1;
					stm32_state <= 3;
				else
					int_FIFO_RE <= '0';
					temp_buffer <= temp_array(0)  & temp_array(1)  & temp_array(2)  & temp_array(3)  & temp_array(4)  & temp_array(5)  & temp_array(6)  & temp_array(7)  & 
							       temp_array(8)  & temp_array(9)  & temp_array(10) & temp_array(11) & temp_array(12) & temp_array(13) & temp_array(14) & temp_array(15) &
								   temp_array(16)  & temp_array(17)  & temp_array(18)  & temp_array(19)  & temp_array(20)  & temp_array(21)  & temp_array(22)  & temp_array(23)  & 
							       temp_array(24)  & temp_array(25)  & temp_array(26) & temp_array(27) & temp_array(28) & temp_array(29) & temp_array(30) & temp_array(31);
					--temp_buffer <= x"0123456789ABCDEF00000000000000000123456789ABCDEF00000000000000000123456789ABCDEF00000000000000000123456789ABCDEF0000000000000000";
					stm32_state <= 5;
				end if;
			
			when 4 => 	 
				--temp_buffer <= x"0123456789ABCDEF00000000000000000123456789ABCDEF00000000000000000123456789ABCDEF00000000000000000123456789ABCDEF0000000000000000";
				stm32_state <= 5;
				
			when 5 =>
				int_STM32_TX_Byte <= temp_buffer;
				int_STM32_TX_DV <= '1';
				stm32_state <= 6;
				
			when 6 =>
				stm32_counter <= 0;
				int_STM32_TX_DV <= '0';
				stm32_state <= 7;
			
			when 7 =>
				if int_STM32_TX_Ready = '1' then
					stm32_state <= 8;
				else
					stm32_state <= 7;
				end if;
			when 8=>
				stm32_state <= 0;
			when others =>
				null;
			end case;
		end if;
	  end if;
	end process;


	process (i_Clk)
        -- Declare variables inside the process
        variable state      : integer := 0;
        variable data_array : t_data_array := (
            0 => x"E800",  -- REG40
            1 => x"E900",  -- REG41
            2 => x"EA00",  -- REG42
            3 => x"EB00",  -- REG43
            4 => x"EC00",  -- REG44
			5 => x"FD00",  -- REG61
			6 => x"FE00",  -- REG62
			7 => x"FF00"   -- REG63
        );
        variable index      : integer := 0;
    begin
        if i_Rst_L = '1' then
            index := 0;
            counter <= 0;
			int_RHD_TX_Byte <= (others => '0');
			int_RHD_TX_DV <= '0';
        elsif rising_edge(i_Clk) then
            if i_Controller_Mode = x"2" then
                case state is
                    when 0 =>
                        -- Send the current value from the array
                        int_RHD_TX_Byte <= data_array(index);
                        int_RHD_TX_DV   <= '1';
                        state := 1;

                    when 1 =>
                        int_RHD_TX_DV <= '0';
                        state := 2;

                    when 2 =>
                        if int_RHD_TX_Ready = '1' then
                            state := 3;
                        end if;

                    when 3 =>
                        -- Move to next value in array
                        if index < 7 then
                            index := index + 1;
                        else
                            index := 0;  -- Reset or stop depending on your needs
                        end if;
                        state := 0;

                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

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
