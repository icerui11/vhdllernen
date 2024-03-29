--============================================================================--
-- Design unit  : Rom_controller module
--
-- File name    : Brom_data.vhd
--
-- Purpose      : read data from rom
--
-- Note         :
--
-- Library      : BROM
--
-- Author       : Rui Yin
--
-- Instantiates : 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library BROM;
use BROM.ROM_Package.all;

entity Brom_data is
    generic(
    width : integer:= 32;
	depth : integer:= 128;
	addr  : integer:=8);
    
     Port ( 
        CE :              in STD_LOGIC;							 
	    rom_addr:         in std_logic_vector (addr-1 downto 0);
	    clk:              in std_logic;
	    rst_n:            in std_logic;
        rom_data_o :      out STD_LOGIC_VECTOR(width-1 downto 0)
 --       DataIn_NewValid : out STD_LOGIC
        );
attribute syn_preserve : boolean;
attribute syn_preserve of rom_data_o : signal is true;
end Brom_data;

architecture rtl of Brom_data is
 -- type ROM_ARRAY is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
  
  signal rom_data_o_tmp : STD_LOGIC_VECTOR(width-1 downto 0) := (others => '0');

begin

    process(clk, rst_n, CE)
    begin
      if rising_edge(clk) then
        if(rst_n = '0') then
           rom_data_o_tmp <= (others => '0');
      else
            if CE = '1' then
              rom_data_o_tmp <= ROM_CONTENT(to_integer(unsigned(rom_addr)));        -- read data from ROM_CONTENT, rom_addr is the address of ROM_CONTENT
            else
              rom_data_o_tmp <= (others =>'0');
            end if;
        end if;
      end if;
     end process;
   rom_data_o <= rom_data_o_tmp;
end rtl;