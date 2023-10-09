-- Version: v11.9 11.9.0.4

library ieee;
use ieee.std_logic_1164.all;
library igloo;
use igloo.all;

entity SPI_Master_0_8_32 is

    port( int_STM32_TX_Byte  : in    std_logic_vector(31 downto 0);
          int_STM32_TX_DV_0  : in    std_logic;
          o_STM32_SPI_MOSI_c : out   std_logic;
          o_STM32_SPI_Clk_c  : out   std_logic;
          i_Rst_L_c          : in    std_logic;
          i_Clk_c            : in    std_logic;
          int_STM32_TX_DV    : in    std_logic;
          w_Master_Ready     : out   std_logic
        );

end SPI_Master_0_8_32;

architecture DEF_ARCH of SPI_Master_0_8_32 is 

  component MX2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          S : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AO1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
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

  component NOR3A
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

  component OR2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1E0P1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          PRE : in    std_logic := 'U';
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

  component DFN1P1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          PRE : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component NOR3
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

  component NOR2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AX1A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OR2
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

  component XOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
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

  component GND
    port( Y : out   std_logic
        );
  end component;

  component XAI1
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

  component XNOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
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

  component XO1
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

  component OR3
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component VCC
    port( Y : out   std_logic
        );
  end component;

  component NOR3B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
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

  component AX1
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

  component XO1A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
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

  component NOR3C
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

  component OR3A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
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

  component OR3C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

    signal N_8_0, \r_RX_Bit_Count[1]_net_1\, 
        \r_RX_Bit_Count[0]_net_1\, N_9_0, 
        \r_RX_Bit_Count[2]_net_1\, N_10_0, 
        \r_RX_Bit_Count[3]_net_1\, N_11_0, 
        \r_RX_Bit_Count[4]_net_1\, N_402, \w_Master_Ready\, N_403, 
        N_404, N_405, \r_RX_Bit_Count[5]_net_1\, m57_d_0_3, 
        m57_d_0_1, m57_d_0_0, N_4, m57_d_a0_3, m57_d_a0_2, N_3, 
        m57_d_a1_2, m57_d_a1_1, N_6, m57_d_a4_0, \r_TX_DV\, 
        \r_TX_Bit_Count[1]_net_1\, m57_d_a2_1, 
        \r_TX_Bit_Count[2]_net_1\, \r_TX_Bit_Count[3]_net_1\, 
        m57_d_a2_0, \r_TX_Bit_Count[4]_net_1\, 
        \r_TX_Byte[15]_net_1\, \r_TX_Byte[31]_net_1\, N_136, 
        N_133, N_178, N_124, N_58_0, N_103, N_177, 
        \r_TX_Bit_Count[0]_net_1\, i43_i, i35_i, i34_i, N_79, 
        N_76, N_100, N_112, N_106, N_109, N_121, N_115, N_118, 
        N_127, \r_TX_Byte[3]_net_1\, \r_TX_Byte[19]_net_1\, N_130, 
        \r_TX_Byte[11]_net_1\, \r_TX_Byte[27]_net_1\, 
        \r_TX_Byte[7]_net_1\, \r_TX_Byte[23]_net_1\, 
        \r_TX_Byte[0]_net_1\, \r_TX_Byte[16]_net_1\, 
        \r_TX_Byte[8]_net_1\, \r_TX_Byte[24]_net_1\, i28_i, 
        \r_TX_Byte[14]_net_1\, \r_TX_Byte[30]_net_1\, i29_i, 
        \r_TX_Byte[6]_net_1\, \r_TX_Byte[22]_net_1\, i30_i, 
        \r_TX_Byte[10]_net_1\, \r_TX_Byte[26]_net_1\, i31_i, 
        \r_TX_Byte[2]_net_1\, \r_TX_Byte[18]_net_1\, i32_i, 
        \r_TX_Byte[12]_net_1\, \r_TX_Byte[28]_net_1\, i33_i, 
        \r_TX_Byte[4]_net_1\, \r_TX_Byte[20]_net_1\, 
        \r_TX_Byte[13]_net_1\, \r_TX_Byte[29]_net_1\, 
        \r_TX_Byte[5]_net_1\, \r_TX_Byte[21]_net_1\, 
        \r_TX_Byte[9]_net_1\, \r_TX_Byte[25]_net_1\, 
        \r_TX_Byte[1]_net_1\, \r_TX_Byte[17]_net_1\, N_88, N_97, 
        r_SPI_Clk_Edges_n6_i_o2_0, \r_SPI_Clk_Edges[3]_net_1\, 
        \r_SPI_Clk_Edges[4]_net_1\, r_m2_e_2_2, 
        \r_SPI_Clk_Edges[6]_net_1\, \r_SPI_Clk_Edges[2]_net_1\, 
        r_m2_0_a2_0, r_m2_e_0_2, \r_SPI_Clk_Edges[5]_net_1\, 
        r_m2_e_0_1, r_m2_e_0_0, \r_SPI_Clk_Edges[1]_net_1\, 
        r_N_5_mux_0, N_411, r_N_7_0, r_N_8_mux, r_i3_mux, N_429, 
        \r_SPI_Clk_Edges[0]_net_1\, r_N_7, \o_TX_Ready_RNO\, 
        \r_SPI_Clk_Count_RNO[0]_net_1\, 
        \r_SPI_Clk_Count[0]_net_1\, N_407, N_416, N_410, N_398, 
        N_45_i, N_396, N_42_i, N_395, N_40_i, N_394, N_38_i, 
        r_SPI_Clk_Edgese, N_418, \r_Leading_Edge_RNO\, 
        \r_SPI_Clk_Count[3]_net_1\, \r_Trailing_Edge_RNO\, N_412, 
        \r_SPI_Clk_Count[1]_net_1\, \r_SPI_Clk_Count[2]_net_1\, 
        N_41_i, r_m5_0_a2_0, r_m3_e_4, r_m3_e_3, r_m3_e_2, N_144, 
        N_141, N_138_mux, N_257_i_i_0, r_Leading_Edge_i_0, 
        \r_SPI_Clk_RNO_0\, \r_SPI_Clk\, N_37_i, N_39_i, N_432, 
        N_15_0, N_389, N_390, N_139_mux, N_391, N_142_mux, N_392, 
        N_144_mux, N_400, N_401, N_137_mux, N_142, N_15_0_mux, 
        N_436_mux, \GND\, \VCC\ : std_logic;

begin 

    w_Master_Ready <= \w_Master_Ready\;

    o_SPI_MOSI_RNO_17 : MX2
      port map(A => i29_i, B => i28_i, S => 
        \r_TX_Bit_Count[3]_net_1\, Y => N_97);
    
    \r_SPI_Clk_Edges_RNO[6]\ : AO1
      port map(A => N_416, B => \r_SPI_Clk_Edges[6]_net_1\, C => 
        N_410, Y => N_407);
    
    \r_TX_Byte[29]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(29), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV, Q => 
        \r_TX_Byte[29]_net_1\);
    
    \r_TX_Byte[7]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(7), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[7]_net_1\);
    
    o_SPI_MOSI_RNO_23 : NOR3A
      port map(A => \r_TX_Bit_Count[3]_net_1\, B => \r_TX_DV\, C
         => \r_TX_Byte[15]_net_1\, Y => m57_d_a0_2);
    
    \r_RX_Bit_Count_RNIFCSP[1]\ : NOR2
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[0]_net_1\, Y => N_8_0);
    
    \r_SPI_Clk_Edges[2]\ : DFN1E1C1
      port map(D => N_395, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[2]_net_1\);
    
    \r_TX_Byte[17]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(17), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[17]_net_1\);
    
    \r_TX_Bit_Count_RNO[2]\ : OR2B
      port map(A => N_139_mux, B => N_432, Y => N_390);
    
    r_TX_DV_RNI0HCD : NOR2
      port map(A => \r_TX_DV\, B => \w_Master_Ready\, Y => N_432);
    
    \r_RX_Bit_Count[4]\ : DFN1E0P1
      port map(D => N_404, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_138_mux, Q => \r_RX_Bit_Count[4]_net_1\);
    
    o_SPI_MOSI_RNO_11 : AO1
      port map(A => m57_d_a0_3, B => m57_d_a0_2, C => N_3, Y => 
        m57_d_0_1);
    
    o_SPI_MOSI_RNO_39 : MX2C
      port map(A => \r_TX_Byte[3]_net_1\, B => 
        \r_TX_Byte[19]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => N_127);
    
    \r_TX_Bit_Count[0]\ : DFN1P1
      port map(D => N_436_mux, CLK => i_Clk_c, PRE => i_Rst_L_c, 
        Q => \r_TX_Bit_Count[0]_net_1\);
    
    \r_SPI_Clk_Edges[5]\ : DFN1E1C1
      port map(D => N_398, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[5]_net_1\);
    
    \r_TX_Byte[0]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(0), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[0]_net_1\);
    
    r_SPI_Clk_RNO_3 : NOR2
      port map(A => \r_SPI_Clk_Edges[3]_net_1\, B => 
        \r_SPI_Clk_Edges[4]_net_1\, Y => r_m3_e_2);
    
    \r_TX_Byte[22]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(22), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[22]_net_1\);
    
    \r_RX_Bit_Count[5]\ : DFN1E0P1
      port map(D => N_405, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_138_mux, Q => \r_RX_Bit_Count[5]_net_1\);
    
    r_SPI_Clk_RNO_2 : NOR3
      port map(A => \r_SPI_Clk_Edges[0]_net_1\, B => 
        \r_SPI_Clk_Edges[1]_net_1\, C => 
        \r_SPI_Clk_Edges[5]_net_1\, Y => r_m3_e_3);
    
    \r_RX_Bit_Count[1]\ : DFN1E0P1
      port map(D => N_401, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_138_mux, Q => \r_RX_Bit_Count[1]_net_1\);
    
    \r_TX_Byte[18]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(18), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[18]_net_1\);
    
    \r_RX_Bit_Count_RNI8KQ61[2]\ : NOR2A
      port map(A => N_8_0, B => \r_RX_Bit_Count[2]_net_1\, Y => 
        N_9_0);
    
    o_SPI_MOSI_RNO_26 : NOR2B
      port map(A => \r_TX_Bit_Count[2]_net_1\, B => 
        \r_TX_Bit_Count[3]_net_1\, Y => m57_d_a1_1);
    
    \r_TX_Byte[23]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(23), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV, Q => 
        \r_TX_Byte[23]_net_1\);
    
    o_SPI_MOSI_RNO_27 : NOR2A
      port map(A => \r_TX_DV\, B => \r_TX_Byte[31]_net_1\, Y => 
        N_6);
    
    \r_TX_Bit_Count_RNO_0[3]\ : AX1A
      port map(A => \r_TX_Bit_Count[0]_net_1\, B => N_142, C => 
        \r_TX_Bit_Count[3]_net_1\, Y => N_142_mux);
    
    \r_SPI_Clk_Edges_RNI7MHD[0]\ : OR2
      port map(A => \r_SPI_Clk_Edges[1]_net_1\, B => 
        \r_SPI_Clk_Edges[0]_net_1\, Y => N_411);
    
    o_SPI_MOSI_RNO_7 : MX2
      port map(A => i43_i, B => N_76, S => 
        \r_TX_Bit_Count[2]_net_1\, Y => N_79);
    
    o_SPI_MOSI_RNO : MX2C
      port map(A => N_178, B => N_103, S => N_177, Y => N_58_0);
    
    \r_SPI_Clk_Edges[0]\ : DFN1E1C1
      port map(D => N_429, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[0]_net_1\);
    
    o_SPI_MOSI_RNO_15 : MX2
      port map(A => i33_i, B => i32_i, S => 
        \r_TX_Bit_Count[3]_net_1\, Y => N_76);
    
    o_TX_Ready_RNO : NOR2A
      port map(A => r_N_5_mux_0, B => int_STM32_TX_DV, Y => 
        \o_TX_Ready_RNO\);
    
    o_SPI_MOSI_RNO_12 : AO1
      port map(A => m57_d_a1_2, B => m57_d_a1_1, C => N_6, Y => 
        m57_d_0_0);
    
    r_Leading_Edge : DFN1P1
      port map(D => \r_Leading_Edge_RNO\, CLK => i_Clk_c, PRE => 
        i_Rst_L_c, Q => r_Leading_Edge_i_0);
    
    \r_TX_Byte[8]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(8), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[8]_net_1\);
    
    \r_SPI_Clk_Count_RNI7KI82[2]\ : AO1D
      port map(A => N_418, B => r_N_5_mux_0, C => int_STM32_TX_DV, 
        Y => r_SPI_Clk_Edgese);
    
    o_SPI_MOSI_RNO_33 : MX2C
      port map(A => \r_TX_Byte[2]_net_1\, B => 
        \r_TX_Byte[18]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => i31_i);
    
    \r_SPI_Clk_Count_RNO[1]\ : XOR2
      port map(A => \r_SPI_Clk_Count[1]_net_1\, B => 
        \r_SPI_Clk_Count[0]_net_1\, Y => N_37_i);
    
    \r_TX_Bit_Count_RNO[0]\ : AO1A
      port map(A => \r_TX_DV\, B => N_15_0_mux, C => 
        \w_Master_Ready\, Y => N_436_mux);
    
    GND_i : GND
      port map(Y => \GND\);
    
    \r_TX_Bit_Count_RNO[1]\ : XAI1
      port map(A => \r_TX_Bit_Count[1]_net_1\, B => 
        \r_TX_Bit_Count[0]_net_1\, C => N_432, Y => N_389);
    
    o_SPI_MOSI : DFN1E0C1
      port map(D => N_58_0, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => N_137_mux, Q => o_STM32_SPI_MOSI_c);
    
    o_SPI_MOSI_RNO_21 : MX2C
      port map(A => \r_TX_Byte[13]_net_1\, B => 
        \r_TX_Byte[29]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => N_118);
    
    r_Trailing_Edge_RNID05K : NOR2B
      port map(A => N_432, B => N_257_i_i_0, Y => N_15_0);
    
    \r_TX_Bit_Count_RNO_0[0]\ : XNOR2
      port map(A => N_257_i_i_0, B => \r_TX_Bit_Count[0]_net_1\, 
        Y => N_15_0_mux);
    
    \r_TX_Byte[9]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(9), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[9]_net_1\);
    
    \r_TX_Byte[25]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(25), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV, Q => 
        \r_TX_Byte[25]_net_1\);
    
    \r_SPI_Clk_Edges_RNO_0[5]\ : AX1D
      port map(A => N_412, B => r_SPI_Clk_Edges_n6_i_o2_0, C => 
        \r_SPI_Clk_Edges[5]_net_1\, Y => N_45_i);
    
    \r_RX_Bit_Count_RNO[2]\ : XO1
      port map(A => \r_RX_Bit_Count[2]_net_1\, B => N_8_0, C => 
        \w_Master_Ready\, Y => N_402);
    
    \r_TX_Bit_Count[3]\ : DFN1E0P1
      port map(D => N_391, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_15_0, Q => \r_TX_Bit_Count[3]_net_1\);
    
    r_SPI_Clk_RNO_0 : AOI1
      port map(A => r_m3_e_4, B => r_m3_e_3, C => int_STM32_TX_DV, 
        Y => r_m5_0_a2_0);
    
    o_SPI_MOSI_RNO_6 : OR3
      port map(A => m57_d_0_1, B => m57_d_0_0, C => N_4, Y => 
        m57_d_0_3);
    
    o_SPI_MOSI_RNO_36 : MX2C
      port map(A => \r_TX_Byte[14]_net_1\, B => 
        \r_TX_Byte[30]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => i28_i);
    
    VCC_i : VCC
      port map(Y => \VCC\);
    
    \r_TX_Bit_Count_RNO_0[2]\ : AX1D
      port map(A => \r_TX_Bit_Count[0]_net_1\, B => 
        \r_TX_Bit_Count[1]_net_1\, C => \r_TX_Bit_Count[2]_net_1\, 
        Y => N_139_mux);
    
    \r_RX_Bit_Count[2]\ : DFN1E0P1
      port map(D => N_402, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_138_mux, Q => \r_RX_Bit_Count[2]_net_1\);
    
    o_SPI_MOSI_RNO_37 : NOR2A
      port map(A => \r_TX_Bit_Count[2]_net_1\, B => 
        \r_TX_Bit_Count[3]_net_1\, Y => m57_d_a2_1);
    
    o_SPI_MOSI_RNO_25 : NOR3B
      port map(A => \r_TX_Bit_Count[1]_net_1\, B => 
        \r_TX_Bit_Count[4]_net_1\, C => \r_TX_Byte[31]_net_1\, Y
         => m57_d_a1_2);
    
    \r_SPI_Clk_Edges_RNO_0[2]\ : XOR2
      port map(A => N_411, B => \r_SPI_Clk_Edges[2]_net_1\, Y => 
        N_40_i);
    
    \r_SPI_Clk_Edges_RNO[3]\ : NOR2
      port map(A => N_42_i, B => N_410, Y => N_396);
    
    o_SPI_MOSI_RNO_22 : NOR3B
      port map(A => \r_TX_Bit_Count[2]_net_1\, B => 
        \r_TX_Bit_Count[1]_net_1\, C => \r_TX_Bit_Count[4]_net_1\, 
        Y => m57_d_a0_3);
    
    \r_TX_Bit_Count_RNO_2[4]\ : NOR2A
      port map(A => \r_TX_Bit_Count[3]_net_1\, B => 
        \r_TX_Bit_Count[2]_net_1\, Y => N_141);
    
    o_SPI_Clk : DFN1C1
      port map(D => \r_SPI_Clk\, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        Q => o_STM32_SPI_Clk_c);
    
    r_TX_DV : DFN1C1
      port map(D => int_STM32_TX_DV, CLK => i_Clk_c, CLR => 
        i_Rst_L_c, Q => \r_TX_DV\);
    
    r_SPI_Clk_RNO : AX1
      port map(A => N_418, B => r_m5_0_a2_0, C => \r_SPI_Clk\, Y
         => \r_SPI_Clk_RNO_0\);
    
    \r_SPI_Clk_Edges[4]\ : DFN1E1C1
      port map(D => r_N_8_mux, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[4]_net_1\);
    
    \r_SPI_Clk_Edges_RNI5SAK[6]\ : NOR3
      port map(A => \r_SPI_Clk_Edges[4]_net_1\, B => 
        \r_SPI_Clk_Edges[6]_net_1\, C => 
        \r_SPI_Clk_Edges[2]_net_1\, Y => r_m2_e_2_2);
    
    \r_SPI_Clk_Edges_RNO_0[1]\ : XOR2
      port map(A => \r_SPI_Clk_Edges[1]_net_1\, B => 
        \r_SPI_Clk_Edges[0]_net_1\, Y => N_38_i);
    
    \r_TX_Byte[27]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(27), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV, Q => 
        \r_TX_Byte[27]_net_1\);
    
    \r_SPI_Clk_Count[3]\ : DFN1E0C1
      port map(D => N_41_i, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => N_410, Q => \r_SPI_Clk_Count[3]_net_1\);
    
    \r_TX_Byte[11]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(11), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[11]_net_1\);
    
    \r_SPI_Clk_Edges[6]\ : DFN1E1C1
      port map(D => N_407, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[6]_net_1\);
    
    \r_SPI_Clk_Edges[3]\ : DFN1E1C1
      port map(D => N_396, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[3]_net_1\);
    
    \r_RX_Bit_Count_RNO[0]\ : OR2A
      port map(A => \r_RX_Bit_Count[0]_net_1\, B => 
        \w_Master_Ready\, Y => N_400);
    
    o_SPI_MOSI_RNO_31 : MX2C
      port map(A => \r_TX_Byte[4]_net_1\, B => 
        \r_TX_Byte[20]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => i33_i);
    
    o_SPI_MOSI_RNO_1 : AO1
      port map(A => m57_d_a4_0, B => N_124, C => m57_d_0_3, Y => 
        N_178);
    
    \r_TX_Bit_Count[4]\ : DFN1E0P1
      port map(D => N_392, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_15_0, Q => \r_TX_Bit_Count[4]_net_1\);
    
    \r_TX_Byte[10]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(10), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[10]_net_1\);
    
    \r_RX_Bit_Count_RNO[1]\ : XO1A
      port map(A => \r_RX_Bit_Count[0]_net_1\, B => 
        \r_RX_Bit_Count[1]_net_1\, C => \w_Master_Ready\, Y => 
        N_401);
    
    \r_TX_Byte[3]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(3), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[3]_net_1\);
    
    \r_TX_Byte[14]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(14), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[14]_net_1\);
    
    \r_SPI_Clk_Count_RNO[0]\ : AX1B
      port map(A => int_STM32_TX_DV, B => r_N_5_mux_0, C => 
        \r_SPI_Clk_Count[0]_net_1\, Y => 
        \r_SPI_Clk_Count_RNO[0]_net_1\);
    
    \r_SPI_Clk_Edges_RNO_0[4]\ : NOR3
      port map(A => \r_SPI_Clk_Edges[5]_net_1\, B => 
        \r_SPI_Clk_Edges[6]_net_1\, C => 
        \r_SPI_Clk_Edges[4]_net_1\, Y => r_N_7_0);
    
    o_SPI_MOSI_RNO_14 : MX2
      port map(A => i35_i, B => i34_i, S => 
        \r_TX_Bit_Count[3]_net_1\, Y => i43_i);
    
    \r_SPI_Clk_Edges_RNO_2[4]\ : NOR2
      port map(A => \r_SPI_Clk_Edges[2]_net_1\, B => 
        \r_SPI_Clk_Edges[3]_net_1\, Y => r_m2_0_a2_0);
    
    \r_SPI_Clk_Count_RNO[3]\ : XNOR2
      port map(A => N_418, B => \r_SPI_Clk_Count[3]_net_1\, Y => 
        N_41_i);
    
    \r_SPI_Clk_Edges_RNO[4]\ : NOR3
      port map(A => int_STM32_TX_DV, B => r_N_7_0, C => r_i3_mux, 
        Y => r_N_8_mux);
    
    \r_TX_Byte[28]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(28), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV, Q => 
        \r_TX_Byte[28]_net_1\);
    
    o_SPI_MOSI_RNO_0 : NOR2A
      port map(A => N_257_i_i_0, B => \r_TX_DV\, Y => N_137_mux);
    
    \r_SPI_Clk_Edges_RNO[1]\ : NOR2
      port map(A => N_38_i, B => N_410, Y => N_394);
    
    \r_SPI_Clk_Edges_RNI8ROG1[6]\ : OR2
      port map(A => int_STM32_TX_DV, B => r_N_5_mux_0, Y => N_410);
    
    \r_SPI_Clk_Count[0]\ : DFN1C1
      port map(D => \r_SPI_Clk_Count_RNO[0]_net_1\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, Q => 
        \r_SPI_Clk_Count[0]_net_1\);
    
    \r_TX_Bit_Count[1]\ : DFN1E0P1
      port map(D => N_389, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_15_0, Q => \r_TX_Bit_Count[1]_net_1\);
    
    o_SPI_MOSI_RNO_18 : MX2C
      port map(A => \r_TX_Byte[1]_net_1\, B => 
        \r_TX_Byte[17]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => N_106);
    
    \r_RX_Bit_Count_RNI2TOJ1[3]\ : NOR2A
      port map(A => N_9_0, B => \r_RX_Bit_Count[3]_net_1\, Y => 
        N_10_0);
    
    \r_SPI_Clk_Edges_RNO[0]\ : NOR3
      port map(A => int_STM32_TX_DV, B => 
        \r_SPI_Clk_Edges[0]_net_1\, C => r_N_7, Y => N_429);
    
    r_Trailing_Edge : DFN1P1
      port map(D => \r_Trailing_Edge_RNO\, CLK => i_Clk_c, PRE
         => i_Rst_L_c, Q => N_257_i_i_0);
    
    \r_TX_Bit_Count_RNO_1[4]\ : NOR3
      port map(A => \r_TX_Bit_Count[1]_net_1\, B => 
        \r_TX_Bit_Count[0]_net_1\, C => N_141, Y => N_144);
    
    r_SPI_Clk : DFN1C1
      port map(D => \r_SPI_Clk_RNO_0\, CLK => i_Clk_c, CLR => 
        i_Rst_L_c, Q => \r_SPI_Clk\);
    
    o_SPI_MOSI_RNO_35 : MX2C
      port map(A => \r_TX_Byte[6]_net_1\, B => 
        \r_TX_Byte[22]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => i29_i);
    
    o_SPI_MOSI_RNO_32 : MX2C
      port map(A => \r_TX_Byte[12]_net_1\, B => 
        \r_TX_Byte[28]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => i32_i);
    
    \r_TX_Byte[2]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(2), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[2]_net_1\);
    
    o_SPI_MOSI_RNO_10 : MX2
      port map(A => N_115, B => N_118, S => 
        \r_TX_Bit_Count[3]_net_1\, Y => N_121);
    
    r_Leading_Edge_RNIG59Q : NOR3B
      port map(A => N_257_i_i_0, B => r_Leading_Edge_i_0, C => 
        \w_Master_Ready\, Y => N_138_mux);
    
    \r_TX_Byte[16]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(16), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[16]_net_1\);
    
    \r_SPI_Clk_Edges[1]\ : DFN1E1C1
      port map(D => N_394, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[1]_net_1\);
    
    \r_SPI_Clk_Edges_RNO_0[0]\ : NOR3C
      port map(A => r_m2_e_0_1, B => r_m2_e_0_0, C => r_m2_e_0_2, 
        Y => r_N_7);
    
    o_SPI_MOSI_RNO_2 : MX2
      port map(A => N_79, B => N_100, S => 
        \r_TX_Bit_Count[1]_net_1\, Y => N_103);
    
    \r_SPI_Clk_Edges_RNO_0[3]\ : XOR2
      port map(A => N_412, B => \r_SPI_Clk_Edges[3]_net_1\, Y => 
        N_42_i);
    
    \r_TX_Byte[19]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(19), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[19]_net_1\);
    
    \r_SPI_Clk_Count[2]\ : DFN1E0C1
      port map(D => N_39_i, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => N_410, Q => \r_SPI_Clk_Count[2]_net_1\);
    
    o_SPI_MOSI_RNO_4 : NOR2
      port map(A => \r_TX_DV\, B => \r_TX_Bit_Count[1]_net_1\, Y
         => m57_d_a4_0);
    
    \r_SPI_Clk_Edges_RNO_2[0]\ : NOR2
      port map(A => \r_SPI_Clk_Edges[1]_net_1\, B => 
        \r_SPI_Clk_Edges[6]_net_1\, Y => r_m2_e_0_0);
    
    \r_SPI_Clk_Edges_RNO_1[4]\ : AX1A
      port map(A => N_411, B => r_m2_0_a2_0, C => 
        \r_SPI_Clk_Edges[4]_net_1\, Y => r_i3_mux);
    
    \r_SPI_Clk_Edges_RNIETHD[3]\ : NOR2
      port map(A => \r_SPI_Clk_Edges[3]_net_1\, B => 
        \r_SPI_Clk_Edges[5]_net_1\, Y => r_m2_e_0_2);
    
    \r_SPI_Clk_Edges_RNO[2]\ : NOR2
      port map(A => N_40_i, B => N_410, Y => N_395);
    
    \r_TX_Byte[5]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(5), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[5]_net_1\);
    
    o_SPI_MOSI_RNO_24 : NOR3C
      port map(A => m57_d_a2_1, B => m57_d_a2_0, C => N_136, Y
         => N_3);
    
    r_Leading_Edge_RNO : OR3
      port map(A => N_410, B => N_418, C => 
        \r_SPI_Clk_Count[3]_net_1\, Y => \r_Leading_Edge_RNO\);
    
    \r_TX_Bit_Count_RNO[3]\ : OR2B
      port map(A => N_142_mux, B => N_432, Y => N_391);
    
    \r_RX_Bit_Count[0]\ : DFN1E0P1
      port map(D => N_400, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_138_mux, Q => \r_RX_Bit_Count[0]_net_1\);
    
    \r_TX_Bit_Count_RNO[4]\ : OR2B
      port map(A => N_144_mux, B => N_432, Y => N_392);
    
    \r_TX_Byte[6]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(6), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[6]_net_1\);
    
    o_SPI_MOSI_RNO_28 : MX2
      port map(A => N_127, B => N_130, S => 
        \r_TX_Bit_Count[3]_net_1\, Y => N_133);
    
    o_SPI_MOSI_RNO_19 : MX2C
      port map(A => \r_TX_Byte[9]_net_1\, B => 
        \r_TX_Byte[25]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => N_109);
    
    o_SPI_MOSI_RNO_9 : MX2
      port map(A => N_106, B => N_109, S => 
        \r_TX_Bit_Count[3]_net_1\, Y => N_112);
    
    \r_SPI_Clk_Edges_RNISIAK[2]\ : OR2
      port map(A => N_411, B => \r_SPI_Clk_Edges[2]_net_1\, Y => 
        N_412);
    
    \r_SPI_Clk_Count[1]\ : DFN1E0C1
      port map(D => N_37_i, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => N_410, Q => \r_SPI_Clk_Count[1]_net_1\);
    
    \r_SPI_Clk_Count_RNO[2]\ : AX1C
      port map(A => \r_SPI_Clk_Count[0]_net_1\, B => 
        \r_SPI_Clk_Count[1]_net_1\, C => 
        \r_SPI_Clk_Count[2]_net_1\, Y => N_39_i);
    
    \r_TX_Byte[12]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(12), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[12]_net_1\);
    
    o_TX_Ready : DFN1C1
      port map(D => \o_TX_Ready_RNO\, CLK => i_Clk_c, CLR => 
        i_Rst_L_c, Q => \w_Master_Ready\);
    
    o_SPI_MOSI_RNO_20 : MX2C
      port map(A => \r_TX_Byte[5]_net_1\, B => 
        \r_TX_Byte[21]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => N_115);
    
    \r_TX_Bit_Count[2]\ : DFN1E0P1
      port map(D => N_390, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_15_0, Q => \r_TX_Bit_Count[2]_net_1\);
    
    \r_SPI_Clk_Edges_RNO_1[0]\ : NOR2
      port map(A => \r_SPI_Clk_Edges[4]_net_1\, B => 
        \r_SPI_Clk_Edges[2]_net_1\, Y => r_m2_e_0_1);
    
    o_SPI_MOSI_RNO_40 : MX2C
      port map(A => \r_TX_Byte[11]_net_1\, B => 
        \r_TX_Byte[27]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => N_130);
    
    \r_TX_Bit_Count_RNO_0[4]\ : AX1A
      port map(A => \r_TX_Bit_Count[2]_net_1\, B => N_144, C => 
        \r_TX_Bit_Count[4]_net_1\, Y => N_144_mux);
    
    \r_TX_Byte[13]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(13), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[13]_net_1\);
    
    o_SPI_MOSI_RNO_5 : MX2
      port map(A => N_112, B => N_121, S => 
        \r_TX_Bit_Count[2]_net_1\, Y => N_124);
    
    \r_TX_Byte[21]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(21), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[21]_net_1\);
    
    \r_TX_Byte[1]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(1), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[1]_net_1\);
    
    r_SPI_Clk_RNO_1 : NOR3A
      port map(A => r_m3_e_2, B => \r_SPI_Clk_Edges[2]_net_1\, C
         => \r_SPI_Clk_Edges[6]_net_1\, Y => r_m3_e_4);
    
    \r_SPI_Clk_Edges_RNO[5]\ : NOR2
      port map(A => N_45_i, B => N_410, Y => N_398);
    
    r_Trailing_Edge_RNO : OR3A
      port map(A => \r_SPI_Clk_Count[3]_net_1\, B => N_410, C => 
        N_418, Y => \r_Trailing_Edge_RNO\);
    
    \r_TX_Bit_Count_RNO_1[3]\ : OA1C
      port map(A => \r_TX_Bit_Count[2]_net_1\, B => 
        \r_TX_Bit_Count[0]_net_1\, C => \r_TX_Bit_Count[1]_net_1\, 
        Y => N_142);
    
    \r_SPI_Clk_Count_RNIVOPN[2]\ : OR3C
      port map(A => \r_SPI_Clk_Count[0]_net_1\, B => 
        \r_SPI_Clk_Count[1]_net_1\, C => 
        \r_SPI_Clk_Count[2]_net_1\, Y => N_418);
    
    o_SPI_MOSI_RNO_3 : NOR2
      port map(A => \r_TX_DV\, B => \r_TX_Bit_Count[0]_net_1\, Y
         => N_177);
    
    \r_TX_Byte[20]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(20), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[20]_net_1\);
    
    \r_TX_Byte[24]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(24), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV, Q => 
        \r_TX_Byte[24]_net_1\);
    
    o_SPI_MOSI_RNO_13 : NOR3B
      port map(A => m57_d_a2_0, B => N_133, C => 
        \r_TX_Bit_Count[2]_net_1\, Y => N_4);
    
    \r_TX_Byte[4]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(4), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[4]_net_1\);
    
    o_SPI_MOSI_RNO_34 : MX2C
      port map(A => \r_TX_Byte[10]_net_1\, B => 
        \r_TX_Byte[26]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => i30_i);
    
    o_SPI_MOSI_RNO_29 : MX2C
      port map(A => \r_TX_Byte[0]_net_1\, B => 
        \r_TX_Byte[16]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => i35_i);
    
    \r_RX_Bit_Count_RNO[5]\ : XO1
      port map(A => \r_RX_Bit_Count[5]_net_1\, B => N_11_0, C => 
        \w_Master_Ready\, Y => N_405);
    
    \r_RX_Bit_Count[3]\ : DFN1E0P1
      port map(D => N_403, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_138_mux, Q => \r_RX_Bit_Count[3]_net_1\);
    
    r_TX_DV_RNIUNKG : NOR2A
      port map(A => \r_TX_Bit_Count[1]_net_1\, B => \r_TX_DV\, Y
         => m57_d_a2_0);
    
    \r_TX_Byte[15]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(15), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV_0, Q => 
        \r_TX_Byte[15]_net_1\);
    
    \r_RX_Bit_Count_RNO[3]\ : XO1
      port map(A => \r_RX_Bit_Count[3]_net_1\, B => N_9_0, C => 
        \w_Master_Ready\, Y => N_403);
    
    \r_RX_Bit_Count_RNO[4]\ : XO1
      port map(A => \r_RX_Bit_Count[4]_net_1\, B => N_10_0, C => 
        \w_Master_Ready\, Y => N_404);
    
    o_SPI_MOSI_RNO_38 : MX2C
      port map(A => \r_TX_Byte[7]_net_1\, B => 
        \r_TX_Byte[23]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => N_136);
    
    \r_SPI_Clk_Edges_RNIQFEF1[6]\ : NOR3B
      port map(A => r_m2_e_2_2, B => r_m2_e_0_2, C => N_411, Y
         => r_N_5_mux_0);
    
    \r_SPI_Clk_Edges_RNIDSHD[3]\ : OR2
      port map(A => \r_SPI_Clk_Edges[3]_net_1\, B => 
        \r_SPI_Clk_Edges[4]_net_1\, Y => 
        r_SPI_Clk_Edges_n6_i_o2_0);
    
    \r_TX_Byte[31]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(31), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV, Q => 
        \r_TX_Byte[31]_net_1\);
    
    o_SPI_MOSI_RNO_30 : MX2C
      port map(A => \r_TX_Byte[8]_net_1\, B => 
        \r_TX_Byte[24]_net_1\, S => \r_TX_Bit_Count[4]_net_1\, Y
         => i34_i);
    
    \r_TX_Byte[26]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(26), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV, Q => 
        \r_TX_Byte[26]_net_1\);
    
    \r_SPI_Clk_Edges_RNO_0[6]\ : OR3
      port map(A => N_412, B => r_SPI_Clk_Edges_n6_i_o2_0, C => 
        \r_SPI_Clk_Edges[5]_net_1\, Y => N_416);
    
    o_SPI_MOSI_RNO_8 : MX2
      port map(A => N_88, B => N_97, S => 
        \r_TX_Bit_Count[2]_net_1\, Y => N_100);
    
    \r_RX_Bit_Count_RNO_0[5]\ : NOR2A
      port map(A => N_10_0, B => \r_RX_Bit_Count[4]_net_1\, Y => 
        N_11_0);
    
    o_SPI_MOSI_RNO_16 : MX2
      port map(A => i31_i, B => i30_i, S => 
        \r_TX_Bit_Count[3]_net_1\, Y => N_88);
    
    \r_TX_Byte[30]\ : DFN1E1C1
      port map(D => int_STM32_TX_Byte(30), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_STM32_TX_DV, Q => 
        \r_TX_Byte[30]_net_1\);
    

end DEF_ARCH; 

library ieee;
use ieee.std_logic_1164.all;
library igloo;
use igloo.all;

entity SPI_Master_CS_0_8_32_4 is

    port( int_STM32_TX_Byte  : in    std_logic_vector(31 downto 0);
          r_SM_CS_RNIVMVV1_0 : out   std_logic;
          o_STM32_SPI_Clk_c  : out   std_logic;
          o_STM32_SPI_MOSI_c : out   std_logic;
          int_STM32_TX_DV_0  : in    std_logic;
          i_Rst_L_c          : in    std_logic;
          i_Clk_c            : in    std_logic;
          o_STM32_SPI_CS_n_c : out   std_logic;
          int_STM32_TX_DV    : in    std_logic;
          N_6_0              : out   std_logic
        );

end SPI_Master_CS_0_8_32_4;

architecture DEF_ARCH of SPI_Master_CS_0_8_32_4 is 

  component NOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component XOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OR2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
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

  component NOR3A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
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

  component VCC
    port( Y : out   std_logic
        );
  end component;

  component OA1C
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

  component AO1A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
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

  component DFN1E1P1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          PRE : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component INV
    port( A : in    std_logic := 'U';
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

  component OA1A
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

  component OR2A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
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

  component GND
    port( Y : out   std_logic
        );
  end component;

  component OA1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
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

  component SPI_Master_0_8_32
    port( int_STM32_TX_Byte  : in    std_logic_vector(31 downto 0) := (others => 'U');
          int_STM32_TX_DV_0  : in    std_logic := 'U';
          o_STM32_SPI_MOSI_c : out   std_logic;
          o_STM32_SPI_Clk_c  : out   std_logic;
          i_Rst_L_c          : in    std_logic := 'U';
          i_Clk_c            : in    std_logic := 'U';
          int_STM32_TX_DV    : in    std_logic := 'U';
          w_Master_Ready     : out   std_logic
        );
  end component;

    signal \r_SM_CS[1]_net_1\, int_N_6, \r_SM_CS[0]_net_1\, 
        r_SM_CS_0_sqmuxa, \r_TX_Count[0]_net_1\, 
        \r_TX_Count[1]_net_1\, w_Master_Ready, r_CS_n_0_sqmuxa, 
        N_30, G_11_i_0, N_25, G_14_0_0, 
        \r_CS_Inactive_Count[1]_net_1\, 
        \r_CS_Inactive_Count[0]_net_1\, 
        \r_CS_Inactive_Count[2]_net_1\, G_5_0_a2_0, G_0_0_a3_0_1, 
        G_16_0_a3_0_1, N_33, N_20, N_38, N_27, N_22, 
        \o_STM32_SPI_CS_n_c\, N_24_i, N_21, N_117, 
        \DWACT_ADD_CI_0_partial_sum[0]\, N_36, \r_TX_Count_8[1]\, 
        N_35, \r_SM_CS_RNO_0[1]_net_1\, N_118, 
        \r_SM_CS_RNO_0[0]_net_1\, un1_r_CS_n_0_sqmuxa, 
        r_CS_Inactive_Counte, N_44, N_116, \GND\, \VCC\
         : std_logic;

    for all : SPI_Master_0_8_32
	Use entity work.SPI_Master_0_8_32(DEF_ARCH);
begin 

    o_STM32_SPI_CS_n_c <= \o_STM32_SPI_CS_n_c\;

    \r_TX_Count_RNIDB9G[1]\ : NOR2
      port map(A => \r_TX_Count[1]_net_1\, B => 
        \r_TX_Count[0]_net_1\, Y => G_5_0_a2_0);
    
    \r_CS_Inactive_Count_RNO_0[1]\ : XOR2
      port map(A => \r_CS_Inactive_Count[1]_net_1\, B => 
        \r_CS_Inactive_Count[0]_net_1\, Y => N_24_i);
    
    \r_SM_CS_RNIHIOA1[1]\ : NOR2B
      port map(A => N_20, B => \r_SM_CS[1]_net_1\, Y => N_44);
    
    \r_SM_CS_RNO_1[0]\ : OR2B
      port map(A => \o_STM32_SPI_CS_n_c\, B => int_STM32_TX_DV, Y
         => N_25);
    
    \r_CS_Inactive_Count[0]\ : DFN1E1C1
      port map(D => N_116, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_CS_Inactive_Counte, Q => 
        \r_CS_Inactive_Count[0]_net_1\);
    
    r_TX_Count_8_G_2_0_a3 : NOR3A
      port map(A => int_STM32_TX_DV, B => \r_TX_Count[0]_net_1\, 
        C => N_21, Y => N_35);
    
    r_TX_Count_8_G_0_0_m2 : MX2B
      port map(A => N_22, B => w_Master_Ready, S => 
        \r_SM_CS[0]_net_1\, Y => N_27);
    
    \r_SM_CS_RNI3MQK[0]\ : OR2B
      port map(A => w_Master_Ready, B => \r_SM_CS[0]_net_1\, Y
         => N_21);
    
    VCC_i : VCC
      port map(Y => \VCC\);
    
    \r_CS_Inactive_Count_RNO[0]\ : OA1C
      port map(A => G_5_0_a2_0, B => N_21, C => 
        \r_CS_Inactive_Count[0]_net_1\, Y => N_116);
    
    \r_SM_CS_RNO_1[1]\ : NOR3B
      port map(A => \r_SM_CS[1]_net_1\, B => N_20, C => 
        \r_SM_CS[0]_net_1\, Y => N_33);
    
    \r_SM_CS_RNO[1]\ : AO1A
      port map(A => N_21, B => G_16_0_a3_0_1, C => N_33, Y => 
        \r_SM_CS_RNO_0[1]_net_1\);
    
    \r_TX_Count[1]\ : DFN1C1
      port map(D => \r_TX_Count_8[1]\, CLK => i_Clk_c, CLR => 
        i_Rst_L_c, Q => \r_TX_Count[1]_net_1\);
    
    \r_CS_Inactive_Count[2]\ : DFN1E1P1
      port map(D => N_118, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => r_CS_Inactive_Counte, Q => 
        \r_CS_Inactive_Count[2]_net_1\);
    
    r_CS_n_RNO : INV
      port map(A => N_30, Y => r_CS_n_0_sqmuxa);
    
    \r_CS_Inactive_Count[1]\ : DFN1E1C1
      port map(D => N_117, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_CS_Inactive_Counte, Q => 
        \r_CS_Inactive_Count[1]_net_1\);
    
    \r_SM_CS_RNIVMVV1[1]\ : OA1B
      port map(A => \r_SM_CS[0]_net_1\, B => \r_SM_CS[1]_net_1\, 
        C => r_SM_CS_0_sqmuxa, Y => r_SM_CS_RNIVMVV1_0);
    
    \r_SM_CS_RNIOSHI1[1]\ : MX2B
      port map(A => \r_SM_CS[1]_net_1\, B => int_N_6, S => 
        \r_SM_CS[0]_net_1\, Y => N_6_0);
    
    \r_CS_Inactive_Count_RNO[1]\ : OA1C
      port map(A => G_5_0_a2_0, B => N_21, C => N_24_i, Y => 
        N_117);
    
    \r_SM_CS_RNO_0[0]\ : AO1A
      port map(A => \r_SM_CS[0]_net_1\, B => N_25, C => 
        \r_SM_CS[1]_net_1\, Y => G_11_i_0);
    
    r_TX_Count_8_G_0_0_a3 : OA1A
      port map(A => int_STM32_TX_DV, B => N_27, C => 
        \r_TX_Count[0]_net_1\, Y => N_36);
    
    \r_SM_CS_RNO_0[1]\ : NOR3
      port map(A => \r_SM_CS[1]_net_1\, B => 
        \r_TX_Count[1]_net_1\, C => \r_TX_Count[0]_net_1\, Y => 
        G_16_0_a3_0_1);
    
    r_CS_n_RNILPVE : OR2A
      port map(A => \o_STM32_SPI_CS_n_c\, B => \r_SM_CS[1]_net_1\, 
        Y => N_22);
    
    \r_CS_Inactive_Count_RNO_0[2]\ : AX1B
      port map(A => \r_CS_Inactive_Count[1]_net_1\, B => 
        \r_CS_Inactive_Count[0]_net_1\, C => 
        \r_CS_Inactive_Count[2]_net_1\, Y => G_14_0_0);
    
    \r_SM_CS_RNIAVNT[0]\ : NOR3A
      port map(A => int_STM32_TX_DV, B => N_22, C => 
        \r_SM_CS[0]_net_1\, Y => N_30);
    
    GND_i : GND
      port map(Y => \GND\);
    
    \r_TX_Count_RNI97MN[1]\ : OA1
      port map(A => \r_TX_Count[0]_net_1\, B => 
        \r_TX_Count[1]_net_1\, C => w_Master_Ready, Y => int_N_6);
    
    \r_SM_CS_RNIG1451[0]\ : NOR3B
      port map(A => w_Master_Ready, B => \r_SM_CS[0]_net_1\, C
         => N_38, Y => r_SM_CS_0_sqmuxa);
    
    \r_CS_Inactive_Count_RNO[2]\ : AO1A
      port map(A => N_21, B => G_5_0_a2_0, C => G_14_0_0, Y => 
        N_118);
    
    r_TX_Count_8_G_0_0_a3_0_1 : NOR3B
      port map(A => \r_TX_Count[1]_net_1\, B => int_STM32_TX_DV, 
        C => \r_TX_Count[0]_net_1\, Y => G_0_0_a3_0_1);
    
    \r_SM_CS_RNI1KSF2[1]\ : AO1A
      port map(A => N_21, B => G_5_0_a2_0, C => N_44, Y => 
        r_CS_Inactive_Counte);
    
    \r_TX_Count_RNIDB9G_0[1]\ : NOR2
      port map(A => \r_TX_Count[1]_net_1\, B => 
        \r_TX_Count[0]_net_1\, Y => N_38);
    
    \r_SM_CS_RNO[0]\ : OA1C
      port map(A => G_5_0_a2_0, B => N_21, C => G_11_i_0, Y => 
        \r_SM_CS_RNO_0[0]_net_1\);
    
    r_TX_Count_8_G_0_0 : AO1A
      port map(A => N_21, B => G_0_0_a3_0_1, C => N_36, Y => 
        \DWACT_ADD_CI_0_partial_sum[0]\);
    
    \r_TX_Count[0]\ : DFN1C1
      port map(D => \DWACT_ADD_CI_0_partial_sum[0]\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, Q => \r_TX_Count[0]_net_1\);
    
    \r_CS_Inactive_Count_RNI9NAT[2]\ : OR3
      port map(A => \r_CS_Inactive_Count[1]_net_1\, B => 
        \r_CS_Inactive_Count[2]_net_1\, C => 
        \r_CS_Inactive_Count[0]_net_1\, Y => N_20);
    
    r_TX_Count_8_G_2_0 : NOR3A
      port map(A => \r_TX_Count[1]_net_1\, B => N_30, C => N_35, 
        Y => \r_TX_Count_8[1]\);
    
    r_CS_n : DFN1E1P1
      port map(D => r_CS_n_0_sqmuxa, CLK => i_Clk_c, PRE => 
        i_Rst_L_c, E => un1_r_CS_n_0_sqmuxa, Q => 
        \o_STM32_SPI_CS_n_c\);
    
    \r_SM_CS[1]\ : DFN1C1
      port map(D => \r_SM_CS_RNO_0[1]_net_1\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, Q => \r_SM_CS[1]_net_1\);
    
    SPI_Master_1 : SPI_Master_0_8_32
      port map(int_STM32_TX_Byte(31) => int_STM32_TX_Byte(31), 
        int_STM32_TX_Byte(30) => int_STM32_TX_Byte(30), 
        int_STM32_TX_Byte(29) => int_STM32_TX_Byte(29), 
        int_STM32_TX_Byte(28) => int_STM32_TX_Byte(28), 
        int_STM32_TX_Byte(27) => int_STM32_TX_Byte(27), 
        int_STM32_TX_Byte(26) => int_STM32_TX_Byte(26), 
        int_STM32_TX_Byte(25) => int_STM32_TX_Byte(25), 
        int_STM32_TX_Byte(24) => int_STM32_TX_Byte(24), 
        int_STM32_TX_Byte(23) => int_STM32_TX_Byte(23), 
        int_STM32_TX_Byte(22) => int_STM32_TX_Byte(22), 
        int_STM32_TX_Byte(21) => int_STM32_TX_Byte(21), 
        int_STM32_TX_Byte(20) => int_STM32_TX_Byte(20), 
        int_STM32_TX_Byte(19) => int_STM32_TX_Byte(19), 
        int_STM32_TX_Byte(18) => int_STM32_TX_Byte(18), 
        int_STM32_TX_Byte(17) => int_STM32_TX_Byte(17), 
        int_STM32_TX_Byte(16) => int_STM32_TX_Byte(16), 
        int_STM32_TX_Byte(15) => int_STM32_TX_Byte(15), 
        int_STM32_TX_Byte(14) => int_STM32_TX_Byte(14), 
        int_STM32_TX_Byte(13) => int_STM32_TX_Byte(13), 
        int_STM32_TX_Byte(12) => int_STM32_TX_Byte(12), 
        int_STM32_TX_Byte(11) => int_STM32_TX_Byte(11), 
        int_STM32_TX_Byte(10) => int_STM32_TX_Byte(10), 
        int_STM32_TX_Byte(9) => int_STM32_TX_Byte(9), 
        int_STM32_TX_Byte(8) => int_STM32_TX_Byte(8), 
        int_STM32_TX_Byte(7) => int_STM32_TX_Byte(7), 
        int_STM32_TX_Byte(6) => int_STM32_TX_Byte(6), 
        int_STM32_TX_Byte(5) => int_STM32_TX_Byte(5), 
        int_STM32_TX_Byte(4) => int_STM32_TX_Byte(4), 
        int_STM32_TX_Byte(3) => int_STM32_TX_Byte(3), 
        int_STM32_TX_Byte(2) => int_STM32_TX_Byte(2), 
        int_STM32_TX_Byte(1) => int_STM32_TX_Byte(1), 
        int_STM32_TX_Byte(0) => int_STM32_TX_Byte(0), 
        int_STM32_TX_DV_0 => int_STM32_TX_DV_0, 
        o_STM32_SPI_MOSI_c => o_STM32_SPI_MOSI_c, 
        o_STM32_SPI_Clk_c => o_STM32_SPI_Clk_c, i_Rst_L_c => 
        i_Rst_L_c, i_Clk_c => i_Clk_c, int_STM32_TX_DV => 
        int_STM32_TX_DV, w_Master_Ready => w_Master_Ready);
    
    \r_SM_CS[0]\ : DFN1C1
      port map(D => \r_SM_CS_RNO_0[0]_net_1\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, Q => \r_SM_CS[0]_net_1\);
    
    r_CS_n_RNO_0 : AO1A
      port map(A => N_21, B => G_5_0_a2_0, C => N_30, Y => 
        un1_r_CS_n_0_sqmuxa);
    

end DEF_ARCH; 

library ieee;
use ieee.std_logic_1164.all;
library igloo;
use igloo.all;

entity SPI_Master_0_16_16 is

    port( int_RHD64_TX_Byte    : in    std_logic_vector(15 downto 0);
          io_RX_Byte_Falling   : out   std_logic_vector(15 downto 0);
          io_RX_Byte_Rising    : out   std_logic_vector(15 downto 0);
          int_RHD64_TX_DV_0    : in    std_logic;
          o_RX_DV              : out   std_logic;
          o_RHD64_SPI_MOSI_c   : out   std_logic;
          o_RHD64_SPI_Clk_c    : out   std_logic;
          int_RHD64_TX_DV      : in    std_logic;
          i_RHD64_SPI_MISO_c   : in    std_logic;
          i_RHD64_SPI_MISO_c_0 : in    std_logic;
          w_Master_Ready       : out   std_logic;
          i_Rst_L_c            : in    std_logic;
          i_Clk_c              : in    std_logic;
          o_RX_DV_0            : out   std_logic
        );

end SPI_Master_0_16_16;

architecture DEF_ARCH of SPI_Master_0_16_16 is 

  component OR3
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
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

  component DFN1E1C1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          CLR : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component OR3C
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

  component XAI1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1E0P1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          PRE : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component NOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
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

  component OR3A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component XNOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR2A
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

  component XOR2
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

  component GND
    port( Y : out   std_logic
        );
  end component;

  component NOR2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component VCC
    port( Y : out   std_logic
        );
  end component;

  component OR3B
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

  component AX1
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

  component AX1D
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

  component AX1C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OR2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
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

  component OA1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

    signal N_95, \o_TX_Ready_RNILGCU2\, o_SPI_MOSI_8, 
        o_SPI_MOSI_7, \r_TX_Byte[15]_net_1\, \r_TX_DV\, N_143, 
        \r_TX_Byte[0]_net_1\, \r_TX_Byte[8]_net_1\, 
        \r_TX_Bit_Count[3]_net_1\, N_144, \r_TX_Byte[4]_net_1\, 
        \r_TX_Byte[12]_net_1\, N_145, \r_TX_Bit_Count[2]_net_1\, 
        N_146, \r_TX_Byte[2]_net_1\, \r_TX_Byte[10]_net_1\, N_147, 
        \r_TX_Byte[6]_net_1\, \r_TX_Byte[14]_net_1\, N_148, N_149, 
        \r_TX_Bit_Count[1]_net_1\, N_150, \r_TX_Byte[1]_net_1\, 
        \r_TX_Byte[9]_net_1\, N_151, \r_TX_Byte[5]_net_1\, 
        \r_TX_Byte[13]_net_1\, N_152, N_153, \r_TX_Byte[3]_net_1\, 
        \r_TX_Byte[11]_net_1\, N_154, \r_TX_Byte[7]_net_1\, N_155, 
        N_156, \r_TX_Bit_Count[0]_net_1\, r_RX_Bit_Count_n4_i_0, 
        N_89, \w_Master_Ready\, N_348, N_117, N_368, N_10, N_94, 
        N_118, \r_RX_Bit_Count[4]_net_1\, 
        \r_RX_Bit_Count[0]_net_1\, \r_RX_Bit_Count[1]_net_1\, 
        \r_RX_Bit_Count[2]_net_1\, N_87, N_8, 
        \r_RX_Bit_Count[3]_net_1\, N_29, 
        \io_RX_Byte_Falling[12]_net_1\, N_110, N_49, 
        \io_RX_Byte_Falling[2]_net_1\, N_108, N_61, 
        \io_RX_Byte_Rising[12]_net_1\, N_81, 
        \io_RX_Byte_Rising[2]_net_1\, N_96, N_107, N_111, N_109, 
        N_106, N_105, N_170_i, \r_Leading_Edge\, N_85, 
        \io_RX_Byte_Rising[0]_net_1\, N_83, 
        \io_RX_Byte_Rising[1]_net_1\, N_79, 
        \io_RX_Byte_Rising[3]_net_1\, N_59, 
        \io_RX_Byte_Rising[13]_net_1\, N_57, 
        \io_RX_Byte_Rising[14]_net_1\, N_55, 
        \io_RX_Byte_Rising[15]_net_1\, N_53, 
        \io_RX_Byte_Falling[0]_net_1\, N_51, 
        \io_RX_Byte_Falling[1]_net_1\, N_47, 
        \io_RX_Byte_Falling[3]_net_1\, N_27, 
        \io_RX_Byte_Falling[13]_net_1\, N_25, 
        \io_RX_Byte_Falling[14]_net_1\, 
        \io_RX_Byte_Falling_RNO[15]_net_1\, 
        \io_RX_Byte_Falling[15]_net_1\, N_121, 
        r_SPI_Clk_0_sqmuxa_0_a2_0, N_14, 
        r_SPI_Clk_Edges_19_i_a2_0, \r_SPI_Clk_Edges[0]_net_1\, 
        un2lt5_i_o2_0_0, \r_SPI_Clk_Edges[3]_net_1\, N_23, N_22, 
        r_SPI_Clk_Edges_n3_0_o2_out, \r_SPI_Clk_Edges[1]_net_1\, 
        \r_SPI_Clk_Edges[2]_net_1\, un1_i_tx_dv, 
        r_SPI_Clk_Count_e0, \r_SPI_Clk_Count[0]_net_1\, 
        o_tx_ready14, r_Leading_Edge_1_sqmuxa, 
        \r_SPI_Clk_Count[4]_net_1\, r_Leading_Edge_0_sqmuxa, 
        r_SPI_Clk_Edgese, N_13, \r_SPI_Clk_Count[1]_net_1\, 
        \r_SPI_Clk_Count[2]_net_1\, \r_SPI_Clk_Count[3]_net_1\, 
        N_20_i, N_16, \r_SPI_Clk_Edges[5]_net_1\, N_6, N_333, 
        N_347, N_332, N_341, N_331, N_340, N_330, 
        \r_SPI_Clk_Edges[4]_net_1\, \r_SPI_Clk_RNO\, \r_SPI_Clk\, 
        N_326, N_367, N_327, r_TX_Bit_Count_c1, N_328, 
        r_TX_Bit_Count_15_0, N_17_i, N_18_i, N_19_i, 
        un16_r_leading_edge, N_120, N_325, N_335, N_349, N_33, 
        \io_RX_Byte_Falling[10]_net_1\, N_102, N_35, 
        \io_RX_Byte_Falling[9]_net_1\, N_103, N_65, 
        \io_RX_Byte_Rising[10]_net_1\, N_67, 
        \io_RX_Byte_Rising[9]_net_1\, N_92, N_93, N_98, N_100, 
        N_104, N_101, N_99, N_97, N_77, 
        \io_RX_Byte_Rising[4]_net_1\, N_75, 
        \io_RX_Byte_Rising[5]_net_1\, N_73, 
        \io_RX_Byte_Rising[6]_net_1\, N_71, 
        \io_RX_Byte_Rising[7]_net_1\, N_69, 
        \io_RX_Byte_Rising[8]_net_1\, N_63, 
        \io_RX_Byte_Rising[11]_net_1\, N_45, 
        \io_RX_Byte_Falling[4]_net_1\, N_43, 
        \io_RX_Byte_Falling[5]_net_1\, N_41, 
        \io_RX_Byte_Falling[6]_net_1\, N_39, 
        \io_RX_Byte_Falling[7]_net_1\, N_37, 
        \io_RX_Byte_Falling[8]_net_1\, N_31, 
        \io_RX_Byte_Falling[11]_net_1\, \GND\, \VCC\ : std_logic;

begin 

    io_RX_Byte_Falling(15) <= \io_RX_Byte_Falling[15]_net_1\;
    io_RX_Byte_Falling(14) <= \io_RX_Byte_Falling[14]_net_1\;
    io_RX_Byte_Falling(13) <= \io_RX_Byte_Falling[13]_net_1\;
    io_RX_Byte_Falling(12) <= \io_RX_Byte_Falling[12]_net_1\;
    io_RX_Byte_Falling(11) <= \io_RX_Byte_Falling[11]_net_1\;
    io_RX_Byte_Falling(10) <= \io_RX_Byte_Falling[10]_net_1\;
    io_RX_Byte_Falling(9) <= \io_RX_Byte_Falling[9]_net_1\;
    io_RX_Byte_Falling(8) <= \io_RX_Byte_Falling[8]_net_1\;
    io_RX_Byte_Falling(7) <= \io_RX_Byte_Falling[7]_net_1\;
    io_RX_Byte_Falling(6) <= \io_RX_Byte_Falling[6]_net_1\;
    io_RX_Byte_Falling(5) <= \io_RX_Byte_Falling[5]_net_1\;
    io_RX_Byte_Falling(4) <= \io_RX_Byte_Falling[4]_net_1\;
    io_RX_Byte_Falling(3) <= \io_RX_Byte_Falling[3]_net_1\;
    io_RX_Byte_Falling(2) <= \io_RX_Byte_Falling[2]_net_1\;
    io_RX_Byte_Falling(1) <= \io_RX_Byte_Falling[1]_net_1\;
    io_RX_Byte_Falling(0) <= \io_RX_Byte_Falling[0]_net_1\;
    io_RX_Byte_Rising(15) <= \io_RX_Byte_Rising[15]_net_1\;
    io_RX_Byte_Rising(14) <= \io_RX_Byte_Rising[14]_net_1\;
    io_RX_Byte_Rising(13) <= \io_RX_Byte_Rising[13]_net_1\;
    io_RX_Byte_Rising(12) <= \io_RX_Byte_Rising[12]_net_1\;
    io_RX_Byte_Rising(11) <= \io_RX_Byte_Rising[11]_net_1\;
    io_RX_Byte_Rising(10) <= \io_RX_Byte_Rising[10]_net_1\;
    io_RX_Byte_Rising(9) <= \io_RX_Byte_Rising[9]_net_1\;
    io_RX_Byte_Rising(8) <= \io_RX_Byte_Rising[8]_net_1\;
    io_RX_Byte_Rising(7) <= \io_RX_Byte_Rising[7]_net_1\;
    io_RX_Byte_Rising(6) <= \io_RX_Byte_Rising[6]_net_1\;
    io_RX_Byte_Rising(5) <= \io_RX_Byte_Rising[5]_net_1\;
    io_RX_Byte_Rising(4) <= \io_RX_Byte_Rising[4]_net_1\;
    io_RX_Byte_Rising(3) <= \io_RX_Byte_Rising[3]_net_1\;
    io_RX_Byte_Rising(2) <= \io_RX_Byte_Rising[2]_net_1\;
    io_RX_Byte_Rising(1) <= \io_RX_Byte_Rising[1]_net_1\;
    io_RX_Byte_Rising(0) <= \io_RX_Byte_Rising[0]_net_1\;
    w_Master_Ready <= \w_Master_Ready\;

    \r_RX_Bit_Count_RNIAPGU1_11[2]\ : OR3
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_89, Y => N_110);
    
    \r_SPI_Clk_Count_RNIUBUC3[3]\ : AO1D
      port map(A => N_14, B => N_22, C => int_RHD64_TX_DV, Y => 
        r_SPI_Clk_Edgese);
    
    \io_RX_Byte_Rising[13]\ : DFN1E1C1
      port map(D => N_59, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[13]_net_1\);
    
    \r_TX_Byte[7]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(7), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_RHD64_TX_DV, Q => 
        \r_TX_Byte[7]_net_1\);
    
    \o_RX_DV_0\ : DFN1E1C1
      port map(D => N_95, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \o_TX_Ready_RNILGCU2\, Q => o_RX_DV_0);
    
    \r_SPI_Clk_Count_RNI2ML1[2]\ : OR3C
      port map(A => \r_SPI_Clk_Count[0]_net_1\, B => 
        \r_SPI_Clk_Count[1]_net_1\, C => 
        \r_SPI_Clk_Count[2]_net_1\, Y => N_13);
    
    \io_RX_Byte_Rising[8]\ : DFN1E1C1
      port map(D => N_69, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[8]_net_1\);
    
    \r_SPI_Clk_Edges[2]\ : DFN1E1C1
      port map(D => N_331, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[2]_net_1\);
    
    \r_RX_Bit_Count_RNO_1[4]\ : OR2A
      port map(A => N_89, B => \w_Master_Ready\, Y => 
        r_RX_Bit_Count_n4_i_0);
    
    \r_RX_Bit_Count_RNIAPGU1_12[2]\ : OR3
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_92, Y => N_104);
    
    \r_TX_Bit_Count_RNO[2]\ : XAI1
      port map(A => r_TX_Bit_Count_c1, B => 
        \r_TX_Bit_Count[2]_net_1\, C => N_367, Y => N_327);
    
    \r_RX_Bit_Count_RNINE8V_0[3]\ : OR2A
      port map(A => \r_RX_Bit_Count[4]_net_1\, B => 
        \r_RX_Bit_Count[3]_net_1\, Y => N_92);
    
    \r_RX_Bit_Count[4]\ : DFN1E0P1
      port map(D => N_348, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_121, Q => \r_RX_Bit_Count[4]_net_1\);
    
    r_TX_DV_RNI2SCA : NOR2
      port map(A => \w_Master_Ready\, B => \r_TX_DV\, Y => N_367);
    
    \io_RX_Byte_Falling_RNO[2]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Falling[2]_net_1\, S => N_108, Y => N_49);
    
    o_SPI_MOSI_RNO_11 : MX2
      port map(A => \r_TX_Byte[6]_net_1\, B => 
        \r_TX_Byte[14]_net_1\, S => \r_TX_Bit_Count[3]_net_1\, Y
         => N_147);
    
    \r_TX_Bit_Count[0]\ : DFN1E0P1
      port map(D => N_325, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_120, Q => \r_TX_Bit_Count[0]_net_1\);
    
    \io_RX_Byte_Rising_RNO[10]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Rising[10]_net_1\, S => N_102, Y => N_65);
    
    \r_RX_Bit_Count_RNIAPGU1_8[2]\ : OR3A
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_93, Y => N_99);
    
    \r_RX_Bit_Count_RNINE8V_2[3]\ : OR2
      port map(A => \r_RX_Bit_Count[3]_net_1\, B => 
        \r_RX_Bit_Count[4]_net_1\, Y => N_87);
    
    \r_SPI_Clk_Edges[5]\ : DFN1E1C1
      port map(D => N_6, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[5]_net_1\);
    
    \o_RX_DV\ : DFN1E1C1
      port map(D => N_95, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \o_TX_Ready_RNILGCU2\, Q => o_RX_DV);
    
    \io_RX_Byte_Falling[10]\ : DFN1E1C1
      port map(D => N_33, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[10]_net_1\);
    
    \r_TX_Byte[0]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(0), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[0]_net_1\);
    
    \io_RX_Byte_Rising_RNO[1]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Rising[1]_net_1\, S => N_106, Y => N_83);
    
    \io_RX_Byte_Rising_RNO[11]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Rising[11]_net_1\, S => N_101, Y => N_63);
    
    \io_RX_Byte_Falling[0]\ : DFN1E1C1
      port map(D => N_53, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[0]_net_1\);
    
    \io_RX_Byte_Rising[15]\ : DFN1E1C1
      port map(D => N_55, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[15]_net_1\);
    
    \io_RX_Byte_Falling_RNO[6]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Falling[6]_net_1\, S => N_98, Y => N_41);
    
    \io_RX_Byte_Rising_RNO[12]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Rising[12]_net_1\, S => N_110, Y => N_61);
    
    \r_SPI_Clk_Count_RNO[4]\ : XNOR2
      port map(A => N_14, B => \r_SPI_Clk_Count[4]_net_1\, Y => 
        N_20_i);
    
    \r_RX_Bit_Count[1]\ : DFN1E0P1
      port map(D => N_349, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_121, Q => \r_RX_Bit_Count[1]_net_1\);
    
    r_Leading_Edge_RNIM0RA : OR2
      port map(A => N_170_i, B => \r_Leading_Edge\, Y => N_95);
    
    \io_RX_Byte_Rising_RNO[0]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Rising[0]_net_1\, S => N_96, Y => N_85);
    
    \io_RX_Byte_Rising[10]\ : DFN1E1C1
      port map(D => N_65, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[10]_net_1\);
    
    \io_RX_Byte_Falling[8]\ : DFN1E1C1
      port map(D => N_37, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[8]_net_1\);
    
    \io_RX_Byte_Rising[6]\ : DFN1E1C1
      port map(D => N_73, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[6]_net_1\);
    
    \io_RX_Byte_Falling[2]\ : DFN1E1C1
      port map(D => N_49, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[2]_net_1\);
    
    \r_RX_Bit_Count_RNIAPGU1_10[2]\ : OR3A
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_87, Y => N_106);
    
    \r_TX_Bit_Count_RNO_0[3]\ : OR2
      port map(A => \r_TX_Bit_Count[2]_net_1\, B => 
        r_TX_Bit_Count_c1, Y => r_TX_Bit_Count_15_0);
    
    o_SPI_MOSI_RNO_7 : MX2
      port map(A => N_153, B => N_154, S => 
        \r_TX_Bit_Count[2]_net_1\, Y => N_155);
    
    \io_RX_Byte_Falling_RNO[7]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Falling[7]_net_1\, S => N_97, Y => N_39);
    
    o_SPI_MOSI_RNO : MX2
      port map(A => o_SPI_MOSI_7, B => \r_TX_Byte[15]_net_1\, S
         => \r_TX_DV\, Y => o_SPI_MOSI_8);
    
    \io_RX_Byte_Falling_RNO[11]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Falling[11]_net_1\, S => N_101, Y => N_31);
    
    \r_SPI_Clk_Edges[0]\ : DFN1E1C1
      port map(D => N_23, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[0]_net_1\);
    
    \io_RX_Byte_Falling_RNO[9]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Falling[9]_net_1\, S => N_103, Y => N_35);
    
    o_SPI_MOSI_RNO_15 : MX2
      port map(A => \r_TX_Byte[7]_net_1\, B => 
        \r_TX_Byte[15]_net_1\, S => \r_TX_Bit_Count[3]_net_1\, Y
         => N_154);
    
    o_TX_Ready_RNO : NOR2A
      port map(A => N_22, B => int_RHD64_TX_DV, Y => un1_i_tx_dv);
    
    \io_RX_Byte_Rising_RNO[3]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Rising[3]_net_1\, S => N_111, Y => N_79);
    
    \io_RX_Byte_Falling_RNO[0]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Falling[0]_net_1\, S => N_96, Y => N_53);
    
    o_SPI_MOSI_RNO_12 : MX2
      port map(A => \r_TX_Byte[1]_net_1\, B => 
        \r_TX_Byte[9]_net_1\, S => \r_TX_Bit_Count[3]_net_1\, Y
         => N_150);
    
    r_Leading_Edge : DFN1C1
      port map(D => r_Leading_Edge_1_sqmuxa, CLK => i_Clk_c, CLR
         => i_Rst_L_c, Q => \r_Leading_Edge\);
    
    \r_TX_Byte[8]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(8), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_RHD64_TX_DV, Q => 
        \r_TX_Byte[8]_net_1\);
    
    \io_RX_Byte_Falling[1]\ : DFN1E1C1
      port map(D => N_51, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[1]_net_1\);
    
    \r_RX_Bit_Count_RNI2T4E2[0]\ : NOR2
      port map(A => N_87, B => N_94, Y => N_368);
    
    \r_SPI_Clk_Count_RNO[1]\ : XOR2
      port map(A => \r_SPI_Clk_Count[1]_net_1\, B => 
        \r_SPI_Clk_Count[0]_net_1\, Y => N_17_i);
    
    \io_RX_Byte_Falling_RNO[14]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Falling[14]_net_1\, S => N_107, Y => N_25);
    
    \r_TX_Bit_Count_RNO[0]\ : MX2B
      port map(A => \w_Master_Ready\, B => 
        \r_TX_Bit_Count[0]_net_1\, S => N_367, Y => N_325);
    
    GND_i : GND
      port map(Y => \GND\);
    
    \r_TX_Bit_Count_RNO[1]\ : XAI1
      port map(A => \r_TX_Bit_Count[0]_net_1\, B => 
        \r_TX_Bit_Count[1]_net_1\, C => N_367, Y => N_326);
    
    \r_RX_Bit_Count_RNIAPGU1_4[2]\ : OR3A
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_89, Y => N_105);
    
    o_SPI_MOSI : DFN1E1C1
      port map(D => o_SPI_MOSI_8, CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => un16_r_leading_edge, Q => 
        o_RHD64_SPI_MOSI_c);
    
    \r_SPI_Clk_Count[4]\ : DFN1E1C1
      port map(D => N_20_i, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => o_tx_ready14, Q => \r_SPI_Clk_Count[4]_net_1\);
    
    \r_TX_Byte[9]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(9), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_RHD64_TX_DV, Q => 
        \r_TX_Byte[9]_net_1\);
    
    \r_RX_Bit_Count_RNO_0[4]\ : NOR2B
      port map(A => N_94, B => \r_RX_Bit_Count[4]_net_1\, Y => 
        N_117);
    
    \r_RX_Bit_Count_RNO[2]\ : OR3A
      port map(A => N_94, B => N_118, C => \w_Master_Ready\, Y
         => N_10);
    
    \r_TX_Bit_Count[3]\ : DFN1E0P1
      port map(D => N_328, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_120, Q => \r_TX_Bit_Count[3]_net_1\);
    
    \r_RX_Bit_Count_RNIAPGU1_9[2]\ : OR3A
      port map(A => \r_RX_Bit_Count[2]_net_1\, B => 
        \r_RX_Bit_Count[1]_net_1\, C => N_87, Y => N_108);
    
    \io_RX_Byte_Rising_RNO[13]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Rising[13]_net_1\, S => N_105, Y => N_59);
    
    \r_RX_Bit_Count_RNIAPGU1_14[2]\ : OR3
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_87, Y => N_96);
    
    \io_RX_Byte_Rising[11]\ : DFN1E1C1
      port map(D => N_63, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[11]_net_1\);
    
    \io_RX_Byte_Rising[9]\ : DFN1E1C1
      port map(D => N_67, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[9]_net_1\);
    
    \r_RX_Bit_Count_RNIAPGU1_6[2]\ : OR3A
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_92, Y => N_103);
    
    o_SPI_MOSI_RNO_6 : MX2
      port map(A => N_150, B => N_151, S => 
        \r_TX_Bit_Count[2]_net_1\, Y => N_152);
    
    \io_RX_Byte_Rising_RNO[8]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Rising[8]_net_1\, S => N_104, Y => N_69);
    
    \io_RX_Byte_Falling[14]\ : DFN1E1C1
      port map(D => N_25, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[14]_net_1\);
    
    \io_RX_Byte_Falling[9]\ : DFN1E1C1
      port map(D => N_35, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[9]_net_1\);
    
    VCC_i : VCC
      port map(Y => \VCC\);
    
    \io_RX_Byte_Falling[11]\ : DFN1E1C1
      port map(D => N_31, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[11]_net_1\);
    
    \r_RX_Bit_Count_RNIAPGU1_1[2]\ : OR3B
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_93, Y => N_97);
    
    \io_RX_Byte_Falling[4]\ : DFN1E1C1
      port map(D => N_45, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[4]_net_1\);
    
    \r_RX_Bit_Count[2]\ : DFN1E0P1
      port map(D => N_10, CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        N_121, Q => \r_RX_Bit_Count[2]_net_1\);
    
    \io_RX_Byte_Falling_RNO[5]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Falling[5]_net_1\, S => N_99, Y => N_43);
    
    \r_SPI_Clk_Edges_RNO_0[2]\ : OR2
      port map(A => \r_SPI_Clk_Edges[1]_net_1\, B => 
        \r_SPI_Clk_Edges[0]_net_1\, Y => N_340);
    
    \r_SPI_Clk_Edges_RNO[3]\ : XA1A
      port map(A => \r_SPI_Clk_Edges[3]_net_1\, B => N_341, C => 
        o_tx_ready14, Y => N_332);
    
    o_SPI_Clk : DFN1C1
      port map(D => \r_SPI_Clk\, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        Q => o_RHD64_SPI_Clk_c);
    
    \io_RX_Byte_Rising_RNO[4]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Rising[4]_net_1\, S => N_100, Y => N_77);
    
    r_TX_DV : DFN1C1
      port map(D => int_RHD64_TX_DV, CLK => i_Clk_c, CLR => 
        i_Rst_L_c, Q => \r_TX_DV\);
    
    r_SPI_Clk_RNO : AX1
      port map(A => N_22, B => r_SPI_Clk_0_sqmuxa_0_a2_0, C => 
        \r_SPI_Clk\, Y => \r_SPI_Clk_RNO\);
    
    \r_SPI_Clk_Edges_RNIBMPU[2]\ : OR2
      port map(A => \r_SPI_Clk_Edges[1]_net_1\, B => 
        \r_SPI_Clk_Edges[2]_net_1\, Y => 
        r_SPI_Clk_Edges_n3_0_o2_out);
    
    \io_RX_Byte_Rising[14]\ : DFN1E1C1
      port map(D => N_57, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[14]_net_1\);
    
    \r_SPI_Clk_Edges[4]\ : DFN1E1C1
      port map(D => N_333, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[4]_net_1\);
    
    \r_RX_Bit_Count_RNIAPGU1_7[2]\ : OR3A
      port map(A => \r_RX_Bit_Count[2]_net_1\, B => 
        \r_RX_Bit_Count[1]_net_1\, C => N_93, Y => N_98);
    
    \io_RX_Byte_Falling[6]\ : DFN1E1C1
      port map(D => N_41, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[6]_net_1\);
    
    \r_SPI_Clk_Count[3]\ : DFN1E1C1
      port map(D => N_19_i, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => o_tx_ready14, Q => \r_SPI_Clk_Count[3]_net_1\);
    
    \r_TX_Byte[11]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(11), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[11]_net_1\);
    
    \io_RX_Byte_Falling_RNO[13]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Falling[13]_net_1\, S => N_105, Y => N_27);
    
    \r_SPI_Clk_Edges[3]\ : DFN1E1C1
      port map(D => N_332, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[3]_net_1\);
    
    \r_RX_Bit_Count_RNO[0]\ : OR2A
      port map(A => \r_RX_Bit_Count[0]_net_1\, B => 
        \w_Master_Ready\, Y => N_335);
    
    \io_RX_Byte_Rising_RNO[2]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Rising[2]_net_1\, S => N_108, Y => N_81);
    
    o_SPI_MOSI_RNO_1 : MX2
      port map(A => N_149, B => N_156, S => 
        \r_TX_Bit_Count[0]_net_1\, Y => o_SPI_MOSI_7);
    
    \r_SPI_Clk_Edges_RNIBMPU[3]\ : OR2
      port map(A => \r_SPI_Clk_Edges[3]_net_1\, B => 
        \r_SPI_Clk_Edges[0]_net_1\, Y => un2lt5_i_o2_0_0);
    
    \r_TX_Byte[10]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(10), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[10]_net_1\);
    
    \r_RX_Bit_Count_RNO[1]\ : XO1A
      port map(A => \r_RX_Bit_Count[0]_net_1\, B => 
        \r_RX_Bit_Count[1]_net_1\, C => \w_Master_Ready\, Y => 
        N_349);
    
    \io_RX_Byte_Rising[2]\ : DFN1E1C1
      port map(D => N_81, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[2]_net_1\);
    
    \r_RX_Bit_Count_RNIBESE1[0]\ : OR3
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => \r_RX_Bit_Count[0]_net_1\, 
        Y => N_94);
    
    \r_TX_Byte[3]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(3), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[3]_net_1\);
    
    \io_RX_Byte_Rising_RNO[15]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Rising[15]_net_1\, S => N_109, Y => N_55);
    
    \r_TX_Byte[14]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(14), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[14]_net_1\);
    
    \r_SPI_Clk_Count_RNO[0]\ : XOR2
      port map(A => \r_SPI_Clk_Count[0]_net_1\, B => o_tx_ready14, 
        Y => r_SPI_Clk_Count_e0);
    
    \r_SPI_Clk_Edges_RNO_0[4]\ : AX1D
      port map(A => r_SPI_Clk_Edges_n3_0_o2_out, B => 
        un2lt5_i_o2_0_0, C => \r_SPI_Clk_Edges[4]_net_1\, Y => 
        N_347);
    
    \io_RX_Byte_Rising[7]\ : DFN1E1C1
      port map(D => N_71, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[7]_net_1\);
    
    \io_RX_Byte_Falling_RNO[8]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Falling[8]_net_1\, S => N_104, Y => N_37);
    
    o_SPI_MOSI_RNO_14 : MX2
      port map(A => \r_TX_Byte[3]_net_1\, B => 
        \r_TX_Byte[11]_net_1\, S => \r_TX_Bit_Count[3]_net_1\, Y
         => N_153);
    
    \io_RX_Byte_Falling_RNO[1]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Falling[1]_net_1\, S => N_106, Y => N_51);
    
    \r_SPI_Clk_Count_RNO[3]\ : XNOR2
      port map(A => N_13, B => \r_SPI_Clk_Count[3]_net_1\, Y => 
        N_19_i);
    
    \r_SPI_Clk_Edges_RNO[4]\ : NOR2A
      port map(A => o_tx_ready14, B => N_347, Y => N_333);
    
    o_SPI_MOSI_RNO_0 : OR2
      port map(A => N_170_i, B => \r_TX_DV\, Y => 
        un16_r_leading_edge);
    
    \r_SPI_Clk_Edges_RNO[1]\ : XA1A
      port map(A => \r_SPI_Clk_Edges[0]_net_1\, B => 
        \r_SPI_Clk_Edges[1]_net_1\, C => o_tx_ready14, Y => N_330);
    
    \r_SPI_Clk_Count[0]\ : DFN1C1
      port map(D => r_SPI_Clk_Count_e0, CLK => i_Clk_c, CLR => 
        i_Rst_L_c, Q => \r_SPI_Clk_Count[0]_net_1\);
    
    \r_TX_Bit_Count[1]\ : DFN1E0P1
      port map(D => N_326, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_120, Q => \r_TX_Bit_Count[1]_net_1\);
    
    \r_SPI_Clk_Edges_RNO[0]\ : NOR2A
      port map(A => r_SPI_Clk_Edges_19_i_a2_0, B => N_22, Y => 
        N_23);
    
    r_Trailing_Edge : DFN1C1
      port map(D => r_Leading_Edge_0_sqmuxa, CLK => i_Clk_c, CLR
         => i_Rst_L_c, Q => N_170_i);
    
    \io_RX_Byte_Falling[13]\ : DFN1E1C1
      port map(D => N_27, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[13]_net_1\);
    
    r_SPI_Clk : DFN1C1
      port map(D => \r_SPI_Clk_RNO\, CLK => i_Clk_c, CLR => 
        i_Rst_L_c, Q => \r_SPI_Clk\);
    
    \r_TX_Byte[2]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(2), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[2]_net_1\);
    
    o_SPI_MOSI_RNO_10 : MX2
      port map(A => \r_TX_Byte[2]_net_1\, B => 
        \r_TX_Byte[10]_net_1\, S => \r_TX_Bit_Count[3]_net_1\, Y
         => N_146);
    
    \r_SPI_Clk_Edges[1]\ : DFN1E1C1
      port map(D => N_330, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => r_SPI_Clk_Edgese, Q => \r_SPI_Clk_Edges[1]_net_1\);
    
    \r_SPI_Clk_Edges_RNO_0[0]\ : NOR2
      port map(A => \r_SPI_Clk_Edges[0]_net_1\, B => 
        int_RHD64_TX_DV, Y => r_SPI_Clk_Edges_19_i_a2_0);
    
    \r_RX_Bit_Count_RNIAPGU1_3[2]\ : OR3A
      port map(A => \r_RX_Bit_Count[2]_net_1\, B => 
        \r_RX_Bit_Count[1]_net_1\, C => N_89, Y => N_107);
    
    o_SPI_MOSI_RNO_2 : MX2
      port map(A => N_145, B => N_148, S => 
        \r_TX_Bit_Count[1]_net_1\, Y => N_149);
    
    \io_RX_Byte_Rising[3]\ : DFN1E1C1
      port map(D => N_79, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[3]_net_1\);
    
    \r_RX_Bit_Count_RNIAPGU1[2]\ : OR3B
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_89, Y => N_109);
    
    \io_RX_Byte_Rising_RNO[6]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Rising[6]_net_1\, S => N_98, Y => N_73);
    
    \r_SPI_Clk_Edges_RNO_0[3]\ : OR2
      port map(A => \r_SPI_Clk_Edges[0]_net_1\, B => 
        r_SPI_Clk_Edges_n3_0_o2_out, Y => N_341);
    
    \io_RX_Byte_Falling_RNO[4]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Falling[4]_net_1\, S => N_100, Y => N_45);
    
    \r_SPI_Clk_Count[2]\ : DFN1E1C1
      port map(D => N_18_i, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => o_tx_ready14, Q => \r_SPI_Clk_Count[2]_net_1\);
    
    o_SPI_MOSI_RNO_4 : MX2
      port map(A => N_143, B => N_144, S => 
        \r_TX_Bit_Count[2]_net_1\, Y => N_145);
    
    \io_RX_Byte_Rising_RNO[7]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Rising[7]_net_1\, S => N_97, Y => N_71);
    
    \io_RX_Byte_Falling_RNO[3]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Falling[3]_net_1\, S => N_111, Y => N_47);
    
    \io_RX_Byte_Rising_RNO[14]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Rising[14]_net_1\, S => N_107, Y => N_57);
    
    \r_SPI_Clk_Edges_RNO[2]\ : XA1A
      port map(A => \r_SPI_Clk_Edges[2]_net_1\, B => N_340, C => 
        o_tx_ready14, Y => N_331);
    
    \r_TX_Byte[5]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(5), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[5]_net_1\);
    
    \io_RX_Byte_Rising_RNO[9]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Rising[9]_net_1\, S => N_103, Y => N_67);
    
    r_Leading_Edge_RNO : NOR3A
      port map(A => r_SPI_Clk_0_sqmuxa_0_a2_0, B => N_22, C => 
        \r_SPI_Clk_Count[4]_net_1\, Y => r_Leading_Edge_1_sqmuxa);
    
    \r_TX_Bit_Count_RNO[3]\ : XAI1
      port map(A => r_TX_Bit_Count_15_0, B => 
        \r_TX_Bit_Count[3]_net_1\, C => N_367, Y => N_328);
    
    \r_SPI_Clk_Edges_RNIEA0D2[4]\ : OR3
      port map(A => r_SPI_Clk_Edges_n3_0_o2_out, B => 
        un2lt5_i_o2_0_0, C => \r_SPI_Clk_Edges[4]_net_1\, Y => 
        N_16);
    
    \r_RX_Bit_Count[0]\ : DFN1E0P1
      port map(D => N_335, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_121, Q => \r_RX_Bit_Count[0]_net_1\);
    
    r_Trailing_Edge_RNIG72E : NOR2A
      port map(A => N_367, B => N_170_i, Y => N_120);
    
    o_TX_Ready_RNILGCU2 : MX2
      port map(A => \w_Master_Ready\, B => N_368, S => N_95, Y
         => \o_TX_Ready_RNILGCU2\);
    
    \r_TX_Byte[6]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(6), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[6]_net_1\);
    
    o_SPI_MOSI_RNO_9 : MX2
      port map(A => \r_TX_Byte[4]_net_1\, B => 
        \r_TX_Byte[12]_net_1\, S => \r_TX_Bit_Count[3]_net_1\, Y
         => N_144);
    
    \r_SPI_Clk_Count[1]\ : DFN1E1C1
      port map(D => N_17_i, CLK => i_Clk_c, CLR => i_Rst_L_c, E
         => o_tx_ready14, Q => \r_SPI_Clk_Count[1]_net_1\);
    
    \io_RX_Byte_Falling_RNO[10]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Falling[10]_net_1\, S => N_102, Y => N_33);
    
    \io_RX_Byte_Rising[5]\ : DFN1E1C1
      port map(D => N_75, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[5]_net_1\);
    
    \r_SPI_Clk_Count_RNO[2]\ : AX1C
      port map(A => \r_SPI_Clk_Count[0]_net_1\, B => 
        \r_SPI_Clk_Count[1]_net_1\, C => 
        \r_SPI_Clk_Count[2]_net_1\, Y => N_18_i);
    
    \r_RX_Bit_Count_RNINE8V_1[3]\ : OR2A
      port map(A => \r_RX_Bit_Count[3]_net_1\, B => 
        \r_RX_Bit_Count[4]_net_1\, Y => N_93);
    
    \r_TX_Byte[12]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(12), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[12]_net_1\);
    
    \r_TX_Bit_Count_RNIL0MQ[0]\ : OR2
      port map(A => \r_TX_Bit_Count[1]_net_1\, B => 
        \r_TX_Bit_Count[0]_net_1\, Y => r_TX_Bit_Count_c1);
    
    o_TX_Ready : DFN1C1
      port map(D => un1_i_tx_dv, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        Q => \w_Master_Ready\);
    
    \r_TX_Bit_Count[2]\ : DFN1E0P1
      port map(D => N_327, CLK => i_Clk_c, PRE => i_Rst_L_c, E
         => N_120, Q => \r_TX_Bit_Count[2]_net_1\);
    
    \io_RX_Byte_Falling_RNO[12]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Falling[12]_net_1\, S => N_110, Y => N_29);
    
    \io_RX_Byte_Falling[3]\ : DFN1E1C1
      port map(D => N_47, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[3]_net_1\);
    
    \io_RX_Byte_Falling[15]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling_RNO[15]_net_1\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => N_170_i, Q => 
        \io_RX_Byte_Falling[15]_net_1\);
    
    \io_RX_Byte_Falling[7]\ : DFN1E1C1
      port map(D => N_39, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[7]_net_1\);
    
    \r_TX_Byte[13]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(13), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[13]_net_1\);
    
    o_SPI_MOSI_RNO_5 : MX2
      port map(A => N_146, B => N_147, S => 
        \r_TX_Bit_Count[2]_net_1\, Y => N_148);
    
    \io_RX_Byte_Rising[4]\ : DFN1E1C1
      port map(D => N_77, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[4]_net_1\);
    
    \r_RX_Bit_Count_RNINE8V[3]\ : OR2B
      port map(A => \r_RX_Bit_Count[3]_net_1\, B => 
        \r_RX_Bit_Count[4]_net_1\, Y => N_89);
    
    \r_TX_Byte[1]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(1), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[1]_net_1\);
    
    \r_SPI_Clk_Edges_RNO[5]\ : XAI1
      port map(A => \r_SPI_Clk_Edges[5]_net_1\, B => N_16, C => 
        o_tx_ready14, Y => N_6);
    
    \r_RX_Bit_Count_RNIAPGU1_2[2]\ : OR3B
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_87, Y => N_111);
    
    r_Trailing_Edge_RNO : NOR3B
      port map(A => r_SPI_Clk_0_sqmuxa_0_a2_0, B => 
        \r_SPI_Clk_Count[4]_net_1\, C => N_22, Y => 
        r_Leading_Edge_0_sqmuxa);
    
    \r_RX_Bit_Count_RNIAPGU1_5[2]\ : OR3A
      port map(A => \r_RX_Bit_Count[2]_net_1\, B => 
        \r_RX_Bit_Count[1]_net_1\, C => N_92, Y => N_102);
    
    o_SPI_MOSI_RNO_3 : MX2
      port map(A => N_152, B => N_155, S => 
        \r_TX_Bit_Count[1]_net_1\, Y => N_156);
    
    \io_RX_Byte_Rising[1]\ : DFN1E1C1
      port map(D => N_83, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[1]_net_1\);
    
    \io_RX_Byte_Falling_RNO[15]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c_0, B => 
        \io_RX_Byte_Falling[15]_net_1\, S => N_109, Y => 
        \io_RX_Byte_Falling_RNO[15]_net_1\);
    
    o_TX_Ready_RNIJJ7G : NOR2
      port map(A => N_95, B => \w_Master_Ready\, Y => N_121);
    
    o_SPI_MOSI_RNO_13 : MX2
      port map(A => \r_TX_Byte[5]_net_1\, B => 
        \r_TX_Byte[13]_net_1\, S => \r_TX_Bit_Count[3]_net_1\, Y
         => N_151);
    
    \r_RX_Bit_Count_RNO_0[2]\ : OA1
      port map(A => \r_RX_Bit_Count[0]_net_1\, B => 
        \r_RX_Bit_Count[1]_net_1\, C => \r_RX_Bit_Count[2]_net_1\, 
        Y => N_118);
    
    \r_TX_Byte[4]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(4), CLK => i_Clk_c, CLR => 
        i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[4]_net_1\);
    
    \r_SPI_Clk_Edges_RNI79DS2[5]\ : NOR2
      port map(A => N_16, B => \r_SPI_Clk_Edges[5]_net_1\, Y => 
        N_22);
    
    \io_RX_Byte_Falling[12]\ : DFN1E1C1
      port map(D => N_29, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[12]_net_1\);
    
    \io_RX_Byte_Falling[5]\ : DFN1E1C1
      port map(D => N_43, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_170_i, Q => \io_RX_Byte_Falling[5]_net_1\);
    
    \r_RX_Bit_Count[3]\ : DFN1E0P1
      port map(D => N_8, CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        N_121, Q => \r_RX_Bit_Count[3]_net_1\);
    
    \io_RX_Byte_Rising[0]\ : DFN1E1C1
      port map(D => N_85, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[0]_net_1\);
    
    \r_SPI_Clk_Count_RNIQK72[3]\ : OR2A
      port map(A => \r_SPI_Clk_Count[3]_net_1\, B => N_13, Y => 
        N_14);
    
    \r_SPI_Clk_Edges_RNI4NMA3[5]\ : NOR2
      port map(A => int_RHD64_TX_DV, B => N_22, Y => o_tx_ready14);
    
    \r_TX_Byte[15]\ : DFN1E1C1
      port map(D => int_RHD64_TX_Byte(15), CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => int_RHD64_TX_DV_0, Q => 
        \r_TX_Byte[15]_net_1\);
    
    \r_RX_Bit_Count_RNO[3]\ : XO1A
      port map(A => \r_RX_Bit_Count[3]_net_1\, B => N_94, C => 
        \w_Master_Ready\, Y => N_8);
    
    \r_RX_Bit_Count_RNO[4]\ : OR3
      port map(A => N_117, B => r_RX_Bit_Count_n4_i_0, C => N_368, 
        Y => N_348);
    
    \r_RX_Bit_Count_RNIAPGU1_13[2]\ : OR3
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_93, Y => N_100);
    
    \io_RX_Byte_Rising[12]\ : DFN1E1C1
      port map(D => N_61, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        \r_Leading_Edge\, Q => \io_RX_Byte_Rising[12]_net_1\);
    
    \io_RX_Byte_Rising_RNO[5]\ : MX2
      port map(A => i_RHD64_SPI_MISO_c, B => 
        \io_RX_Byte_Rising[5]_net_1\, S => N_99, Y => N_75);
    
    \r_RX_Bit_Count_RNIAPGU1_0[2]\ : OR3B
      port map(A => \r_RX_Bit_Count[1]_net_1\, B => 
        \r_RX_Bit_Count[2]_net_1\, C => N_92, Y => N_101);
    
    \r_SPI_Clk_Count_RNIN2HG[3]\ : NOR2
      port map(A => int_RHD64_TX_DV, B => N_14, Y => 
        r_SPI_Clk_0_sqmuxa_0_a2_0);
    
    o_SPI_MOSI_RNO_8 : MX2
      port map(A => \r_TX_Byte[0]_net_1\, B => 
        \r_TX_Byte[8]_net_1\, S => \r_TX_Bit_Count[3]_net_1\, Y
         => N_143);
    

end DEF_ARCH; 

library ieee;
use ieee.std_logic_1164.all;
library igloo;
use igloo.all;

entity SPI_Master_CS_0_16_16_16 is

    port( io_RX_Byte_Rising    : out   std_logic_vector(15 downto 0);
          io_RX_Byte_Falling   : out   std_logic_vector(15 downto 0);
          int_RHD64_TX_Byte    : in    std_logic_vector(15 downto 0);
          o_RX_DV_0            : out   std_logic;
          i_RHD64_SPI_MISO_c_0 : in    std_logic;
          i_RHD64_SPI_MISO_c   : in    std_logic;
          o_RHD64_SPI_Clk_c    : out   std_logic;
          o_RHD64_SPI_MOSI_c   : out   std_logic;
          o_RX_DV              : out   std_logic;
          int_RHD64_TX_DV_0    : in    std_logic;
          i_Rst_L_c            : in    std_logic;
          i_Clk_c              : in    std_logic;
          o_RHD64_SPI_CS_n_c   : out   std_logic;
          int_RHD64_TX_DV      : in    std_logic;
          o_RHD64_TX_Ready_i_1 : out   std_logic
        );

end SPI_Master_CS_0_16_16_16;

architecture DEF_ARCH of SPI_Master_CS_0_16_16_16 is 

  component OR3A
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

  component NOR2A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
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

  component VCC
    port( Y : out   std_logic
        );
  end component;

  component NOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component MX2C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          S : in    std_logic := 'U';
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

  component OR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
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

  component XA1C
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

  component OR2A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AND2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1E0P1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          PRE : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component AX1D
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
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

  component OR2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component GND
    port( Y : out   std_logic
        );
  end component;

  component XO1A
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

  component MX2A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          S : in    std_logic := 'U';
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

  component SPI_Master_0_16_16
    port( int_RHD64_TX_Byte    : in    std_logic_vector(15 downto 0) := (others => 'U');
          io_RX_Byte_Falling   : out   std_logic_vector(15 downto 0);
          io_RX_Byte_Rising    : out   std_logic_vector(15 downto 0);
          int_RHD64_TX_DV_0    : in    std_logic := 'U';
          o_RX_DV              : out   std_logic;
          o_RHD64_SPI_MOSI_c   : out   std_logic;
          o_RHD64_SPI_Clk_c    : out   std_logic;
          int_RHD64_TX_DV      : in    std_logic := 'U';
          i_RHD64_SPI_MISO_c   : in    std_logic := 'U';
          i_RHD64_SPI_MISO_c_0 : in    std_logic := 'U';
          w_Master_Ready       : out   std_logic;
          i_Rst_L_c            : in    std_logic := 'U';
          i_Clk_c              : in    std_logic := 'U';
          o_RX_DV_0            : out   std_logic
        );
  end component;

  component AO1A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OA1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

    signal \r_SM_CS_RNO[0]_net_1\, \r_SM_CS_RNIJM951[0]_net_1\, 
        \r_SM_CS[1]_net_1\, N_30, N_37, N_29, N_34_i, 
        \r_CS_Inactive_Count[1]_net_1\, 
        \r_CS_Inactive_Count[0]_net_1\, 
        \r_CS_Inactive_Count[2]_net_1\, N_33_i, N_32, N_27, 
        \r_CS_Inactive_Count[3]_net_1\, \r_SM_CS[0]_net_1\, 
        w_Master_Ready, \r_TX_Count[0]_net_1\, 
        \r_TX_Count[1]_net_1\, N_23, N_48, \r_SM_CS_RNO[1]_net_1\, 
        \r_CS_Inactive_Count_RNO[1]_net_1\, 
        \r_CS_Inactive_Count_RNO[2]_net_1\, 
        \r_CS_Inactive_Count_RNO[3]_net_1\, N_4, 
        \r_CS_Inactive_Count[4]_net_1\, N_44, N_39, N_24, N_58, 
        \un1_r_TX_Count_0_sqmuxa_i_0[3]\, \o_RHD64_SPI_CS_n_c\, 
        N_22, N_47, N_18, \r_TX_Count_RNI4VRS1[1]_net_1\, N_66, 
        N_28, \r_TX_Count_RNI3URS1[0]_net_1\, 
        \DWACT_ADD_CI_0_partial_sum[0]\, \r_TX_Count_8[1]\, 
        \DWACT_ADD_CI_0_partial_sum[1]\, \DWACT_ADD_CI_0_TMP[0]\, 
        \GND\, \VCC\ : std_logic;

    for all : SPI_Master_0_16_16
	Use entity work.SPI_Master_0_16_16(DEF_ARCH);
begin 

    o_RHD64_SPI_CS_n_c <= \o_RHD64_SPI_CS_n_c\;

    \r_TX_Count_RNICOM41[0]\ : OR3A
      port map(A => w_Master_Ready, B => \r_TX_Count[0]_net_1\, C
         => \r_TX_Count[1]_net_1\, Y => N_29);
    
    \r_CS_Inactive_Count_RNO_0[1]\ : XOR2
      port map(A => \r_CS_Inactive_Count[1]_net_1\, B => 
        \r_CS_Inactive_Count[0]_net_1\, Y => N_33_i);
    
    r_TX_Count_8_I_7 : XOR2
      port map(A => \r_TX_Count_RNI4VRS1[1]_net_1\, B => N_18, Y
         => \DWACT_ADD_CI_0_partial_sum[1]\);
    
    \r_SM_CS_RNIJM951[0]\ : NOR2A
      port map(A => N_28, B => \r_SM_CS[0]_net_1\, Y => 
        \r_SM_CS_RNIJM951[0]_net_1\);
    
    \r_CS_Inactive_Count[0]\ : DFN1E0C1
      port map(D => N_39, CLK => i_Clk_c, CLR => i_Rst_L_c, E => 
        N_44, Q => \r_CS_Inactive_Count[0]_net_1\);
    
    VCC_i : VCC
      port map(Y => \VCC\);
    
    \r_CS_Inactive_Count_RNO[0]\ : NOR2
      port map(A => N_30, B => \r_CS_Inactive_Count[0]_net_1\, Y
         => N_39);
    
    \r_SM_CS_RNO[1]\ : MX2C
      port map(A => N_23, B => N_37, S => \r_SM_CS[0]_net_1\, Y
         => \r_SM_CS_RNO[1]_net_1\);
    
    \r_TX_Count[1]\ : DFN1C1
      port map(D => \r_TX_Count_8[1]\, CLK => i_Clk_c, CLR => 
        i_Rst_L_c, Q => \r_TX_Count[1]_net_1\);
    
    \r_CS_Inactive_Count[2]\ : DFN1E0C1
      port map(D => \r_CS_Inactive_Count_RNO[2]_net_1\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => N_44, Q => 
        \r_CS_Inactive_Count[2]_net_1\);
    
    \r_CS_Inactive_Count_RNIIEAO1[3]\ : OR2
      port map(A => N_27, B => \r_CS_Inactive_Count[3]_net_1\, Y
         => N_32);
    
    \r_TX_Count_RNIN9771[0]\ : NOR3A
      port map(A => \r_SM_CS[0]_net_1\, B => 
        \r_TX_Count[0]_net_1\, C => \r_TX_Count[1]_net_1\, Y => 
        N_58);
    
    r_CS_n_RNO : OR3A
      port map(A => N_24, B => N_47, C => 
        \r_SM_CS_RNIJM951[0]_net_1\, Y => N_22);
    
    r_CS_n_RNIOSN13 : NOR3A
      port map(A => N_24, B => N_58, C => 
        \un1_r_TX_Count_0_sqmuxa_i_0[3]\, Y => N_18);
    
    \r_CS_Inactive_Count[1]\ : DFN1E0C1
      port map(D => \r_CS_Inactive_Count_RNO[1]_net_1\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => N_44, Q => 
        \r_CS_Inactive_Count[1]_net_1\);
    
    \r_CS_Inactive_Count_RNO[3]\ : XA1C
      port map(A => \r_CS_Inactive_Count[3]_net_1\, B => N_27, C
         => N_30, Y => \r_CS_Inactive_Count_RNO[3]_net_1\);
    
    \r_SM_CS_RNIKSJC1[0]\ : NOR2A
      port map(A => \r_SM_CS[0]_net_1\, B => N_29, Y => N_30);
    
    r_CS_n_RNIJM951 : OAI1
      port map(A => \o_RHD64_SPI_CS_n_c\, B => \r_SM_CS[0]_net_1\, 
        C => int_RHD64_TX_DV, Y => 
        \un1_r_TX_Count_0_sqmuxa_i_0[3]\);
    
    \r_CS_Inactive_Count_RNO[1]\ : NOR2
      port map(A => N_30, B => N_33_i, Y => 
        \r_CS_Inactive_Count_RNO[1]_net_1\);
    
    \r_SM_CS_RNIH9QF[1]\ : NOR2
      port map(A => \r_SM_CS[0]_net_1\, B => \r_SM_CS[1]_net_1\, 
        Y => N_66);
    
    r_TX_Count_8_I_10 : XOR2
      port map(A => \DWACT_ADD_CI_0_partial_sum[1]\, B => 
        \DWACT_ADD_CI_0_TMP[0]\, Y => \r_TX_Count_8[1]\);
    
    \r_TX_Count_RNI2KNA2[0]\ : OR3A
      port map(A => N_24, B => N_58, C => int_RHD64_TX_DV, Y => 
        o_RHD64_TX_Ready_i_1);
    
    \r_SM_CS_RNI2AAE2[1]\ : OR2A
      port map(A => \r_SM_CS[1]_net_1\, B => N_48, Y => N_23);
    
    r_TX_Count_8_I_1 : AND2
      port map(A => \r_TX_Count_RNI3URS1[0]_net_1\, B => N_18, Y
         => \DWACT_ADD_CI_0_TMP[0]\);
    
    \r_SM_CS_RNO_0[1]\ : OR2
      port map(A => N_29, B => \r_SM_CS[1]_net_1\, Y => N_37);
    
    \r_CS_Inactive_Count[4]\ : DFN1E0P1
      port map(D => N_4, CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        N_44, Q => \r_CS_Inactive_Count[4]_net_1\);
    
    \r_CS_Inactive_Count_RNO_0[2]\ : AX1D
      port map(A => \r_CS_Inactive_Count[1]_net_1\, B => 
        \r_CS_Inactive_Count[0]_net_1\, C => 
        \r_CS_Inactive_Count[2]_net_1\, Y => N_34_i);
    
    \r_CS_Inactive_Count[3]\ : DFN1E0C1
      port map(D => \r_CS_Inactive_Count_RNO[3]_net_1\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, E => N_44, Q => 
        \r_CS_Inactive_Count[3]_net_1\);
    
    \r_SM_CS_RNIM6UQ3[1]\ : NOR2A
      port map(A => N_23, B => N_30, Y => N_44);
    
    \r_CS_Inactive_Count_RNICP7A1[2]\ : OR3
      port map(A => \r_CS_Inactive_Count[1]_net_1\, B => 
        \r_CS_Inactive_Count[0]_net_1\, C => 
        \r_CS_Inactive_Count[2]_net_1\, Y => N_27);
    
    r_CS_n_RNIBICT : OR2B
      port map(A => \o_RHD64_SPI_CS_n_c\, B => int_RHD64_TX_DV, Y
         => N_28);
    
    GND_i : GND
      port map(Y => \GND\);
    
    \r_CS_Inactive_Count_RNIP4D62[4]\ : NOR2
      port map(A => N_32, B => \r_CS_Inactive_Count[4]_net_1\, Y
         => N_48);
    
    r_TX_Count_8_I_8 : XOR2
      port map(A => \r_TX_Count_RNI3URS1[0]_net_1\, B => N_18, Y
         => \DWACT_ADD_CI_0_partial_sum[0]\);
    
    \r_CS_Inactive_Count_RNO[2]\ : NOR2
      port map(A => N_30, B => N_34_i, Y => 
        \r_CS_Inactive_Count_RNO[2]_net_1\);
    
    \r_CS_Inactive_Count_RNO[4]\ : XO1A
      port map(A => \r_CS_Inactive_Count[4]_net_1\, B => N_32, C
         => N_30, Y => N_4);
    
    \r_SM_CS_RNO[0]\ : NOR3
      port map(A => \r_SM_CS_RNIJM951[0]_net_1\, B => 
        \r_SM_CS[1]_net_1\, C => N_30, Y => 
        \r_SM_CS_RNO[0]_net_1\);
    
    \r_TX_Count[0]\ : DFN1C1
      port map(D => \DWACT_ADD_CI_0_partial_sum[0]\, CLK => 
        i_Clk_c, CLR => i_Rst_L_c, Q => \r_TX_Count[0]_net_1\);
    
    \r_SM_CS_RNIES6L[1]\ : MX2A
      port map(A => \r_SM_CS[1]_net_1\, B => w_Master_Ready, S
         => \r_SM_CS[0]_net_1\, Y => N_24);
    
    \r_TX_Count_RNI4VRS1[1]\ : OA1A
      port map(A => N_66, B => N_28, C => \r_TX_Count[1]_net_1\, 
        Y => \r_TX_Count_RNI4VRS1[1]_net_1\);
    
    r_CS_n : DFN1E0P1
      port map(D => N_30, CLK => i_Clk_c, PRE => i_Rst_L_c, E => 
        N_22, Q => \o_RHD64_SPI_CS_n_c\);
    
    \r_SM_CS[1]\ : DFN1C1
      port map(D => \r_SM_CS_RNO[1]_net_1\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, Q => \r_SM_CS[1]_net_1\);
    
    SPI_Master_1 : SPI_Master_0_16_16
      port map(int_RHD64_TX_Byte(15) => int_RHD64_TX_Byte(15), 
        int_RHD64_TX_Byte(14) => int_RHD64_TX_Byte(14), 
        int_RHD64_TX_Byte(13) => int_RHD64_TX_Byte(13), 
        int_RHD64_TX_Byte(12) => int_RHD64_TX_Byte(12), 
        int_RHD64_TX_Byte(11) => int_RHD64_TX_Byte(11), 
        int_RHD64_TX_Byte(10) => int_RHD64_TX_Byte(10), 
        int_RHD64_TX_Byte(9) => int_RHD64_TX_Byte(9), 
        int_RHD64_TX_Byte(8) => int_RHD64_TX_Byte(8), 
        int_RHD64_TX_Byte(7) => int_RHD64_TX_Byte(7), 
        int_RHD64_TX_Byte(6) => int_RHD64_TX_Byte(6), 
        int_RHD64_TX_Byte(5) => int_RHD64_TX_Byte(5), 
        int_RHD64_TX_Byte(4) => int_RHD64_TX_Byte(4), 
        int_RHD64_TX_Byte(3) => int_RHD64_TX_Byte(3), 
        int_RHD64_TX_Byte(2) => int_RHD64_TX_Byte(2), 
        int_RHD64_TX_Byte(1) => int_RHD64_TX_Byte(1), 
        int_RHD64_TX_Byte(0) => int_RHD64_TX_Byte(0), 
        io_RX_Byte_Falling(15) => io_RX_Byte_Falling(15), 
        io_RX_Byte_Falling(14) => io_RX_Byte_Falling(14), 
        io_RX_Byte_Falling(13) => io_RX_Byte_Falling(13), 
        io_RX_Byte_Falling(12) => io_RX_Byte_Falling(12), 
        io_RX_Byte_Falling(11) => io_RX_Byte_Falling(11), 
        io_RX_Byte_Falling(10) => io_RX_Byte_Falling(10), 
        io_RX_Byte_Falling(9) => io_RX_Byte_Falling(9), 
        io_RX_Byte_Falling(8) => io_RX_Byte_Falling(8), 
        io_RX_Byte_Falling(7) => io_RX_Byte_Falling(7), 
        io_RX_Byte_Falling(6) => io_RX_Byte_Falling(6), 
        io_RX_Byte_Falling(5) => io_RX_Byte_Falling(5), 
        io_RX_Byte_Falling(4) => io_RX_Byte_Falling(4), 
        io_RX_Byte_Falling(3) => io_RX_Byte_Falling(3), 
        io_RX_Byte_Falling(2) => io_RX_Byte_Falling(2), 
        io_RX_Byte_Falling(1) => io_RX_Byte_Falling(1), 
        io_RX_Byte_Falling(0) => io_RX_Byte_Falling(0), 
        io_RX_Byte_Rising(15) => io_RX_Byte_Rising(15), 
        io_RX_Byte_Rising(14) => io_RX_Byte_Rising(14), 
        io_RX_Byte_Rising(13) => io_RX_Byte_Rising(13), 
        io_RX_Byte_Rising(12) => io_RX_Byte_Rising(12), 
        io_RX_Byte_Rising(11) => io_RX_Byte_Rising(11), 
        io_RX_Byte_Rising(10) => io_RX_Byte_Rising(10), 
        io_RX_Byte_Rising(9) => io_RX_Byte_Rising(9), 
        io_RX_Byte_Rising(8) => io_RX_Byte_Rising(8), 
        io_RX_Byte_Rising(7) => io_RX_Byte_Rising(7), 
        io_RX_Byte_Rising(6) => io_RX_Byte_Rising(6), 
        io_RX_Byte_Rising(5) => io_RX_Byte_Rising(5), 
        io_RX_Byte_Rising(4) => io_RX_Byte_Rising(4), 
        io_RX_Byte_Rising(3) => io_RX_Byte_Rising(3), 
        io_RX_Byte_Rising(2) => io_RX_Byte_Rising(2), 
        io_RX_Byte_Rising(1) => io_RX_Byte_Rising(1), 
        io_RX_Byte_Rising(0) => io_RX_Byte_Rising(0), 
        int_RHD64_TX_DV_0 => int_RHD64_TX_DV_0, o_RX_DV => 
        o_RX_DV, o_RHD64_SPI_MOSI_c => o_RHD64_SPI_MOSI_c, 
        o_RHD64_SPI_Clk_c => o_RHD64_SPI_Clk_c, int_RHD64_TX_DV
         => int_RHD64_TX_DV, i_RHD64_SPI_MISO_c => 
        i_RHD64_SPI_MISO_c, i_RHD64_SPI_MISO_c_0 => 
        i_RHD64_SPI_MISO_c_0, w_Master_Ready => w_Master_Ready, 
        i_Rst_L_c => i_Rst_L_c, i_Clk_c => i_Clk_c, o_RX_DV_0 => 
        o_RX_DV_0);
    
    \r_SM_CS[0]\ : DFN1C1
      port map(D => \r_SM_CS_RNO[0]_net_1\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, Q => \r_SM_CS[0]_net_1\);
    
    \r_TX_Count_RNI3URS1[0]\ : AO1A
      port map(A => N_28, B => N_66, C => \r_TX_Count[0]_net_1\, 
        Y => \r_TX_Count_RNI3URS1[0]_net_1\);
    
    r_CS_n_RNO_0 : OA1
      port map(A => \r_TX_Count[0]_net_1\, B => 
        \r_TX_Count[1]_net_1\, C => \r_SM_CS[0]_net_1\, Y => N_47);
    

end DEF_ARCH; 

library ieee;
use ieee.std_logic_1164.all;
library igloo;
use igloo.all;

entity FIFO is

    port( int_FIFO_DATA : in    std_logic_vector(31 downto 0);
          o_FIFO_Q      : out   std_logic_vector(31 downto 0);
          WEBP          : in    std_logic;
          int_FIFO_RE   : in    std_logic;
          i_Clk_c       : in    std_logic;
          G_3_0_0       : out   std_logic;
          i_Rst_L_c     : in    std_logic;
          G_0_i_a2_0    : out   std_logic
        );

end FIFO;

architecture DEF_ARCH of FIFO is 

  component NOR3
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NAND2A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
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

  component NAND2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component VCC
    port( Y : out   std_logic
        );
  end component;

  component AND2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component GND
    port( Y : out   std_logic
        );
  end component;

  component INV
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

    signal \Z\\EMPTYX_I[0]\\\, \Z\\EMPTYX_I[1]\\\, o_FIFO_EMPTY, 
        \Z\\AEMPTYX_I[1]\\\, \Z\\AFULLX_I[1]\\\, 
        \Z\\FULLX_I[1]\\\, \Z\\FIFOBLOCK[1]\\_RD14\, 
        \Z\\FIFOBLOCK[1]\\_RD15\, \Z\\FIFOBLOCK[1]\\_RD16\, 
        \Z\\FIFOBLOCK[1]\\_RD17\, FIFO_GND, FIFO_VCC, 
        READ_ENABLE_I, RESETP, WRITE_ENABLE_I, 
        \Z\\AEMPTYX_I[0]\\\, \Z\\AFULLX_I[0]\\\, 
        \Z\\FULLX_I[0]\\\, READ_ESTOP_ENABLE, WRITE_FSTOP_ENABLE, 
        FULL : std_logic;

begin 


    \\\FIFOBLOCK[0]\\_RNI3F8V\ : NOR3
      port map(A => \Z\\EMPTYX_I[0]\\\, B => \Z\\EMPTYX_I[1]\\\, 
        C => i_Rst_L_c, Y => G_0_i_a2_0);
    
    WRITE_AND : NAND2A
      port map(A => WEBP, B => WRITE_FSTOP_ENABLE, Y => 
        WRITE_ENABLE_I);
    
    \FIFOBLOCK[0]\ : FIFO4K18
      port map(AEVAL11 => FIFO_GND, AEVAL10 => FIFO_GND, AEVAL9
         => FIFO_GND, AEVAL8 => FIFO_GND, AEVAL7 => FIFO_GND, 
        AEVAL6 => FIFO_VCC, AEVAL5 => FIFO_GND, AEVAL4 => 
        FIFO_VCC, AEVAL3 => FIFO_GND, AEVAL2 => FIFO_GND, AEVAL1
         => FIFO_GND, AEVAL0 => FIFO_GND, AFVAL11 => FIFO_VCC, 
        AFVAL10 => FIFO_VCC, AFVAL9 => FIFO_VCC, AFVAL8 => 
        FIFO_VCC, AFVAL7 => FIFO_VCC, AFVAL6 => FIFO_GND, AFVAL5
         => FIFO_VCC, AFVAL4 => FIFO_GND, AFVAL3 => FIFO_GND, 
        AFVAL2 => FIFO_GND, AFVAL1 => FIFO_GND, AFVAL0 => 
        FIFO_GND, WD17 => int_FIFO_DATA(17), WD16 => 
        int_FIFO_DATA(16), WD15 => int_FIFO_DATA(15), WD14 => 
        int_FIFO_DATA(14), WD13 => int_FIFO_DATA(13), WD12 => 
        int_FIFO_DATA(12), WD11 => int_FIFO_DATA(11), WD10 => 
        int_FIFO_DATA(10), WD9 => int_FIFO_DATA(9), WD8 => 
        int_FIFO_DATA(8), WD7 => int_FIFO_DATA(7), WD6 => 
        int_FIFO_DATA(6), WD5 => int_FIFO_DATA(5), WD4 => 
        int_FIFO_DATA(4), WD3 => int_FIFO_DATA(3), WD2 => 
        int_FIFO_DATA(2), WD1 => int_FIFO_DATA(1), WD0 => 
        int_FIFO_DATA(0), WW0 => FIFO_GND, WW1 => FIFO_GND, WW2
         => FIFO_VCC, RW0 => FIFO_GND, RW1 => FIFO_GND, RW2 => 
        FIFO_VCC, RPIPE => FIFO_GND, WEN => WRITE_ENABLE_I, REN
         => READ_ENABLE_I, WBLK => FIFO_GND, RBLK => FIFO_GND, 
        WCLK => i_Clk_c, RCLK => i_Clk_c, RESET => RESETP, ESTOP
         => FIFO_VCC, FSTOP => FIFO_VCC, RD17 => o_FIFO_Q(17), 
        RD16 => o_FIFO_Q(16), RD15 => o_FIFO_Q(15), RD14 => 
        o_FIFO_Q(14), RD13 => o_FIFO_Q(13), RD12 => o_FIFO_Q(12), 
        RD11 => o_FIFO_Q(11), RD10 => o_FIFO_Q(10), RD9 => 
        o_FIFO_Q(9), RD8 => o_FIFO_Q(8), RD7 => o_FIFO_Q(7), RD6
         => o_FIFO_Q(6), RD5 => o_FIFO_Q(5), RD4 => o_FIFO_Q(4), 
        RD3 => o_FIFO_Q(3), RD2 => o_FIFO_Q(2), RD1 => 
        o_FIFO_Q(1), RD0 => o_FIFO_Q(0), FULL => 
        \Z\\FULLX_I[0]\\\, AFULL => \Z\\AFULLX_I[0]\\\, EMPTY => 
        \Z\\EMPTYX_I[0]\\\, AEMPTY => \Z\\AEMPTYX_I[0]\\\);
    
    READ_ESTOP_GATE : NAND2
      port map(A => o_FIFO_EMPTY, B => FIFO_VCC, Y => 
        READ_ESTOP_ENABLE);
    
    \\\FIFOBLOCK[0]\\_RNI36EN\ : OR2
      port map(A => \Z\\EMPTYX_I[0]\\\, B => \Z\\EMPTYX_I[1]\\\, 
        Y => G_3_0_0);
    
    VCC_i : VCC
      port map(Y => FIFO_VCC);
    
    READ_AND : AND2
      port map(A => int_FIFO_RE, B => READ_ESTOP_ENABLE, Y => 
        READ_ENABLE_I);
    
    \FIFOBLOCK[1]\ : FIFO4K18
      port map(AEVAL11 => FIFO_GND, AEVAL10 => FIFO_GND, AEVAL9
         => FIFO_GND, AEVAL8 => FIFO_GND, AEVAL7 => FIFO_GND, 
        AEVAL6 => FIFO_VCC, AEVAL5 => FIFO_GND, AEVAL4 => 
        FIFO_VCC, AEVAL3 => FIFO_GND, AEVAL2 => FIFO_GND, AEVAL1
         => FIFO_GND, AEVAL0 => FIFO_GND, AFVAL11 => FIFO_VCC, 
        AFVAL10 => FIFO_VCC, AFVAL9 => FIFO_VCC, AFVAL8 => 
        FIFO_VCC, AFVAL7 => FIFO_VCC, AFVAL6 => FIFO_GND, AFVAL5
         => FIFO_VCC, AFVAL4 => FIFO_GND, AFVAL3 => FIFO_GND, 
        AFVAL2 => FIFO_GND, AFVAL1 => FIFO_GND, AFVAL0 => 
        FIFO_GND, WD17 => FIFO_GND, WD16 => FIFO_GND, WD15 => 
        FIFO_GND, WD14 => FIFO_GND, WD13 => int_FIFO_DATA(31), 
        WD12 => int_FIFO_DATA(30), WD11 => int_FIFO_DATA(29), 
        WD10 => int_FIFO_DATA(28), WD9 => int_FIFO_DATA(27), WD8
         => int_FIFO_DATA(26), WD7 => int_FIFO_DATA(25), WD6 => 
        int_FIFO_DATA(24), WD5 => int_FIFO_DATA(23), WD4 => 
        int_FIFO_DATA(22), WD3 => int_FIFO_DATA(21), WD2 => 
        int_FIFO_DATA(20), WD1 => int_FIFO_DATA(19), WD0 => 
        int_FIFO_DATA(18), WW0 => FIFO_GND, WW1 => FIFO_GND, WW2
         => FIFO_VCC, RW0 => FIFO_GND, RW1 => FIFO_GND, RW2 => 
        FIFO_VCC, RPIPE => FIFO_GND, WEN => WRITE_ENABLE_I, REN
         => READ_ENABLE_I, WBLK => FIFO_GND, RBLK => FIFO_GND, 
        WCLK => i_Clk_c, RCLK => i_Clk_c, RESET => RESETP, ESTOP
         => FIFO_VCC, FSTOP => FIFO_VCC, RD17 => 
        \Z\\FIFOBLOCK[1]\\_RD17\, RD16 => 
        \Z\\FIFOBLOCK[1]\\_RD16\, RD15 => 
        \Z\\FIFOBLOCK[1]\\_RD15\, RD14 => 
        \Z\\FIFOBLOCK[1]\\_RD14\, RD13 => o_FIFO_Q(31), RD12 => 
        o_FIFO_Q(30), RD11 => o_FIFO_Q(29), RD10 => o_FIFO_Q(28), 
        RD9 => o_FIFO_Q(27), RD8 => o_FIFO_Q(26), RD7 => 
        o_FIFO_Q(25), RD6 => o_FIFO_Q(24), RD5 => o_FIFO_Q(23), 
        RD4 => o_FIFO_Q(22), RD3 => o_FIFO_Q(21), RD2 => 
        o_FIFO_Q(20), RD1 => o_FIFO_Q(19), RD0 => o_FIFO_Q(18), 
        FULL => \Z\\FULLX_I[1]\\\, AFULL => \Z\\AFULLX_I[1]\\\, 
        EMPTY => \Z\\EMPTYX_I[1]\\\, AEMPTY => 
        \Z\\AEMPTYX_I[1]\\\);
    
    OR2_FULL : OR2
      port map(A => \Z\\FULLX_I[0]\\\, B => \Z\\FULLX_I[1]\\\, Y
         => FULL);
    
    GND_i : GND
      port map(Y => FIFO_GND);
    
    READ_ESTOP_GATE_RNO : OR2
      port map(A => \Z\\EMPTYX_I[1]\\\, B => \Z\\EMPTYX_I[0]\\\, 
        Y => o_FIFO_EMPTY);
    
    WRITE_FSTOP_GATE : NAND2
      port map(A => FULL, B => FIFO_VCC, Y => WRITE_FSTOP_ENABLE);
    
    RESETBUBBLEA : INV
      port map(A => i_Rst_L_c, Y => RESETP);
    

end DEF_ARCH; 

library ieee;
use ieee.std_logic_1164.all;
library igloo;
use igloo.all;

entity Controller_RHD64 is

    port( o_FIFO_Q             : out   std_logic_vector(31 downto 0);
          int_RHD64_TX_Byte    : in    std_logic_vector(15 downto 0);
          G_0_i_a2_0           : out   std_logic;
          G_3_0_0              : out   std_logic;
          int_FIFO_RE          : in    std_logic;
          o_RHD64_TX_Ready_i_1 : out   std_logic;
          int_RHD64_TX_DV      : in    std_logic;
          o_RHD64_SPI_CS_n_c   : out   std_logic;
          int_RHD64_TX_DV_0    : in    std_logic;
          o_RHD64_SPI_MOSI_c   : out   std_logic;
          o_RHD64_SPI_Clk_c    : out   std_logic;
          i_RHD64_SPI_MISO_c   : in    std_logic;
          i_RHD64_SPI_MISO_c_0 : in    std_logic;
          i_Rst_L_c            : in    std_logic;
          i_Clk_c              : in    std_logic
        );

end Controller_RHD64;

architecture DEF_ARCH of Controller_RHD64 is 

  component DFN1E1C1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          CLR : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component SPI_Master_CS_0_16_16_16
    port( io_RX_Byte_Rising    : out   std_logic_vector(15 downto 0);
          io_RX_Byte_Falling   : out   std_logic_vector(15 downto 0);
          int_RHD64_TX_Byte    : in    std_logic_vector(15 downto 0) := (others => 'U');
          o_RX_DV_0            : out   std_logic;
          i_RHD64_SPI_MISO_c_0 : in    std_logic := 'U';
          i_RHD64_SPI_MISO_c   : in    std_logic := 'U';
          o_RHD64_SPI_Clk_c    : out   std_logic;
          o_RHD64_SPI_MOSI_c   : out   std_logic;
          o_RX_DV              : out   std_logic;
          int_RHD64_TX_DV_0    : in    std_logic := 'U';
          i_Rst_L_c            : in    std_logic := 'U';
          i_Clk_c              : in    std_logic := 'U';
          o_RHD64_SPI_CS_n_c   : out   std_logic;
          int_RHD64_TX_DV      : in    std_logic := 'U';
          o_RHD64_TX_Ready_i_1 : out   std_logic
        );
  end component;

  component FIFO
    port( int_FIFO_DATA : in    std_logic_vector(31 downto 0) := (others => 'U');
          o_FIFO_Q      : out   std_logic_vector(31 downto 0);
          WEBP          : in    std_logic := 'U';
          int_FIFO_RE   : in    std_logic := 'U';
          i_Clk_c       : in    std_logic := 'U';
          G_3_0_0       : out   std_logic;
          i_Rst_L_c     : in    std_logic := 'U';
          G_0_i_a2_0    : out   std_logic
        );
  end component;

  component VCC
    port( Y : out   std_logic
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
    port( Y : out   std_logic
        );
  end component;

    signal WEBP, o_RX_DV, \int_FIFO_DATA[0]_net_1\, 
        \io_RX_Byte_Falling[0]\, o_RX_DV_0, 
        \int_FIFO_DATA[1]_net_1\, \io_RX_Byte_Falling[1]\, 
        \int_FIFO_DATA[2]_net_1\, \io_RX_Byte_Falling[2]\, 
        \int_FIFO_DATA[3]_net_1\, \io_RX_Byte_Falling[3]\, 
        \int_FIFO_DATA[4]_net_1\, \io_RX_Byte_Falling[4]\, 
        \int_FIFO_DATA[5]_net_1\, \io_RX_Byte_Falling[5]\, 
        \int_FIFO_DATA[6]_net_1\, \io_RX_Byte_Falling[6]\, 
        \int_FIFO_DATA[7]_net_1\, \io_RX_Byte_Falling[7]\, 
        \int_FIFO_DATA[8]_net_1\, \io_RX_Byte_Falling[8]\, 
        \int_FIFO_DATA[9]_net_1\, \io_RX_Byte_Falling[9]\, 
        \int_FIFO_DATA[10]_net_1\, \io_RX_Byte_Falling[10]\, 
        \int_FIFO_DATA[11]_net_1\, \io_RX_Byte_Falling[11]\, 
        \int_FIFO_DATA[12]_net_1\, \io_RX_Byte_Falling[12]\, 
        \int_FIFO_DATA[13]_net_1\, \io_RX_Byte_Falling[13]\, 
        \int_FIFO_DATA[14]_net_1\, \io_RX_Byte_Falling[14]\, 
        \int_FIFO_DATA[15]_net_1\, \io_RX_Byte_Falling[15]\, 
        \int_FIFO_DATA[16]_net_1\, \io_RX_Byte_Rising[0]\, 
        \int_FIFO_DATA[17]_net_1\, \io_RX_Byte_Rising[1]\, 
        \int_FIFO_DATA[18]_net_1\, \io_RX_Byte_Rising[2]\, 
        \int_FIFO_DATA[19]_net_1\, \io_RX_Byte_Rising[3]\, 
        \int_FIFO_DATA[20]_net_1\, \io_RX_Byte_Rising[4]\, 
        \int_FIFO_DATA[21]_net_1\, \io_RX_Byte_Rising[5]\, 
        \int_FIFO_DATA[22]_net_1\, \io_RX_Byte_Rising[6]\, 
        \int_FIFO_DATA[23]_net_1\, \io_RX_Byte_Rising[7]\, 
        \int_FIFO_DATA[24]_net_1\, \io_RX_Byte_Rising[8]\, 
        \int_FIFO_DATA[25]_net_1\, \io_RX_Byte_Rising[9]\, 
        \int_FIFO_DATA[26]_net_1\, \io_RX_Byte_Rising[10]\, 
        \int_FIFO_DATA[27]_net_1\, \io_RX_Byte_Rising[11]\, 
        \int_FIFO_DATA[28]_net_1\, \io_RX_Byte_Rising[12]\, 
        \int_FIFO_DATA[29]_net_1\, \io_RX_Byte_Rising[13]\, 
        \int_FIFO_DATA[30]_net_1\, \io_RX_Byte_Rising[14]\, 
        \int_FIFO_DATA[31]_net_1\, \io_RX_Byte_Rising[15]\, \GND\, 
        \VCC\ : std_logic;

    for all : SPI_Master_CS_0_16_16_16
	Use entity work.SPI_Master_CS_0_16_16_16(DEF_ARCH);
    for all : FIFO
	Use entity work.FIFO(DEF_ARCH);
begin 


    \int_FIFO_DATA[31]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[15]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[31]_net_1\);
    
    SPI_Master_CS_1 : SPI_Master_CS_0_16_16_16
      port map(io_RX_Byte_Rising(15) => \io_RX_Byte_Rising[15]\, 
        io_RX_Byte_Rising(14) => \io_RX_Byte_Rising[14]\, 
        io_RX_Byte_Rising(13) => \io_RX_Byte_Rising[13]\, 
        io_RX_Byte_Rising(12) => \io_RX_Byte_Rising[12]\, 
        io_RX_Byte_Rising(11) => \io_RX_Byte_Rising[11]\, 
        io_RX_Byte_Rising(10) => \io_RX_Byte_Rising[10]\, 
        io_RX_Byte_Rising(9) => \io_RX_Byte_Rising[9]\, 
        io_RX_Byte_Rising(8) => \io_RX_Byte_Rising[8]\, 
        io_RX_Byte_Rising(7) => \io_RX_Byte_Rising[7]\, 
        io_RX_Byte_Rising(6) => \io_RX_Byte_Rising[6]\, 
        io_RX_Byte_Rising(5) => \io_RX_Byte_Rising[5]\, 
        io_RX_Byte_Rising(4) => \io_RX_Byte_Rising[4]\, 
        io_RX_Byte_Rising(3) => \io_RX_Byte_Rising[3]\, 
        io_RX_Byte_Rising(2) => \io_RX_Byte_Rising[2]\, 
        io_RX_Byte_Rising(1) => \io_RX_Byte_Rising[1]\, 
        io_RX_Byte_Rising(0) => \io_RX_Byte_Rising[0]\, 
        io_RX_Byte_Falling(15) => \io_RX_Byte_Falling[15]\, 
        io_RX_Byte_Falling(14) => \io_RX_Byte_Falling[14]\, 
        io_RX_Byte_Falling(13) => \io_RX_Byte_Falling[13]\, 
        io_RX_Byte_Falling(12) => \io_RX_Byte_Falling[12]\, 
        io_RX_Byte_Falling(11) => \io_RX_Byte_Falling[11]\, 
        io_RX_Byte_Falling(10) => \io_RX_Byte_Falling[10]\, 
        io_RX_Byte_Falling(9) => \io_RX_Byte_Falling[9]\, 
        io_RX_Byte_Falling(8) => \io_RX_Byte_Falling[8]\, 
        io_RX_Byte_Falling(7) => \io_RX_Byte_Falling[7]\, 
        io_RX_Byte_Falling(6) => \io_RX_Byte_Falling[6]\, 
        io_RX_Byte_Falling(5) => \io_RX_Byte_Falling[5]\, 
        io_RX_Byte_Falling(4) => \io_RX_Byte_Falling[4]\, 
        io_RX_Byte_Falling(3) => \io_RX_Byte_Falling[3]\, 
        io_RX_Byte_Falling(2) => \io_RX_Byte_Falling[2]\, 
        io_RX_Byte_Falling(1) => \io_RX_Byte_Falling[1]\, 
        io_RX_Byte_Falling(0) => \io_RX_Byte_Falling[0]\, 
        int_RHD64_TX_Byte(15) => int_RHD64_TX_Byte(15), 
        int_RHD64_TX_Byte(14) => int_RHD64_TX_Byte(14), 
        int_RHD64_TX_Byte(13) => int_RHD64_TX_Byte(13), 
        int_RHD64_TX_Byte(12) => int_RHD64_TX_Byte(12), 
        int_RHD64_TX_Byte(11) => int_RHD64_TX_Byte(11), 
        int_RHD64_TX_Byte(10) => int_RHD64_TX_Byte(10), 
        int_RHD64_TX_Byte(9) => int_RHD64_TX_Byte(9), 
        int_RHD64_TX_Byte(8) => int_RHD64_TX_Byte(8), 
        int_RHD64_TX_Byte(7) => int_RHD64_TX_Byte(7), 
        int_RHD64_TX_Byte(6) => int_RHD64_TX_Byte(6), 
        int_RHD64_TX_Byte(5) => int_RHD64_TX_Byte(5), 
        int_RHD64_TX_Byte(4) => int_RHD64_TX_Byte(4), 
        int_RHD64_TX_Byte(3) => int_RHD64_TX_Byte(3), 
        int_RHD64_TX_Byte(2) => int_RHD64_TX_Byte(2), 
        int_RHD64_TX_Byte(1) => int_RHD64_TX_Byte(1), 
        int_RHD64_TX_Byte(0) => int_RHD64_TX_Byte(0), o_RX_DV_0
         => o_RX_DV_0, i_RHD64_SPI_MISO_c_0 => 
        i_RHD64_SPI_MISO_c_0, i_RHD64_SPI_MISO_c => 
        i_RHD64_SPI_MISO_c, o_RHD64_SPI_Clk_c => 
        o_RHD64_SPI_Clk_c, o_RHD64_SPI_MOSI_c => 
        o_RHD64_SPI_MOSI_c, o_RX_DV => o_RX_DV, int_RHD64_TX_DV_0
         => int_RHD64_TX_DV_0, i_Rst_L_c => i_Rst_L_c, i_Clk_c
         => i_Clk_c, o_RHD64_SPI_CS_n_c => o_RHD64_SPI_CS_n_c, 
        int_RHD64_TX_DV => int_RHD64_TX_DV, o_RHD64_TX_Ready_i_1
         => o_RHD64_TX_Ready_i_1);
    
    \int_FIFO_DATA[23]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[7]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[23]_net_1\);
    
    \int_FIFO_DATA[13]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[13]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[13]_net_1\);
    
    \int_FIFO_DATA[29]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[13]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[29]_net_1\);
    
    \int_FIFO_DATA[19]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[3]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[19]_net_1\);
    
    \int_FIFO_DATA[9]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[9]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[9]_net_1\);
    
    \int_FIFO_DATA[30]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[14]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[30]_net_1\);
    
    FIFO_1 : FIFO
      port map(int_FIFO_DATA(31) => \int_FIFO_DATA[31]_net_1\, 
        int_FIFO_DATA(30) => \int_FIFO_DATA[30]_net_1\, 
        int_FIFO_DATA(29) => \int_FIFO_DATA[29]_net_1\, 
        int_FIFO_DATA(28) => \int_FIFO_DATA[28]_net_1\, 
        int_FIFO_DATA(27) => \int_FIFO_DATA[27]_net_1\, 
        int_FIFO_DATA(26) => \int_FIFO_DATA[26]_net_1\, 
        int_FIFO_DATA(25) => \int_FIFO_DATA[25]_net_1\, 
        int_FIFO_DATA(24) => \int_FIFO_DATA[24]_net_1\, 
        int_FIFO_DATA(23) => \int_FIFO_DATA[23]_net_1\, 
        int_FIFO_DATA(22) => \int_FIFO_DATA[22]_net_1\, 
        int_FIFO_DATA(21) => \int_FIFO_DATA[21]_net_1\, 
        int_FIFO_DATA(20) => \int_FIFO_DATA[20]_net_1\, 
        int_FIFO_DATA(19) => \int_FIFO_DATA[19]_net_1\, 
        int_FIFO_DATA(18) => \int_FIFO_DATA[18]_net_1\, 
        int_FIFO_DATA(17) => \int_FIFO_DATA[17]_net_1\, 
        int_FIFO_DATA(16) => \int_FIFO_DATA[16]_net_1\, 
        int_FIFO_DATA(15) => \int_FIFO_DATA[15]_net_1\, 
        int_FIFO_DATA(14) => \int_FIFO_DATA[14]_net_1\, 
        int_FIFO_DATA(13) => \int_FIFO_DATA[13]_net_1\, 
        int_FIFO_DATA(12) => \int_FIFO_DATA[12]_net_1\, 
        int_FIFO_DATA(11) => \int_FIFO_DATA[11]_net_1\, 
        int_FIFO_DATA(10) => \int_FIFO_DATA[10]_net_1\, 
        int_FIFO_DATA(9) => \int_FIFO_DATA[9]_net_1\, 
        int_FIFO_DATA(8) => \int_FIFO_DATA[8]_net_1\, 
        int_FIFO_DATA(7) => \int_FIFO_DATA[7]_net_1\, 
        int_FIFO_DATA(6) => \int_FIFO_DATA[6]_net_1\, 
        int_FIFO_DATA(5) => \int_FIFO_DATA[5]_net_1\, 
        int_FIFO_DATA(4) => \int_FIFO_DATA[4]_net_1\, 
        int_FIFO_DATA(3) => \int_FIFO_DATA[3]_net_1\, 
        int_FIFO_DATA(2) => \int_FIFO_DATA[2]_net_1\, 
        int_FIFO_DATA(1) => \int_FIFO_DATA[1]_net_1\, 
        int_FIFO_DATA(0) => \int_FIFO_DATA[0]_net_1\, 
        o_FIFO_Q(31) => o_FIFO_Q(31), o_FIFO_Q(30) => 
        o_FIFO_Q(30), o_FIFO_Q(29) => o_FIFO_Q(29), o_FIFO_Q(28)
         => o_FIFO_Q(28), o_FIFO_Q(27) => o_FIFO_Q(27), 
        o_FIFO_Q(26) => o_FIFO_Q(26), o_FIFO_Q(25) => 
        o_FIFO_Q(25), o_FIFO_Q(24) => o_FIFO_Q(24), o_FIFO_Q(23)
         => o_FIFO_Q(23), o_FIFO_Q(22) => o_FIFO_Q(22), 
        o_FIFO_Q(21) => o_FIFO_Q(21), o_FIFO_Q(20) => 
        o_FIFO_Q(20), o_FIFO_Q(19) => o_FIFO_Q(19), o_FIFO_Q(18)
         => o_FIFO_Q(18), o_FIFO_Q(17) => o_FIFO_Q(17), 
        o_FIFO_Q(16) => o_FIFO_Q(16), o_FIFO_Q(15) => 
        o_FIFO_Q(15), o_FIFO_Q(14) => o_FIFO_Q(14), o_FIFO_Q(13)
         => o_FIFO_Q(13), o_FIFO_Q(12) => o_FIFO_Q(12), 
        o_FIFO_Q(11) => o_FIFO_Q(11), o_FIFO_Q(10) => 
        o_FIFO_Q(10), o_FIFO_Q(9) => o_FIFO_Q(9), o_FIFO_Q(8) => 
        o_FIFO_Q(8), o_FIFO_Q(7) => o_FIFO_Q(7), o_FIFO_Q(6) => 
        o_FIFO_Q(6), o_FIFO_Q(5) => o_FIFO_Q(5), o_FIFO_Q(4) => 
        o_FIFO_Q(4), o_FIFO_Q(3) => o_FIFO_Q(3), o_FIFO_Q(2) => 
        o_FIFO_Q(2), o_FIFO_Q(1) => o_FIFO_Q(1), o_FIFO_Q(0) => 
        o_FIFO_Q(0), WEBP => WEBP, int_FIFO_RE => int_FIFO_RE, 
        i_Clk_c => i_Clk_c, G_3_0_0 => G_3_0_0, i_Rst_L_c => 
        i_Rst_L_c, G_0_i_a2_0 => G_0_i_a2_0);
    
    \int_FIFO_DATA[27]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[11]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[27]_net_1\);
    
    \int_FIFO_DATA[17]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[1]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[17]_net_1\);
    
    VCC_i : VCC
      port map(Y => \VCC\);
    
    \int_FIFO_DATA[6]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[6]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[6]_net_1\);
    
    int_FIFO_WE : DFI1C1
      port map(D => o_RX_DV, CLK => i_Clk_c, CLR => i_Rst_L_c, QN
         => WEBP);
    
    \int_FIFO_DATA[24]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[8]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[24]_net_1\);
    
    \int_FIFO_DATA[14]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[14]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[14]_net_1\);
    
    \int_FIFO_DATA[2]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[2]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[2]_net_1\);
    
    \int_FIFO_DATA[21]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[5]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[21]_net_1\);
    
    \int_FIFO_DATA[11]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[11]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[11]_net_1\);
    
    \int_FIFO_DATA[26]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[10]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[26]_net_1\);
    
    \int_FIFO_DATA[1]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[1]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[1]_net_1\);
    
    \int_FIFO_DATA[16]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[0]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[16]_net_1\);
    
    \int_FIFO_DATA[28]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[12]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[28]_net_1\);
    
    \int_FIFO_DATA[18]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[2]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[18]_net_1\);
    
    \int_FIFO_DATA[8]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[8]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[8]_net_1\);
    
    \int_FIFO_DATA[20]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[4]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[20]_net_1\);
    
    \int_FIFO_DATA[10]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[10]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[10]_net_1\);
    
    \int_FIFO_DATA[22]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[6]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[22]_net_1\);
    
    \int_FIFO_DATA[12]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[12]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[12]_net_1\);
    
    GND_i : GND
      port map(Y => \GND\);
    
    \int_FIFO_DATA[0]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[0]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[0]_net_1\);
    
    \int_FIFO_DATA[3]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[3]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[3]_net_1\);
    
    \int_FIFO_DATA[4]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[4]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[4]_net_1\);
    
    \int_FIFO_DATA[7]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[7]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[7]_net_1\);
    
    \int_FIFO_DATA[5]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[5]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[5]_net_1\);
    
    \int_FIFO_DATA[25]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Rising[9]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV, Q => 
        \int_FIFO_DATA[25]_net_1\);
    
    \int_FIFO_DATA[15]\ : DFN1E1C1
      port map(D => \io_RX_Byte_Falling[15]\, CLK => i_Clk_c, CLR
         => i_Rst_L_c, E => o_RX_DV_0, Q => 
        \int_FIFO_DATA[15]_net_1\);
    

end DEF_ARCH; 

library ieee;
use ieee.std_logic_1164.all;
library igloo;
use igloo.all;

entity Controller_Headstage is

    port( o_STM32_SPI_CS_n_c   : out   std_logic;
          o_STM32_SPI_MOSI_c   : out   std_logic;
          o_STM32_SPI_Clk_c    : out   std_logic;
          i_RHD64_SPI_MISO_c_0 : in    std_logic;
          i_RHD64_SPI_MISO_c   : in    std_logic;
          o_RHD64_SPI_Clk_c    : out   std_logic;
          o_RHD64_SPI_MOSI_c   : out   std_logic;
          o_RHD64_SPI_CS_n_c   : out   std_logic;
          i_Rst_L_c            : in    std_logic;
          i_Clk_c              : in    std_logic
        );

end Controller_Headstage;

architecture DEF_ARCH of Controller_Headstage is 

  component DFN1E0
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component DFN1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component OR2
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

  component DFN1E1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component XOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR2B
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
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

  component AX1C
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

  component NOR3C
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component GND
    port( Y : out   std_logic
        );
  end component;

  component SPI_Master_CS_0_8_32_4
    port( int_STM32_TX_Byte  : in    std_logic_vector(31 downto 0) := (others => 'U');
          r_SM_CS_RNIVMVV1_0 : out   std_logic;
          o_STM32_SPI_Clk_c  : out   std_logic;
          o_STM32_SPI_MOSI_c : out   std_logic;
          int_STM32_TX_DV_0  : in    std_logic := 'U';
          i_Rst_L_c          : in    std_logic := 'U';
          i_Clk_c            : in    std_logic := 'U';
          o_STM32_SPI_CS_n_c : out   std_logic;
          int_STM32_TX_DV    : in    std_logic := 'U';
          N_6_0              : out   std_logic
        );
  end component;

  component AX1
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

  component VCC
    port( Y : out   std_logic
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

  component Controller_RHD64
    port( o_FIFO_Q             : out   std_logic_vector(31 downto 0);
          int_RHD64_TX_Byte    : in    std_logic_vector(15 downto 0) := (others => 'U');
          G_0_i_a2_0           : out   std_logic;
          G_3_0_0              : out   std_logic;
          int_FIFO_RE          : in    std_logic := 'U';
          o_RHD64_TX_Ready_i_1 : out   std_logic;
          int_RHD64_TX_DV      : in    std_logic := 'U';
          o_RHD64_SPI_CS_n_c   : out   std_logic;
          int_RHD64_TX_DV_0    : in    std_logic := 'U';
          o_RHD64_SPI_MOSI_c   : out   std_logic;
          o_RHD64_SPI_Clk_c    : out   std_logic;
          i_RHD64_SPI_MISO_c   : in    std_logic := 'U';
          i_RHD64_SPI_MISO_c_0 : in    std_logic := 'U';
          i_Rst_L_c            : in    std_logic := 'U';
          i_Clk_c              : in    std_logic := 'U'
        );
  end component;

  component DFN1C1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          CLR : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component OA1B
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

  component XA1C
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

    signal \int_STM32_TX_DV_0\, \int_STM32_TX_DV_RNIG8OO2\, 
        \int_RHD64_TX_DV_0\, N_10, int_N_5_0, G_0_i_a2_0, N_6_0, 
        \int_STM32_TX_DV\, G_3_0_0, \r_SM_CS_RNIVMVV1[1]\, 
        \int_STM32_TX_DV_RNI9N4J2\, 
        int_RHD64_TX_Byte_0_sqmuxa_0_a2_0, \state[1]_net_1\, 
        \state[0]_net_1\, \un1_int_rhd64_tx_byte8_2_i_o3_26[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_17[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_16[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_22[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_25[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_11[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_10[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_21[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_24[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_7[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_6[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_19[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_1[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_0[0]\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_14[0]\, \state[20]_net_1\, 
        \state[17]_net_1\, \un1_int_rhd64_tx_byte8_2_i_o3_13[0]\, 
        \state[12]_net_1\, \state[9]_net_1\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_9[0]\, \state[4]_net_1\, 
        \state[2]_net_1\, \un1_int_rhd64_tx_byte8_2_i_o3_5[0]\, 
        \state[22]_net_1\, \state[19]_net_1\, 
        \un1_int_rhd64_tx_byte8_2_i_o3_3[0]\, \state[13]_net_1\, 
        \state[16]_net_1\, \state[11]_net_1\, \state[14]_net_1\, 
        \state[15]_net_1\, \state[18]_net_1\, \state[5]_net_1\, 
        \state[8]_net_1\, \state[3]_net_1\, \state[6]_net_1\, 
        \state[7]_net_1\, \state[10]_net_1\, \state[29]_net_1\, 
        \state[31]_net_1\, \state[27]_net_1\, \state[30]_net_1\, 
        \state[21]_net_1\, \state[24]_net_1\, \state[25]_net_1\, 
        \state[28]_net_1\, \state[23]_net_1\, \state[26]_net_1\, 
        N_40, N_48, o_RHD64_TX_Ready_i_1, 
        int_RHD64_TX_Byte_0_sqmuxa, N_41, N_8, counter_e0, 
        \counter[0]_net_1\, int_rhd64_tx_byte8, N_49, 
        \int_RHD64_TX_DV\, N_50, \state_RNO[1]_net_1\, 
        counter_m2_0_a2_2, \counter[12]_net_1\, 
        \counter[13]_net_1\, counter_m2_0_a2_1, 
        \counter[11]_net_1\, \counter[10]_net_1\, 
        counter_m5_0_a2_6_1, \counter[4]_net_1\, 
        \counter[5]_net_1\, counter_m5_0_a2_6_0, 
        \counter[9]_net_1\, \counter[3]_net_1\, counter_m4_0_a2_5, 
        counter_m4_0_a2_2, counter_m4_0_a2_1, counter_m4_0_a2_3, 
        \counter[8]_net_1\, \counter[7]_net_1\, 
        \counter[2]_net_1\, \counter[6]_net_1\, 
        counter_m5_0_a2_5_0, counter_m5_0_a2_5, counter_m5_0_a2_6, 
        counter_c1, counter_c13, counter_n9, counter_n14, 
        \counter[14]_net_1\, counter_n13, counter_c11, 
        counter_n12, counter_n11, counter_c10, counter_n10, 
        counter_n8, counter_c6, counter_n7, counter_n6, 
        counter_c4, counter_n5, counter_n4, counter_c2, 
        counter_n3, counter_n2, counter_n1, \counter[1]_net_1\, 
        counter_n15, \counter[15]_net_1\, \int_FIFO_RE\, 
        \int_STM32_TX_Byte[0]_net_1\, \o_FIFO_Q[0]\, 
        \int_STM32_TX_Byte[1]_net_1\, \o_FIFO_Q[1]\, 
        \int_STM32_TX_Byte[2]_net_1\, \o_FIFO_Q[2]\, 
        \int_STM32_TX_Byte[3]_net_1\, \o_FIFO_Q[3]\, 
        \int_STM32_TX_Byte[4]_net_1\, \o_FIFO_Q[4]\, 
        \int_STM32_TX_Byte[5]_net_1\, \o_FIFO_Q[5]\, 
        \int_STM32_TX_Byte[6]_net_1\, \o_FIFO_Q[6]\, 
        \int_STM32_TX_Byte[7]_net_1\, \o_FIFO_Q[7]\, 
        \int_STM32_TX_Byte[8]_net_1\, \o_FIFO_Q[8]\, 
        \int_STM32_TX_Byte[9]_net_1\, \o_FIFO_Q[9]\, 
        \int_STM32_TX_Byte[10]_net_1\, \o_FIFO_Q[10]\, 
        \int_STM32_TX_Byte[11]_net_1\, \o_FIFO_Q[11]\, 
        \int_STM32_TX_Byte[12]_net_1\, \o_FIFO_Q[12]\, 
        \int_STM32_TX_Byte[13]_net_1\, \o_FIFO_Q[13]\, 
        \int_STM32_TX_Byte[14]_net_1\, \o_FIFO_Q[14]\, 
        \int_STM32_TX_Byte[15]_net_1\, \o_FIFO_Q[15]\, 
        \int_STM32_TX_Byte[16]_net_1\, \o_FIFO_Q[16]\, 
        \int_STM32_TX_Byte[17]_net_1\, \o_FIFO_Q[17]\, 
        \int_STM32_TX_Byte[18]_net_1\, \o_FIFO_Q[18]\, 
        \int_STM32_TX_Byte[19]_net_1\, \o_FIFO_Q[19]\, 
        \int_STM32_TX_Byte[20]_net_1\, \o_FIFO_Q[20]\, 
        \int_STM32_TX_Byte[21]_net_1\, \o_FIFO_Q[21]\, 
        \int_STM32_TX_Byte[22]_net_1\, \o_FIFO_Q[22]\, 
        \int_STM32_TX_Byte[23]_net_1\, \o_FIFO_Q[23]\, 
        \int_STM32_TX_Byte[24]_net_1\, \o_FIFO_Q[24]\, 
        \int_STM32_TX_Byte[25]_net_1\, \o_FIFO_Q[25]\, 
        \int_STM32_TX_Byte[26]_net_1\, \o_FIFO_Q[26]\, 
        \int_STM32_TX_Byte[27]_net_1\, \o_FIFO_Q[27]\, 
        \int_STM32_TX_Byte[28]_net_1\, \o_FIFO_Q[28]\, 
        \int_STM32_TX_Byte[29]_net_1\, \o_FIFO_Q[29]\, 
        \int_STM32_TX_Byte[30]_net_1\, \o_FIFO_Q[30]\, 
        \int_STM32_TX_Byte[31]_net_1\, \o_FIFO_Q[31]\, 
        \int_RHD64_TX_Byte[0]_net_1\, 
        \int_RHD64_TX_Byte[1]_net_1\, 
        \int_RHD64_TX_Byte[2]_net_1\, 
        \int_RHD64_TX_Byte[3]_net_1\, 
        \int_RHD64_TX_Byte[4]_net_1\, 
        \int_RHD64_TX_Byte[5]_net_1\, 
        \int_RHD64_TX_Byte[6]_net_1\, 
        \int_RHD64_TX_Byte[7]_net_1\, 
        \int_RHD64_TX_Byte[8]_net_1\, 
        \int_RHD64_TX_Byte[9]_net_1\, 
        \int_RHD64_TX_Byte[10]_net_1\, 
        \int_RHD64_TX_Byte[11]_net_1\, 
        \int_RHD64_TX_Byte[12]_net_1\, 
        \int_RHD64_TX_Byte[13]_net_1\, 
        \int_RHD64_TX_Byte[14]_net_1\, 
        \int_RHD64_TX_Byte[15]_net_1\, \GND\, \VCC\ : std_logic;

    for all : SPI_Master_CS_0_8_32_4
	Use entity work.SPI_Master_CS_0_8_32_4(DEF_ARCH);
    for all : Controller_RHD64
	Use entity work.Controller_RHD64(DEF_ARCH);
begin 


    \int_STM32_TX_Byte[11]\ : DFN1E0
      port map(D => \o_FIFO_Q[11]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[11]_net_1\);
    
    \state[0]\ : DFN1
      port map(D => N_8, CLK => i_Clk_c, Q => \state[0]_net_1\);
    
    \state[23]\ : DFN1
      port map(D => \state[23]_net_1\, CLK => i_Clk_c, Q => 
        \state[23]_net_1\);
    
    \state_RNIBVIND[2]\ : OR2
      port map(A => N_40, B => i_Rst_L_c, Y => N_41);
    
    int_RHD64_TX_DV_0 : DFN1E0
      port map(D => N_10, CLK => i_Clk_c, E => i_Rst_L_c, Q => 
        \int_RHD64_TX_DV_0\);
    
    \state_RNI92DS2[13]\ : OR3
      port map(A => \un1_int_rhd64_tx_byte8_2_i_o3_1[0]\, B => 
        \un1_int_rhd64_tx_byte8_2_i_o3_0[0]\, C => 
        \un1_int_rhd64_tx_byte8_2_i_o3_14[0]\, Y => 
        \un1_int_rhd64_tx_byte8_2_i_o3_22[0]\);
    
    \int_RHD64_TX_Byte[13]\ : DFN1E1
      port map(D => \counter[13]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[13]_net_1\);
    
    \state[29]\ : DFN1
      port map(D => \state[29]_net_1\, CLK => i_Clk_c, Q => 
        \state[29]_net_1\);
    
    \int_STM32_TX_Byte[14]\ : DFN1E0
      port map(D => \o_FIFO_Q[14]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[14]_net_1\);
    
    \int_STM32_TX_Byte[1]\ : DFN1E0
      port map(D => \o_FIFO_Q[1]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[1]_net_1\);
    
    \counter_RNO[11]\ : XOR2
      port map(A => counter_c10, B => \counter[11]_net_1\, Y => 
        counter_n11);
    
    \counter_RNI7I3H[4]\ : NOR2B
      port map(A => \counter[4]_net_1\, B => \counter[5]_net_1\, 
        Y => counter_m5_0_a2_6_1);
    
    \state_RNIIN3G6[2]\ : OR3
      port map(A => \un1_int_rhd64_tx_byte8_2_i_o3_17[0]\, B => 
        \un1_int_rhd64_tx_byte8_2_i_o3_16[0]\, C => 
        \un1_int_rhd64_tx_byte8_2_i_o3_22[0]\, Y => 
        \un1_int_rhd64_tx_byte8_2_i_o3_26[0]\);
    
    \state[10]\ : DFN1
      port map(D => \state[10]_net_1\, CLK => i_Clk_c, Q => 
        \state[10]_net_1\);
    
    \int_STM32_TX_Byte[0]\ : DFN1E0
      port map(D => \o_FIFO_Q[0]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[0]_net_1\);
    
    \counter[11]\ : DFN1E1C1
      port map(D => counter_n11, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[11]_net_1\);
    
    \int_STM32_TX_Byte[9]\ : DFN1E0
      port map(D => \o_FIFO_Q[9]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[9]_net_1\);
    
    \int_STM32_TX_Byte[4]\ : DFN1E0
      port map(D => \o_FIFO_Q[4]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[4]_net_1\);
    
    \state[6]\ : DFN1
      port map(D => \state[6]_net_1\, CLK => i_Clk_c, Q => 
        \state[6]_net_1\);
    
    \counter_RNIV93H[1]\ : NOR2B
      port map(A => \counter[0]_net_1\, B => \counter[1]_net_1\, 
        Y => counter_c1);
    
    \counter_RNO[15]\ : AX1C
      port map(A => \counter[14]_net_1\, B => counter_c13, C => 
        \counter[15]_net_1\, Y => counter_n15);
    
    \int_RHD64_TX_Byte[7]\ : DFN1E1
      port map(D => \counter[7]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[7]_net_1\);
    
    \counter_RNO[7]\ : XOR2
      port map(A => counter_c6, B => \counter[7]_net_1\, Y => 
        counter_n7);
    
    \counter[6]\ : DFN1E1C1
      port map(D => counter_n6, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[6]_net_1\);
    
    \state[31]\ : DFN1
      port map(D => \state[31]_net_1\, CLK => i_Clk_c, Q => 
        \state[31]_net_1\);
    
    \state_RNINIJT1[19]\ : OR3
      port map(A => \state[22]_net_1\, B => \state[19]_net_1\, C
         => \un1_int_rhd64_tx_byte8_2_i_o3_3[0]\, Y => 
        \un1_int_rhd64_tx_byte8_2_i_o3_16[0]\);
    
    \counter[3]\ : DFN1E1C1
      port map(D => counter_n3, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[3]_net_1\);
    
    \counter[2]\ : DFN1E1C1
      port map(D => counter_n2, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[2]_net_1\);
    
    \state_RNI56MGS[0]\ : NOR2
      port map(A => N_50, B => N_49, Y => N_10);
    
    \counter_RNO[8]\ : AX1C
      port map(A => \counter[7]_net_1\, B => counter_c6, C => 
        \counter[8]_net_1\, Y => counter_n8);
    
    \counter_RNO[13]\ : AX1C
      port map(A => \counter[12]_net_1\, B => counter_c11, C => 
        \counter[13]_net_1\, Y => counter_n13);
    
    \int_STM32_TX_Byte[7]\ : DFN1E0
      port map(D => \o_FIFO_Q[7]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[7]_net_1\);
    
    \state[4]\ : DFN1
      port map(D => \state[4]_net_1\, CLK => i_Clk_c, Q => 
        \state[4]_net_1\);
    
    \int_STM32_TX_Byte[16]\ : DFN1E0
      port map(D => \o_FIFO_Q[16]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[16]_net_1\);
    
    \counter_RNIJ9721[2]\ : NOR3C
      port map(A => \counter[2]_net_1\, B => \counter[7]_net_1\, 
        C => counter_m5_0_a2_5_0, Y => counter_m5_0_a2_5);
    
    \int_STM32_TX_Byte[3]\ : DFN1E0
      port map(D => \o_FIFO_Q[3]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[3]_net_1\);
    
    \counter_RNO[12]\ : XOR2
      port map(A => counter_c11, B => \counter[12]_net_1\, Y => 
        counter_n12);
    
    \state[7]\ : DFN1
      port map(D => \state[7]_net_1\, CLK => i_Clk_c, Q => 
        \state[7]_net_1\);
    
    \counter_RNO[1]\ : XOR2
      port map(A => \counter[0]_net_1\, B => \counter[1]_net_1\, 
        Y => counter_n1);
    
    \state_RNIHAHT1[17]\ : OR3
      port map(A => \state[20]_net_1\, B => \state[17]_net_1\, C
         => \un1_int_rhd64_tx_byte8_2_i_o3_13[0]\, Y => 
        \un1_int_rhd64_tx_byte8_2_i_o3_21[0]\);
    
    \state[14]\ : DFN1
      port map(D => \state[14]_net_1\, CLK => i_Clk_c, Q => 
        \state[14]_net_1\);
    
    \counter[4]\ : DFN1E1C1
      port map(D => counter_n4, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[4]_net_1\);
    
    \state[5]\ : DFN1
      port map(D => \state[5]_net_1\, CLK => i_Clk_c, Q => 
        \state[5]_net_1\);
    
    \counter[10]\ : DFN1E1C1
      port map(D => counter_n10, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[10]_net_1\);
    
    \int_STM32_TX_Byte[12]\ : DFN1E0
      port map(D => \o_FIFO_Q[12]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[12]_net_1\);
    
    \int_STM32_TX_Byte[27]\ : DFN1E0
      port map(D => \o_FIFO_Q[27]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[27]_net_1\);
    
    \int_STM32_TX_Byte[19]\ : DFN1E0
      port map(D => \o_FIFO_Q[19]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[19]_net_1\);
    
    GND_i : GND
      port map(Y => \GND\);
    
    \counter[13]\ : DFN1E1C1
      port map(D => counter_n13, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[13]_net_1\);
    
    \int_RHD64_TX_Byte[14]\ : DFN1E1
      port map(D => \counter[14]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[14]_net_1\);
    
    \counter_RNI1LBK[10]\ : NOR2B
      port map(A => \counter[11]_net_1\, B => \counter[10]_net_1\, 
        Y => counter_m2_0_a2_1);
    
    \int_STM32_TX_Byte[21]\ : DFN1E0
      port map(D => \o_FIFO_Q[21]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[21]_net_1\);
    
    \counter[12]\ : DFN1E1C1
      port map(D => counter_n12, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[12]_net_1\);
    
    \int_RHD64_TX_Byte[1]\ : DFN1E1
      port map(D => \counter[1]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[1]_net_1\);
    
    \state_RNICBRU[27]\ : OR2
      port map(A => \state[27]_net_1\, B => \state[30]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_5[0]\);
    
    \state_RNII23M1[2]\ : OR3
      port map(A => \state[4]_net_1\, B => \state[2]_net_1\, C
         => \un1_int_rhd64_tx_byte8_2_i_o3_5[0]\, Y => 
        \un1_int_rhd64_tx_byte8_2_i_o3_17[0]\);
    
    \int_STM32_TX_Byte[24]\ : DFN1E0
      port map(D => \o_FIFO_Q[24]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[24]_net_1\);
    
    \int_RHD64_TX_Byte[3]\ : DFN1E1
      port map(D => \counter[3]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[3]_net_1\);
    
    \counter_RNIGHAJ1[4]\ : NOR3C
      port map(A => counter_m5_0_a2_6_1, B => counter_m5_0_a2_6_0, 
        C => counter_c1, Y => counter_m5_0_a2_6);
    
    \counter_RNI4GT93[11]\ : NOR2B
      port map(A => counter_c10, B => \counter[11]_net_1\, Y => 
        counter_c11);
    
    SPI_Master_CS_STM32 : SPI_Master_CS_0_8_32_4
      port map(int_STM32_TX_Byte(31) => 
        \int_STM32_TX_Byte[31]_net_1\, int_STM32_TX_Byte(30) => 
        \int_STM32_TX_Byte[30]_net_1\, int_STM32_TX_Byte(29) => 
        \int_STM32_TX_Byte[29]_net_1\, int_STM32_TX_Byte(28) => 
        \int_STM32_TX_Byte[28]_net_1\, int_STM32_TX_Byte(27) => 
        \int_STM32_TX_Byte[27]_net_1\, int_STM32_TX_Byte(26) => 
        \int_STM32_TX_Byte[26]_net_1\, int_STM32_TX_Byte(25) => 
        \int_STM32_TX_Byte[25]_net_1\, int_STM32_TX_Byte(24) => 
        \int_STM32_TX_Byte[24]_net_1\, int_STM32_TX_Byte(23) => 
        \int_STM32_TX_Byte[23]_net_1\, int_STM32_TX_Byte(22) => 
        \int_STM32_TX_Byte[22]_net_1\, int_STM32_TX_Byte(21) => 
        \int_STM32_TX_Byte[21]_net_1\, int_STM32_TX_Byte(20) => 
        \int_STM32_TX_Byte[20]_net_1\, int_STM32_TX_Byte(19) => 
        \int_STM32_TX_Byte[19]_net_1\, int_STM32_TX_Byte(18) => 
        \int_STM32_TX_Byte[18]_net_1\, int_STM32_TX_Byte(17) => 
        \int_STM32_TX_Byte[17]_net_1\, int_STM32_TX_Byte(16) => 
        \int_STM32_TX_Byte[16]_net_1\, int_STM32_TX_Byte(15) => 
        \int_STM32_TX_Byte[15]_net_1\, int_STM32_TX_Byte(14) => 
        \int_STM32_TX_Byte[14]_net_1\, int_STM32_TX_Byte(13) => 
        \int_STM32_TX_Byte[13]_net_1\, int_STM32_TX_Byte(12) => 
        \int_STM32_TX_Byte[12]_net_1\, int_STM32_TX_Byte(11) => 
        \int_STM32_TX_Byte[11]_net_1\, int_STM32_TX_Byte(10) => 
        \int_STM32_TX_Byte[10]_net_1\, int_STM32_TX_Byte(9) => 
        \int_STM32_TX_Byte[9]_net_1\, int_STM32_TX_Byte(8) => 
        \int_STM32_TX_Byte[8]_net_1\, int_STM32_TX_Byte(7) => 
        \int_STM32_TX_Byte[7]_net_1\, int_STM32_TX_Byte(6) => 
        \int_STM32_TX_Byte[6]_net_1\, int_STM32_TX_Byte(5) => 
        \int_STM32_TX_Byte[5]_net_1\, int_STM32_TX_Byte(4) => 
        \int_STM32_TX_Byte[4]_net_1\, int_STM32_TX_Byte(3) => 
        \int_STM32_TX_Byte[3]_net_1\, int_STM32_TX_Byte(2) => 
        \int_STM32_TX_Byte[2]_net_1\, int_STM32_TX_Byte(1) => 
        \int_STM32_TX_Byte[1]_net_1\, int_STM32_TX_Byte(0) => 
        \int_STM32_TX_Byte[0]_net_1\, r_SM_CS_RNIVMVV1_0 => 
        \r_SM_CS_RNIVMVV1[1]\, o_STM32_SPI_Clk_c => 
        o_STM32_SPI_Clk_c, o_STM32_SPI_MOSI_c => 
        o_STM32_SPI_MOSI_c, int_STM32_TX_DV_0 => 
        \int_STM32_TX_DV_0\, i_Rst_L_c => i_Rst_L_c, i_Clk_c => 
        i_Clk_c, o_STM32_SPI_CS_n_c => o_STM32_SPI_CS_n_c, 
        int_STM32_TX_DV => \int_STM32_TX_DV\, N_6_0 => N_6_0);
    
    \state_RNO[1]\ : AX1
      port map(A => N_41, B => \state[0]_net_1\, C => 
        \state[1]_net_1\, Y => \state_RNO[1]_net_1\);
    
    \counter[15]\ : DFN1E1C1
      port map(D => counter_n15, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[15]_net_1\);
    
    \state[30]\ : DFN1
      port map(D => \state[30]_net_1\, CLK => i_Clk_c, Q => 
        \state[30]_net_1\);
    
    \state[21]\ : DFN1
      port map(D => \state[21]_net_1\, CLK => i_Clk_c, Q => 
        \state[21]_net_1\);
    
    int_STM32_TX_DV : DFN1E0
      port map(D => \int_STM32_TX_DV_RNIG8OO2\, CLK => i_Clk_c, E
         => i_Rst_L_c, Q => \int_STM32_TX_DV\);
    
    \int_RHD64_TX_Byte[11]\ : DFN1E1
      port map(D => \counter[11]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[11]_net_1\);
    
    \state_RNO_0[0]\ : NOR3B
      port map(A => \state[1]_net_1\, B => o_RHD64_TX_Ready_i_1, 
        C => \state[0]_net_1\, Y => N_48);
    
    \state[28]\ : DFN1
      port map(D => \state[28]_net_1\, CLK => i_Clk_c, Q => 
        \state[28]_net_1\);
    
    \state_RNIFBOU[15]\ : OR2
      port map(A => \state[15]_net_1\, B => \state[18]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_11[0]\);
    
    \state[12]\ : DFN1
      port map(D => \state[12]_net_1\, CLK => i_Clk_c, Q => 
        \state[12]_net_1\);
    
    VCC_i : VCC
      port map(Y => \VCC\);
    
    \counter_RNO[14]\ : XOR2
      port map(A => counter_c13, B => \counter[14]_net_1\, Y => 
        counter_n14);
    
    \counter_RNI999U3[13]\ : NOR3C
      port map(A => counter_m5_0_a2_5, B => counter_m2_0_a2_2, C
         => counter_m5_0_a2_6, Y => counter_c13);
    
    \counter[1]\ : DFN1E1C1
      port map(D => counter_n1, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[1]_net_1\);
    
    \int_RHD64_TX_Byte[5]\ : DFN1E1
      port map(D => \counter[5]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[5]_net_1\);
    
    \state_RNI9Q7N[3]\ : OR2
      port map(A => \state[3]_net_1\, B => \state[6]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_9[0]\);
    
    \counter_RNO[5]\ : XOR2
      port map(A => counter_c4, B => \counter[5]_net_1\, Y => 
        counter_n5);
    
    \counter_RNIG0LP[1]\ : NOR3C
      port map(A => \counter[1]_net_1\, B => \counter[0]_net_1\, 
        C => \counter[2]_net_1\, Y => counter_c2);
    
    \state_RNIDBQU[23]\ : OR2
      port map(A => \state[23]_net_1\, B => \state[26]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_0[0]\);
    
    \counter_RNO[3]\ : XOR2
      port map(A => counter_c2, B => \counter[3]_net_1\, Y => 
        counter_n3);
    
    \counter_RNIU4SR1[6]\ : NOR3C
      port map(A => \counter[5]_net_1\, B => counter_c4, C => 
        \counter[6]_net_1\, Y => counter_c6);
    
    \state[9]\ : DFN1
      port map(D => \state[9]_net_1\, CLK => i_Clk_c, Q => 
        \state[9]_net_1\);
    
    \counter[5]\ : DFN1E1C1
      port map(D => counter_n5, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[5]_net_1\);
    
    \int_STM32_TX_Byte[26]\ : DFN1E0
      port map(D => \o_FIFO_Q[26]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[26]_net_1\);
    
    \state[25]\ : DFN1
      port map(D => \state[25]_net_1\, CLK => i_Clk_c, Q => 
        \state[25]_net_1\);
    
    int_STM32_TX_DV_0 : DFN1E0
      port map(D => \int_STM32_TX_DV_RNIG8OO2\, CLK => i_Clk_c, E
         => i_Rst_L_c, Q => \int_STM32_TX_DV_0\);
    
    \counter_RNO[10]\ : AX1C
      port map(A => counter_m5_0_a2_5, B => counter_m5_0_a2_6, C
         => \counter[10]_net_1\, Y => counter_n10);
    
    int_STM32_TX_DV_RNI9N4J2 : OR3A
      port map(A => G_0_i_a2_0, B => \int_STM32_TX_DV\, C => 
        N_6_0, Y => \int_STM32_TX_DV_RNI9N4J2\);
    
    \counter_RNO_0[9]\ : NOR3C
      port map(A => counter_m4_0_a2_2, B => counter_m4_0_a2_1, C
         => counter_m4_0_a2_3, Y => counter_m4_0_a2_5);
    
    \state[27]\ : DFN1
      port map(D => \state[27]_net_1\, CLK => i_Clk_c, Q => 
        \state[27]_net_1\);
    
    \counter_RNO_1[9]\ : NOR2B
      port map(A => \counter[2]_net_1\, B => \counter[6]_net_1\, 
        Y => counter_m4_0_a2_2);
    
    \state_RNIC807E_0[0]\ : NOR3
      port map(A => \state[1]_net_1\, B => N_40, C => 
        \state[0]_net_1\, Y => int_rhd64_tx_byte8);
    
    \int_STM32_TX_Byte[13]\ : DFN1E0
      port map(D => \o_FIFO_Q[13]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[13]_net_1\);
    
    \int_RHD64_TX_Byte[9]\ : DFN1E1
      port map(D => \counter[9]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[9]_net_1\);
    
    Controller_RHD64_1 : Controller_RHD64
      port map(o_FIFO_Q(31) => \o_FIFO_Q[31]\, o_FIFO_Q(30) => 
        \o_FIFO_Q[30]\, o_FIFO_Q(29) => \o_FIFO_Q[29]\, 
        o_FIFO_Q(28) => \o_FIFO_Q[28]\, o_FIFO_Q(27) => 
        \o_FIFO_Q[27]\, o_FIFO_Q(26) => \o_FIFO_Q[26]\, 
        o_FIFO_Q(25) => \o_FIFO_Q[25]\, o_FIFO_Q(24) => 
        \o_FIFO_Q[24]\, o_FIFO_Q(23) => \o_FIFO_Q[23]\, 
        o_FIFO_Q(22) => \o_FIFO_Q[22]\, o_FIFO_Q(21) => 
        \o_FIFO_Q[21]\, o_FIFO_Q(20) => \o_FIFO_Q[20]\, 
        o_FIFO_Q(19) => \o_FIFO_Q[19]\, o_FIFO_Q(18) => 
        \o_FIFO_Q[18]\, o_FIFO_Q(17) => \o_FIFO_Q[17]\, 
        o_FIFO_Q(16) => \o_FIFO_Q[16]\, o_FIFO_Q(15) => 
        \o_FIFO_Q[15]\, o_FIFO_Q(14) => \o_FIFO_Q[14]\, 
        o_FIFO_Q(13) => \o_FIFO_Q[13]\, o_FIFO_Q(12) => 
        \o_FIFO_Q[12]\, o_FIFO_Q(11) => \o_FIFO_Q[11]\, 
        o_FIFO_Q(10) => \o_FIFO_Q[10]\, o_FIFO_Q(9) => 
        \o_FIFO_Q[9]\, o_FIFO_Q(8) => \o_FIFO_Q[8]\, o_FIFO_Q(7)
         => \o_FIFO_Q[7]\, o_FIFO_Q(6) => \o_FIFO_Q[6]\, 
        o_FIFO_Q(5) => \o_FIFO_Q[5]\, o_FIFO_Q(4) => 
        \o_FIFO_Q[4]\, o_FIFO_Q(3) => \o_FIFO_Q[3]\, o_FIFO_Q(2)
         => \o_FIFO_Q[2]\, o_FIFO_Q(1) => \o_FIFO_Q[1]\, 
        o_FIFO_Q(0) => \o_FIFO_Q[0]\, int_RHD64_TX_Byte(15) => 
        \int_RHD64_TX_Byte[15]_net_1\, int_RHD64_TX_Byte(14) => 
        \int_RHD64_TX_Byte[14]_net_1\, int_RHD64_TX_Byte(13) => 
        \int_RHD64_TX_Byte[13]_net_1\, int_RHD64_TX_Byte(12) => 
        \int_RHD64_TX_Byte[12]_net_1\, int_RHD64_TX_Byte(11) => 
        \int_RHD64_TX_Byte[11]_net_1\, int_RHD64_TX_Byte(10) => 
        \int_RHD64_TX_Byte[10]_net_1\, int_RHD64_TX_Byte(9) => 
        \int_RHD64_TX_Byte[9]_net_1\, int_RHD64_TX_Byte(8) => 
        \int_RHD64_TX_Byte[8]_net_1\, int_RHD64_TX_Byte(7) => 
        \int_RHD64_TX_Byte[7]_net_1\, int_RHD64_TX_Byte(6) => 
        \int_RHD64_TX_Byte[6]_net_1\, int_RHD64_TX_Byte(5) => 
        \int_RHD64_TX_Byte[5]_net_1\, int_RHD64_TX_Byte(4) => 
        \int_RHD64_TX_Byte[4]_net_1\, int_RHD64_TX_Byte(3) => 
        \int_RHD64_TX_Byte[3]_net_1\, int_RHD64_TX_Byte(2) => 
        \int_RHD64_TX_Byte[2]_net_1\, int_RHD64_TX_Byte(1) => 
        \int_RHD64_TX_Byte[1]_net_1\, int_RHD64_TX_Byte(0) => 
        \int_RHD64_TX_Byte[0]_net_1\, G_0_i_a2_0 => G_0_i_a2_0, 
        G_3_0_0 => G_3_0_0, int_FIFO_RE => \int_FIFO_RE\, 
        o_RHD64_TX_Ready_i_1 => o_RHD64_TX_Ready_i_1, 
        int_RHD64_TX_DV => \int_RHD64_TX_DV\, o_RHD64_SPI_CS_n_c
         => o_RHD64_SPI_CS_n_c, int_RHD64_TX_DV_0 => 
        \int_RHD64_TX_DV_0\, o_RHD64_SPI_MOSI_c => 
        o_RHD64_SPI_MOSI_c, o_RHD64_SPI_Clk_c => 
        o_RHD64_SPI_Clk_c, i_RHD64_SPI_MISO_c => 
        i_RHD64_SPI_MISO_c, i_RHD64_SPI_MISO_c_0 => 
        i_RHD64_SPI_MISO_c_0, i_Rst_L_c => i_Rst_L_c, i_Clk_c => 
        i_Clk_c);
    
    \state_RNI97QU[21]\ : OR2
      port map(A => \state[21]_net_1\, B => \state[24]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_3[0]\);
    
    \state[16]\ : DFN1
      port map(D => \state[16]_net_1\, CLK => i_Clk_c, Q => 
        \state[16]_net_1\);
    
    \int_STM32_TX_Byte[22]\ : DFN1E0
      port map(D => \o_FIFO_Q[22]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[22]_net_1\);
    
    \int_RHD64_TX_Byte[0]\ : DFN1E1
      port map(D => \counter[0]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[0]_net_1\);
    
    \counter_RNO_2[9]\ : NOR2B
      port map(A => \counter[4]_net_1\, B => \counter[3]_net_1\, 
        Y => counter_m4_0_a2_1);
    
    \int_RHD64_TX_Byte[10]\ : DFN1E1
      port map(D => \counter[10]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[10]_net_1\);
    
    \int_STM32_TX_Byte[29]\ : DFN1E0
      port map(D => \o_FIFO_Q[29]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[29]_net_1\);
    
    \counter_RNO_3[9]\ : NOR3C
      port map(A => \counter[5]_net_1\, B => \counter[8]_net_1\, 
        C => \counter[7]_net_1\, Y => counter_m4_0_a2_3);
    
    \state[13]\ : DFN1
      port map(D => \state[13]_net_1\, CLK => i_Clk_c, Q => 
        \state[13]_net_1\);
    
    \counter_RNO[6]\ : AX1C
      port map(A => \counter[5]_net_1\, B => counter_c4, C => 
        \counter[6]_net_1\, Y => counter_n6);
    
    \state[8]\ : DFN1
      port map(D => \state[8]_net_1\, CLK => i_Clk_c, Q => 
        \state[8]_net_1\);
    
    \state[20]\ : DFN1
      port map(D => \state[20]_net_1\, CLK => i_Clk_c, Q => 
        \state[20]_net_1\);
    
    \state[19]\ : DFN1
      port map(D => \state[19]_net_1\, CLK => i_Clk_c, Q => 
        \state[19]_net_1\);
    
    \int_STM32_TX_Byte[2]\ : DFN1E0
      port map(D => \o_FIFO_Q[2]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[2]_net_1\);
    
    \state_RNIHFQU[25]\ : OR2
      port map(A => \state[25]_net_1\, B => \state[28]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_1[0]\);
    
    \state[3]\ : DFN1
      port map(D => \state[3]_net_1\, CLK => i_Clk_c, Q => 
        \state[3]_net_1\);
    
    int_STM32_TX_DV_0_RNIOMCJ2 : OR3A
      port map(A => G_0_i_a2_0, B => \int_STM32_TX_DV_0\, C => 
        N_6_0, Y => int_N_5_0);
    
    \int_STM32_TX_Byte[8]\ : DFN1E0
      port map(D => \o_FIFO_Q[8]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[8]_net_1\);
    
    int_FIFO_RE : DFN1C1
      port map(D => \int_STM32_TX_DV_RNIG8OO2\, CLK => i_Clk_c, 
        CLR => i_Rst_L_c, Q => \int_FIFO_RE\);
    
    \counter[14]\ : DFN1E1C1
      port map(D => counter_n14, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[14]_net_1\);
    
    \state_RNIDKHJ3[5]\ : OR3
      port map(A => \un1_int_rhd64_tx_byte8_2_i_o3_11[0]\, B => 
        \un1_int_rhd64_tx_byte8_2_i_o3_10[0]\, C => 
        \un1_int_rhd64_tx_byte8_2_i_o3_21[0]\, Y => 
        \un1_int_rhd64_tx_byte8_2_i_o3_25[0]\);
    
    \int_RHD64_TX_Byte[15]\ : DFN1E1
      port map(D => \counter[15]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[15]_net_1\);
    
    \state_RNIB7OU[13]\ : OR2
      port map(A => \state[13]_net_1\, B => \state[16]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_14[0]\);
    
    \counter_RNI3LNV2[10]\ : NOR3C
      port map(A => counter_m5_0_a2_5, B => counter_m5_0_a2_6, C
         => \counter[10]_net_1\, Y => counter_c10);
    
    \state_RNIPTL9E[1]\ : OA1B
      port map(A => \state[1]_net_1\, B => N_40, C => 
        \int_RHD64_TX_DV\, Y => N_49);
    
    \counter_RNICN3H[8]\ : NOR2B
      port map(A => \counter[8]_net_1\, B => \counter[6]_net_1\, 
        Y => counter_m5_0_a2_5_0);
    
    \int_STM32_TX_Byte[5]\ : DFN1E0
      port map(D => \o_FIFO_Q[5]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[5]_net_1\);
    
    \counter_RNO[4]\ : AX1C
      port map(A => \counter[3]_net_1\, B => counter_c2, C => 
        \counter[4]_net_1\, Y => counter_n4);
    
    \int_STM32_TX_Byte[30]\ : DFN1E0
      port map(D => \o_FIFO_Q[30]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[30]_net_1\);
    
    \int_STM32_TX_Byte[18]\ : DFN1E0
      port map(D => \o_FIFO_Q[18]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[18]_net_1\);
    
    \state[24]\ : DFN1
      port map(D => \state[24]_net_1\, CLK => i_Clk_c, Q => 
        \state[24]_net_1\);
    
    \int_STM32_TX_Byte[15]\ : DFN1E0
      port map(D => \o_FIFO_Q[15]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[15]_net_1\);
    
    \int_STM32_TX_Byte[10]\ : DFN1E0
      port map(D => \o_FIFO_Q[10]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[10]_net_1\);
    
    \state_RNIFERU[29]\ : OR2
      port map(A => \state[29]_net_1\, B => \state[31]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_6[0]\);
    
    \state_RNI73OU[11]\ : OR2
      port map(A => \state[11]_net_1\, B => \state[14]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_13[0]\);
    
    \int_RHD64_TX_Byte[12]\ : DFN1E1
      port map(D => \counter[12]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[12]_net_1\);
    
    \int_STM32_TX_Byte[23]\ : DFN1E0
      port map(D => \o_FIFO_Q[23]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[23]_net_1\);
    
    \state[2]\ : DFN1
      port map(D => \state[2]_net_1\, CLK => i_Clk_c, Q => 
        \state[2]_net_1\);
    
    \counter_RNI6EN81[13]\ : NOR3C
      port map(A => \counter[12]_net_1\, B => \counter[13]_net_1\, 
        C => counter_m2_0_a2_1, Y => counter_m2_0_a2_2);
    
    \state[1]\ : DFN1
      port map(D => \state_RNO[1]_net_1\, CLK => i_Clk_c, Q => 
        \state[1]_net_1\);
    
    \counter[7]\ : DFN1E1C1
      port map(D => counter_n7, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[7]_net_1\);
    
    \state_RNI1I7N[0]\ : NOR2
      port map(A => \state[1]_net_1\, B => \state[0]_net_1\, Y
         => int_RHD64_TX_Byte_0_sqmuxa_0_a2_0);
    
    \state_RNIDU7N[5]\ : OR2
      port map(A => \state[5]_net_1\, B => \state[8]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_10[0]\);
    
    \state_RNICHQEE[0]\ : NOR2A
      port map(A => int_RHD64_TX_Byte_0_sqmuxa_0_a2_0, B => N_41, 
        Y => int_RHD64_TX_Byte_0_sqmuxa);
    
    \int_RHD64_TX_Byte[2]\ : DFN1E1
      port map(D => \counter[2]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[2]_net_1\);
    
    \state_RNIOUVQ[7]\ : OR2
      port map(A => \state[7]_net_1\, B => \state[10]_net_1\, Y
         => \un1_int_rhd64_tx_byte8_2_i_o3_7[0]\);
    
    \int_RHD64_TX_Byte[6]\ : DFN1E1
      port map(D => \counter[6]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[6]_net_1\);
    
    \counter_RNO[0]\ : XOR2
      port map(A => \counter[0]_net_1\, B => int_rhd64_tx_byte8, 
        Y => counter_e0);
    
    \int_STM32_TX_Byte[6]\ : DFN1E0
      port map(D => \o_FIFO_Q[6]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[6]_net_1\);
    
    \state_RNO[0]\ : XA1C
      port map(A => \state[0]_net_1\, B => N_41, C => N_48, Y => 
        N_8);
    
    \int_RHD64_TX_Byte[4]\ : DFN1E1
      port map(D => \counter[4]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[4]_net_1\);
    
    \counter_RNIAL3H[9]\ : NOR2B
      port map(A => \counter[9]_net_1\, B => \counter[3]_net_1\, 
        Y => counter_m5_0_a2_6_0);
    
    \state[22]\ : DFN1
      port map(D => \state[22]_net_1\, CLK => i_Clk_c, Q => 
        \state[22]_net_1\);
    
    \state[11]\ : DFN1
      port map(D => \state[11]_net_1\, CLK => i_Clk_c, Q => 
        \state[11]_net_1\);
    
    int_STM32_TX_DV_RNIG8OO2 : NOR3
      port map(A => \int_STM32_TX_DV\, B => G_3_0_0, C => 
        \r_SM_CS_RNIVMVV1[1]\, Y => \int_STM32_TX_DV_RNIG8OO2\);
    
    \state[18]\ : DFN1
      port map(D => \state[18]_net_1\, CLK => i_Clk_c, Q => 
        \state[18]_net_1\);
    
    \state_RNIC807E[0]\ : NOR3A
      port map(A => \state[0]_net_1\, B => \state[1]_net_1\, C
         => N_40, Y => N_50);
    
    \counter_RNILGOA1[4]\ : NOR3C
      port map(A => \counter[3]_net_1\, B => counter_c2, C => 
        \counter[4]_net_1\, Y => counter_c4);
    
    \state_RNIBMOFD[2]\ : OR3
      port map(A => \un1_int_rhd64_tx_byte8_2_i_o3_25[0]\, B => 
        \un1_int_rhd64_tx_byte8_2_i_o3_24[0]\, C => 
        \un1_int_rhd64_tx_byte8_2_i_o3_26[0]\, Y => N_40);
    
    \counter_RNO[2]\ : XOR2
      port map(A => counter_c1, B => \counter[2]_net_1\, Y => 
        counter_n2);
    
    \counter[9]\ : DFN1E1C1
      port map(D => counter_n9, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[9]_net_1\);
    
    \counter_RNO[9]\ : AX1C
      port map(A => counter_c1, B => counter_m4_0_a2_5, C => 
        \counter[9]_net_1\, Y => counter_n9);
    
    \int_RHD64_TX_Byte[8]\ : DFN1E1
      port map(D => \counter[8]_net_1\, CLK => i_Clk_c, E => 
        int_RHD64_TX_Byte_0_sqmuxa, Q => 
        \int_RHD64_TX_Byte[8]_net_1\);
    
    \state_RNICA3C3[7]\ : OR3
      port map(A => \un1_int_rhd64_tx_byte8_2_i_o3_7[0]\, B => 
        \un1_int_rhd64_tx_byte8_2_i_o3_6[0]\, C => 
        \un1_int_rhd64_tx_byte8_2_i_o3_19[0]\, Y => 
        \un1_int_rhd64_tx_byte8_2_i_o3_24[0]\);
    
    \counter[8]\ : DFN1E1C1
      port map(D => counter_n8, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        E => int_rhd64_tx_byte8, Q => \counter[8]_net_1\);
    
    \int_STM32_TX_Byte[28]\ : DFN1E0
      port map(D => \o_FIFO_Q[28]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[28]_net_1\);
    
    int_RHD64_TX_DV : DFN1E0
      port map(D => N_10, CLK => i_Clk_c, E => i_Rst_L_c, Q => 
        \int_RHD64_TX_DV\);
    
    \state[15]\ : DFN1
      port map(D => \state[15]_net_1\, CLK => i_Clk_c, Q => 
        \state[15]_net_1\);
    
    \int_STM32_TX_Byte[25]\ : DFN1E0
      port map(D => \o_FIFO_Q[25]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[25]_net_1\);
    
    \state[26]\ : DFN1
      port map(D => \state[26]_net_1\, CLK => i_Clk_c, Q => 
        \state[26]_net_1\);
    
    \int_STM32_TX_Byte[17]\ : DFN1E0
      port map(D => \o_FIFO_Q[17]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[17]_net_1\);
    
    \int_STM32_TX_Byte[31]\ : DFN1E0
      port map(D => \o_FIFO_Q[31]\, CLK => i_Clk_c, E => 
        \int_STM32_TX_DV_RNI9N4J2\, Q => 
        \int_STM32_TX_Byte[31]_net_1\);
    
    \counter[0]\ : DFN1C1
      port map(D => counter_e0, CLK => i_Clk_c, CLR => i_Rst_L_c, 
        Q => \counter[0]_net_1\);
    
    \state_RNI5T7I1[9]\ : OR3
      port map(A => \state[12]_net_1\, B => \state[9]_net_1\, C
         => \un1_int_rhd64_tx_byte8_2_i_o3_9[0]\, Y => 
        \un1_int_rhd64_tx_byte8_2_i_o3_19[0]\);
    
    \int_STM32_TX_Byte[20]\ : DFN1E0
      port map(D => \o_FIFO_Q[20]\, CLK => i_Clk_c, E => 
        int_N_5_0, Q => \int_STM32_TX_Byte[20]_net_1\);
    
    \state[17]\ : DFN1
      port map(D => \state[17]_net_1\, CLK => i_Clk_c, Q => 
        \state[17]_net_1\);
    

end DEF_ARCH; 

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

  component OUTBUF
    port( D   : in    std_logic := 'U';
          PAD : out   std_logic
        );
  end component;

  component Controller_Headstage
    port( o_STM32_SPI_CS_n_c   : out   std_logic;
          o_STM32_SPI_MOSI_c   : out   std_logic;
          o_STM32_SPI_Clk_c    : out   std_logic;
          i_RHD64_SPI_MISO_c_0 : in    std_logic := 'U';
          i_RHD64_SPI_MISO_c   : in    std_logic := 'U';
          o_RHD64_SPI_Clk_c    : out   std_logic;
          o_RHD64_SPI_MOSI_c   : out   std_logic;
          o_RHD64_SPI_CS_n_c   : out   std_logic;
          i_Rst_L_c            : in    std_logic := 'U';
          i_Clk_c              : in    std_logic := 'U'
        );
  end component;

  component CLKBUF
    port( PAD : in    std_logic := 'U';
          Y   : out   std_logic
        );
  end component;

  component INBUF
    port( PAD : in    std_logic := 'U';
          Y   : out   std_logic
        );
  end component;

  component VCC
    port( Y : out   std_logic
        );
  end component;

  component GND
    port( Y : out   std_logic
        );
  end component;

  component BUFF
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

    signal \VCC\, \GND\, i_Rst_L_c, i_Clk_c, o_STM32_SPI_Clk_c, 
        o_STM32_SPI_MOSI_c, o_STM32_SPI_CS_n_c, o_RHD64_SPI_Clk_c, 
        i_RHD64_SPI_MISO_c, o_RHD64_SPI_MOSI_c, 
        o_RHD64_SPI_CS_n_c, i_RHD64_SPI_MISO_c_0 : std_logic;

    for all : Controller_Headstage
	Use entity work.Controller_Headstage(DEF_ARCH);
begin 


    o_STM32_SPI_CS_n_pad : OUTBUF
      port map(D => o_STM32_SPI_CS_n_c, PAD => o_STM32_SPI_CS_n);
    
    Controller_Headstage_1 : Controller_Headstage
      port map(o_STM32_SPI_CS_n_c => o_STM32_SPI_CS_n_c, 
        o_STM32_SPI_MOSI_c => o_STM32_SPI_MOSI_c, 
        o_STM32_SPI_Clk_c => o_STM32_SPI_Clk_c, 
        i_RHD64_SPI_MISO_c_0 => i_RHD64_SPI_MISO_c_0, 
        i_RHD64_SPI_MISO_c => i_RHD64_SPI_MISO_c, 
        o_RHD64_SPI_Clk_c => o_RHD64_SPI_Clk_c, 
        o_RHD64_SPI_MOSI_c => o_RHD64_SPI_MOSI_c, 
        o_RHD64_SPI_CS_n_c => o_RHD64_SPI_CS_n_c, i_Rst_L_c => 
        i_Rst_L_c, i_Clk_c => i_Clk_c);
    
    o_RHD64_SPI_MOSI_pad : OUTBUF
      port map(D => o_RHD64_SPI_MOSI_c, PAD => o_RHD64_SPI_MOSI);
    
    o_RHD64_SPI_CS_n_pad : OUTBUF
      port map(D => o_RHD64_SPI_CS_n_c, PAD => o_RHD64_SPI_CS_n);
    
    i_Rst_L_pad : CLKBUF
      port map(PAD => i_Rst_L, Y => i_Rst_L_c);
    
    i_RHD64_SPI_MISO_pad : INBUF
      port map(PAD => i_RHD64_SPI_MISO, Y => i_RHD64_SPI_MISO_c);
    
    o_RHD64_SPI_Clk_pad : OUTBUF
      port map(D => o_RHD64_SPI_Clk_c, PAD => o_RHD64_SPI_Clk);
    
    VCC_i : VCC
      port map(Y => \VCC\);
    
    o_STM32_SPI_MOSI_pad : OUTBUF
      port map(D => o_STM32_SPI_MOSI_c, PAD => o_STM32_SPI_MOSI);
    
    o_STM32_SPI_Clk_pad : OUTBUF
      port map(D => o_STM32_SPI_Clk_c, PAD => o_STM32_SPI_Clk);
    
    GND_i : GND
      port map(Y => \GND\);
    
    i_RHD64_SPI_MISO_pad_RNI6BFA : BUFF
      port map(A => i_RHD64_SPI_MISO_c, Y => i_RHD64_SPI_MISO_c_0);
    
    i_Clk_pad : CLKBUF
      port map(PAD => i_Clk, Y => i_Clk_c);
    

end DEF_ARCH; 
