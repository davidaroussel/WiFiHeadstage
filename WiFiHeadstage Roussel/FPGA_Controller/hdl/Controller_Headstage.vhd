library ieee;
use ieee.std_logic_1164.all;

entity Controller_Headstage is
  port (
    i_Rst_L        : in std_logic;
    i_Clk          : in std_logic;

    -- STM32 SPI Interface
    o_STM32_SPI_Clk      : out std_logic;
    i_STM32_SPI_MISO     : in  std_logic;
    o_STM32_SPI_MOSI     : out std_logic;
    o_STM32_SPI_CS_n     : out std_logic;

    -- TX (MOSI) Signals
    i_STM32_TX_Count     : in  std_logic_vector;
    i_STM32_TX_Byte      : in  std_logic_vector(15 downto 0);
    i_STM32_TX_DV        : in  std_logic;
    o_STM32_TX_Ready     : out std_logic;

    -- RX (MISO) Signals
    o_STM32_RX_Count     : out std_logic_vector;
    o_STM32_RX_DV        : out std_logic;
    io_STM32_RX_Byte_Rising  : inout std_logic_vector(15 downto 0);
    io_STM32_RX_Byte_Falling : inout std_logic_vector(15 downto 0);

    -- FIFO Signals
    o_FIFO_Data    : out std_logic_vector(31 downto 0);
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
    i_RHD64_TX_Count     : in  std_logic_vector;
    i_RHD64_TX_Byte      : in  std_logic_vector(15 downto 0);
    i_RHD64_TX_DV        : in  std_logic;
    o_RHD64_TX_Ready     : out std_logic;

    -- RX (MISO) Signals
    o_RHD64_RX_Count     : out std_logic_vector;
    o_RHD64_RX_DV        : out std_logic;
    io_RHD64_RX_Byte_Rising  : inout std_logic_vector(15 downto 0);
    io_RHD64_RX_Byte_Falling : inout std_logic_vector(15 downto 0)
  );
end entity Controller_Headstage;

architecture RTL of Controller_Headstage is
 
  component Controller_RHD64 is 
   port (
      i_Rst_L        : in std_logic;
      i_Clk          : in std_logic;
      o_SPI_Clk      : out std_logic;
      i_SPI_MISO     : in  std_logic;
      o_SPI_MOSI     : out std_logic;
      o_SPI_CS_n     : out std_logic;
      i_TX_Count     : in  std_logic_vector;
      i_TX_Byte      : in  std_logic_vector(15 downto 0);
      i_TX_DV        : in  std_logic;
      o_TX_Ready     : out std_logic;
      o_RX_Count     : out std_logic_vector;
      o_RX_DV        : out std_logic;
      io_RX_Byte_Rising  : inout std_logic_vector(15 downto 0);
      io_RX_Byte_Falling : inout std_logic_vector(15 downto 0);
      o_FIFO_Data    : out std_logic_vector(31 downto 0);
      o_FIFO_WE      : out std_logic;
      i_FIFO_RE      : in std_logic;
      o_FIFO_Q       : out std_logic_vector(31 downto 0);
      o_FIFO_EMPTY   : out std_logic;
      o_FIFO_FULL    : out std_logic;
      o_FIFO_AEMPTY  : out std_logic;
      o_FIFO_AFULL   : out std_logic
    );
  end component;

    -- Component declaration for SPI_Master_CS
  component SPI_Master_CS is
    generic (
      SPI_MODE          : integer := 0;
      CLKS_PER_HALF_BIT : integer := 3;
      MAX_PACKET_PER_CS : integer := 2;
      CS_INACTIVE_CLKS  : integer := 4
    );
    port (
      i_Rst_L    : in std_logic;     -- FPGA Reset
      i_Clk      : in std_logic;     -- FPGA Clock
      -- TX (MOSI) Signals
      i_TX_Count : in  std_logic_vector;  -- # bytes per CS low
      i_TX_Byte  : in  std_logic_vector(15 downto 0);  -- Byte to transmit on MOSI
      i_TX_DV    : in  std_logic;     -- Data Valid Pulse with i_TX_Byte
      o_TX_Ready : out std_logic;     -- Transmit Ready for next byte
      -- RX (MISO) Signals
      o_RX_Count        : out std_logic_vector;  -- Index RX byte
      o_RX_DV           : out std_logic;  -- Data Valid pulse (1 clock cycle)
      io_RX_Byte_Rising  : inout std_logic_vector(15 downto 0);   -- Byte received on MISO Rising  CLK Edge
      io_RX_Byte_Falling : inout std_logic_vector(15 downto 0);  -- Byte received on MISO Falling CLK Edge
      -- SPI Interface
      o_SPI_Clk  : out std_logic;
      i_SPI_MISO : in  std_logic;
      o_SPI_MOSI : out std_logic;
      o_SPI_CS_n : out std_logic
    );
  end component;

  signal int_FIFO_Data    : std_logic_vector(31 downto 0);
  signal int_FIFO_WE      : std_logic;
  signal int_FIFO_RE      : std_logic;
  signal int_FIFO_Q       : std_logic_vector(31 downto 0);
  signal int_FIFO_EMPTY   : std_logic;
  signal int_FIFO_FULL    : std_logic;
  signal int_FIFO_AEMPTY  : std_logic;
  signal int_FIFO_AFULL   : std_logic;

  signal int_STM32_SPI_Clk      : std_logic;
  signal int_STM32_SPI_MISO     : std_logic;
  signal int_STM32_SPI_MOSI     : std_logic;
  signal int_STM32_SPI_CS_n     : std_logic;
  signal int_STM32_TX_Count     : std_logic_vector(15 downto 0);
  signal int_STM32_TX_Byte      : std_logic_vector(15 downto 0);
  signal int_STM32_TX_DV        : std_logic;
  signal int_STM32_TX_Ready     : std_logic;
  signal int_STM32_RX_Count     : std_logic_vector(15 downto 0);
  signal int_STM32_RX_DV        : std_logic;
  signal int_STM32_RX_Byte_Rising  : std_logic_vector(15 downto 0);
  signal int_STM32_RX_Byte_Falling : std_logic_vector(15 downto 0);

  signal sig_FIFO_RE : std_logic;
  
begin
  Controller_RHD64_1 : entity work.Controller_RHD64
    port map (
      i_Rst_L        => i_Rst_L,
      i_Clk          => i_Clk,
      o_SPI_Clk      => o_RHD64_SPI_Clk,
      i_SPI_MISO     => i_RHD64_SPI_MISO,
      o_SPI_MOSI     => o_RHD64_SPI_MOSI,
      o_SPI_CS_n     => o_RHD64_SPI_CS_n,
      i_TX_Count     => i_RHD64_TX_Count,
      i_TX_Byte      => i_RHD64_TX_Byte,
      i_TX_DV        => i_RHD64_TX_DV,
      o_TX_Ready     => o_RHD64_TX_Ready,
      o_RX_Count     => o_RHD64_RX_Count,
      o_RX_DV        => o_RHD64_RX_DV,
      io_RX_Byte_Rising  => io_RHD64_RX_Byte_Rising,
      io_RX_Byte_Falling => io_RHD64_RX_Byte_Falling,
      o_FIFO_Data    => o_FIFO_Data,
      o_FIFO_WE      => o_FIFO_WE,
      i_FIFO_RE      => int_FIFO_RE,
      o_FIFO_Q       => int_FIFO_Q,
      o_FIFO_EMPTY   => int_FIFO_EMPTY,
      o_FIFO_FULL    => int_FIFO_FULL,
      o_FIFO_AEMPTY  => int_FIFO_AEMPTY,
      o_FIFO_AFULL   => int_FIFO_AFULL
    );

  -- SPI_Master_CS instantiation
  SPI_Master_CS_STM32 : entity work.SPI_Master_CS
    generic map (
      SPI_MODE          => 0,
      CLKS_PER_HALF_BIT => 3,
      MAX_PACKET_PER_CS => 2,
      CS_INACTIVE_CLKS  => 4
    )
    port map (
      i_Rst_L           => i_Rst_L,
      i_Clk             => i_Clk,
      i_TX_Count        => i_STM32_TX_Count,           
      i_TX_Byte         => i_STM32_TX_Byte,           
      i_TX_DV           => i_STM32_TX_DV,                   
      o_TX_Ready        => o_STM32_TX_Ready,                
      o_RX_Count        => o_STM32_RX_Count,                
      o_RX_DV           => o_STM32_RX_DV,               
      io_RX_Byte_Rising  => io_STM32_RX_Byte_Rising,
      io_RX_Byte_Falling => io_STM32_RX_Byte_Falling,
      
      o_SPI_Clk  => o_STM32_SPI_CLK,
      i_SPI_MISO => i_STM32_SPI_MISO,
      o_SPI_MOSI => o_STM32_SPI_MOSI,
      o_SPI_CS_n => o_STM32_SPI_CS_n
    );


  -- FIFO to SPI STM32 logic
  process (i_Clk, i_Rst_L)
  begin
    if i_Rst_L = '1' then
      int_FIFO_RE  <= '0';
      sig_FIFO_RE  <= '0'; 
      io_STM32_RX_Byte_Rising <= X"00000000";
      io_STM32_RX_Byte_Falling <= X"00000000";
    elsif rising_edge(i_Clk) then
      if int_FIFO_EMPTY = '1' then
        if sig_FIFO_RE = '0' then
            sig_FIFO_RE <= '1';
            int_FIFO_RE <= '1';
        elsif sig_FIFO_RE = '1' then
            sig_FIFO_RE <= '0';
            int_FIFO_RE <= '0';
            io_STM32_RX_Byte_Rising <= int_FIFO_Q(31 downto 16);
            io_STM32_RX_Byte_Falling <= int_FIFO_Q(15 downto 0);
            
        end if;
      end if;
    end if;
  end process;

  o_FIFO_RE      <=  int_FIFO_RE;
  o_FIFO_Q       <=  int_FIFO_Q;
  o_FIFO_EMPTY   <=  int_FIFO_EMPTY;
  o_FIFO_FULL    <=  int_FIFO_FULL;
  o_FIFO_AEMPTY  <=  int_FIFO_AEMPTY;
  o_FIFO_AFULL   <=  int_FIFO_AFULL;


end architecture RTL;


