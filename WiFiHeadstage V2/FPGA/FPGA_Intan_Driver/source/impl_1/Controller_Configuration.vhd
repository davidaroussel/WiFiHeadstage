library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_RHD_Configuration is
  generic (
      STM32_SPI_NUM_BITS_PER_PACKET : integer := 16;
      STM32_CLKS_PER_HALF_BIT 		: integer := 4;
	  STM32_CS_INACTIVE_CLKS 		: integer := 4;
	  
	  RHD_SPI_DDR_MODE 				: integer := 0;
	  
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
    o_STM32_FIFO_Data    : out std_logic_vector(15 downto 0);
	o_STM32_FIFO_COUNT   : out std_logic_vector(7 downto 0);
    o_STM32_FIFO_WE      : out std_logic;
    o_STM32_FIFO_RE      : out std_logic;
    o_STM32_FIFO_Q       : out std_logic_vector(31 downto 0);
    o_STM32_FIFO_EMPTY   : out std_logic;
    o_STM32_FIFO_FULL    : out std_logic;
    o_STM32_FIFO_AEMPTY  : out std_logic;
    o_STM32_FIFO_AFULL   : out std_logic;


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
end entity Controller_RHD_Configuration;

architecture RTL of Controller_RHD_Configuration is

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
	
	signal int_STM32_FIFO_Data    : std_logic_vector(31 downto 0);
	signal int_STM32_FIFO_COUNT   : std_logic_vector(7 downto 0);
	signal int_STM32_FIFO_WE      : std_logic;
	signal int_STM32_FIFO_RE      : std_logic;
	signal int_STM32_FIFO_Q       : std_logic_vector(31 downto 0);
	signal int_STM32_FIFO_EMPTY   : std_logic;
	signal int_STM32_FIFO_FULL    : std_logic;
	signal int_STM32_FIFO_AEMPTY  : std_logic;
	signal int_STM32_FIFO_AFULL   : std_logic;
	
	

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


  Controller_STM32_FIFO_1 : entity work.Controller_RHD_FIFO
    generic map (
      SPI_MODE               => 0,
      CLKS_PER_HALF_BIT      => STM32_CLKS_PER_HALF_BIT,
      NUM_OF_BITS_PER_PACKET => STM32_SPI_NUM_BITS_PER_PACKET,
      CS_INACTIVE_CLKS       => STM32_CS_INACTIVE_CLKS
    )
    port map (
      i_Rst_L        	=> i_Rst_L,
      i_Clk          	=> i_Clk,
	  i_Controller_Mode => i_Controller_Mode,
      o_SPI_Clk      	=> o_STM32_SPI_Clk,
      i_SPI_MISO     	=> i_STM32_SPI_MISO,
      o_SPI_MOSI     	=> o_STM32_SPI_MOSI,
      o_SPI_CS_n     	=> o_STM32_SPI_CS_n,
      i_TX_Byte      	=> int_STM32_TX_Byte,
      i_TX_DV        	=> int_STM32_TX_DV,
      o_TX_Ready     	=> int_STM32_TX_Ready,
      o_RX_DV        	=> o_STM32_RX_DV,
      o_RX_Byte_Rising  => o_STM32_RX_Byte_Rising,
      o_RX_Byte_Falling => o_STM32_RX_Byte_Falling,
      o_FIFO_Data    => o_STM32_FIFO_Data,
	  o_FIFO_COUNT   => int_STM32_FIFO_COUNT,
      o_FIFO_WE      => o_STM32_FIFO_WE,
      i_FIFO_RE      => int_STM32_FIFO_RE,
      o_FIFO_Q       => int_STM32_FIFO_Q,
      o_FIFO_EMPTY   => int_STM32_FIFO_EMPTY,
      o_FIFO_FULL    => int_STM32_FIFO_FULL,
      o_FIFO_AEMPTY  => int_STM32_FIFO_AEMPTY,
      o_FIFO_AFULL   => int_STM32_FIFO_AFULL
    );

  -- SPI RHD to FIFO logic
  process (i_Clk, i_Rst_L)
  begin
    if i_Rst_L = '1' then	
      int_STM32_FIFO_DATA <= (others => '1');
      int_STM32_FIFO_WE   <= '0';   	
	  init_STM32_FIFO_Read <= '0';  	
	  init_STM32_FIFO_State <= '0';
    elsif rising_edge(i_Clk) then
		if i_Controller_Mode = x"0" then
			if init_STM32_FIFO_State = '0' then
				int_STM32_FIFO_WE <= '1';
				int_STM32_FIFO_DATA(31 downto 0) <= x"AAAAAAAA";
				init_STM32_FIFO_State <= '1';
			else
				int_STM32_FIFO_WE <= '0';
			end if;
			
		elsif i_Controller_Mode = x"1" then
		  if int_STM32_RX_DV = '1' then
			int_STM32_FIFO_WE <= '1';
			int_STM32_FIFO_DATA(31 downto 16) <= int_RX_Byte_Rising;
			int_STM32_FIFO_DATA(15 downto 0)  <= int_RX_Byte_Falling;
		  else
			int_STM32_FIFO_WE <= '0';
		  end if;
		end if;
	end if;
  end process;
  
  
	
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
	
	init_FIFO_Read <= '0';
	init_FIFO_State <= '0';

	
	NUM_DATA <= (STM32_SPI_NUM_BITS_PER_PACKET / RHD_SPI_NUM_BITS_PER_PACKET);
	
  elsif rising_edge(i_Clk) then
	
	if i_Controller_Mode = x"0" then
		if init_FIFO_Read = '0' then
			int_FIFO_RE <= '1';
			init_FIFO_Read <= '1';
		else
			int_FIFO_RE <= '0';
		end if;
	
	elsif i_Controller_Mode = x"1" then
		case stm32_state is
			when 0 =>
				if (NUM_DATA-1) < to_integer(unsigned(int_FIFO_COUNT)) then
					stm32_state <= 1; -- Move to next state
					int_FIFO_RE <= '1'; -- Enable FIFO data
				else
					stm32_state <= 0;
				end if;
			when 1 =>
				--int_FIFO_RE <= '1'; -- Enable FIFO data
				stm32_state <= 2;
			when 2 =>
				stm32_state <= 3;
			when 3 =>
				if NUM_DATA > stm32_counter then
					if RHD_SPI_DDR_MODE = 1 then
						temp_buffer((NUM_DATA - 1 - stm32_counter)*32 + 31 downto (NUM_DATA - 1 - stm32_counter)*32) <= int_STM32_FIFO_Q;
					else
						temp_array(stm32_counter) := int_STM32_FIFO_Q(15 downto 0);
					end if;
					stm32_counter <= stm32_counter + 1;
					stm32_state <= 3;
				else
					int_FIFO_RE <= '0';
					temp_buffer <= temp_array(0)  & temp_array(1)  & temp_array(2)  & temp_array(3);
					stm32_state <= 5;
				end if;
			
			when 4 => 	 
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
            1 => x"E900"  -- REG41
 
        );
        variable index      : integer := 0;
    begin
        if i_Rst_L = '1' then
            index := 0;
            counter <= 0;
			int_RHD_TX_Byte <= (others => '0');
			int_RHD_TX_DV <= '0';
        elsif rising_edge(i_Clk) then
            if i_Controller_Mode = x"1" then
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
                        if index < 1 then
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

	o_STM32_RX_DV <= int_STM32_RX_DV;

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
