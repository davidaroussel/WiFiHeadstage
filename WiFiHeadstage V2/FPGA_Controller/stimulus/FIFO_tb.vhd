library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all; -- Include textio package for string handling



entity FIFO_tb is
end FIFO_tb;

architecture behave of FIFO_tb is
  signal r_DATA      : std_logic_vector(31 downto 0);
  signal w_Q         : std_logic_vector(31 downto 0);
  signal r_WE        : std_logic := '0';
  signal r_RE        : std_logic := '0';
  signal r_CLOCK     : std_logic := '0';  
  signal r_WCLOCK    : std_logic;
  signal r_RCLOCK    : std_logic;
  signal w_FULL      : std_logic;
  signal w_EMPTY     : std_logic;
  signal r_RESET     : std_logic := '1';
  signal w_AEMPTY    : std_logic;
  signal w_AFULL     : std_logic;

  component FIFO_MEM is
    port(
      clk_i         : in std_logic;
      rst_i         : in std_logic;
      wr_en_i       : in std_logic;
      rd_en_i       : in std_logic;
      wr_data_i     : in std_logic_vector(31 downto 0);
      full_o        : out std_logic;
      empty_o       : out std_logic;
      almost_full_o : out std_logic;
      almost_empty_o: out std_logic;
      rd_data_o     : out std_logic_vector(31 downto 0)
    );
  end component;


begin
  UUT : FIFO_MEM
    port map (
      clk_i         => r_CLOCK,
      rst_i         => r_RESET,
      wr_en_i       => r_WE,
      rd_en_i       => r_RE,
      wr_data_i     => r_DATA,
      full_o        => w_FULL,
      empty_o       => w_EMPTY,
      almost_full_o => w_AFULL,
      almost_empty_o=> w_AEMPTY,
      rd_data_o     => w_Q
    );
   
  -- Clock Generators:
  r_CLOCK <= not r_CLOCK after 20.83 ns;
  r_WCLOCK <= r_CLOCK;
  r_RCLOCK <= r_CLOCK;

  p_TEST : process is
  begin
    r_RESET <= '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    r_RESET <= '0';    
    wait until r_CLOCK = '1';
    
    r_WE <= '1';
    r_DATA <= X"12345678";    
    wait until r_CLOCK = '1';
    r_WE <= '0'; 
    
    wait until r_CLOCK = '1';    
    wait until r_CLOCK = '1';   
    
    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';       
    wait until r_CLOCK = '1'; 

    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';

    r_WE <= '1';
    r_DATA <= X"A1A1A1A1";    
    wait until r_CLOCK = '1';
    r_WE <= '0';

    wait until r_CLOCK = '1';
    r_DATA <= X"A2A2A2A2";    
    r_WE <= '1';
    wait until r_CLOCK = '1';
    r_WE <= '0';

    wait until r_CLOCK = '1';

    r_DATA <= X"A3A3A3A3";    
    r_WE <= '1';
    wait until r_CLOCK = '1';
    r_WE <= '0';

    wait until r_CLOCK = '1';
	
	r_DATA <= X"A4A4A4A4";    
    wait until r_CLOCK = '1';   
	r_WE <= '1';
    wait until r_CLOCK = '1';
	r_WE <= '0';
	
	
    wait until r_CLOCK = '1';
	r_WE <= '1';
	 wait until r_CLOCK = '1';
	r_DATA <= X"A4A4A4A4";    
    wait until r_CLOCK = '1';   
	
    r_WE <= '0';

    wait until r_CLOCK = '1';	

    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';        
    wait until r_CLOCK = '1';
    
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';
    wait until r_CLOCK = '1';

    r_DATA <= X"B4B4B4B4";    
    r_WE <= '1';
    wait until r_CLOCK = '1';


    r_DATA <= X"A7A7A7A7";    
    wait until r_CLOCK = '1';
	r_DATA <= X"A8A8A8A8";    
    wait until r_CLOCK = '1';
    r_DATA <= X"A9A9A9A9";    
    wait until r_CLOCK = '1';
	r_DATA <= X"AAAAAAAA";    
    wait until r_CLOCK = '1';
	r_WE <= '0';

    wait until r_CLOCK = '1';    
    
    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';        
    wait until r_CLOCK = '1';
    
	r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';        
    wait until r_CLOCK = '1';
    
	r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0';        
    wait until r_CLOCK = '1';
	
    r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0'; 
    wait until r_CLOCK = '1';       

	r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0'; 
    wait until r_CLOCK = '1';       

	r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0'; 
    wait until r_CLOCK = '1';       

	r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0'; 
    wait until r_CLOCK = '1';       

	r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0'; 
    wait until r_CLOCK = '1';       


	r_RE <= '1';
    wait until r_CLOCK = '1';
    
    wait until r_CLOCK = '1';       

	wait until r_CLOCK = '1';
    
	wait until r_CLOCK = '1';       

	
	wait until r_CLOCK = '1';
    r_RE <= '0'; 
    wait until r_CLOCK = '1';       


	r_RE <= '1';
    wait until r_CLOCK = '1';
    r_RE <= '0'; 
    wait until r_CLOCK = '1';   

    assert false report "Test Complete" severity failure;  
  end process;
end behave;
