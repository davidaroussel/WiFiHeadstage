----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Thu Aug 24 14:04:40 2023
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FIFO_tb.vhd
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity FIFO_tb is
end FIFO_tb;
 
architecture behave of FIFO_tb is
  signal r_DATA   : std_logic_vector(31 downto 0);
  signal w_Q      : std_logic_vector(31 downto 0);
  signal r_WE     : std_logic := '0';
  signal r_RE     : std_logic := '0';
  signal r_CLOCK  : std_logic := '0';  
  signal r_WCLOCK : std_logic;
  signal r_RCLOCK : std_logic;
  signal w_FULL   : std_logic;
  signal w_EMPTY  : std_logic;
  signal r_RESET  : std_logic := '1';
  signal w_AEMPTY : std_logic;
  signal w_AFULL  : std_logic;
   
  
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
  MODULE_FIFO : FIFO
    port map (
      DATA      => r_DATA,
      Q         => w_Q,
      WE        => r_WE,
      RE        => r_RE,
      WCLOCK    => r_WCLOCK,
      RCLOCK    => r_RCLOCK,
      FULL      => w_FULL,
      EMPTY     => w_EMPTY,
      RESET     => r_RESET,
      AEMPTY    => w_AEMPTY,
      AFULL     => w_AFULL
      );
   
  -- Clock Generators:
  r_CLOCK <= not r_CLOCK after 20.83 ns;
  r_WCLOCK <= r_CLOCK;
  r_RCLOCK <= r_CLOCK;

  p_TEST : process is
  begin
    r_RESET <= '0';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    r_RESET <= '1';    
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    
    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';        
   
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
 

    r_WE <= '1';
    r_DATA <= X"12345678";    
    wait until r_CLOCK = '1';
    r_WE <= '0'; 
    
    wait until r_CLOCK = '1';    
    
    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';        
    report "Received 0x" & to_hstring(unsigned(w_Q)); 
    
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';

    r_DATA <= X"A1A1A1A1";    
    r_WE <= '1';
    wait until r_CLOCK = '1';
    r_WE <= '0';

    r_DATA <= X"A2A2A2A2";    
    r_WE <= '1';
    wait until r_CLOCK = '1';
    r_WE <= '0';

    r_DATA <= X"A3A3A3A3";    
    r_WE <= '1';
    wait until r_CLOCK = '1';
    r_WE <= '0';

    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';        
    wait until r_CLOCK = '1';
    report "Received 0x" & to_hstring(unsigned(w_Q)); 
    
    
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';

    r_DATA <= X"B4B4B4B4";    
    r_WE <= '1';
    wait until r_CLOCK = '1';
    r_WE <= '0';

    r_DATA <= X"A7A7A7A7";    
    r_WE <= '1';
    wait until r_CLOCK = '1';
    r_WE <= '0';

    
    wait until r_CLOCK = '1';    
    
    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';        
    wait until r_CLOCK = '1';
    report "Received 0x" & to_hstring(unsigned(w_Q)); 
    
    wait until r_CLOCK = '1';    
    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';        
    wait until r_CLOCK = '1';
    report "Received 0x" & to_hstring(unsigned(w_Q)); 
    
    wait until r_CLOCK = '1';    
    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';        
    wait until r_CLOCK = '1';
    report "Received 0x" & to_hstring(unsigned(w_Q)); 
    
    wait until r_CLOCK = '1';    
    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0'; 
    wait until r_CLOCK = '1';       
    report "Received 0x" & to_hstring(unsigned(w_Q)); 
    


    assert false report "Test Complete" severity failure;  
  end process;
end behave;
