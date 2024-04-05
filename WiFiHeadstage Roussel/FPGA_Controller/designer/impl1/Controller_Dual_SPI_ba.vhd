-- Version: v11.9 11.9.0.4
-- File used only for Simulation

library ieee;
use ieee.std_logic_1164.all;
library igloo;
use igloo.all;

entity Controller_Dual_SPI is

    port( i_Rst_L          : in    std_logic;
          i_Clk            : in    std_logic;
          o_STM32_SPI_Clk  : out   std_logic;
          i_STM32_SPI_MISO : in    std_logic;
          o_STM32_SPI_MOSI : out   std_logic;
          o_STM32_SPI_CS_n : out   std_logic;
          o_RHD64_SPI_Clk  : out   std_logic;
          i_RHD64_SPI_MISO : in    std_logic;
          o_RHD64_SPI_MOSI : out   std_logic;
          o_RHD64_SPI_CS_n : out   std_logic
        );

end Controller_Dual_SPI;

architecture DEF_ARCH of Controller_Dual_SPI is 

  component DFN1E0P1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          PRE : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component DFN1E1C1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          CLR : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component OR3A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR3
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component MX2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          S : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component IOTRI_OB_EB
    port( D    : in    std_logic := 'U';
          E    : in    std_logic := 'U';
          DOUT : out   std_logic;
          EOUT : out   std_logic
        );
  end component;

  component OR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR3C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component XA1A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component XO1A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR2A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component OR2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OR3
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1E0
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component AX1A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AND3C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AO1A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR3B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1E1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component MX2C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          S : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AX1B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OAI1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AX1C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1E0C1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          CLR : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component OA1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR3A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component XAI1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component XOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1C1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          CLR : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component OR3B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OR2A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component CLKIO
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component IOPAD_TRI
    port( D   : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          PAD : out   std_logic
        );
  end component;

  component AO1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component XA1C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1E1P1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          PRE : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component XNOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AO1D
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component INV
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OA1C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OA1B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AOI1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component XOR3
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AX1D
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AX1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component ULSICC_INT
    port( USTDBY : in    std_logic := 'U';
          LPENA  : in    std_logic := 'U'
        );
  end component;

  component OR3C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OA1A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AND3B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component FIFO4K18
    port( AEVAL11 : in    std_logic := 'U';
          AEVAL10 : in    std_logic := 'U';
          AEVAL9  : in    std_logic := 'U';
          AEVAL8  : in    std_logic := 'U';
          AEVAL7  : in    std_logic := 'U';
          AEVAL6  : in    std_logic := 'U';
          AEVAL5  : in    std_logic := 'U';
          AEVAL4  : in    std_logic := 'U';
          AEVAL3  : in    std_logic := 'U';
          AEVAL2  : in    std_logic := 'U';
          AEVAL1  : in    std_logic := 'U';
          AEVAL0  : in    std_logic := 'U';
          AFVAL11 : in    std_logic := 'U';
          AFVAL10 : in    std_logic := 'U';
          AFVAL9  : in    std_logic := 'U';
          AFVAL8  : in    std_logic := 'U';
          AFVAL7  : in    std_logic := 'U';
          AFVAL6  : in    std_logic := 'U';
          AFVAL5  : in    std_logic := 'U';
          AFVAL4  : in    std_logic := 'U';
          AFVAL3  : in    std_logic := 'U';
          AFVAL2  : in    std_logic := 'U';
          AFVAL1  : in    std_logic := 'U';
          AFVAL0  : in    std_logic := 'U';
          WD17    : in    std_logic := 'U';
          WD16    : in    std_logic := 'U';
          WD15    : in    std_logic := 'U';
          WD14    : in    std_logic := 'U';
          WD13    : in    std_logic := 'U';
          WD12    : in    std_logic := 'U';
          WD11    : in    std_logic := 'U';
          WD10    : in    std_logic := 'U';
          WD9     : in    std_logic := 'U';
          WD8     : in    std_logic := 'U';
          WD7     : in    std_logic := 'U';
          WD6     : in    std_logic := 'U';
          WD5     : in    std_logic := 'U';
          WD4     : in    std_logic := 'U';
          WD3     : in    std_logic := 'U';
          WD2     : in    std_logic := 'U';
          WD1     : in    std_logic := 'U';
          WD0     : in    std_logic := 'U';
          WW0     : in    std_logic := 'U';
          WW1     : in    std_logic := 'U';
          WW2     : in    std_logic := 'U';
          RW0     : in    std_logic := 'U';
          RW1     : in    std_logic := 'U';
          RW2     : in    std_logic := 'U';
          RPIPE   : in    std_logic := 'U';
          WEN     : in    std_logic := 'U';
          REN     : in    std_logic := 'U';
          WBLK    : in    std_logic := 'U';
          RBLK    : in    std_logic := 'U';
          WCLK    : in    std_logic := 'U';
          RCLK    : in    std_logic := 'U';
          RESET   : in    std_logic := 'U';
          ESTOP   : in    std_logic := 'U';
          FSTOP   : in    std_logic := 'U';
          RD17    : out   std_logic;
          RD16    : out   std_logic;
          RD15    : out   std_logic;
          RD14    : out   std_logic;
          RD13    : out   std_logic;
          RD12    : out   std_logic;
          RD11    : out   std_logic;
          RD10    : out   std_logic;
          RD9     : out   std_logic;
          RD8     : out   std_logic;
          RD7     : out   std_logic;
          RD6     : out   std_logic;
          RD5     : out   std_logic;
          RD4     : out   std_logic;
          RD3     : out   std_logic;
          RD2     : out   std_logic;
          RD1     : out   std_logic;
          RD0     : out   std_logic;
          FULL    : out   std_logic;
          AFULL   : out   std_logic;
          EMPTY   : out   std_logic;
          AEMPTY  : out   std_logic
        );
  end component;

  component DFN1P1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          PRE : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component IOIN_IB
    port( YIN : in    std_logic := 'U';
          Y   : out   std_logic
        );
  end component;

  component AND2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component MX2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          S : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component IOPAD_IN
    port( PAD : in    std_logic := 'U';
          Y   : out   std_logic
        );
  end component;

  component MX2A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          S : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component BUFF
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFI1C1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          CLR : in    std_logic := 'U';
          QN  : out   std_logic
        );
  end component;

  component GND
    port(Y : out std_logic); 
  end component;

  component VCC
    port(Y : out std_logic); 
  end component;

    signal i_Rst_L_c, i_Clk_c, o_STM32_SPI_Clk_c, 
        o_STM32_SPI_MOSI_c, o_STM32_SPI_CS_n_c, o_RHD64_SPI_Clk_c, 
        i_RHD64_SPI_MISO_c, o_RHD64_SPI_MOSI_c, 
        o_RHD64_SPI_CS_n_c, i_RHD64_SPI_MISO_c_0, 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, 
        \Controller_Headstage_1/int_STM32_TX_DV_RNIG8OO2_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, 
        \Controller_Headstage_1/N_10\, 
        \Controller_Headstage_1/int_N_5_0\, 
        \Controller_Headstage_1/G_0_i_a2_0\, 
        \Controller_Headstage_1/N_6_0\, 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, 
        \Controller_Headstage_1/G_3_0_0\, 
        \Controller_Headstage_1/r_SM_CS_RNIVMVV1[1]\, 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        \Controller_Headstage_1/state[1]_net_1\, 
        \Controller_Headstage_1/state[0]_net_1\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_26[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_17[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_16[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_22[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_25[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_11[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_10[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_21[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_24[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_7[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_6[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_19[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_1[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_0[0]\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_14[0]\, 
        \Controller_Headstage_1/state[20]_net_1\, 
        \Controller_Headstage_1/state[17]_net_1\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_13[0]\, 
        \Controller_Headstage_1/state[12]_net_1\, 
        \Controller_Headstage_1/state[9]_net_1\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_9[0]\, 
        \Controller_Headstage_1/state[4]_net_1\, 
        \Controller_Headstage_1/state[2]_net_1\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_5[0]\, 
        \Controller_Headstage_1/state[22]_net_1\, 
        \Controller_Headstage_1/state[19]_net_1\, 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_3[0]\, 
        \Controller_Headstage_1/state[13]_net_1\, 
        \Controller_Headstage_1/state[16]_net_1\, 
        \Controller_Headstage_1/state[11]_net_1\, 
        \Controller_Headstage_1/state[14]_net_1\, 
        \Controller_Headstage_1/state[15]_net_1\, 
        \Controller_Headstage_1/state[18]_net_1\, 
        \Controller_Headstage_1/state[5]_net_1\, 
        \Controller_Headstage_1/state[8]_net_1\, 
        \Controller_Headstage_1/state[3]_net_1\, 
        \Controller_Headstage_1/state[6]_net_1\, 
        \Controller_Headstage_1/state[7]_net_1\, 
        \Controller_Headstage_1/state[10]_net_1\, 
        \Controller_Headstage_1/state[29]_net_1\, 
        \Controller_Headstage_1/state[31]_net_1\, 
        \Controller_Headstage_1/state[27]_net_1\, 
        \Controller_Headstage_1/state[30]_net_1\, 
        \Controller_Headstage_1/state[21]_net_1\, 
        \Controller_Headstage_1/state[24]_net_1\, 
        \Controller_Headstage_1/state[25]_net_1\, 
        \Controller_Headstage_1/state[28]_net_1\, 
        \Controller_Headstage_1/state[23]_net_1\, 
        \Controller_Headstage_1/state[26]_net_1\, 
        \Controller_Headstage_1/N_40\, 
        \Controller_Headstage_1/N_48\, 
        \Controller_Headstage_1/o_RHD64_TX_Ready_i_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, 
        \Controller_Headstage_1/N_41\, 
        \Controller_Headstage_1/N_8\, 
        \Controller_Headstage_1/counter_e0\, 
        \Controller_Headstage_1/counter[0]_net_1\, 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, 
        \Controller_Headstage_1/N_49\, 
        \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, 
        \Controller_Headstage_1/N_50\, 
        \Controller_Headstage_1/state_RNO[1]_net_1\, 
        \Controller_Headstage_1/counter_m2_0_a2_2\, 
        \Controller_Headstage_1/counter[12]_net_1\, 
        \Controller_Headstage_1/counter[13]_net_1\, 
        \Controller_Headstage_1/counter_m2_0_a2_1\, 
        \Controller_Headstage_1/counter[11]_net_1\, 
        \Controller_Headstage_1/counter[10]_net_1\, 
        \Controller_Headstage_1/counter_m5_0_a2_6_1\, 
        \Controller_Headstage_1/counter[4]_net_1\, 
        \Controller_Headstage_1/counter[5]_net_1\, 
        \Controller_Headstage_1/counter_m5_0_a2_6_0\, 
        \Controller_Headstage_1/counter[9]_net_1\, 
        \Controller_Headstage_1/counter[3]_net_1\, 
        \Controller_Headstage_1/counter_m4_0_a2_5\, 
        \Controller_Headstage_1/counter_m4_0_a2_2\, 
        \Controller_Headstage_1/counter_m4_0_a2_1\, 
        \Controller_Headstage_1/counter_m4_0_a2_3\, 
        \Controller_Headstage_1/counter[8]_net_1\, 
        \Controller_Headstage_1/counter[7]_net_1\, 
        \Controller_Headstage_1/counter[2]_net_1\, 
        \Controller_Headstage_1/counter[6]_net_1\, 
        \Controller_Headstage_1/counter_m5_0_a2_5_0\, 
        \Controller_Headstage_1/counter_m5_0_a2_5\, 
        \Controller_Headstage_1/counter_m5_0_a2_6\, 
        \Controller_Headstage_1/counter_c1\, 
        \Controller_Headstage_1/counter_c13\, 
        \Controller_Headstage_1/counter_n9\, 
        \Controller_Headstage_1/counter_n14\, 
        \Controller_Headstage_1/counter[14]_net_1\, 
        \Controller_Headstage_1/counter_n13\, 
        \Controller_Headstage_1/counter_c11\, 
        \Controller_Headstage_1/counter_n12\, 
        \Controller_Headstage_1/counter_n11\, 
        \Controller_Headstage_1/counter_c10\, 
        \Controller_Headstage_1/counter_n10\, 
        \Controller_Headstage_1/counter_n8\, 
        \Controller_Headstage_1/counter_c6\, 
        \Controller_Headstage_1/counter_n7\, 
        \Controller_Headstage_1/counter_n6\, 
        \Controller_Headstage_1/counter_c4\, 
        \Controller_Headstage_1/counter_n5\, 
        \Controller_Headstage_1/counter_n4\, 
        \Controller_Headstage_1/counter_c2\, 
        \Controller_Headstage_1/counter_n3\, 
        \Controller_Headstage_1/counter_n2\, 
        \Controller_Headstage_1/counter_n1\, 
        \Controller_Headstage_1/counter[1]_net_1\, 
        \Controller_Headstage_1/counter_n15\, 
        \Controller_Headstage_1/counter[15]_net_1\, 
        \Controller_Headstage_1/int_FIFO_RE_net_1\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[0]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[0]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[1]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[1]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[2]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[2]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[3]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[3]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[4]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[4]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[5]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[5]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[6]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[6]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[7]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[7]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[8]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[8]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[9]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[9]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[10]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[10]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[11]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[11]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[12]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[12]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[13]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[13]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[14]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[14]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[15]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[15]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[16]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[16]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[17]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[17]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[18]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[18]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[19]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[19]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[20]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[20]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[21]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[21]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[22]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[22]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[23]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[23]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[24]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[24]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[25]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[25]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[26]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[26]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[27]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[27]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[28]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[28]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[29]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[29]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[30]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[30]\, 
        \Controller_Headstage_1/int_STM32_TX_Byte[31]_net_1\, 
        \Controller_Headstage_1/o_FIFO_Q[31]\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[0]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[1]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[2]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[3]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[4]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[5]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[6]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[7]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[8]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[9]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[10]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[11]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[12]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[13]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[14]_net_1\, 
        \Controller_Headstage_1/int_RHD64_TX_Byte[15]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[1]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/int_N_6\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_0_sqmuxa\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[0]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[1]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/w_Master_Ready\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_n_0_sqmuxa\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_30\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_11_i_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_25\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_14_0_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[1]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[0]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[2]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_5_0_a2_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_0_0_a3_0_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_16_0_a3_0_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_33\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_20\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_38\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_27\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_22\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_24_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_117\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/DWACT_ADD_CI_0_partial_sum[0]\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_36\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_8[1]\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_35\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO_0[1]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_118\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO_0[0]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/un1_r_CS_n_0_sqmuxa\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Counte\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_44\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_116\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_0_3\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_0_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_0_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_4\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a0_3\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a0_2\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_3\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a1_2\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a1_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_6\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a4_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a2_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a2_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[15]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[31]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_136\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_133\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_178\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_124\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_58_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_103\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_177\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i43_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i35_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i34_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_79\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_76\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_100\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_112\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_106\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_109\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_121\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_115\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_118\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_127\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[3]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[19]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_130\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[11]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[27]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[7]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[23]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[0]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[16]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[8]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[24]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i28_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[14]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[30]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i29_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[6]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[22]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i30_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[10]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[26]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i31_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[2]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[18]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i32_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[12]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[28]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i33_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[4]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[20]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[13]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[29]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[5]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[21]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[9]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[25]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[1]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[17]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_88\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_97\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_n6_i_o2_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_2_2\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[6]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_0_a2_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_0_2\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_0_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_0_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_5_mux_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_411\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_7_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_8_mux\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_i3_mux\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_429\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_7\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_TX_Ready_RNO_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count_RNO[0]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_407\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_416\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_398\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_45_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_396\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_395\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_394\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edgese\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_418\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[3]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_Trailing_Edge_RNO_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_412\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[1]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[2]_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_41_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m5_0_a2_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m3_e_4\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m3_e_3\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m3_e_2\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_144\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_141\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_257_i_i_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_RNO_0_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_net_1\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_37_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_39_i\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_432\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_15_0\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_389\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_390\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_139_mux\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_391\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_142_mux\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_392\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_144_mux\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_137_mux\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_142\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_15_0_mux\, 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_436_mux\, 
        \Controller_Headstage_1/Controller_RHD64_1/WEBP\, 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[0]\, 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[1]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[2]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[2]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[3]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[3]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[4]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[4]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[5]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[5]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[6]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[6]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[7]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[7]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[8]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[8]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[9]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[9]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[10]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[10]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[11]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[11]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[12]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[12]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[13]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[13]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[14]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[14]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[15]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[15]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[16]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[0]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[17]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[1]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[18]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[2]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[19]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[3]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[20]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[4]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[21]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[5]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[22]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[6]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[23]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[7]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[24]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[8]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[25]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[9]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[26]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[10]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[27]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[11]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[28]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[12]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[29]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[13]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[30]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[14]\, 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[31]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[15]\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNO[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNIJM951[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_30\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_37\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_29\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_34_i\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[2]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_32\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_27\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[3]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_23\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNO[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[2]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[3]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_4\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[4]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_44\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_39\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_24\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_58\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/un1_r_TX_Count_0_sqmuxa_i_0[3]\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_22\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_47\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_18\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNI4VRS1[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_66\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_28\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNI3URS1[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/DWACT_ADD_CI_0_partial_sum[0]\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_8[1]\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/DWACT_ADD_CI_0_TMP[0]\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_95\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_TX_Ready_RNILGCU2_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_8\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_7\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[15]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_DV_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_143\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[8]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_144\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[4]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[12]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_145\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_146\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[2]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[10]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_147\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[6]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[14]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_148\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_149\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_150\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[9]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_151\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[5]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[13]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_152\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_153\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[3]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[11]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_154\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[7]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_155\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_156\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_n4_i_0\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_89\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_348\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_117\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_368\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_10\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_94\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_118\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[4]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_87\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_8\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[3]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_29\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_110\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_49\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_108\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_61\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_81\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_96\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_107\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_111\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_109\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_106\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_105\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_85\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_83\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_79\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_59\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_57\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_55\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_53\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_51\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_47\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_27\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_25\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[15]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_121\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_0_sqmuxa_0_a2_0\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_14\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/un2lt5_i_o2_0_0\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_23\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_22\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_n3_0_o2_out\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/un1_i_tx_dv\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_e0\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_1_sqmuxa\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[4]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_0_sqmuxa\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edgese\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_13\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[1]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[2]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[3]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_20_i\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_16\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_6\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_333\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_347\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_332\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_341\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_331\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_340\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_330\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_RNO_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_net_1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_326\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_367\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_327\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_c1\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_328\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_15_0\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_17_i\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_18_i\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_19_i\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/un16_r_leading_edge\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_120\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_325\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_335\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_349\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_33\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_102\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_35\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_103\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_65\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_67\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_92\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_93\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_98\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_100\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_104\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_101\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_99\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_97\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_77\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_75\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_73\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_71\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_69\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_63\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_45\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_43\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_41\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_39\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_37\, 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_31\, 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\EMPTYX_I[0]\\\\\, 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\EMPTYX_I[1]\\\\\, 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\FULLX_I[1]\\\\\, 
        \GND\, \VCC\, 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/READ_ENABLE_I\, 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/WRITE_ENABLE_I\, 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\FULLX_I[0]\\\\\, 
        \i_RHD64_SPI_MISO_pad/U0/NET1\, 
        \o_STM32_SPI_CS_n_pad/U0/NET1\, 
        \o_STM32_SPI_CS_n_pad/U0/NET2\, \i_Rst_L_pad/U0/NET1\, 
        \o_RHD64_SPI_CS_n_pad/U0/NET1\, 
        \o_RHD64_SPI_CS_n_pad/U0/NET2\, 
        \o_STM32_SPI_MOSI_pad/U0/NET1\, 
        \o_STM32_SPI_MOSI_pad/U0/NET2\, 
        \o_RHD64_SPI_Clk_pad/U0/NET1\, 
        \o_RHD64_SPI_Clk_pad/U0/NET2\, 
        \o_RHD64_SPI_MOSI_pad/U0/NET1\, 
        \o_RHD64_SPI_MOSI_pad/U0/NET2\, 
        \o_STM32_SPI_Clk_pad/U0/NET1\, 
        \o_STM32_SPI_Clk_pad/U0/NET2\, \i_Clk_pad/U0/NET1\, 
        AFLSDF_VCC, AFLSDF_GND, \AFLSDF_INV_0\, \AFLSDF_INV_1\
         : std_logic;
    signal GND_power_net1 : std_logic;
    signal VCC_power_net1 : std_logic;

begin 

    AFLSDF_GND <= GND_power_net1;
    \GND\ <= GND_power_net1;
    \VCC\ <= VCC_power_net1;
    AFLSDF_VCC <= VCC_power_net1;

    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[1]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_326\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_120\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[1]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[13]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[13]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[13]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_Trailing_Edge_RNO\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[3]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_418\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_Trailing_Edge_RNO_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO_0[4]\ : 
        NOR3
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[6]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_7_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[2]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[2]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_108\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_81\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[6]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[6]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_98\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_73\);
    
    \o_STM32_SPI_MOSI_pad/U0/U1\ : IOTRI_OB_EB
      port map(D => o_STM32_SPI_MOSI_c, E => \VCC\, DOUT => 
        \o_STM32_SPI_MOSI_pad/U0/NET1\, EOUT => 
        \o_STM32_SPI_MOSI_pad/U0/NET2\);
    
    \Controller_Headstage_1/state_RNI9Q7N[3]\ : OR2
      port map(A => \Controller_Headstage_1/state[3]_net_1\, B
         => \Controller_Headstage_1/state[6]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_9[0]\);
    
    \Controller_Headstage_1/counter_RNO_0[9]\ : NOR3C
      port map(A => \Controller_Headstage_1/counter_m4_0_a2_2\, B
         => \Controller_Headstage_1/counter_m4_0_a2_1\, C => 
        \Controller_Headstage_1/counter_m4_0_a2_3\, Y => 
        \Controller_Headstage_1/counter_m4_0_a2_5\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[15]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[15]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[15]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNO[1]\ : 
        XA1A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_330\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNO[1]\ : 
        XO1A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_349\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[12]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[12]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_110\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_29\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_RNIUNKG\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a2_0\);
    
    \Controller_Headstage_1/state[27]\ : DFN1
      port map(D => \Controller_Headstage_1/state[27]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[27]_net_1\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO_1[0]\ : 
        OR2B
      port map(A => o_STM32_SPI_CS_n_c, B => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_25\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_TX_Ready_RNO\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_22\, 
        B => \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, Y
         => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/un1_i_tx_dv\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO[4]\ : 
        OR2B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_144_mux\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_432\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_392\);
    
    \Controller_Headstage_1/state_RNINIJT1[19]\ : OR3
      port map(A => \Controller_Headstage_1/state[22]_net_1\, B
         => \Controller_Headstage_1/state[19]_net_1\, C => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_3[0]\, 
        Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_16[0]\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[8]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[8]\, CLK => 
        i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[8]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[6]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[6]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[6]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO_0[4]\ : 
        AX1A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_144\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_144_mux\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_26\ : 
        NOR2B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a1_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[1]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[1]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[1]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNO[0]\ : 
        AND3C
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        B => \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, C
         => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_22\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_23\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO[1]\ : 
        AO1A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_16_0_a3_0_1\, 
        C => \Controller_Headstage_1/SPI_Master_CS_STM32/N_33\, Y
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO_0[1]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_8_G_0_0_a3_0_1\ : 
        NOR3B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[1]_net_1\, 
        B => \Controller_Headstage_1/int_STM32_TX_DV_net_1\, C
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_0_0_a3_0_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[13]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[13]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[13]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[24]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[24]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[24]_net_1\);
    
    \Controller_Headstage_1/state[22]\ : DFN1
      port map(D => \Controller_Headstage_1/state[22]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[22]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[5]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[5]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[5]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO_2[4]\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_141\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_29\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[0]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[16]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i35_i\);
    
    \Controller_Headstage_1/state[11]\ : DFN1
      port map(D => \Controller_Headstage_1/state[11]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[11]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count_RNO[0]\ : 
        AX1B
      port map(A => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_5_mux_0\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count_RNO[0]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[12]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[12]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[12]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[0]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_116\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Counte\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[0]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNIEA0D2[4]\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_n3_0_o2_out\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/un2lt5_i_o2_0_0\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_16\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_n_RNIJM951\ : 
        OAI1
      port map(A => o_RHD64_SPI_CS_n_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]_net_1\, 
        C => \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, Y
         => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/un1_r_TX_Count_0_sqmuxa_i_0[3]\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[9]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[9]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[9]_net_1\);
    
    \Controller_Headstage_1/counter_RNO[15]\ : AX1C
      port map(A => \Controller_Headstage_1/counter[14]_net_1\, B
         => \Controller_Headstage_1/counter_c13\, C => 
        \Controller_Headstage_1/counter[15]_net_1\, Y => 
        \Controller_Headstage_1/counter_n15\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[3]\ : 
        DFN1E0C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_41_i\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[3]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[8]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_69\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[8]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_RNI97MN[1]\ : 
        OA1
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/w_Master_Ready\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/int_N_6\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_RNO_1\ : 
        NOR3A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m3_e_2\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[6]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m3_e_4\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_RNO[1]\ : 
        XAI1
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_367\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_326\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[3]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_47\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[3]\);
    
    \Controller_Headstage_1/counter_RNO[3]\ : XOR2
      port map(A => \Controller_Headstage_1/counter_c2\, B => 
        \Controller_Headstage_1/counter[3]_net_1\, Y => 
        \Controller_Headstage_1/counter_n3\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[7]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[7]\, CLK => 
        i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[7]_net_1\);
    
    \Controller_Headstage_1/counter[7]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n7\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[7]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_Clk\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => o_RHD64_SPI_Clk_c);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[17]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[17]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[17]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[4]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[4]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_100\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_77\);
    
    \Controller_Headstage_1/counter_RNO[11]\ : XOR2
      port map(A => \Controller_Headstage_1/counter_c10\, B => 
        \Controller_Headstage_1/counter[11]_net_1\, Y => 
        \Controller_Headstage_1/counter_n11\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_RNO[2]\ : 
        AX1C
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_18_i\);
    
    \Controller_Headstage_1/counter_RNO[5]\ : XOR2
      port map(A => \Controller_Headstage_1/counter_c4\, B => 
        \Controller_Headstage_1/counter[5]_net_1\, Y => 
        \Controller_Headstage_1/counter_n5\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_Clk\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => o_STM32_SPI_Clk_c);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_TX_Ready\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/un1_i_tx_dv\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_6\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_150\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_151\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_152\);
    
    \o_RHD64_SPI_MOSI_pad/U0/U1\ : IOTRI_OB_EB
      port map(D => o_RHD64_SPI_MOSI_c, E => \VCC\, DOUT => 
        \o_RHD64_SPI_MOSI_pad/U0/NET1\, EOUT => 
        \o_RHD64_SPI_MOSI_pad/U0/NET2\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_23\ : 
        NOR3A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[15]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a0_2\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNIHIOA1[1]\ : 
        NOR2B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_20\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[1]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_44\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[10]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_33\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[10]\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[2]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[2]\, CLK => 
        i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[2]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[4]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_348\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_121\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[4]_net_1\);
    
    \Controller_Headstage_1/counter_RNO_3[9]\ : NOR3C
      port map(A => \Controller_Headstage_1/counter[5]_net_1\, B
         => \Controller_Headstage_1/counter[8]_net_1\, C => 
        \Controller_Headstage_1/counter[7]_net_1\, Y => 
        \Controller_Headstage_1/counter_m4_0_a2_3\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[15]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[15]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_109\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[15]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_1[2]\ : 
        OR3B
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_93\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_97\);
    
    \Controller_Headstage_1/state_RNIB7OU[13]\ : OR2
      port map(A => \Controller_Headstage_1/state[13]_net_1\, B
         => \Controller_Headstage_1/state[16]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_14[0]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNINE8V_0[3]\ : 
        OR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[4]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_92\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_24\ : 
        NOR3C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a2_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a2_0\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_136\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_3\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[6]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[6]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[6]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_TX_Ready_RNO\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_5_mux_0\, 
        B => \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Y
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_TX_Ready_RNO_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO[1]\ : 
        XAI1
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_432\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_389\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[2]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_331\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNO[4]\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_117\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_n4_i_0\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_368\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_348\);
    
    \i_Rst_L_pad/U0/U1\ : CLKIO
      port map(A => \i_Rst_L_pad/U0/NET1\, Y => i_Rst_L_c);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[11]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_31\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[11]\);
    
    \Controller_Headstage_1/counter_RNO_1[9]\ : NOR2B
      port map(A => \Controller_Headstage_1/counter[2]_net_1\, B
         => \Controller_Headstage_1/counter[6]_net_1\, Y => 
        \Controller_Headstage_1/counter_m4_0_a2_2\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[8]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[8]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_104\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_37\);
    
    \Controller_Headstage_1/state[5]\ : DFN1
      port map(D => \Controller_Headstage_1/state[5]_net_1\, CLK
         => i_Clk_c, Q => \Controller_Headstage_1/state[5]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[0]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[0]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[0]_net_1\);
    
    \Controller_Headstage_1/state[26]\ : DFN1
      port map(D => \Controller_Headstage_1/state[26]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[26]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[4]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_4\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_44\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[4]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[19]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[19]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[19]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Trailing_Edge_RNIG72E\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_367\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_120\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNIKSJC1[0]\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_29\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_30\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_9\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[4]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[12]_net_1\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_144\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_178\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_103\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_177\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_58_0\);
    
    \Controller_Headstage_1/state_RNO_0[0]\ : NOR3B
      port map(A => \Controller_Headstage_1/state[1]_net_1\, B
         => \Controller_Headstage_1/o_RHD64_TX_Ready_i_1\, C => 
        \Controller_Headstage_1/state[0]_net_1\, Y => 
        \Controller_Headstage_1/N_48\);
    
    \Controller_Headstage_1/counter_RNICN3H[8]\ : NOR2B
      port map(A => \Controller_Headstage_1/counter[8]_net_1\, B
         => \Controller_Headstage_1/counter[6]_net_1\, Y => 
        \Controller_Headstage_1/counter_m5_0_a2_5_0\);
    
    \o_RHD64_SPI_Clk_pad/U0/U0\ : IOPAD_TRI
      port map(D => \o_RHD64_SPI_Clk_pad/U0/NET1\, E => 
        \o_RHD64_SPI_Clk_pad/U0/NET2\, PAD => o_RHD64_SPI_Clk);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNISIAK[2]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_411\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_412\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_7\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_153\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_154\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_155\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[12]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[12]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[12]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_17\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i29_i\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i28_i\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_97\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[30]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[30]\, CLK
         => i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[30]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[13]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[13]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[13]_net_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[15]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[15]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[15]_net_1\);
    
    \Controller_Headstage_1/state_RNICHQEE[0]\ : AND3C
      port map(A => \Controller_Headstage_1/state[1]_net_1\, B
         => \Controller_Headstage_1/state[0]_net_1\, C => 
        \Controller_Headstage_1/N_41\, Y => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[12]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[12]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[12]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[15]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[15]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[15]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_n_RNIOSN13\ : 
        NOR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_24\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_58\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/un1_r_TX_Count_0_sqmuxa_i_0[3]\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_18\);
    
    \Controller_Headstage_1/counter_RNIGHAJ1[4]\ : NOR3C
      port map(A => \Controller_Headstage_1/counter_m5_0_a2_6_1\, 
        B => \Controller_Headstage_1/counter_m5_0_a2_6_0\, C => 
        \Controller_Headstage_1/counter_c1\, Y => 
        \Controller_Headstage_1/counter_m5_0_a2_6\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_1\ : 
        AO1
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a4_0\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_124\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_0_3\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_178\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[11]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[11]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[11]_net_1\);
    
    \Controller_Headstage_1/counter_RNO[0]\ : XOR2
      port map(A => \Controller_Headstage_1/counter[0]_net_1\, B
         => \Controller_Headstage_1/int_rhd64_tx_byte8\, Y => 
        \Controller_Headstage_1/counter_e0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[2]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[2]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[2]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[18]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[18]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[18]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[3]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_8\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_121\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[3]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_18\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[17]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_106\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[21]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[5]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[21]_net_1\);
    
    \Controller_Headstage_1/state_RNIOUVQ[7]\ : OR2
      port map(A => \Controller_Headstage_1/state[7]_net_1\, B
         => \Controller_Headstage_1/state[10]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_7[0]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_11\ : 
        AO1
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a0_3\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a0_2\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_3\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_0_1\);
    
    \Controller_Headstage_1/state_RNI5T7I1[9]\ : OR3
      port map(A => \Controller_Headstage_1/state[12]_net_1\, B
         => \Controller_Headstage_1/state[9]_net_1\, C => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_9[0]\, 
        Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_19[0]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO_0[0]\ : 
        NOR3C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_0_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_0_0\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_0_2\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_7\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_8_G_2_0_a3\ : 
        NOR3A
      port map(A => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[0]_net_1\, 
        C => \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\, Y
         => \Controller_Headstage_1/SPI_Master_CS_STM32/N_35\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_RNO_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNO_0[2]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_340\);
    
    \Controller_Headstage_1/counter[12]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n12\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[12]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_RNIN2HG[3]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_14\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_0_sqmuxa_0_a2_0\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO[2]\ : 
        XA1C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_411\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_395\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[2]\ : 
        DFN1E1P1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_118\, CLK
         => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Counte\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[2]_net_1\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[1]\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO_0[1]_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[1]_net_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[11]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[11]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[11]_net_1\);
    
    \Controller_Headstage_1/counter_RNO[8]\ : AX1C
      port map(A => \Controller_Headstage_1/counter[7]_net_1\, B
         => \Controller_Headstage_1/counter_c6\, C => 
        \Controller_Headstage_1/counter[8]_net_1\, Y => 
        \Controller_Headstage_1/counter_n8\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_0[2]\ : 
        OR3B
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_92\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_101\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count_RNO[1]\ : 
        XOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_37_i\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO_0[0]\ : 
        XNOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_257_i_i_0\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_15_0_mux\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[15]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[15]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[15]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_6[2]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_92\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_103\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[3]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[3]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_111\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_47\);
    
    \Controller_Headstage_1/counter_RNIJ9721[2]\ : NOR3C
      port map(A => \Controller_Headstage_1/counter[2]_net_1\, B
         => \Controller_Headstage_1/counter[7]_net_1\, C => 
        \Controller_Headstage_1/counter_m5_0_a2_5_0\, Y => 
        \Controller_Headstage_1/counter_m5_0_a2_5\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[2]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_81\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[2]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count_RNI7KI82[2]\ : 
        AO1D
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_418\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_5_mux_0\, 
        C => \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Y
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edgese\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[0]\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/DWACT_ADD_CI_0_partial_sum[0]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[0]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNI8ROG1[6]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_5_mux_0\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[1]\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_8[1]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[1]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNO[0]_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_RNO_0_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_25\ : 
        NOR3B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[31]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a1_2\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[0]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_23\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[1]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_394\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[27]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[27]\, CLK
         => i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[27]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_3[2]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_89\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_107\);
    
    \Controller_Headstage_1/state_RNIBVIND[2]\ : OR2
      port map(A => \Controller_Headstage_1/N_40\, B => i_Rst_L_c, 
        Y => \Controller_Headstage_1/N_41\);
    
    \Controller_Headstage_1/counter[8]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n8\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[8]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[10]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_65\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[10]\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[0]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[0]\, CLK => 
        i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[0]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[14]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_25\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[14]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[2]\ : 
        DFN1E0C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_39_i\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[2]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNO_1[4]\ : 
        OR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_89\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_n4_i_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[9]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[9]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_103\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_67\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_7[2]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_93\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_98\);
    
    \Controller_Headstage_1/state_RNIFBOU[15]\ : OR2
      port map(A => \Controller_Headstage_1/state[15]_net_1\, B
         => \Controller_Headstage_1/state[18]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_11[0]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[3]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[3]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_111\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_79\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[16]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[16]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[16]_net_1\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_n_RNO\ : INV
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_30\, Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_n_0_sqmuxa\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO[2]\ : 
        OR2B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_139_mux\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_432\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_390\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNIJM951[0]\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_28\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNIJM951[0]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_DV_RNIG8OO2\ : NOR3
      port map(A => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, B => 
        \Controller_Headstage_1/G_3_0_0\, C => 
        \Controller_Headstage_1/r_SM_CS_RNIVMVV1[1]\, Y => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNIG8OO2_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO_1[3]\ : 
        OA1C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_142\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[4]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_20_i\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[4]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNINE8V_1[3]\ : 
        OR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[3]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_93\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[8]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[8]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[8]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_TX_Ready_RNIJJ7G\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_95\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_121\);
    
    \Controller_Headstage_1/counter[13]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n13\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[13]_net_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[14]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[14]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[14]_net_1\);
    
    \Controller_Headstage_1/state[17]\ : DFN1
      port map(D => \Controller_Headstage_1/state[17]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[17]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count_RNO[1]\ : 
        OA1C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_5_0_a2_0\, 
        B => \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\, C
         => \Controller_Headstage_1/SPI_Master_CS_STM32/N_24_i\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_117\);
    
    \Controller_Headstage_1/state_RNIDU7N[5]\ : OR2
      port map(A => \Controller_Headstage_1/state[5]_net_1\, B
         => \Controller_Headstage_1/state[8]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_10[0]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[3]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[3]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[3]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[22]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[22]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[22]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_10[2]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_87\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_106\);
    
    \Controller_Headstage_1/counter_RNI1LBK[10]\ : NOR2B
      port map(A => \Controller_Headstage_1/counter[11]_net_1\, B
         => \Controller_Headstage_1/counter[10]_net_1\, Y => 
        \Controller_Headstage_1/counter_m2_0_a2_1\);
    
    \o_STM32_SPI_CS_n_pad/U0/U1\ : IOTRI_OB_EB
      port map(D => o_STM32_SPI_CS_n_c, E => \VCC\, DOUT => 
        \o_STM32_SPI_CS_n_pad/U0/NET1\, EOUT => 
        \o_STM32_SPI_CS_n_pad/U0/NET2\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_9\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_106\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_109\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_112\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[10]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[10]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_102\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_33\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[25]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[25]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[25]_net_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[1]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[1]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[1]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNIVMVV1[1]\ : 
        OA1B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[1]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_0_sqmuxa\, 
        Y => \Controller_Headstage_1/r_SM_CS_RNIVMVV1[1]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNINE8V[3]\ : 
        OR2B
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[3]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_89\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[21]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[21]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[21]_net_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[8]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[8]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[8]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[30]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[14]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[30]_net_1\);
    
    \o_RHD64_SPI_CS_n_pad/U0/U1\ : IOTRI_OB_EB
      port map(D => o_RHD64_SPI_CS_n_c, E => \VCC\, DOUT => 
        \o_RHD64_SPI_CS_n_pad/U0/NET1\, EOUT => 
        \o_RHD64_SPI_CS_n_pad/U0/NET2\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[2]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[2]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_108\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_49\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[28]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[28]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[28]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNO[4]\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_347\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_333\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO_0[3]\ : 
        AX1A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_142\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_142_mux\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNICP7A1[2]\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[0]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_27\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[29]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[29]\, CLK
         => i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[29]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_RNO_0\ : 
        AOI1
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m3_e_4\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m3_e_3\, 
        C => \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Y
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m5_0_a2_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_RNO_0[3]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_c1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_15_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[4]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_45\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[4]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[0]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_335\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_121\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[0]_net_1\);
    
    \Controller_Headstage_1/state[12]\ : DFN1
      port map(D => \Controller_Headstage_1/state[12]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[12]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[0]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[0]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[0]_net_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[0]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[0]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[0]_net_1\);
    
    \Controller_Headstage_1/counter_RNI4GT93[11]\ : NOR2B
      port map(A => \Controller_Headstage_1/counter_c10\, B => 
        \Controller_Headstage_1/counter[11]_net_1\, Y => 
        \Controller_Headstage_1/counter_c11\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_37\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a2_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[13]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_27\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[13]\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[22]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[22]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[22]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[15]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[15]_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[15]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_2\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_145\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_148\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_149\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO_1[0]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_0_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_8_I_10\ : 
        XOR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNI4VRS1[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_18\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/DWACT_ADD_CI_0_TMP[0]\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_8[1]\);
    
    \Controller_Headstage_1/state_RNII23M1[2]\ : OR3
      port map(A => \Controller_Headstage_1/state[4]_net_1\, B
         => \Controller_Headstage_1/state[2]_net_1\, C => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_5[0]\, 
        Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_17[0]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_3\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_177\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNO[0]\ : 
        NOR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNIJM951[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_30\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNO[0]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNO_0[3]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_n3_0_o2_out\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_341\);
    
    \Controller_Headstage_1/counter_RNO[10]\ : AX1C
      port map(A => \Controller_Headstage_1/counter_m5_0_a2_5\, B
         => \Controller_Headstage_1/counter_m5_0_a2_6\, C => 
        \Controller_Headstage_1/counter[10]_net_1\, Y => 
        \Controller_Headstage_1/counter_n10\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_8[2]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_93\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_99\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_8\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[8]_net_1\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_143\);
    
    \Controller_Headstage_1/state_RNIFERU[29]\ : OR2
      port map(A => \Controller_Headstage_1/state[29]_net_1\, B
         => \Controller_Headstage_1/state[31]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_6[0]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[3]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_19_i\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[3]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[0]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[0]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_96\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_53\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[11]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[11]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[11]_net_1\);
    
    \Controller_Headstage_1/state_RNI56MGS[0]\ : NOR2
      port map(A => \Controller_Headstage_1/N_50\, B => 
        \Controller_Headstage_1/N_49\, Y => 
        \Controller_Headstage_1/N_10\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_10\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_115\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_118\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_121\);
    
    \Controller_Headstage_1/counter[14]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n14\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[14]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_38\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[7]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[23]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_136\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[2]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[2]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[2]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_n\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_30\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_22\, 
        Q => o_RHD64_SPI_CS_n_c);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[11]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[11]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[11]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_31\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[4]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[20]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i33_i\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_6\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_0_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_0_0\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_4\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_0_3\);
    
    \Controller_Headstage_1/int_RHD64_TX_DV\ : DFN1E0
      port map(D => \Controller_Headstage_1/N_10\, CLK => i_Clk_c, 
        E => i_Rst_L_c, Q => 
        \Controller_Headstage_1/int_RHD64_TX_DV_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO_0[2]\ : 
        AX1D
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_139_mux\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_12\ : 
        AO1
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a1_2\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a1_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_6\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_0_0\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[10]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[10]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[10]_net_1\);
    
    \Controller_Headstage_1/state[4]\ : DFN1
      port map(D => \Controller_Headstage_1/state[4]_net_1\, CLK
         => i_Clk_c, Q => \Controller_Headstage_1/state[4]_net_1\);
    
    \Controller_Headstage_1/state[29]\ : DFN1
      port map(D => \Controller_Headstage_1/state[29]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[29]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNIM6UQ3[1]\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_23\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_30\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_44\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[25]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[25]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[25]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_RNO\ : 
        AX1
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_418\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m5_0_a2_0\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_RNO_0_net_1\);
    
    \Controller_Headstage_1/counter_RNIV93H[1]\ : NOR2B
      port map(A => \Controller_Headstage_1/counter[0]_net_1\, B
         => \Controller_Headstage_1/counter[1]_net_1\, Y => 
        \Controller_Headstage_1/counter_c1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_3\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_152\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_155\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_156\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_8_G_0_0\ : 
        AO1A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_0_0_a3_0_1\, 
        C => \Controller_Headstage_1/SPI_Master_CS_STM32/N_36\, Y
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/DWACT_ADD_CI_0_partial_sum[0]\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[8]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[8]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[8]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[11]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[11]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_101\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_31\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_7\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i43_i\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_76\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_79\);
    
    INT_ULSICC_INSTANCE_0 : ULSICC_INT
      port map(USTDBY => \GND\, LPENA => \GND\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_5[2]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_92\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_102\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[6]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_41\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[6]\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[24]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[8]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[24]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[2]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_395\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNIBMPU[2]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_n3_0_o2_out\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[2]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_49\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[2]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_4\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a4_0\);
    
    \Controller_Headstage_1/state[16]\ : DFN1
      port map(D => \Controller_Headstage_1/state[16]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[16]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNI4NMA3[5]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_22\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count_RNIVOPN[2]\ : 
        OR3C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_418\);
    
    \Controller_Headstage_1/state_RNIHAHT1[17]\ : OR3
      port map(A => \Controller_Headstage_1/state[20]_net_1\, B
         => \Controller_Headstage_1/state[17]_net_1\, C => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_13[0]\, 
        Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_21[0]\);
    
    \Controller_Headstage_1/counter_RNI6EN81[13]\ : NOR3C
      port map(A => \Controller_Headstage_1/counter[12]_net_1\, B
         => \Controller_Headstage_1/counter[13]_net_1\, C => 
        \Controller_Headstage_1/counter_m2_0_a2_1\, Y => 
        \Controller_Headstage_1/counter_m2_0_a2_2\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[4]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[4]\, CLK => 
        i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[4]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_390\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_15_0\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[26]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[26]\, CLK
         => i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[26]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[5]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_398\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO[4]\ : 
        NOR3
      port map(A => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_7_0\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_i3_mux\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_8_mux\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[1]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[1]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_106\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_83\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNI4VRS1[1]\ : 
        OA1A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_66\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_28\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNI4VRS1[1]_net_1\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_n_RNILPVE\ : 
        OR2A
      port map(A => o_STM32_SPI_CS_n_c, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[1]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_22\);
    
    \Controller_Headstage_1/state[24]\ : DFN1
      port map(D => \Controller_Headstage_1/state[24]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[24]_net_1\);
    
    \Controller_Headstage_1/counter_RNI999U3[13]\ : NOR3C
      port map(A => \Controller_Headstage_1/counter_m5_0_a2_5\, B
         => \Controller_Headstage_1/counter_m2_0_a2_2\, C => 
        \Controller_Headstage_1/counter_m5_0_a2_6\, Y => 
        \Controller_Headstage_1/counter_c13\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[6]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[6]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[6]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[4]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[4]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[4]_net_1\);
    
    \Controller_Headstage_1/state[0]\ : DFN1
      port map(D => \Controller_Headstage_1/N_8\, CLK => i_Clk_c, 
        Q => \Controller_Headstage_1/state[0]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[0]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_53\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[0]\);
    
    \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/READ_AND\ : 
        AND3B
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\EMPTYX_I[1]\\\\\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\EMPTYX_I[0]\\\\\, 
        C => \Controller_Headstage_1/int_FIFO_RE_net_1\, Y => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/READ_ENABLE_I\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_1\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_149\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_156\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_7\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[0]\ : 
        DFN1E0C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_39\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_44\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[0]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count_RNO_0[2]\ : 
        AX1B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[0]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_14_0_0\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[19]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[19]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[19]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[11]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[11]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_101\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_63\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_n_RNO\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_24\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_47\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNIJM951[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_22\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[14]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[14]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[14]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO_0[2]\ : 
        AX1D
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[0]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_34_i\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_RNIL0MQ[0]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_c1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[0]\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count_RNO[0]_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\);
    
    \Controller_Headstage_1/counter[15]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n15\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[15]_net_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_DV_0\ : DFN1E0
      port map(D => \Controller_Headstage_1/N_10\, CLK => i_Clk_c, 
        E => i_Rst_L_c, Q => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_RNO_3\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m3_e_2\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIBESE1[0]\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_94\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_RX_DV_0\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_95\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_TX_Ready_RNILGCU2_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/_FIFOBLOCK[1]_\ : 
        FIFO4K18
      port map(AEVAL11 => \GND\, AEVAL10 => \GND\, AEVAL9 => 
        \GND\, AEVAL8 => \GND\, AEVAL7 => \GND\, AEVAL6 => \VCC\, 
        AEVAL5 => \GND\, AEVAL4 => \VCC\, AEVAL3 => \GND\, AEVAL2
         => \GND\, AEVAL1 => \GND\, AEVAL0 => \GND\, AFVAL11 => 
        \VCC\, AFVAL10 => \VCC\, AFVAL9 => \VCC\, AFVAL8 => \VCC\, 
        AFVAL7 => \VCC\, AFVAL6 => \GND\, AFVAL5 => \VCC\, AFVAL4
         => \GND\, AFVAL3 => \GND\, AFVAL2 => \GND\, AFVAL1 => 
        \GND\, AFVAL0 => \GND\, WD17 => \GND\, WD16 => \GND\, 
        WD15 => \GND\, WD14 => \GND\, WD13 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[31]_net_1\, 
        WD12 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[30]_net_1\, 
        WD11 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[29]_net_1\, 
        WD10 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[28]_net_1\, 
        WD9 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[27]_net_1\, 
        WD8 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[26]_net_1\, 
        WD7 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[25]_net_1\, 
        WD6 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[24]_net_1\, 
        WD5 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[23]_net_1\, 
        WD4 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[22]_net_1\, 
        WD3 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[21]_net_1\, 
        WD2 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[20]_net_1\, 
        WD1 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[19]_net_1\, 
        WD0 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[18]_net_1\, 
        WW0 => \GND\, WW1 => \GND\, WW2 => \VCC\, RW0 => \GND\, 
        RW1 => \GND\, RW2 => \VCC\, RPIPE => \GND\, WEN => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/WRITE_ENABLE_I\, 
        REN => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/READ_ENABLE_I\, 
        WBLK => \GND\, RBLK => \GND\, WCLK => i_Clk_c, RCLK => 
        i_Clk_c, RESET => \AFLSDF_INV_1\, ESTOP => \VCC\, FSTOP
         => \VCC\, RD17 => OPEN, RD16 => OPEN, RD15 => OPEN, RD14
         => OPEN, RD13 => \Controller_Headstage_1/o_FIFO_Q[31]\, 
        RD12 => \Controller_Headstage_1/o_FIFO_Q[30]\, RD11 => 
        \Controller_Headstage_1/o_FIFO_Q[29]\, RD10 => 
        \Controller_Headstage_1/o_FIFO_Q[28]\, RD9 => 
        \Controller_Headstage_1/o_FIFO_Q[27]\, RD8 => 
        \Controller_Headstage_1/o_FIFO_Q[26]\, RD7 => 
        \Controller_Headstage_1/o_FIFO_Q[25]\, RD6 => 
        \Controller_Headstage_1/o_FIFO_Q[24]\, RD5 => 
        \Controller_Headstage_1/o_FIFO_Q[23]\, RD4 => 
        \Controller_Headstage_1/o_FIFO_Q[22]\, RD3 => 
        \Controller_Headstage_1/o_FIFO_Q[21]\, RD2 => 
        \Controller_Headstage_1/o_FIFO_Q[20]\, RD1 => 
        \Controller_Headstage_1/o_FIFO_Q[19]\, RD0 => 
        \Controller_Headstage_1/o_FIFO_Q[18]\, FULL => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\FULLX_I[1]\\\\\, 
        AFULL => OPEN, EMPTY => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\EMPTYX_I[1]\\\\\, 
        AEMPTY => OPEN);
    
    \Controller_Headstage_1/state_RNI97QU[21]\ : OR2
      port map(A => \Controller_Headstage_1/state[21]_net_1\, B
         => \Controller_Headstage_1/state[24]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_3[0]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[30]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[30]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[30]_net_1\);
    
    \Controller_Headstage_1/state_RNIDBQU[23]\ : OR2
      port map(A => \Controller_Headstage_1/state[23]_net_1\, B
         => \Controller_Headstage_1/state[26]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_0[0]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNIN9771[0]\ : 
        NOR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[0]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_58\);
    
    \Controller_Headstage_1/counter[11]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n11\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[11]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_4\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_143\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_144\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_145\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNIBMPU[3]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/un2lt5_i_o2_0_0\);
    
    \Controller_Headstage_1/counter[3]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n3\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[3]_net_1\);
    
    \Controller_Headstage_1/counter_RNO[7]\ : XOR2
      port map(A => \Controller_Headstage_1/counter_c6\, B => 
        \Controller_Headstage_1/counter[7]_net_1\, Y => 
        \Controller_Headstage_1/counter_n7\);
    
    \Controller_Headstage_1/state[7]\ : DFN1
      port map(D => \Controller_Headstage_1/state[7]_net_1\, CLK
         => i_Clk_c, Q => \Controller_Headstage_1/state[7]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_13\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[5]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[13]_net_1\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_151\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[1]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_83\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[1]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO[1]\ : 
        XA1C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_394\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[8]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[8]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[8]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_Trailing_Edge\ : 
        DFN1P1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_Trailing_Edge_RNO_net_1\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_257_i_i_0\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNIETHD[3]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_0_2\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[6]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_407\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[6]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_10\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_121\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_n_RNO_0\ : 
        OA1
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_47\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_30\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[8]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[24]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i34_i\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[21]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[21]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[21]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNO[1]\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_23\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_37\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNO[1]_net_1\);
    
    \Controller_Headstage_1/counter_RNIG0LP[1]\ : NOR3C
      port map(A => \Controller_Headstage_1/counter[1]_net_1\, B
         => \Controller_Headstage_1/counter[0]_net_1\, C => 
        \Controller_Headstage_1/counter[2]_net_1\, Y => 
        \Controller_Headstage_1/counter_c2\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[4]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_8_mux\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_8_G_2_0\ : 
        NOR3A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[1]_net_1\, 
        B => \Controller_Headstage_1/SPI_Master_CS_STM32/N_30\, C
         => \Controller_Headstage_1/SPI_Master_CS_STM32/N_35\, Y
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_8[1]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[7]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[7]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[7]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[5]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[5]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_99\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_75\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[7]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_71\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[7]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_32\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[12]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[28]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i32_i\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_11\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[6]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[14]_net_1\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_147\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_8_G_0_0_a3\ : 
        OA1A
      port map(A => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_27\, C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[0]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_36\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_5\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_146\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_147\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_148\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO[0]\ : 
        AO1A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_15_0_mux\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/w_Master_Ready\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_436_mux\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Trailing_Edge\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_0_sqmuxa\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[10]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[10]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[10]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_14\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[3]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[11]_net_1\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_153\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Trailing_Edge_RNO\ : 
        NOR3B
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_0_sqmuxa_0_a2_0\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[4]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_22\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_0_sqmuxa\);
    
    \Controller_Headstage_1/state[1]\ : DFN1
      port map(D => \Controller_Headstage_1/state_RNO[1]_net_1\, 
        CLK => i_Clk_c, Q => 
        \Controller_Headstage_1/state[1]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[5]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[5]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_99\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_43\);
    
    \i_Clk_pad/U0/U1\ : CLKIO
      port map(A => \i_Clk_pad/U0/NET1\, Y => i_Clk_c);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO_1[1]\ : 
        NOR3B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[1]_net_1\, 
        B => \Controller_Headstage_1/SPI_Master_CS_STM32/N_20\, C
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_33\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[13]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_59\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[13]\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[3]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[3]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[3]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[5]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_75\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[5]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[1]\ : 
        DFN1E0C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_37_i\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[1]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[14]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[14]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[14]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[13]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[13]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[13]_net_1\);
    
    \Controller_Headstage_1/counter[2]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n2\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[2]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNI3MQK[0]\ : 
        OR2B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/w_Master_Ready\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[29]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[29]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[29]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNI1KSF2[1]\ : 
        AO1A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_5_0_a2_0\, 
        C => \Controller_Headstage_1/SPI_Master_CS_STM32/N_44\, Y
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Counte\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[1]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_17_i\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[1]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_389\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_15_0\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[15]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_55\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[15]\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[2]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[2]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[2]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1[2]\ : 
        OR3B
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_89\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_109\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_15\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[7]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[15]_net_1\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_154\);
    
    \o_STM32_SPI_MOSI_pad/U0/U0\ : IOPAD_TRI
      port map(D => \o_STM32_SPI_MOSI_pad/U0/NET1\, E => 
        \o_STM32_SPI_MOSI_pad/U0/NET2\, PAD => o_STM32_SPI_MOSI);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[5]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[5]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[5]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO_1[4]\ : 
        AX1A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_411\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_0_a2_0\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_i3_mux\);
    
    \i_RHD64_SPI_MISO_pad/U0/U1\ : IOIN_IB
      port map(YIN => \i_RHD64_SPI_MISO_pad/U0/NET1\, Y => 
        i_RHD64_SPI_MISO_c);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_0\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_DV_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/un16_r_leading_edge\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNI3URS1[0]\ : 
        AO1A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_28\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_66\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNI3URS1[0]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[0]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_30\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_39\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[2]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_30\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_34_i\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[2]_net_1\);
    
    \Controller_Headstage_1/counter[1]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n1\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[1]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNI79DS2[5]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_16\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_22\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[2]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[2]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[2]_net_1\);
    
    \Controller_Headstage_1/state_RNIDKHJ3[5]\ : OR3
      port map(A => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_11[0]\, 
        B => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_10[0]\, 
        C => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_21[0]\, 
        Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_25[0]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_40\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[11]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[27]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_130\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNO_0[4]\ : 
        AX1D
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_n3_0_o2_out\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/un2lt5_i_o2_0_0\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_347\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNIAVNT[0]\ : 
        NOR3A
      port map(A => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_22\, C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_30\);
    
    \Controller_Headstage_1/state_RNIPTL9E[1]\ : OA1B
      port map(A => \Controller_Headstage_1/state[1]_net_1\, B
         => \Controller_Headstage_1/N_40\, C => 
        \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, Y => 
        \Controller_Headstage_1/N_49\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[12]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[12]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_110\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_61\);
    
    \Controller_Headstage_1/counter_RNIU4SR1[6]\ : NOR3C
      port map(A => \Controller_Headstage_1/counter[5]_net_1\, B
         => \Controller_Headstage_1/counter_c4\, C => 
        \Controller_Headstage_1/counter[6]_net_1\, Y => 
        \Controller_Headstage_1/counter_c6\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_349\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_121\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[13]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[13]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_105\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_27\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_16\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i31_i\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i30_i\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_88\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[0]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[0]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_96\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_85\);
    
    \Controller_Headstage_1/state[25]\ : DFN1
      port map(D => \Controller_Headstage_1/state[25]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[25]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_392\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_15_0\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[3]\ : 
        XA1C
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[3]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_27\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_30\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[3]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO_2[0]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[6]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_0_0\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[24]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[24]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[24]_net_1\);
    
    \Controller_Headstage_1/state[23]\ : DFN1
      port map(D => \Controller_Headstage_1/state[23]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[23]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[7]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[7]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[7]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_RNO_2\ : 
        NOR3
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m3_e_3\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[9]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[9]\, CLK => 
        i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[9]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO[3]\ : 
        OR2B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_142_mux\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_432\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_391\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[15]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[15]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_109\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_55\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_19\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[9]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[25]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_109\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNIIEAO1[3]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_27\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_32\);
    
    \Controller_Headstage_1/state[3]\ : DFN1
      port map(D => \Controller_Headstage_1/state[3]_net_1\, CLK
         => i_Clk_c, Q => \Controller_Headstage_1/state[3]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[5]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[5]\, CLK => 
        i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[5]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[8]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[8]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_104\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_69\);
    
    \Controller_Headstage_1/state[19]\ : DFN1
      port map(D => \Controller_Headstage_1/state[19]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[19]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[1]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[1]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[1]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNIH9QF[1]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_66\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[13]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[13]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[13]_net_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[5]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[5]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[5]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_RNO[3]\ : 
        XNOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_13\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_19_i\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO[5]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_45_i\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_398\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count_RNO_1[4]\ : 
        NOR3
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_141\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_144\);
    
    \Controller_Headstage_1/state[28]\ : DFN1
      port map(D => \Controller_Headstage_1/state[28]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[28]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNI2T4E2[0]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_87\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_94\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_368\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNI5SAK[6]\ : 
        NOR3
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[6]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_2_2\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_391\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_15_0\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNO[3]\ : 
        XO1A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[3]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_94\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_8\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_7\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[15]_net_1\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_DV_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_8\);
    
    \Controller_Headstage_1/counter_RNO_2[9]\ : NOR2B
      port map(A => \Controller_Headstage_1/counter[4]_net_1\, B
         => \Controller_Headstage_1/counter[3]_net_1\, Y => 
        \Controller_Headstage_1/counter_m4_0_a2_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNO[3]\ : 
        XA1A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_341\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_332\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_5\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_112\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_121\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_124\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_13\ : 
        NOR3B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a2_0\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_133\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_4\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_8_I_1\ : 
        AND2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNI3URS1[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_18\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/DWACT_ADD_CI_0_TMP[0]\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[4]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[4]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[4]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNIQFEF1[6]\ : 
        NOR3B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_2_2\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_e_0_2\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_411\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_5_mux_0\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_RNIDB9G_0[1]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[0]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_38\);
    
    \Controller_Headstage_1/counter_RNILGOA1[4]\ : NOR3C
      port map(A => \Controller_Headstage_1/counter[3]_net_1\, B
         => \Controller_Headstage_1/counter_c2\, C => 
        \Controller_Headstage_1/counter[4]_net_1\, Y => 
        \Controller_Headstage_1/counter_c4\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNIOSHI1[1]\ : 
        MX2B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[1]_net_1\, 
        B => \Controller_Headstage_1/SPI_Master_CS_STM32/int_N_6\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]_net_1\, 
        Y => \Controller_Headstage_1/N_6_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_328\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_120\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\);
    
    \Controller_Headstage_1/counter[6]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n6\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[6]_net_1\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO[0]\ : 
        OA1C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_5_0_a2_0\, 
        B => \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\, C
         => \Controller_Headstage_1/SPI_Master_CS_STM32/G_11_i_0\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO_0[0]_net_1\);
    
    \i_Clk_pad/U0/U0\ : IOPAD_IN
      port map(PAD => i_Clk, Y => \i_Clk_pad/U0/NET1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_27\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[31]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_6\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_14\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i35_i\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i34_i\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i43_i\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[9]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[9]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[9]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_RNO\ : 
        NOR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_0_sqmuxa_0_a2_0\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_22\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_1_sqmuxa\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_2\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_79\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_100\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_103\);
    
    \Controller_Headstage_1/state[14]\ : DFN1
      port map(D => \Controller_Headstage_1/state[14]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[14]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[20]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[4]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[20]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_RNO[1]\ : 
        XOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_17_i\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_10\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[2]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[10]_net_1\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_146\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[20]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[20]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[20]_net_1\);
    
    \o_RHD64_SPI_CS_n_pad/U0/U0\ : IOPAD_TRI
      port map(D => \o_RHD64_SPI_CS_n_pad/U0/NET1\, E => 
        \o_RHD64_SPI_CS_n_pad/U0/NET2\, PAD => o_RHD64_SPI_CS_n);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[4]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[4]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_100\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_45\);
    
    \Controller_Headstage_1/int_STM32_TX_DV_0_RNIOMCJ2\ : OR3A
      port map(A => \Controller_Headstage_1/G_0_i_a2_0\, B => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, C => 
        \Controller_Headstage_1/N_6_0\, Y => 
        \Controller_Headstage_1/int_N_5_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[7]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_39\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[7]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_14[2]\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_87\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_96\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_RNI0HCD\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/w_Master_Ready\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_432\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_28\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_127\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_130\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_133\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[4]\ : 
        XO1A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[4]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_32\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_30\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_4\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[4]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_77\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[4]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[17]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[17]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[17]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_21\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[13]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[29]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_118\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_RNO_12\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[9]_net_1\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_150\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_DV_RNI2SCA\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_DV_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_367\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_RNO[3]\ : 
        XAI1
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_15_0\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_367\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_328\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[0]\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/DWACT_ADD_CI_0_partial_sum[0]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[0]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNO_0[1]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_29\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_37\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_SPI_MOSI_8\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/un16_r_leading_edge\, 
        Q => o_RHD64_SPI_MOSI_c);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[23]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[23]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[23]_net_1\);
    
    \o_RHD64_SPI_Clk_pad/U0/U1\ : IOTRI_OB_EB
      port map(D => o_RHD64_SPI_Clk_c, E => \VCC\, DOUT => 
        \o_RHD64_SPI_Clk_pad/U0/NET1\, EOUT => 
        \o_RHD64_SPI_Clk_pad/U0/NET2\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[8]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_37\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[8]\);
    
    \Controller_Headstage_1/counter[10]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n10\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[10]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[7]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[7]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_97\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_39\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[25]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[9]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[25]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[10]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[10]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_102\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_65\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[6]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_73\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[6]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[0]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_429\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count_RNO[2]\ : 
        AX1C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_39_i\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[29]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[13]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[29]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO[6]\ : 
        AO1
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_416\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[6]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_407\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_RNO\ : 
        AX1
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_22\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_0_sqmuxa_0_a2_0\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_RNO_net_1\);
    
    \i_Rst_L_pad/U0/U0\ : IOPAD_IN
      port map(PAD => i_Rst_L, Y => \i_Rst_L_pad/U0/NET1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_0\ : 
        NOR2A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_257_i_i_0\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_137_mux\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[2]\ : 
        DFN1E0C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[2]_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_44\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[2]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[14]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_57\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[14]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_36\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[14]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[30]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i28_i\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[23]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[23]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[23]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[3]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_79\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[3]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/\\\\FIFOBLOCK[0]\\\\_RNI36EN\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\EMPTYX_I[0]\\\\\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\EMPTYX_I[1]\\\\\, 
        Y => \Controller_Headstage_1/G_3_0_0\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[22]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[6]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[22]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_RNIUBUC3[3]\ : 
        AO1D
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_14\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_22\, 
        C => \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, Y
         => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edgese\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[27]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[11]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[27]_net_1\);
    
    \Controller_Headstage_1/counter_RNO[1]\ : XOR2
      port map(A => \Controller_Headstage_1/counter[0]_net_1\, B
         => \Controller_Headstage_1/counter[1]_net_1\, Y => 
        \Controller_Headstage_1/counter_n1\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[6]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[6]\, CLK => 
        i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[6]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNO[0]\ : 
        OR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_335\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNIES6L[1]\ : 
        MX2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_24\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_8_G_0_0_m2\ : 
        MX2B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_22\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/w_Master_Ready\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_27\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_2[2]\ : 
        OR3B
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_87\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_111\);
    
    \Controller_Headstage_1/state_RNIBMOFD[2]\ : OR3
      port map(A => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_25[0]\, 
        B => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_24[0]\, 
        C => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_26[0]\, 
        Y => \Controller_Headstage_1/N_40\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_39\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[3]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[19]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_127\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count_RNO[0]\ : 
        OA1C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_5_0_a2_0\, 
        B => \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\, C
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[0]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_116\);
    
    \Controller_Headstage_1/state_RNI73OU[11]\ : OR2
      port map(A => \Controller_Headstage_1/state[11]_net_1\, B
         => \Controller_Headstage_1/state[14]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_13[0]\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[28]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[12]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[28]_net_1\);
    
    \Controller_Headstage_1/state_RNIC807E_0[0]\ : NOR3
      port map(A => \Controller_Headstage_1/state[1]_net_1\, B
         => \Controller_Headstage_1/N_40\, C => 
        \Controller_Headstage_1/state[0]_net_1\, Y => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_15\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i33_i\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i32_i\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_76\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[3]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[3]\, CLK => 
        i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[3]_net_1\);
    
    AFLSDF_INV_0 : INV
      port map(A => i_Rst_L_c, Y => \AFLSDF_INV_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[12]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_61\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[12]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[0]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_325\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_120\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[0]_net_1\);
    
    \Controller_Headstage_1/state[30]\ : DFN1
      port map(D => \Controller_Headstage_1/state[30]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[30]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[1]\ : 
        XA1C
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[0]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_30\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[1]_net_1\);
    
    \Controller_Headstage_1/state[20]\ : DFN1
      port map(D => \Controller_Headstage_1/state[20]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[20]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_DV_0\ : DFN1E0
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNIG8OO2_net_1\, 
        CLK => i_Clk_c, E => i_Rst_L_c, Q => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\);
    
    \Controller_Headstage_1/state_RNIC807E[0]\ : NOR3A
      port map(A => \Controller_Headstage_1/state[0]_net_1\, B
         => \Controller_Headstage_1/state[1]_net_1\, C => 
        \Controller_Headstage_1/N_40\, Y => 
        \Controller_Headstage_1/N_50\);
    
    \Controller_Headstage_1/state_RNO[0]\ : XA1C
      port map(A => \Controller_Headstage_1/state[0]_net_1\, B
         => \Controller_Headstage_1/N_41\, C => 
        \Controller_Headstage_1/N_48\, Y => 
        \Controller_Headstage_1/N_8\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[26]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[10]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[26]_net_1\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO_0[1]\ : 
        NOR3
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_16_0_a3_0_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[10]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[10]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[10]_net_1\);
    
    \Controller_Headstage_1/state_RNO[1]\ : AX1
      port map(A => \Controller_Headstage_1/N_41\, B => 
        \Controller_Headstage_1/state[0]_net_1\, C => 
        \Controller_Headstage_1/state[1]_net_1\, Y => 
        \Controller_Headstage_1/state_RNO[1]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[18]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[18]\, CLK
         => i_Clk_c, E => \Controller_Headstage_1/int_N_5_0\, Q
         => \Controller_Headstage_1/int_STM32_TX_Byte[18]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[0]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_85\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[0]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_33\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[2]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[18]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i31_i\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO[3]\ : 
        XA1C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_412\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_410\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_396\);
    
    \Controller_Headstage_1/counter_RNIAL3H[9]\ : NOR2B
      port map(A => \Controller_Headstage_1/counter[9]_net_1\, B
         => \Controller_Headstage_1/counter[3]_net_1\, Y => 
        \Controller_Headstage_1/counter_m5_0_a2_6_0\);
    
    \i_RHD64_SPI_MISO_pad/U0/U0\ : IOPAD_IN
      port map(PAD => i_RHD64_SPI_MISO, Y => 
        \i_RHD64_SPI_MISO_pad/U0/NET1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[16]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[16]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[16]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[1]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_51\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[1]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_RNO[0]\ : 
        MX2B
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[0]_net_1\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_367\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_325\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[27]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[27]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[27]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[3]\ : 
        DFN1E0C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[3]_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_44\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[3]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNIDSHD[3]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_n6_i_o2_0\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO[0]\ : 
        NOR3
      port map(A => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_N_7\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_429\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[4]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[4]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[4]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_8_I_8\ : 
        XOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNI3URS1[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_18\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/DWACT_ADD_CI_0_partial_sum[0]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[1]\ : 
        DFN1E0C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count_RNO[1]_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_44\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[1]_net_1\);
    
    \Controller_Headstage_1/counter_RNO[6]\ : AX1C
      port map(A => \Controller_Headstage_1/counter[5]_net_1\, B
         => \Controller_Headstage_1/counter_c4\, C => 
        \Controller_Headstage_1/counter[6]_net_1\, Y => 
        \Controller_Headstage_1/counter_n6\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[14]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[14]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_107\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_25\);
    
    \Controller_Headstage_1/state_RNIHFQU[25]\ : OR2
      port map(A => \Controller_Headstage_1/state[25]_net_1\, B
         => \Controller_Headstage_1/state[28]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_1[0]\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_n\ : 
        DFN1E1P1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_n_0_sqmuxa\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/un1_r_CS_n_0_sqmuxa\, 
        Q => o_STM32_SPI_CS_n_c);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNI7MHD[0]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_411\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_34\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[10]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[26]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i30_i\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[10]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[10]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[10]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNIG1451[0]\ : 
        NOR3B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/w_Master_Ready\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]_net_1\, 
        C => \Controller_Headstage_1/SPI_Master_CS_STM32/N_38\, Y
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_0_sqmuxa\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[9]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[9]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[9]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[0]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[0]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[0]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[1]\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNO[1]_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[1]_net_1\);
    
    \Controller_Headstage_1/state_RNI92DS2[13]\ : OR3
      port map(A => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_1[0]\, 
        B => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_0[0]\, 
        C => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_14[0]\, 
        Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_22[0]\);
    
    \Controller_Headstage_1/counter_RNO[4]\ : AX1C
      port map(A => \Controller_Headstage_1/counter[3]_net_1\, B
         => \Controller_Headstage_1/counter_c2\, C => 
        \Controller_Headstage_1/counter[4]_net_1\, Y => 
        \Controller_Headstage_1/counter_n4\);
    
    i_RHD64_SPI_MISO_pad_RNI6BFA : BUFF
      port map(A => i_RHD64_SPI_MISO_c, Y => i_RHD64_SPI_MISO_c_0);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count_RNO[3]\ : 
        XNOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_418\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Count[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_41_i\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[10]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[10]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[10]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNICOM41[0]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[0]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_29\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[4]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_333\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[4]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_n_RNIBICT\ : 
        OR2B
      port map(A => o_RHD64_SPI_CS_n_c, B => 
        \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_28\);
    
    \Controller_Headstage_1/state[15]\ : DFN1
      port map(D => \Controller_Headstage_1/state[15]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[15]_net_1\);
    
    \Controller_Headstage_1/state[6]\ : DFN1
      port map(D => \Controller_Headstage_1/state[6]_net_1\, CLK
         => i_Clk_c, Q => \Controller_Headstage_1/state[6]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_RX_DV\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_95\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_TX_Ready_RNILGCU2_net_1\, 
        Q => \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_20\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[5]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[21]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_115\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO_0[0]\ : 
        AO1A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]_net_1\, 
        B => \Controller_Headstage_1/SPI_Master_CS_STM32/N_25\, C
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_11_i_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[5]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[5]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[5]_net_1\);
    
    \Controller_Headstage_1/state[13]\ : DFN1
      port map(D => \Controller_Headstage_1/state[13]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[13]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[31]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[15]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[31]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[1]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[1]\, CLK => 
        i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[1]_net_1\);
    
    \Controller_Headstage_1/state_RNIIN3G6[2]\ : OR3
      port map(A => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_17[0]\, 
        B => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_16[0]\, 
        C => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_22[0]\, 
        Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_26[0]\);
    
    \Controller_Headstage_1/state[31]\ : DFN1
      port map(D => \Controller_Headstage_1/state[31]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[31]_net_1\);
    
    \Controller_Headstage_1/state[21]\ : DFN1
      port map(D => \Controller_Headstage_1/state[21]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[21]_net_1\);
    
    \Controller_Headstage_1/counter_RNO[12]\ : XOR2
      port map(A => \Controller_Headstage_1/counter_c11\, B => 
        \Controller_Headstage_1/counter[12]_net_1\, Y => 
        \Controller_Headstage_1/counter_n12\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNO[5]\ : 
        XAI1
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_16\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_6\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_11[2]\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_89\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_110\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_22\ : 
        NOR3B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/m57_d_a0_3\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[5]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_6\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/\\\\FIFOBLOCK[0]\\\\_RNI3F8V\ : 
        NOR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\EMPTYX_I[0]\\\\\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\EMPTYX_I[1]\\\\\, 
        C => i_Rst_L_c, Y => \Controller_Headstage_1/G_0_i_a2_0\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count_RNO[2]\ : 
        AO1A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_5_0_a2_0\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_14_0_0\, Y
         => \Controller_Headstage_1/SPI_Master_CS_STM32/N_118\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[9]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_67\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[9]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[6]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[6]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_98\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_41\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[7]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[7]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_97\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_71\);
    
    \o_STM32_SPI_Clk_pad/U0/U1\ : IOTRI_OB_EB
      port map(D => o_STM32_SPI_Clk_c, E => \VCC\, DOUT => 
        \o_STM32_SPI_Clk_pad/U0/NET1\, EOUT => 
        \o_STM32_SPI_Clk_pad/U0/NET2\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[3]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[3]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[3]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[15]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[15]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[15]_net_1\);
    
    \o_RHD64_SPI_MOSI_pad/U0/U0\ : IOPAD_TRI
      port map(D => \o_RHD64_SPI_MOSI_pad/U0/NET1\, E => 
        \o_RHD64_SPI_MOSI_pad/U0/NET2\, PAD => o_RHD64_SPI_MOSI);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[5]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_43\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[5]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[13]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[13]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_105\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_59\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[19]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[3]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[19]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[31]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[31]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[31]_net_1\);
    
    \Controller_Headstage_1/counter_RNO[2]\ : XOR2
      port map(A => \Controller_Headstage_1/counter_c1\, B => 
        \Controller_Headstage_1/counter[2]_net_1\, Y => 
        \Controller_Headstage_1/counter_n2\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges_RNO[2]\ : 
        XA1A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_340\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_331\);
    
    \Controller_Headstage_1/state[18]\ : DFN1
      port map(D => \Controller_Headstage_1/state[18]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[18]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/WRITE_AND\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\FULLX_I[0]\\\\\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\FULLX_I[1]\\\\\, 
        C => \Controller_Headstage_1/Controller_RHD64_1/WEBP\, Y
         => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/WRITE_ENABLE_I\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_n_RNO_0\ : 
        AO1A
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_21\, B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_5_0_a2_0\, 
        C => \Controller_Headstage_1/SPI_Master_CS_STM32/N_30\, Y
         => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/un1_r_CS_n_0_sqmuxa\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_1_sqmuxa\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNO_0[2]\ : 
        OA1
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_118\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_9[2]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_87\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_108\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_TX_Ready_RNILGCU2\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_368\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_95\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_TX_Ready_RNILGCU2_net_1\);
    
    AFLSDF_INV_1 : INV
      port map(A => i_Rst_L_c, Y => \AFLSDF_INV_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[12]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[12]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[12]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO_0[6]\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_412\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_n6_i_o2_0\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_416\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[17]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[1]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[17]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[23]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[7]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[23]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_DV\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_DV_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising[11]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_63\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[11]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[3]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_332\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_RNIQK72[3]\ : 
        OR2A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[3]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_13\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_14\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count_RNO_0[1]\ : 
        XOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[0]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_24_i\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_4[2]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_89\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_105\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[20]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[20]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[20]_net_1\);
    
    \Controller_Headstage_1/state_RNICBRU[27]\ : OR2
      port map(A => \Controller_Headstage_1/state[27]_net_1\, B
         => \Controller_Headstage_1/state[30]_net_1\, Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_5[0]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[1]\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_8[1]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count[1]_net_1\);
    
    \Controller_Headstage_1/state_RNICA3C3[7]\ : OR3
      port map(A => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_7[0]\, 
        B => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_6[0]\, 
        C => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_19[0]\, 
        Y => 
        \Controller_Headstage_1/un1_int_rhd64_tx_byte8_2_i_o3_24[0]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[26]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[26]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[26]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[18]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[2]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[18]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNO[2]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_94\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_118\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/w_Master_Ready\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_10\);
    
    \Controller_Headstage_1/counter_RNO[13]\ : AX1C
      port map(A => \Controller_Headstage_1/counter[12]_net_1\, B
         => \Controller_Headstage_1/counter_c11\, C => 
        \Controller_Headstage_1/counter[13]_net_1\, Y => 
        \Controller_Headstage_1/counter_n13\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_35\ : 
        MX2C
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[6]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[22]_net_1\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/i29_i\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[2]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_18_i\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[2]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO_0[5]\ : 
        AX1D
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_412\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_n6_i_o2_0\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[5]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_45_i\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges_RNO_2[4]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[2]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_m2_0_a2_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[1]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_330\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Edges[1]_net_1\);
    
    \Controller_Headstage_1/state[8]\ : DFN1
      port map(D => \Controller_Headstage_1/state[8]_net_1\, CLK
         => i_Clk_c, Q => \Controller_Headstage_1/state[8]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS_RNI2AAE2[1]\ : 
        OAI1
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_32\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_CS_Inactive_Count[4]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_SM_CS[1]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_23\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[9]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[9]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[9]_net_1\);
    
    \Controller_Headstage_1/counter[0]\ : DFN1C1
      port map(D => \Controller_Headstage_1/counter_e0\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/counter[0]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[16]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[0]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[16]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[14]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[14]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[14]_net_1\);
    
    \Controller_Headstage_1/state[9]\ : DFN1
      port map(D => \Controller_Headstage_1/state[9]_net_1\, CLK
         => i_Clk_c, Q => \Controller_Headstage_1/state[9]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[28]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[28]\, CLK
         => i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[28]_net_1\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[1]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[1]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[1]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/_FIFOBLOCK[0]_\ : 
        FIFO4K18
      port map(AEVAL11 => \GND\, AEVAL10 => \GND\, AEVAL9 => 
        \GND\, AEVAL8 => \GND\, AEVAL7 => \GND\, AEVAL6 => \VCC\, 
        AEVAL5 => \GND\, AEVAL4 => \VCC\, AEVAL3 => \GND\, AEVAL2
         => \GND\, AEVAL1 => \GND\, AEVAL0 => \GND\, AFVAL11 => 
        \VCC\, AFVAL10 => \VCC\, AFVAL9 => \VCC\, AFVAL8 => \VCC\, 
        AFVAL7 => \VCC\, AFVAL6 => \GND\, AFVAL5 => \VCC\, AFVAL4
         => \GND\, AFVAL3 => \GND\, AFVAL2 => \GND\, AFVAL1 => 
        \GND\, AFVAL0 => \GND\, WD17 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[17]_net_1\, 
        WD16 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[16]_net_1\, 
        WD15 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[15]_net_1\, 
        WD14 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[14]_net_1\, 
        WD13 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[13]_net_1\, 
        WD12 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[12]_net_1\, 
        WD11 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[11]_net_1\, 
        WD10 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[10]_net_1\, 
        WD9 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[9]_net_1\, 
        WD8 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[8]_net_1\, 
        WD7 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[7]_net_1\, 
        WD6 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[6]_net_1\, 
        WD5 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[5]_net_1\, 
        WD4 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[4]_net_1\, 
        WD3 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[3]_net_1\, 
        WD2 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[2]_net_1\, 
        WD1 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[1]_net_1\, 
        WD0 => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[0]_net_1\, 
        WW0 => \GND\, WW1 => \GND\, WW2 => \VCC\, RW0 => \GND\, 
        RW1 => \GND\, RW2 => \VCC\, RPIPE => \GND\, WEN => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/WRITE_ENABLE_I\, 
        REN => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/READ_ENABLE_I\, 
        WBLK => \GND\, RBLK => \GND\, WCLK => i_Clk_c, RCLK => 
        i_Clk_c, RESET => \AFLSDF_INV_0\, ESTOP => \VCC\, FSTOP
         => \VCC\, RD17 => \Controller_Headstage_1/o_FIFO_Q[17]\, 
        RD16 => \Controller_Headstage_1/o_FIFO_Q[16]\, RD15 => 
        \Controller_Headstage_1/o_FIFO_Q[15]\, RD14 => 
        \Controller_Headstage_1/o_FIFO_Q[14]\, RD13 => 
        \Controller_Headstage_1/o_FIFO_Q[13]\, RD12 => 
        \Controller_Headstage_1/o_FIFO_Q[12]\, RD11 => 
        \Controller_Headstage_1/o_FIFO_Q[11]\, RD10 => 
        \Controller_Headstage_1/o_FIFO_Q[10]\, RD9 => 
        \Controller_Headstage_1/o_FIFO_Q[9]\, RD8 => 
        \Controller_Headstage_1/o_FIFO_Q[8]\, RD7 => 
        \Controller_Headstage_1/o_FIFO_Q[7]\, RD6 => 
        \Controller_Headstage_1/o_FIFO_Q[6]\, RD5 => 
        \Controller_Headstage_1/o_FIFO_Q[5]\, RD4 => 
        \Controller_Headstage_1/o_FIFO_Q[4]\, RD3 => 
        \Controller_Headstage_1/o_FIFO_Q[3]\, RD2 => 
        \Controller_Headstage_1/o_FIFO_Q[2]\, RD1 => 
        \Controller_Headstage_1/o_FIFO_Q[1]\, RD0 => 
        \Controller_Headstage_1/o_FIFO_Q[0]\, FULL => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\FULLX_I[0]\\\\\, 
        AFULL => OPEN, EMPTY => 
        \Controller_Headstage_1/Controller_RHD64_1/FIFO_1/Z\\\\EMPTYX_I[0]\\\\\, 
        AEMPTY => OPEN);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[0]\ : 
        DFN1P1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_436_mux\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[0]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[2]\ : 
        DFN1E0P1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_327\, 
        CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_120\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[2]_net_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[7]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[7]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[7]_net_1\);
    
    \Controller_Headstage_1/counter[9]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n9\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[9]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_DV_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[3]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_396\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edgese\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_SPI_Clk_Edges[3]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[11]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[11]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[11]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_13[2]\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_93\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_100\);
    
    \Controller_Headstage_1/counter[4]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n4\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[4]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI_RNO_8\ : 
        MX2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_88\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_97\, 
        S => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_100\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[14]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_Byte[14]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_TX_Byte[14]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count_RNI9NAT[2]\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[0]_net_1\, 
        Y => \Controller_Headstage_1/SPI_Master_CS_STM32/N_20\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_WE\ : 
        DFI1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, QN => 
        \Controller_Headstage_1/Controller_RHD64_1/WEBP\);
    
    \Controller_Headstage_1/int_FIFO_RE\ : DFN1C1
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNIG8OO2_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/int_FIFO_RE_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_RNO[4]\ : 
        XNOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_14\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_20_i\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_RNO[2]\ : 
        XAI1
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count_c1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_367\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_327\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[1]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[1]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_106\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_51\);
    
    \Controller_Headstage_1/counter_RNO[9]\ : AX1C
      port map(A => \Controller_Headstage_1/counter_c1\, B => 
        \Controller_Headstage_1/counter_m4_0_a2_5\, C => 
        \Controller_Headstage_1/counter[9]_net_1\, Y => 
        \Controller_Headstage_1/counter_n9\);
    
    \Controller_Headstage_1/state[2]\ : DFN1
      port map(D => \Controller_Headstage_1/state[2]_net_1\, CLK
         => i_Clk_c, Q => \Controller_Headstage_1/state[2]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNIAPGU1_12[2]\ : 
        OR3
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[2]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_92\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_104\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNINE8V_2[3]\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[3]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_87\);
    
    \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2\ : OR3A
      port map(A => \Controller_Headstage_1/G_0_i_a2_0\, B => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\, C => 
        \Controller_Headstage_1/N_6_0\, Y => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\);
    
    \o_STM32_SPI_Clk_pad/U0/U0\ : IOPAD_TRI
      port map(D => \o_STM32_SPI_Clk_pad/U0/NET1\, E => 
        \o_STM32_SPI_Clk_pad/U0/NET2\, PAD => o_STM32_SPI_Clk);
    
    \Controller_Headstage_1/counter_RNO[14]\ : XOR2
      port map(A => \Controller_Headstage_1/counter_c13\, B => 
        \Controller_Headstage_1/counter[14]_net_1\, Y => 
        \Controller_Headstage_1/counter_n14\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[4]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[4]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[4]_net_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/r_Trailing_Edge_RNID05K\ : 
        NOR2B
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_432\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_257_i_i_0\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_15_0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[6]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[6]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[6]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/r_TX_Count_RNI2KNA2[0]\ : 
        OR3A
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_24\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/N_58\, 
        C => \Controller_Headstage_1/int_RHD64_TX_DV_net_1\, Y
         => \Controller_Headstage_1/o_RHD64_TX_Ready_i_1\);
    
    \Controller_Headstage_1/counter_RNI3LNV2[10]\ : NOR3C
      port map(A => \Controller_Headstage_1/counter_m5_0_a2_5\, B
         => \Controller_Headstage_1/counter_m5_0_a2_6\, C => 
        \Controller_Headstage_1/counter[10]_net_1\, Y => 
        \Controller_Headstage_1/counter_c10\);
    
    \Controller_Headstage_1/counter[5]\ : DFN1E1C1
      port map(D => \Controller_Headstage_1/counter_n5\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_rhd64_tx_byte8\, Q => 
        \Controller_Headstage_1/counter[5]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[3]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/int_RHD64_TX_Byte[3]_net_1\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_DV_0_net_1\, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_TX_Byte[3]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_RNI2ML1[2]\ : 
        OR3C
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[1]_net_1\, 
        C => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[2]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_13\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_TX_Ready\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_TX_Ready_RNO_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/w_Master_Ready\);
    
    \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[7]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[7]\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/o_RX_DV_0\, Q
         => 
        \Controller_Headstage_1/Controller_RHD64_1/int_FIFO_DATA[7]_net_1\);
    
    \Controller_Headstage_1/int_RHD64_TX_Byte[12]\ : DFN1E1
      port map(D => \Controller_Headstage_1/counter[12]_net_1\, 
        CLK => i_Clk_c, E => 
        \Controller_Headstage_1/int_RHD64_TX_Byte_0_sqmuxa\, Q
         => \Controller_Headstage_1/int_RHD64_TX_Byte[12]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[9]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_35\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[9]\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Rising_RNO[14]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Rising[14]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_107\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_57\);
    
    \Controller_Headstage_1/counter_RNI7I3H[4]\ : NOR2B
      port map(A => \Controller_Headstage_1/counter[4]_net_1\, B
         => \Controller_Headstage_1/counter[5]_net_1\, Y => 
        \Controller_Headstage_1/counter_m5_0_a2_6_1\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[1]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/N_117\, CLK
         => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Counte\, 
        Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_CS_Inactive_Count[1]_net_1\);
    
    \Controller_Headstage_1/int_STM32_TX_Byte[31]\ : DFN1E0
      port map(D => \Controller_Headstage_1/o_FIFO_Q[31]\, CLK
         => i_Clk_c, E => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNI9N4J2_net_1\, 
        Q => \Controller_Headstage_1/int_STM32_TX_Byte[31]_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_RNIM0RA\ : 
        OR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_Leading_Edge_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_95\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_RNO[0]\ : 
        XOR2
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/o_tx_ready14\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_e0\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling_RNO[9]\ : 
        MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[9]\, 
        S => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_103\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_35\);
    
    \Controller_Headstage_1/int_STM32_TX_DV\ : DFN1E0
      port map(D => 
        \Controller_Headstage_1/int_STM32_TX_DV_RNIG8OO2_net_1\, 
        CLK => i_Clk_c, E => i_Rst_L_c, Q => 
        \Controller_Headstage_1/int_STM32_TX_DV_net_1\);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/io_RX_Byte_Falling[12]\ : 
        DFN1E1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_29\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_170_i\, 
        Q => 
        \Controller_Headstage_1/Controller_RHD64_1/io_RX_Byte_Falling[12]\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count_RNIDB9G[1]\ : 
        NOR2
      port map(A => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[1]_net_1\, 
        B => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_TX_Count[0]_net_1\, 
        Y => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/G_5_0_a2_0\);
    
    
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/o_SPI_MOSI\ : 
        DFN1E0C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_58_0\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/SPI_Master_1/N_137_mux\, 
        Q => o_STM32_SPI_MOSI_c);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count_RNO_0[4]\ : 
        NOR2B
      port map(A => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_94\, 
        B => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_RX_Bit_Count[4]_net_1\, 
        Y => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/N_117\);
    
    \Controller_Headstage_1/state[10]\ : DFN1
      port map(D => \Controller_Headstage_1/state[10]_net_1\, CLK
         => i_Clk_c, Q => 
        \Controller_Headstage_1/state[10]_net_1\);
    
    \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS_RNO_0[0]_net_1\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/SPI_Master_CS_STM32/r_SM_CS[0]_net_1\);
    
    \o_STM32_SPI_CS_n_pad/U0/U0\ : IOPAD_TRI
      port map(D => \o_STM32_SPI_CS_n_pad/U0/NET1\, E => 
        \o_STM32_SPI_CS_n_pad/U0/NET2\, PAD => o_STM32_SPI_CS_n);
    
    
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[0]\ : 
        DFN1C1
      port map(D => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count_e0\, 
        CLK => i_Clk_c, CLR => i_Rst_L_c, Q => 
        \Controller_Headstage_1/Controller_RHD64_1/SPI_Master_CS_1/SPI_Master_1/r_SPI_Clk_Count[0]_net_1\);
    
    GND_power_inst1 : GND
      port map( Y => GND_power_net1);

    VCC_power_inst1 : VCC
      port map( Y => VCC_power_net1);


end DEF_ARCH; 
