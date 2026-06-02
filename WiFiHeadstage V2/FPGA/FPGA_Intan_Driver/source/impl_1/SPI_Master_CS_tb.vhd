library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPI_Master_CS_TB is
end entity SPI_Master_CS_TB;

architecture TB of SPI_Master_CS_TB is

  constant CLK_PERIOD   : time := 10 ns; -- Adjust as needed 

  constant SPI_MODE                : integer := 0;  -- CPOL = 0 CPHA = 0
  constant CLKS_PER_HALF_BIT       : integer := 1;  -- (125/2)/CLK_PER_HALF_BIT MHz
  constant NUM_OF_BITS_PER_PACKET  : integer := 1024;  -- 2 bytes per chip select
  constant CS_INACTIVE_CLKS        : integer := 4;  -- Adds delay between bytes
  
  signal r_Rst_L    : std_logic := '1';
  signal w_SPI_Clk  : std_logic;
  signal r_Clk      : std_logic := '0';
  signal w_SPI_CS_n : std_logic;
  signal w_SPI_MOSI : std_logic;
  signal r_SPI_MISO : std_logic;
  
  -- Master Specific
  signal r_Master_TX_Byte         : std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0) := (others => '0');
  signal r_Master_TX_DV           : std_logic := '0';
  signal w_Master_TX_Ready        : std_logic;
  signal w_Master_RX_DV           : std_logic;
  signal w_Master_RX_Byte_Rising  : std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);
  signal w_Master_RX_Byte_Falling : std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);

  -- Data buffer for SendMessage procedure
  signal message_data : std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);

  -- Sends a single byte from master. 
  procedure SendMessage (
    data          : in  std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);
    signal o_data : out std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);
    signal o_dv   : out std_logic) is
  begin
    wait until rising_edge(r_Clk);
    o_data <= data;
    o_dv   <= '1';
    wait until rising_edge(r_Clk);
    o_dv   <= '0';
    wait until rising_edge(w_Master_TX_Ready);
  end procedure SendMessage;

begin  -- architecture TB 

  -- Clock Generators:
  r_Clk <= not r_Clk after CLK_PERIOD;
  r_SPI_MISO <= w_SPI_MOSI;
  
  -- Data Generation Process
  Data_Gen_Proc: process
  begin
    wait for 10 ns; -- Delay to ensure initialization
    -- Fill message_data with appropriate data
    for i in 0 to NUM_OF_BITS_PER_PACKET/16-1 loop
        message_data(i*16+15 downto i*16) <= std_logic_vector(to_unsigned(i, 16));
    end loop;
    wait;
  end process Data_Gen_Proc;

  -- Instantiate UUT
  UUT : entity work.SPI_Master_CS
    generic map (
      SPI_MODE                => SPI_MODE,
      CLKS_PER_HALF_BIT       => CLKS_PER_HALF_BIT,
      NUM_OF_BITS_PER_PACKET  => NUM_OF_BITS_PER_PACKET,
      CS_INACTIVE_CLKS        => CS_INACTIVE_CLKS)
    port map (
      i_Rst_L    => r_Rst_L,
      i_Clk      => r_Clk,
      -- TX (MOSI) Signals     
      i_TX_Byte  => r_Master_TX_Byte,   -- Byte to transmit on MOSI       
      i_TX_DV    => r_Master_TX_DV,     -- Data Valid Pulse with i_TX_Byte
      o_TX_Ready => w_Master_TX_Ready,  -- Transmit Ready for Byte        
      -- RX (MISO) Signals            
      o_RX_DV           => w_Master_RX_DV,     -- Data Valid pulse (1 clock cycle)
      o_RX_Byte_Rising  => w_Master_RX_Byte_Rising,   -- Byte received on MISO
      o_RX_Byte_Falling => w_Master_RX_Byte_Falling,  -- Byte received on MISO                   
      -- SPI Interface
      o_SPI_Clk  => w_SPI_Clk,
      i_SPI_MISO => r_SPI_MISO,
      o_SPI_MOSI => w_SPI_MOSI,
      o_SPI_CS_n => w_SPI_CS_n
      );

  -- Testing Process
  Testing : process is
  begin
    wait for 100 ns;
    r_Rst_L <= '1';
    wait for 100 ns;
    r_Rst_L <= '0';

    -- Test single byte
    SendMessage(message_data, r_Master_TX_Byte, r_Master_TX_DV);

    -- Test double byte
    SendMessage(message_data, r_Master_TX_Byte, r_Master_TX_DV);

    SendMessage(message_data, r_Master_TX_Byte, r_Master_TX_DV);

    wait for 100 ns;
    assert false report "Test Complete" severity failure;
  end process Testing;

end architecture TB;
