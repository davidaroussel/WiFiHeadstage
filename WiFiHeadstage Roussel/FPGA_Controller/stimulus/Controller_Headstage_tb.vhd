library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_Headstage_tb is
end entity Controller_Headstage_tb;

architecture Testbench of Controller_Headstage_tb is
  -- Constants
  constant CLK_PERIOD : time := 20.83 ns;

  -- Signals
  signal tb_Rst_L        : std_logic := '0';
  signal tb_Clk          : std_logic := '0';

  -- STM32 SPI Interface
  signal tb_STM32_SPI_Clk      : std_logic;
  signal tb_STM32_SPI_MISO     : std_logic;
  signal tb_STM32_SPI_MOSI     : std_logic;
  signal tb_STM32_SPI_CS_n     : std_logic;
  signal tb_STM32_TX_Count     : std_logic_vector(1 downto 0)  := "01";
  signal tb_STM32_TX_Byte      : std_logic_vector(15 downto 0) := X"0000";
  signal tb_STM32_TX_DV        : std_logic := '0';
  signal tb_STM32_TX_Ready     : std_logic;
  signal tb_STM32_RX_Count     : std_logic_vector(15 downto 0);
  signal tb_STM32_RX_DV        : std_logic;
  signal tb_STM32_RX_Byte_Rising  : std_logic_vector(15 downto 0);
  signal tb_STM32_RX_Byte_Falling : std_logic_vector(15 downto 0);

  -- FIFO Signals
  signal tb_FIFO_Data    : std_logic_vector(31 downto 0);
  signal tb_FIFO_WE      : std_logic;
  signal tb_FIFO_RE      : std_logic;
  signal tb_FIFO_Q       : std_logic_vector(31 downto 0);
  signal tb_FIFO_EMPTY   : std_logic;
  signal tb_FIFO_FULL    : std_logic;
  signal tb_FIFO_AEMPTY  : std_logic;
  signal tb_FIFO_AFULL   : std_logic;

  -- RHD64 SPI Interface
  signal tb_RHD64_SPI_Clk      : std_logic;
  signal tb_RHD64_SPI_MISO     : std_logic;
  signal tb_RHD64_SPI_MOSI     : std_logic;
  signal tb_RHD64_SPI_CS_n     : std_logic;
  signal tb_RHD64_TX_Count     : std_logic_vector(1 downto 0)  := "01";
  signal tb_RHD64_TX_Byte      : std_logic_vector(15 downto 0) := X"0000";
  signal tb_RHD64_TX_DV        : std_logic := '0';
  signal tb_RHD64_TX_Ready     : std_logic;
  signal tb_RHD64_RX_Count     : std_logic_vector(15 downto 0);
  signal tb_RHD64_RX_DV        : std_logic;
  signal tb_RHD64_RX_Byte_Rising  : std_logic_vector(15 downto 0);
  signal tb_RHD64_RX_Byte_Falling : std_logic_vector(15 downto 0);
  
  -- Sends a single byte from master. 
  procedure SendMessage (
    data          : in  std_logic_vector(15 downto 0);
    signal o_data : out std_logic_vector(15 downto 0);
    signal o_dv   : out std_logic) is
  begin
    wait until rising_edge(tb_Clk);
    o_data <= data;
    o_dv   <= '1';
    wait until rising_edge(tb_Clk);
    o_dv   <= '0';
    wait until rising_edge(tb_RHD64_TX_Ready);
  end procedure SendMessage;
begin

  tb_Clk <= not tb_Clk after CLK_PERIOD;
  tb_RHD64_SPI_MISO <= tb_RHD64_SPI_MOSI;
  -- Instantiate the Controller_Headstage
  UUT : entity work.Controller_Headstage
    port map (
      i_Rst_L        => tb_Rst_L,
      i_Clk          => tb_Clk,
      o_STM32_SPI_Clk          => tb_STM32_SPI_Clk,
      i_STM32_SPI_MISO         => tb_STM32_SPI_MISO,
      o_STM32_SPI_MOSI         => tb_STM32_SPI_MOSI,
      o_STM32_SPI_CS_n         => tb_STM32_SPI_CS_n,
      i_STM32_TX_Count         => tb_STM32_TX_Count,
      i_STM32_TX_Byte          => tb_STM32_TX_Byte,
      i_STM32_TX_DV            => tb_STM32_TX_DV,
      o_STM32_TX_Ready         => tb_STM32_TX_Ready,
      o_STM32_RX_Count         => tb_STM32_RX_Count,
      o_STM32_RX_DV            => tb_STM32_RX_DV,
      io_STM32_RX_Byte_Rising  => tb_STM32_RX_Byte_Rising,
      io_STM32_RX_Byte_Falling => open,
      o_FIFO_Data    => tb_FIFO_Data,
      o_FIFO_WE      => tb_FIFO_WE,
      o_FIFO_RE      => tb_FIFO_RE,
      o_FIFO_Q       => tb_FIFO_Q,
      o_FIFO_EMPTY   => tb_FIFO_EMPTY,
      o_FIFO_FULL    => tb_FIFO_FULL,
      o_FIFO_AEMPTY  => tb_FIFO_AEMPTY,
      o_FIFO_AFULL   => tb_FIFO_AFULL,
      o_RHD64_SPI_Clk          => tb_RHD64_SPI_Clk,
      i_RHD64_SPI_MISO         => tb_RHD64_SPI_MISO,
      o_RHD64_SPI_MOSI         => tb_RHD64_SPI_MOSI,
      o_RHD64_SPI_CS_n         => tb_RHD64_SPI_CS_n,
      i_RHD64_TX_Count         => tb_RHD64_TX_Count,
      i_RHD64_TX_Byte          => tb_RHD64_TX_Byte,
      i_RHD64_TX_DV            => tb_RHD64_TX_DV,
      o_RHD64_TX_Ready         => tb_RHD64_TX_Ready,
      o_RHD64_RX_Count         => tb_RHD64_RX_Count,
      o_RHD64_RX_DV            => tb_RHD64_RX_DV,
      io_RHD64_RX_Byte_Rising  => tb_RHD64_RX_Byte_Rising,
      io_RHD64_RX_Byte_Falling => tb_RHD64_RX_Byte_Falling
    );

  Testing : process is
  begin
    wait for 100 ns;
    tb_Rst_L <= '1';
    tb_FIFO_RE <= '0';
    wait for 100 ns;
    tb_Rst_L <= '0';
    
    wait until rising_edge(tb_Clk);
    wait until rising_edge(tb_Clk);
    
    
    -- Test single byte
    SendMessage(X"C1C2", tb_RHD64_TX_Byte, tb_RHD64_TX_DV);
    report "Sent out 0xC1C2, Received 0x" & to_hstring(unsigned(tb_RHD64_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(tb_RHD64_RX_Byte_Falling));

    wait until rising_edge(tb_Clk);
    tb_FIFO_RE <= '1';
    wait until rising_edge(tb_Clk);
    tb_FIFO_RE <= '0';
    report "Received 0x" & to_hstring(unsigned(tb_FIFO_Q)); 
    
    -- Test double byte
    SendMessage(X"ADBC", tb_RHD64_TX_Byte, tb_RHD64_TX_DV);
    report "Sent out 0xADBC, Received 0x" & to_hstring(unsigned(tb_RHD64_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(tb_RHD64_RX_Byte_Falling));


    SendMessage(X"A1A2", tb_RHD64_TX_Byte, tb_RHD64_TX_DV);
    report "Sent out 0xA1A2, Received 0x" & to_hstring(unsigned(tb_RHD64_RX_Byte_Rising)); 
    report " and 0x" & to_hstring(unsigned(tb_RHD64_RX_Byte_Falling));   

    wait until rising_edge(tb_Clk);
    tb_FIFO_RE <= '1';
    wait until rising_edge(tb_Clk);
    tb_FIFO_RE <= '0';
    report "Received 0x" & to_hstring(unsigned(tb_FIFO_Q)); 
    for i in 0 to 9 loop
        wait until rising_edge(tb_Clk);
    end loop;
    
    tb_FIFO_RE <= '1';
    wait until rising_edge(tb_Clk);
    tb_FIFO_RE <= '0';
    report "Received 0x" & to_hstring(unsigned(tb_FIFO_Q)); 

    wait for 5000 ns;
    assert false report "Test Complete" severity failure;
  end process Testing;
end architecture Testbench;
