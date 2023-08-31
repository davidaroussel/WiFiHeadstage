----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Wed Aug 30 16:11:17 2023
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Controller_tb.vhd
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

entity Controller_tb is
end Controller_tb;

architecture behavioral of Controller_tb is

    constant SYSCLK_PERIOD : time := 100 ns; -- 10MHZ

    signal r_Clk : std_logic := '0';
    signal r_Rst_L : std_logic := '0';

    component SPI_Master
        -- ports
        port( 
            -- Inputs
            i_Rst_L : in std_logic;
            i_Clk : in std_logic;
            i_TX_Byte : in std_logic_vector(15 downto 0);
            i_TX_DV : in std_logic;
            i_SPI_MISO : in std_logic;

            -- Outputs
            o_TX_Ready : out std_logic;
            o_RX_DV : out std_logic;
            o_RX_Byte_Rising : out std_logic_vector(15 downto 0);
            o_RX_Byte_Falling : out std_logic_vector(15 downto 0);
            w : out std_logic_vector(7 downto 0);
            o_SPI_Clk : out std_logic;
            o_SPI_MOSI : out std_logic

            -- Inouts

        );
    end component;

begin

    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            NSYSRESET <= '0';
            wait for ( SYSCLK_PERIOD * 10 );
            
            NSYSRESET <= '1';
            wait;
        end if;
    end process;

    -- Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );

    -- Instantiate Unit Under Test:  SPI_Master
    SPI_Master_0 : SPI_Master
        -- port map
        port map( 
            -- Inputs
            i_Rst_L => NSYSRESET,
            i_Clk => SYSCLK,
            i_TX_Byte => (others=> '0'),
            i_TX_DV => '0',
            i_SPI_MISO => '0',

            -- Outputs
            o_TX_Ready =>  open,
            o_RX_DV =>  open,
            o_RX_Byte_Rising => open,
            o_RX_Byte_Falling => open,
            w => open,
            o_SPI_Clk =>  open,
            o_SPI_MOSI =>  open

            -- Inouts

        );

end behavioral;

