-- Version: v11.9 11.9.0.4

library ieee;
use ieee.std_logic_1164.all;
library igloo;
use igloo.all;

entity clock is

    port( GL  : out   std_logic;
          CLK : in    std_logic
        );

end clock;

architecture DEF_ARCH of clock is 

  component CLKDLY
    port( CLK    : in    std_logic := 'U';
          GL     : out   std_logic;
          DLYGL0 : in    std_logic := 'U';
          DLYGL1 : in    std_logic := 'U';
          DLYGL2 : in    std_logic := 'U';
          DLYGL3 : in    std_logic := 'U';
          DLYGL4 : in    std_logic := 'U'
        );
  end component;

  component GND
    port(Y : out std_logic); 
  end component;

    signal \GND\ : std_logic;
    signal GND_power_net1 : std_logic;

begin 

    \GND\ <= GND_power_net1;

    Inst1 : CLKDLY
      port map(CLK => CLK, GL => GL, DLYGL0 => \GND\, DLYGL1 => 
        \GND\, DLYGL2 => \GND\, DLYGL3 => \GND\, DLYGL4 => \GND\);
    
    GND_power_inst1 : GND
      port map( Y => GND_power_net1);


end DEF_ARCH; 

-- _Disclaimer: Please leave the following comments in the file, they are for internal purposes only._


-- _GEN_File_Contents_

-- Version:11.9.0.4
-- ACTGENU_CALL:1
-- BATCH:T
-- FAM:PA3LCLP
-- OUTFORMAT:VHDL
-- LPMTYPE:LPM_PLL_CLKDLY
-- LPM_HINT:NONE
-- INSERT_PAD:NO
-- INSERT_IOREG:NO
-- GEN_BHV_VHDL_VAL:F
-- GEN_BHV_VERILOG_VAL:F
-- MGNTIMER:F
-- MGNCMPL:T
-- DESDIR:C:/Users/David/Desktop/WiFi Headstage GIT/WiFiHeadstage/WiFiHeadstage Roussel/FPGA_Controller/smartgen\clock
-- GEN_BEHV_MODULE:F
-- SMARTGEN_DIE:UM4X4M1NLPLV
-- SMARTGEN_PACKAGE:vq100
-- AGENIII_IS_SUBPROJECT_LIBERO:T
-- DLYGL:1
-- CLKASRC:0

-- _End_Comments_

