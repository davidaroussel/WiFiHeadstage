--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Controller.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::IGLOO> <Die::AGLN250V2> <Package::100 VQFP>
-- Author: <Name>
--
--------------------------------------------------------------------------------
library IEEE;

use IEEE.std_logic_1164.all;

entity Controller is
   generic (
       NUM_OF_READ_TO_PUSH : integer := 32 -- 64 CHANNELS WITH DUAL DATA BIT SPI PROTOCOLE SO 32 READ NECESSARY
        );
   port (
       -- Control/Data Signals,
       i_Rst_L : in std_logic;     -- FPGA Reset
       i_Clk   : in std_logic;     -- FPGA Clock

       -- SPI Interface
       o_uC_SPI_Clk  : out std_logic;
       i_uC_SPI_MISO : in  std_logic;
       o_uC_SPI_MOSI : out std_logic;
       o_uC_SPI_CS_n : out std_logic;

       -- SPI Interface
       o_RHD64_uC_SPI_Clk  : out std_logic;
       i_RHD64_uC_SPI_MISO : in  std_logic;
       o_RHD64_uC_SPI_MOSI : out std_logic;
       o_RHD64_uC_SPI_CS_n : out std_logic

       o_FIFO_FULL   : out   std_logic;
       o_FIFO_EMPTY  : out   std_logic;
       o_FIFO_AEMPTY : out   std_logic;
       o_FIFO_AFULL  : out   std_logic
        );
end Controller;


architecture architecture_Controller of Controller is
   -- Control/Data Signals,
   signal r_Rst_L : in std_logic;     -- FPGA Reset
   signal w_Clk   : in std_logic;     -- FPGA Clock

   -- TX (MOSI) Signals
   signal r_uC_TX_Count : in  std_logic_vector;               -- # bytes per CS low
   signal r_uC_TX_Byte  : in  std_logic_vector(15 downto 0);  -- Byte to transmit on MOSI
   signal r_uC_TX_DV    : in  std_logic;     -- Data Valid Pulse with i_TX_Byte
   signal w_uC_TX_Ready : out std_logic;     -- Transmit Ready for next byte
   -- RX (MISO) Signals
   signal w_uC_RX_Count : out std_logic_vector;  -- Index RX byte
   signal w_uC_RX_DV    : out std_logic;         -- Data Valid pulse (1 clock cycle)
   signal w_uC_RX_Byte_Rising  : out std_logic_vector(15 downto 0);  -- Byte received on MISO Rising  CLK Edge
   signal w_uC_RX_Byte_Falling : out std_logic_vector(15 downto 0);  -- Byte received on MISO Falling CLK Edge
   -- SPI Interface
   signal w_uC_SPI_Clk  : out std_logic;
   signal r_uC_SPI_MISO : in  std_logic;
   signal w_uC_SPI_MOSI : out std_logic;
   signal w_uC_SPI_CS_n : out std_logic;
  
   -- TX (MOSI) Signals
   signal r_RHD64_TX_Count : in  std_logic_vector;               -- # bytes per CS low
   signal r_RHD64_TX_Byte  : in  std_logic_vector(15 downto 0);  -- Byte to transmit on MOSI
   signal r_RHD64_TX_DV    : in  std_logic;     -- Data Valid Pulse with i_TX_Byte
   signal w_RHD64_TX_Ready : out std_logic;     -- Transmit Ready for next byte
   -- RX (MISO) Signals
   signal w_RHD64_RX_Count : out std_logic_vector;  -- Index RX byte
   signal w_RHD64_RX_DV    : out std_logic;         -- Data Valid pulse (1 clock cycle)
   signal w_RHD64_RX_Byte_Rising  : out std_logic_vector(15 downto 0);   -- Byte received on MISO Rising  CLK Edge
   signal w_RHD64_RX_Byte_Falling  : out std_logic_vector(15 downto 0);  -- Byte received on MISO Falling CLK Edge
   -- SPI Interface
   signal w_RHD64_SPI_Clk  : out std_logic;
   signal r_RHD64_SPI_MISO : in  std_logic;
   signal w_RHD64_SPI_MOSI : out std_logic;
   signal w_RHD64_SPI_CS_n : out std_logic
   
    -- FIFO Interface
   signal r_FIFO_DATA   : in    std_logic_vector(31 downto 0);
   signal w_FIFO_Q      : out   std_logic_vector(31 downto 0);
   signal r_FIFO_WE     : in    std_logic;
   signal r_FIFO_RE     : in    std_logic;
   signal r_FIFO_WCLOCK : in    std_logic;
   signal r_FIFO_RCLOCK : in    std_logic;
   signal w_FIFO_FULL   : out   std_logic;
   signal w_FIFO_EMPTY  : out   std_logic;
   signal r_FIFO_RESET  : in    std_logic;
   signal w_FIFO_AEMPTY : out   std_logic;
   signal w_FIFO_AFULL  : out   std_logic;

   constant r_COMMAND_0  : integer:= 16#00#;
   constant r_COMMAND_63 : integer:= 16#63#;
   
   signal r_CH_Counter : integer range 0 to NUM_OF_READ_TO_PUSH;

   type t_SM_RHD64 is (IDLE, PUT_DATA_ON_LINE, FIFO_FULL);
   signal r_SM_RHD64 : t_SM_RHD64;

begin

  -- Instantiate Master uControler
  SPI_Master_CS_1 : entity work.SPI_Master_CS
    generic map (
      SPI_MODE          => integer := 0,
      CLKS_PER_HALF_BIT => integer := 2,
      MAX_BYTES_PER_CS  => integer := 1,
      CS_INACTIVE_CLKS  => integer := 1)
    port map (
      -- Control/Data Signals,
      i_Rst_L    => r_Rst_L,            -- FPGA Reset
      i_Clk      => r_Clk,              -- FPGA Clock
      -- TX (MOSI) Signals
      i_TX_Count => r_uC_TX_Count,         -- Index Tx byte
      i_TX_Byte  => r_uC_TX_Byte,          -- Byte to transmit
      i_TX_DV    => r_uC_TX_DV,            -- Data Valid pulse
      o_TX_Ready => w_uC_TX_Ready,         -- Transmit Ready for Byte
      -- RX (MISO) Signals
      o_RX_Count        => o_uC_RX_Count          -- Index RX byte
      o_RX_DV           => o_uC_RX_DV,            -- Data Valid pulse
      o_RX_Byte_Rising  => o_uC_RX_Byte_Rising,   -- Byte received on MISO Rising  CLK Edge 
      o_RX_Byte_Falling => o_uC_RX_Byte_Falling,  -- Byte received on MISO Falling CLK Edge       
       -- SPI Interface
      o_SPI_Clk  => w_uC_SPI_Clk, 
      i_SPI_MISO => r_uC_SPI_MISO,
      o_SPI_MOSI => w_uC_SPI_MOSI,
      o_SPI_CS_n => w_uC_SPI_CS_n
      );

  -- Instantiate Master RHD64
  SPI_Master_CS_2 : entity work.SPI_Master_CS
    generic map (
      SPI_MODE          => integer := 0,
      CLKS_PER_HALF_BIT => integer := 2,
      MAX_BYTES_PER_CS  => integer := 2,
      CS_INACTIVE_CLKS  => integer := 1)
    port map (
      -- Control/Data Signals,
      i_Rst_L    => r_Rst_L,            -- FPGA Reset
      i_Clk      => r_Clk,              -- FPGA Clock
      -- TX (MOSI) Signals
      i_TX_Count => r_RHD64_TX_Count,         -- Index Tx byte
      i_TX_Byte  => r_RHD64_TX_Byte,          -- Byte to transmit
      i_TX_DV    => r_RHD64_TX_DV,            -- Data Valid pulse
      o_TX_Ready => w_RHD64_TX_Ready,     -- Transmit Ready for Byte
      -- RX (MISO) Signals
      o_RX_Count        => w_RHD64_RX_Count          -- Index RX byte
      o_RX_DV           => w_RHD64_RX_DV,            -- Data Valid pulse
      o_RX_Byte_Rising  => w_RHD64_RX_Byte_Rising,   -- Byte received on MISO Rising  CLK Edge 
      o_RX_Byte_Falling => w_RHD64_RX_Byte_Falling,  -- Byte received on MISO Falling CLK Edge       
       -- SPI Interface
      o_SPI_Clk  => w_RHD64_SPI_Clk, 
      i_SPI_MISO => r_RHD64_SPI_MISO,
      o_SPI_MOSI => w_RHD64_SPI_MOSI,
      o_SPI_CS_n => w_RHD64_SPI_CS_n
      );

  -- Instantiate FIFO
  FIFO_1 : entity work.FIFO
    port map(
      DATA   => i_FIFO_DATA,
      Q      => o_FIFO_Q,
      WE     => o_FIFO_WE,
      RE     => o_FIFO_RE,
      WCLOCK => o_FIFO_WCLOCK,
      RCLOCK => o_FIFO_RCLOCK,
      FULL   => o_FIFO_FULL,
      EMPTY  => o_FIFO_EMPTY,
      RESET  => o_FIFO_RESET,
      AEMPTY => o_FIFO_AEMPTY,
      AFULL  => o_FIFO_AFULL
    );

  



  RHD64 : process(i_Clk, i_Rst_L) is
  begin
    if i_Rst_L = '1' then
        r_CH_Counter <= '32';
    elsif rising_edge(i_Clk) then
        case r_SM_RHD64 is
            when IDLE =>
                
      
            when INSERT_DATA_MOSI =>
                if w_RHD64_TX_Ready = '1' then                        
                    if r_CH_Counter = '0' then
                        r_RHD64_TX_Byte <= r_COMMAND_0;
                    else
                        r_RHD64_TX_Byte <= r_COMMAND_63;
                    end if;
                    r_RHD64_TX_DV <= '1';
                end if;    
                r_CH_Counter <= r_CH_Counter + 1;
                r_SM_RHD64   <= FLAG_TX_DV;
                    
            when FLAG_TX_DV => 
                r_RHD64_TX_DV <= '0';
                r_SM_RHD64   <= TRANSFER_DATA;

            when TRANSFER_DATA =>
                if r_CH_Counter > 0 then
                    r_CH_Counter = r_CH_Counter - 1;
                end if;
                
                
                

                   

            when CS_INACTIVE =>
         
            when others => 
            r_CS_n  <= '1'; -- we done, so set CS high
            r_SM_RHD64 <= IDLE;
        end case;
                



  end process RHD64;

   -- architecture body
end architecture_Controller;

