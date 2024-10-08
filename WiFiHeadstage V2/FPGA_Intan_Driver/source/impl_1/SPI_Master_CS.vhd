--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: SPI_Master_CS.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Note:        i_Clk must be at least 2x faster than i_SPI_Clk
--
-- Parameters:  SPI_MODE, can be 0, 1, 2, or 3.  See above.
--              Can be configured in one of 4 modes:
--              Mode | Clock Polarity (CPOL/CKP) | Clock Phase (CPHA)
--               0   |             0             |        0
--               1   |             0             |        1
--               2   |             1             |        0
--               3   |             1             |        1
--
--              CLKS_PER_HALF_BIT - Sets frequency of o_SPI_Clk.  o_SPI_Clk is
--              derived from i_Clk.  Set to integer number of clocks for each
--              half-bit of SPI data.  E.g. 100 MHz i_Clk, CLKS_PER_HALF_BIT = 2
--              would create o_SPI_CLK of 25 MHz.  Must be >= 2
--                 
--              IN THIS CASE, 250MHz (1.5V) 
--
--              MAX_PACKET_PER_CS - Set to the maximum number of bytes that
--              will be sent during a single CS-low pulse.
-- 
--              CS_INACTIVE_CLKS - Sets the amount of time in clock cycles to
--              hold the state of Chip-Selct high (inactive) before next 
--              command is allowed on the line.  Useful if chip requires some
--              time when CS is high between transfers.
--
-- Targeted device: <Family::IGLOO> <Die::AGLN250V2> <Package::100 VQFP>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPI_Master_CS is
  generic (
      SPI_MODE               : integer := 0;
      CLKS_PER_HALF_BIT      : integer := 3;
      NUM_OF_BITS_PER_PACKET : integer := 1024;
      CS_INACTIVE_CLKS       : integer := 4
    );
  port (
   -- Control/Data Signals,
   i_Rst_L : in std_logic;     -- FPGA Reset
   i_Clk   : in std_logic;     -- FPGA Clock
   -- SPI Interface
   o_SPI_Clk  : out std_logic;
   i_SPI_MISO : in  std_logic;
   o_SPI_MOSI : out std_logic;
   o_SPI_CS_n : out std_logic;

   -- TX (MOSI) Signals
   i_TX_DV    : in  std_logic;     -- Data Valid Pulse with i_TX_Byte
   i_TX_Byte  : in  std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);  -- Byte to transmit on MOSI
   o_TX_Ready : out std_logic;     -- Transmit Ready for next byte
   
   -- RX (MISO) Signals
   o_RX_DV    : out std_logic;  -- Data Valid pulse (1 clock cycle)
   o_RX_Byte_Rising  : out std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);   -- Byte received on MISO Rising  CLK Edge
   o_RX_Byte_Falling : out std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0)  -- Byte received on MISO Falling CLK Edge

   );
end entity SPI_Master_CS;

architecture RTL of SPI_Master_CS is

  type t_SM_CS is (IDLE, TRANSFER, CS_INACTIVE);

  signal r_SM_CS : t_SM_CS;
  signal r_CS_n  : std_logic;
  signal r_CS_Inactive_Count : integer range 0 to CS_INACTIVE_CLKS;
  signal r_TX_Count     : integer range 0 to NUM_OF_BITS_PER_PACKET + 1;
  signal w_Master_Ready : std_logic;

  signal r_RX_Count : std_logic_vector(1 downto 0) := (others => '0');
  signal r_RX_DV : std_logic;

  component SPI_Master is
      generic (
        SPI_MODE               : integer := 0;
        CLKS_PER_HALF_BIT      : integer := 2;
        NUM_OF_BITS_PER_PACKET : integer := 32
        );
      port (
       -- Control/Data Signals,
       i_Rst_L : in std_logic;        -- FPGA Reset
       i_Clk   : in std_logic;        -- FPGA Clock
       
       -- TX (MOSI) Signals
       i_TX_Byte   : in std_logic_vector(15 downto 0);   -- Byte to transmit on MOSI
       i_TX_DV     : in std_logic;          -- Data Valid Pulse with i_TX_Byte
       o_TX_Ready  : out std_logic;         -- Transmit Ready for next byte
       
       -- RX (MISO) Signals
       o_RX_DV   : out std_logic;                      -- Data Valid pulse (1 clock cycle)
       o_RX_Byte_Rising  : out std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);    -- Byte received on MISO Rising Edge
       o_RX_Byte_Falling  : out std_logic_vector(NUM_OF_BITS_PER_PACKET-1 downto 0);   -- Byte received on MISO Falling Edge
      
       -- SPI Interface
       o_SPI_Clk  : out std_logic;
       i_SPI_MISO : in  std_logic;
       o_SPI_MOSI : out std_logic
       );
    end component SPI_Master;


begin

  -- Instantiate Master
  SPI_Master_1 : entity work.SPI_Master
    generic map (
      SPI_MODE               => SPI_MODE,
      CLKS_PER_HALF_BIT      => CLKS_PER_HALF_BIT,
      NUM_OF_BITS_PER_PACKET => NUM_OF_BITS_PER_PACKET)
    port map (
      -- Control/Data Signals,
      i_Rst_L    => i_Rst_L,            -- FPGA Reset
      i_Clk      => i_Clk,              -- FPGA Clock
      -- TX (MOSI) Signals
      i_TX_Byte  => i_TX_Byte,          -- Byte to transmit
      i_TX_DV    => i_TX_DV,            -- Data Valid pulse
      o_TX_Ready => w_Master_Ready,     -- Transmit Ready for Byte
      -- RX (MISO) Signals
      o_RX_DV           => r_RX_DV,            -- Data Valid pulse
      o_RX_Byte_Rising  => o_RX_Byte_Rising,   -- Byte received on MISO Rising  CLK Edge 
      o_RX_Byte_Falling => o_RX_Byte_Falling,  -- Byte received on MISO Falling CLK Edge       
       -- SPI Interface
      o_SPI_Clk  => o_SPI_Clk, 
      i_SPI_MISO => i_SPI_MISO,
      o_SPI_MOSI => o_SPI_MOSI
      );
  

  -- Purpose: Control CS line using State Machine
  SM_CS : process (i_Clk, i_Rst_L) is
  begin
    if i_Rst_L = '1' then
      r_SM_CS             <= IDLE;
      r_CS_n              <= '1';   -- Resets to high
      r_TX_Count          <= 0;
      r_CS_Inactive_Count <= CS_INACTIVE_CLKS;
    elsif rising_edge(i_Clk) then

      case r_SM_CS is
        when IDLE =>
          if r_CS_n = '1' and i_TX_DV = '1' then -- Start of transmission
            r_TX_Count <= 0;         -- Register TX Count
            r_CS_n     <= '0';       -- Drive CS low
            r_SM_CS    <= TRANSFER;   -- Transfer bytes
          end if;

        when TRANSFER =>
          -- Wait until SPI is done transferring do next thing
          if w_Master_Ready = '1' then
            if r_TX_Count > 0 then
              if i_TX_DV = '1' then
                r_TX_Count <= r_TX_Count - 1;
              end if;
            else
              r_CS_n              <= '1'; -- we done, so set CS high
              r_CS_Inactive_Count <= CS_INACTIVE_CLKS;
              r_SM_CS             <= CS_INACTIVE;
            end if;
          end if;
          
        when CS_INACTIVE =>
          if r_CS_Inactive_Count > 0 then
            r_CS_Inactive_Count <= r_CS_Inactive_Count - 1;
          else
            r_SM_CS <= IDLE;
          end if;

        when others =>
          r_SM_CS <= IDLE;
      end case;
    end if;
  end process SM_CS;
  

  -- RX Count logic
  RX_COUNT : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      if r_CS_n = '1' then
        r_RX_Count <= std_logic_vector(to_unsigned(0, r_RX_Count'length));
      elsif r_RX_DV = '1' then
        r_RX_Count <= std_logic_vector(unsigned(r_RX_Count) + 1);
      end if;
    end if;
  end process RX_COUNT;

  -- Assign internal signals to output ports
  o_RX_DV <= r_RX_DV;

  o_SPI_CS_n <= r_CS_n;
  
  o_TX_Ready <= '1' when 
				i_TX_DV /= '1' and ((r_SM_CS = IDLE)  or  (r_SM_CS = TRANSFER and w_Master_Ready = '1' and r_TX_Count > 0)) 
				else '0'; 

end architecture RTL;
