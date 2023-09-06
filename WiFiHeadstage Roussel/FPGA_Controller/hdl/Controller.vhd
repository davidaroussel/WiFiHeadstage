library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity Controller is
  generic (
    SPI_MODE          : integer := 0;
    CLKS_PER_HALF_BIT : integer := 2;
    MAX_PACKET_PER_CS : integer := 1;
    CS_INACTIVE_CLKS  : integer := 1
    );
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
    o_RX_Byte_Rising  : out std_logic_vector(15 downto 0);   -- Byte received on MISO Rising  CLK Edge
    o_RX_Byte_Falling : out std_logic_vector(15 downto 0);  -- Byte received on MISO Falling CLK Edge

    o_FIFO_Data : out std_logic_vector(31 downto 0);
    o_FIFO_EMPTY : out std_logic;
    o_FIFO_FULL : out std_logic;
    o_FIFO_AEMPTY : out std_logic;
    o_FIFO_AFULL : out std_logic
  );
end entity Controller;

architecture RTL of Controller is

  -- Signals for SPI_Master_CS
  signal inter_RX_Byte_Rising  : std_logic_vector(15 downto 0);
  signal inter_RX_Byte_Falling : std_logic_vector(15 downto 0);
  signal inter_RX_DV           : std_logic;
  
  signal inter_TX_Byte         : std_logic_vector(15 downto 0);
  signal inter_TX_DV           : std_logic; 
  signal inter_TX_Ready        : std_logic;

  signal inter_FIFO_DATA : std_logic_vector(31 downto 0);
  signal inter_FIFO_Q    : std_logic_vector(31 downto 0);
  signal inter_FIFO_WE   : std_logic;
  signal inter_FIFO_RE   : std_logic;
  signal inter_FIFO_RESET     : std_logic;
  signal inter_FIFO_WCLOCK    : std_logic;
  signal inter_FIFO_RCLOCK    : std_logic;
  signal inter_FIFO_FULL      : std_logic;
  signal inter_FIFO_EMPTY     : std_logic;
  signal inter_FIFO_AEMPTY    : std_logic;
  signal inter_FIFO_AFULL     : std_logic;



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
      o_RX_Byte_Rising  : out std_logic_vector(15 downto 0);   -- Byte received on MISO Rising  CLK Edge
      o_RX_Byte_Falling : out std_logic_vector(15 downto 0);  -- Byte received on MISO Falling CLK Edge
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

begin
  -- SPI_Master_CS instantiation
  SPI_Master_CS_1 : SPI_Master_CS
    generic map (
      SPI_MODE           => SPI_MODE,
      CLKS_PER_HALF_BIT  => CLKS_PER_HALF_BIT,
      MAX_PACKET_PER_CS  => MAX_PACKET_PER_CS,
      CS_INACTIVE_CLKS   => CS_INACTIVE_CLKS
    )
    port map (
      i_Rst_L           => i_Rst_L,
      i_Clk             => i_Clk,
      i_TX_Count        => i_TX_Count,           
      i_TX_Byte         => inter_TX_Byte,           
      i_TX_DV           => inter_TX_DV,                   
      o_TX_Ready        => inter_TX_Ready,                
      o_RX_Count        => o_RX_Count,                
      o_RX_DV           => inter_RX_DV,               
      o_RX_Byte_Rising  => inter_RX_Byte_Rising,
      o_RX_Byte_Falling => inter_RX_Byte_Falling,
      
      o_SPI_Clk  => o_SPI_CLK,
      i_SPI_MISO => i_SPI_MISO,
      o_SPI_MOSI => o_SPI_MOSI,
      o_SPI_CS_n => o_SPI_CS_n
    );


  FIFO_1 : entity work.FIFO
    port map (
      DATA      => inter_FIFO_DATA,
      Q         => inter_FIFO_Q,
      WE        => inter_FIFO_WE,
      RE        => inter_FIFO_RE,
      WCLOCK    => inter_FIFO_WCLOCK,
      RCLOCK    => inter_FIFO_RCLOCK,
      FULL      => inter_FIFO_FULL,
      EMPTY     => inter_FIFO_EMPTY,
      RESET     => inter_FIFO_RESET,
      AEMPTY    => inter_FIFO_AEMPTY,
      AFULL     => inter_FIFO_AFULL
      );

  inter_FIFO_RESET  <= i_Rst_L; 
  inter_FIFO_WCLOCK <= i_Clk;
  inter_FIFO_RCLOCK <= i_Clk;
  
  inter_TX_DV       <= i_TX_DV;     -- Data Valid Pulse with i_TX_Byte
  
  -- FIFO logic
  process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      -- Check if SPI data is valid and FIFO is not full
      if inter_RX_DV = '1' and inter_FIFO_FULL = '0' then
        -- Push MISO data into the FIFO
        inter_FIFO_DATA(31 downto 16) <= inter_RX_Byte_Rising;
        inter_FIFO_DATA(15 downto 0)  <= inter_RX_Byte_Falling;
      end if;
    end if;
  end process;

  -- Full and Empty flags
  o_FIFO_FULL <= inter_FIFO_FULL;
  o_FIFO_EMPTY <= inter_FIFO_EMPTY;

  -- RX (MISO) Signals
  o_RX_DV          <= inter_RX_DV;
  o_RX_Byte_Rising <= inter_RX_Byte_Rising;
  o_RX_Byte_Falling <= inter_RX_Byte_Falling; 
  


  -- Reset logic
  process (i_Rst_L)
  begin
    if i_Rst_L = '1' then
      inter_FIFO_DATA <= (others => '0');
      inter_FIFO_FULL <= '0';
      inter_FIFO_EMPTY <= '1';
    elsif rising_edge(inter_FIFO_RE) then
      inter_FIFO_FULL <= '0';
      if inter_FIFO_EMPTY = '0' then
        inter_FIFO_EMPTY <= '1';
      end if;
    end if;
  end process;

  -- Data access ports
  o_FIFO_DATA <= inter_FIFO_DATA;

  -- Almost empty and Almost full flags
  o_FIFO_AEMPTY <= '0';  -- Modify as needed
  o_FIFO_AFULL <= '0';   -- Modify as needed

  o_TX_Ready <= inter_TX_Ready;     -- Transmit Ready for next byte


end architecture RTL;
