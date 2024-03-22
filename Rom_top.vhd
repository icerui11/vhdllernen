--============================================================================--
-- Design unit  : Rom_controller module
--
-- File name    : Rom_top.vhd
--
-- Purpose      : test
--
-- Note         :
--
-- Library      : shyloc_utils
--
-- Author       : Rui Yin
--
-- Instantiates : 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Rom_top is
    generic(
	width : integer:= 32;
	depth : integer:= 162;
	addr  : integer:=8);
Port ( 
        clk : in STD_LOGIC;
        rst_n : in STD_LOGIC;
        CE : in STD_LOGIC;
	rom_data_o :      out STD_LOGIC_VECTOR(width-1 downto 0);
        DataIn_NewValid : out STD_LOGIC
        );
end entity Rom_top;

architecture rtl of Rom_top is
  component Brom_addr is
    generic(
	width : integer:= 32;
	depth : integer:= 162;
	addr  : integer:=8);
     Port ( 
        clk : in STD_LOGIC;
        rst_n : in STD_LOGIC;
        CE : in STD_LOGIC;
	rom_addr: out std_logic_vector (addr-1 downto 0)
    );
end component;

   component Brom is
    port(
        clk : in std_logic;
        rst_n : in std_logic;
        CE : in std_logic;
        rom_addr: in std_logic_vector (addr-1 downto 0);
        rom_data_o : out std_logic_vector(width-1 downto 0);
        DataIn_NewValid : out std_logic
    );
    end component;    

-- Ports declaration
    signal rom_addr : STD_LOGIC_VECTOR(7 downto 0);
begin
    -- instantiate Brom_addr
U1:Brom_addr
	port map (
            clk => clk,
            rst_n => rst_n,
            CE => CE,
            rom_addr => rom_addr
        );
U2:Brom
        port map (
            clk => clk,
            rst_n => rst_n,
            CE => CE,
            rom_addr => rom_addr,
            rom_data_o => rom_data_o,
            DataIn_NewValid => DataIn_NewValid
        );

end rtl;

