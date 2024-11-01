library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller_Dual_SPI is
  generic (
    STM32_SPI_NUM_BITS_PER_PACKET : integer := 32;
    STM32_CLKS_PER_HALF_BIT : integer := 8;
    RHD64_SPI_NUM_BITS_PER_PACKET : integer := 16;
    RHD64_CLKS_PER_HALF_BIT : integer := 16
  );
  port (
    i_Rst_L        : in std_logic;
    i_Clk          : in std_logic;

    -- STM32 SPI Interface
    o_STM32_SPI_Clk      : out std_logic;
    i_STM32_SPI_MISO     : in  std_logic;
    o_STM32_SPI_MOSI     : out std_logic;
    o_STM32_SPI_CS_n     : out std_logic;

    -- RHD64 SPI Interface
    o_RHD64_SPI_Clk      : out std_logic;
    i_RHD64_SPI_MISO     : in  std_logic;
    o_RHD64_SPI_MOSI     : out std_logic;
    o_RHD64_SPI_CS_n     : out std_logic
  );
end entity Controller_Dual_SPI;

architecture RTL of Controller_Dual_SPI is

  -- Component declarations
  component Controller_Headstage is
    generic (
      STM32_SPI_NUM_BITS_PER_PACKET : integer := 32;
      STM32_CLKS_PER_HALF_BIT : integer := 8;
      RHD64_SPI_NUM_BITS_PER_PACKET : integer := 16;
      RHD64_CLKS_PER_HALF_BIT : integer := 16
    );
    port (
      i_Rst_L        : in std_logic;
      i_Clk          : in std_logic;
      o_STM32_SPI_Clk      : out std_logic;
      i_STM32_SPI_MISO     : in  std_logic;
      o_STM32_SPI_MOSI     : out std_logic;
      o_STM32_SPI_CS_n     : out std_logic;
      o_RHD64_SPI_Clk      : out std_logic;
      i_RHD64_SPI_MISO     : in  std_logic;
      o_RHD64_SPI_MOSI     : out std_logic;
      o_RHD64_SPI_CS_n     : out std_logic
    );
  end component;

begin
  -- Instantiate the Controller_Headstage module
  Controller_Headstage_1 : Controller_Headstage
    generic map (
      STM32_SPI_NUM_BITS_PER_PACKET => 32,
      STM32_CLKS_PER_HALF_BIT => 8,
      RHD64_SPI_NUM_BITS_PER_PACKET => 16,
      RHD64_CLKS_PER_HALF_BIT => 16
    )
    port map (
      i_Rst_L        => i_Rst_L,
      i_Clk          => i_Clk,
      o_STM32_SPI_Clk   => o_STM32_SPI_Clk,
      i_STM32_SPI_MISO  => i_STM32_SPI_MISO,
      o_STM32_SPI_MOSI  => o_STM32_SPI_MOSI,
      o_STM32_SPI_CS_n  => o_STM32_SPI_CS_n,

      o_RHD64_SPI_Clk   => o_RHD64_SPI_Clk,
      i_RHD64_SPI_MISO  => i_RHD64_SPI_MISO,
      o_RHD64_SPI_MOSI  => o_RHD64_SPI_MOSI,
      o_RHD64_SPI_CS_n  => o_RHD64_SPI_CS_n
      );

  -- Other signals and connections for STM32 and RHD64 SPI interfaces go here...

end architecture RTL;
