library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_RHD64_Config is
  generic (
      STM32_SPI_NUM_BITS_PER_PACKET : integer := 16;
      STM32_CLKS_PER_HALF_BIT 		: integer := 2;
	  STM32_CS_INACTIVE_CLKS 		: integer := 4;
      RHD64_SPI_NUM_BITS_PER_PACKET : integer := 16;
      RHD64_CLKS_PER_HALF_BIT 		: integer := 4;
	  RHD64_CS_INACTIVE_CLKS 		: integer := 4
    );
  port (
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
	o_STM32_RX_Byte_Falling  : out std_logic_vector(STM32_SPI_NUM_BITS_PER_PACKET-1 downto 0);

    -- FIFO Signals
    o_FIFO_Data    : out std_logic_vector(31 downto 0);
	o_FIFO_COUNT       : out std_logic_vector(10 downto 0);
    o_FIFO_WE      : out std_logic;
    o_FIFO_RE      : out std_logic;
    o_FIFO_Q       : out std_logic_vector(31 downto 0);
    o_FIFO_EMPTY   : out std_logic;
    o_FIFO_FULL    : out std_logic;
    o_FIFO_AEMPTY  : out std_logic;
    o_FIFO_AFULL   : out std_logic;

    -- STM32 SPI Interface
    o_RHD64_SPI_Clk      : out std_logic;
    i_RHD64_SPI_MISO     : in  std_logic;
    o_RHD64_SPI_MOSI     : out std_logic;
    o_RHD64_SPI_CS_n     : out std_logic;

    -- TX (MOSI) Signals
    o_RHD64_TX_Byte      : out  std_logic_vector(15 downto 0);
    o_RHD64_TX_DV        : out  std_logic;
    o_RHD64_TX_Ready     : out  std_logic;

    -- RX (MISO) Signals
    o_RHD64_RX_DV        : out std_logic;
    o_RHD64_RX_Byte_Rising  : out std_logic_vector(15 downto 0);
    o_RHD64_RX_Byte_Falling : out std_logic_vector(15 downto 0)
  );
end entity Controller_RHD64_Config;

architecture RTL of Controller_RHD64_Config is

  component Controller_RHD64 is
    generic (
      SPI_MODE               : integer := 0;
      CLKS_PER_HALF_BIT      : integer := STM32_CLKS_PER_HALF_BIT;
      NUM_OF_BITS_PER_PACKET : integer := STM32_SPI_NUM_BITS_PER_PACKET;
      CS_INACTIVE_CLKS       : integer := STM32_CS_INACTIVE_CLKS
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
      o_RX_Byte_Rising  : out std_logic_vector(15 downto 0);
      o_RX_Byte_Falling : out std_logic_vector(15 downto 0);
      o_FIFO_Data        : out std_logic_vector(31 downto 0);
      o_FIFO_COUNT       : out std_logic_vector(10 downto 0);
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
      CLKS_PER_HALF_BIT      : integer := RHD64_CLKS_PER_HALF_BIT;
      NUM_OF_BITS_PER_PACKET : integer := RHD64_SPI_NUM_BITS_PER_PACKET;
      CS_INACTIVE_CLKS       : integer := RHD64_CS_INACTIVE_CLKS
    );
    port (
      i_Rst_L    : in std_logic;     -- FPGA Reset
      i_Clk      : in std_logic;     -- FPGA Clock
      -- TX (MOSI) Signals
      i_TX_Byte  : in  std_logic_vector(RHD64_SPI_NUM_BITS_PER_PACKET-1 downto 0);  -- Byte to transmit on MOSI
      i_TX_DV    : in  std_logic;     -- Data Valid Pulse with i_TX_Byte
      o_TX_Ready : out std_logic;     -- Transmit Ready for next byte
      -- RX (MISO) Signals
      o_RX_DV           : out std_logic;  -- Data Valid pulse (1 clock cycle)
      o_RX_Byte_Rising  : out std_logic_vector(RHD64_SPI_NUM_BITS_PER_PACKET-1 downto 0);   -- Byte received on MISO Rising  CLK Edge
      o_RX_Byte_Falling : out std_logic_vector(RHD64_SPI_NUM_BITS_PER_PACKET-1 downto 0);  -- Byte received on MISO Falling CLK Edge
      -- SPI Interface
      o_SPI_Clk  : out std_logic;
      i_SPI_MISO : in  std_logic;
      o_SPI_MOSI : out std_logic;
      o_SPI_CS_n : out std_logic
    );
  end component;

  signal int_FIFO_Data    : std_logic_vector(31 downto 0);
  signal int_FIFO_COUNT   : std_logic_vector(10 downto 0);
  signal int_FIFO_WE      : std_logic;
  signal int_FIFO_RE      : std_logic;
  signal int_FIFO_Q       : std_logic_vector(31 downto 0);
  signal int_FIFO_EMPTY   : std_logic;
  signal int_FIFO_FULL    : std_logic;
  signal int_FIFO_AEMPTY  : std_logic;
  signal int_FIFO_AFULL   : std_logic;

  signal int_RHD64_SPI_Clk      : std_logic;
  signal int_RHD64_SPI_MISO     : std_logic;
  signal int_RHD64_SPI_MOSI     : std_logic;
  signal int_RHD64_SPI_CS_n     : std_logic;
  signal int_RHD64_TX_Byte      : std_logic_vector(15 downto 0);
  signal int_RHD64_TX_DV        : std_logic;
  signal int_RHD64_TX_Ready     : std_logic;
  signal int_RHD64_RX_DV        : std_logic;
  signal int_RHD64_RX_Byte_Rising  : std_logic_vector(15 downto 0);
  signal int_RHD64_RX_Byte_Falling : std_logic_vector(15 downto 0);

  signal int_STM32_SPI_Clk      : std_logic;
  signal int_STM32_SPI_MISO     : std_logic;
  signal int_STM32_SPI_MOSI     : std_logic;
  signal int_STM32_SPI_CS_n     : std_logic;
  signal int_STM32_TX_Byte      : std_logic_vector(15 downto 0);
  signal int_STM32_TX_DV        : std_logic;
  signal int_STM32_TX_Ready     : std_logic;
  signal int_STM32_RX_DV        : std_logic;
  signal int_STM32_RX_Byte_Rising  : std_logic_vector(15 downto 0);
  signal int_STM32_RX_Byte_Falling : std_logic_vector(15 downto 0);

  signal stm32_counter : integer := 0; -- Counter to keep track of bits stored in temporary buffer
  signal counter      : integer := 0; -- Counter to control SendDataToRHD64SPI
  
  
begin
  Controller_STM32_1 : entity work.Controller_RHD64_FIFO
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
  SPI_Master_CS_RHD64 : entity work.SPI_Master_CS
    generic map (
      SPI_MODE               => 0,
      CLKS_PER_HALF_BIT      => RHD64_CLKS_PER_HALF_BIT,
      NUM_OF_BITS_PER_PACKET => RHD64_SPI_NUM_BITS_PER_PACKET,
      CS_INACTIVE_CLKS       => RHD64_CS_INACTIVE_CLKS
    )
    port map (
      i_Rst_L            => i_Rst_L,
      i_Clk              => i_Clk,
      i_TX_Byte          => int_RHD64_TX_Byte,
      i_TX_DV            => int_RHD64_TX_DV,
      o_TX_Ready         => int_RHD64_TX_Ready,
      o_RX_DV            => o_RHD64_RX_DV,
      o_RX_Byte_Rising   => int_RHD64_RX_Byte_Rising,  -- WILL ALWAYS BE EMPTY SINCE ITS ONLY A MOSI COMMUNNICATION
      o_RX_Byte_Falling  => open,                      -- FALLING EDGE NOT BEING USE SINCE WE ARE NOT DOING DUAL DATA RATE FOR THIS COMMUNICATION

      o_SPI_Clk  => o_RHD64_SPI_CLK,
      i_SPI_MISO => i_RHD64_SPI_MISO,
      o_SPI_MOSI => o_RHD64_SPI_MOSI,
      o_SPI_CS_n => o_RHD64_SPI_CS_n
    );




  -- RHD64 PROCESS, GETTING DATA ONTO THE FIFO OF THE CONTROLER_RHD64 MODULE
  process (i_Clk)
  begin
    if i_Rst_L = '1' then
        int_FIFO_RE <= '0';  -- Toggle back to '0'
		int_RHD64_TX_Byte <= (others => '1');
    elsif rising_edge(i_Clk) then
		if i_Controller_Mode = x"1" then
		  if int_FIFO_RE = '1' then
			int_FIFO_RE <= '0';  -- Toggle back to '0'
		  end if;
		  
		  if int_FIFO_AEMPTY = '0' and int_RHD64_TX_Ready = '1' then
			-- Read data from FIFO and assign it to STM32_TX_Byte
			int_RHD64_TX_Byte <= int_FIFO_Q(15 downto 0);
			-- Notify the STM32 that data is ready to be sent
			int_RHD64_TX_DV <= '1';
		   
			-- Set the toggle signal for the next rising edge
			int_FIFO_RE <= '1';
		  else
			-- No data to send or STM32 is not ready, clear the data valid signal
			int_RHD64_TX_DV <= '0';
		  end if;
		end if;
	end if;
  end process;








  -- STM32 PROCESS, PUTTING DATA ONTO THE FIFO OF THE CONTROLER_RHD64 MODULE
process (i_Clk)
	variable state : integer := 0;
begin
  if i_Rst_L = '1' then
	counter <= 0;
  elsif rising_edge(i_Clk) then
	if i_Controller_Mode = x"1" then
	  case state is
		when 0 =>
		  -- Sending pattern from the list
		  int_STM32_TX_Byte <= std_logic_vector(to_unsigned(counter, 16));
		  int_STM32_TX_DV   <= '1';
		  counter <= counter + 1;
		  state := 1;

		when 1 =>
		  int_STM32_TX_DV <= '0';
		  state := 2;	

		when 2 =>
		  if int_STM32_TX_Ready = '1' then
			state := 3;
		  else
			state := 2;
		  end if;

		when 3 =>
		  -- FSM is done
		  state := 0;

		when others =>
		  null; -- Optional, handle unexpected states
	  end case;
	end if;
  end if;
end process;


  o_FIFO_RE <= int_FIFO_RE;  

  o_STM32_TX_Byte <= int_STM32_TX_Byte;
  o_RHD64_TX_Byte <= int_RHD64_TX_Byte;

  o_STM32_TX_DV <= int_STM32_TX_DV;
  o_RHD64_TX_DV <= int_RHD64_TX_DV;

  o_RHD64_RX_Byte_Rising <= int_RHD64_RX_Byte_Rising;

  o_STM32_TX_Ready <= int_STM32_TX_Ready;
  o_RHD64_TX_Ready <= int_RHD64_TX_Ready;

  o_FIFO_COUNT   <= int_FIFO_COUNT;
  o_FIFO_Q       <= int_FIFO_Q;
  o_FIFO_EMPTY   <= int_FIFO_EMPTY;
  o_FIFO_FULL    <= int_FIFO_FULL;
  o_FIFO_AEMPTY  <= int_FIFO_AEMPTY;
  o_FIFO_AFULL   <= int_FIFO_AFULL;

end architecture RTL;
