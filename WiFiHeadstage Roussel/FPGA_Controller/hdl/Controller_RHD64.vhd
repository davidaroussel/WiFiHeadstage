library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity Controller_RHD64 is
  port (
    i_Rst_L        : in std_logic;
    i_Clk          : in std_logic;

    -- SPI Interface
    o_SPI_Clk  : out std_logic;
    i_SPI_MISO : in  std_logic;
    o_SPI_MOSI : out std_logic;
    o_SPI_CS_n : out std_logic;
    
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

    o_FIFO_Data   : out std_logic_vector(31 downto 0);
    o_FIFO_WE     : out std_logic;
    i_FIFO_RE     : in std_logic;

    o_FIFO_Q : out std_logic_vector(31 downto 0);
    o_FIFO_EMPTY : out std_logic;
    o_FIFO_FULL : out std_logic;
    o_FIFO_AEMPTY : out std_logic;
    o_FIFO_AFULL : out std_logic
  
);
end entity Controller_RHD64;

architecture RTL of Controller_RHD64 is

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

  component FIFO is
    port( DATA   : in    std_logic_vector(31 downto 0);
          Q      : out   std_logic_vector(31 downto 0);
          WE     : in    std_logic;
          RE     : in    std_logic;
          WCLOCK : in    std_logic;
          RCLOCK : in    std_logic;
          FULL   : out   std_logic;
          EMPTY  : out   std_logic;
          RESET  : in    std_logic;
          AEMPTY : out   std_logic;
          AFULL  : out   std_logic
      );
  end component FIFO;

  -- Signals for SPI_Master_CS
  signal int_RX_Byte_Rising  : std_logic_vector(15 downto 0);
  signal int_RX_Byte_Falling : std_logic_vector(15 downto 0);
  signal int_RX_DV           : std_logic;
  
  signal int_TX_Byte         : std_logic_vector(15 downto 0);
  signal int_TX_DV           : std_logic; 
  signal int_TX_Ready        : std_logic;

  signal int_FIFO_DATA : std_logic_vector(31 downto 0);
  signal int_FIFO_Q    : std_logic_vector(31 downto 0);
  signal int_FIFO_WE   : std_logic;
  --signal int_FIFO_RE   : std_logic;
  --signal int_FIFO_RESET     : std_logic;
  --signal int_FIFO_WCLOCK    : std_logic;
  --signal int_FIFO_RCLOCK    : std_logic;
  signal int_FIFO_FULL      : std_logic;
  signal int_FIFO_EMPTY     : std_logic;
  signal int_FIFO_AEMPTY    : std_logic;
  signal int_FIFO_AFULL     : std_logic;
  

begin
  -- SPI_Master_CS instantiation
  SPI_Master_CS_1 : SPI_Master_CS
    generic map (
      SPI_MODE          => 0,
      CLKS_PER_HALF_BIT => 3,
      MAX_PACKET_PER_CS => 2,
      CS_INACTIVE_CLKS  => 4
    )
    port map (
      i_Rst_L           => i_Rst_L,
      i_Clk             => i_Clk,
      i_TX_Count        => i_TX_Count,           
      i_TX_Byte         => i_TX_Byte,           
      i_TX_DV           => i_TX_DV,                   
      o_TX_Ready        => o_TX_Ready,                
      o_RX_Count        => o_RX_Count,                
      o_RX_DV           => int_RX_DV,               
      io_RX_Byte_Rising  => int_RX_Byte_Rising,
      io_RX_Byte_Falling => int_RX_Byte_Falling,
      
      o_SPI_Clk  => o_SPI_CLK,
      i_SPI_MISO => i_SPI_MISO,
      o_SPI_MOSI => o_SPI_MOSI,
      o_SPI_CS_n => o_SPI_CS_n
    );


  FIFO_1 : entity work.FIFO
    port map (
      DATA      => int_FIFO_DATA,
      Q         => o_FIFO_Q,
      WE        => int_FIFO_WE,
      RE        => i_FIFO_RE,
      WCLOCK    => i_Clk,
      RCLOCK    => i_Clk,
      FULL      => int_FIFO_FULL,
      EMPTY     => int_FIFO_EMPTY,
      RESET     => i_Rst_L,
      AEMPTY    => int_FIFO_AEMPTY,
      AFULL     => int_FIFO_AFULL
      );

  -- SPI RHD64 to FIFO logic
  process (i_Clk, i_Rst_L)
  begin
    if i_Rst_L = '1' then
      int_FIFO_DATA <= X"00000000";
      int_FIFO_WE   <= '0';  
    elsif rising_edge(i_Clk) then
      if int_RX_DV = '1' then
        -- Push MISO data into the FIFO
        int_FIFO_WE <= '1';
        int_FIFO_DATA(31 downto 16) <= int_RX_Byte_Rising;
        int_FIFO_DATA(15 downto 0)  <= int_RX_Byte_Falling;
      else
        int_FIFO_WE <= '0';
      end if;
    end if;
  end process;


  -- SIGNALING FOR CONTROLLER TESTBENCH
  o_FIFO_WE     <= int_FIFO_WE;
  
  -- SIGNALING FOR CONTROLLER TESTBENCH
  
  -- data access ports
  o_FIFO_DATA <= int_FIFO_DATA;
  --o_FIFO_Q <= int_FIFO_Q;
  -- RX (MISO) Signals
  o_RX_DV            <= int_RX_DV;
  io_RX_Byte_Rising  <= int_RX_Byte_Rising;
  io_RX_Byte_Falling <= int_RX_Byte_Falling; 
  -- Full and Empty flags
  o_FIFO_FULL  <= int_FIFO_FULL;
  o_FIFO_EMPTY <= int_FIFO_EMPTY;
  -- almost empty and almost full flags
  o_FIFO_AEMPTY <= int_FIFO_AEMPTY;  
  o_FIFO_AFULL  <= int_FIFO_AFULL;   



end architecture RTL;

