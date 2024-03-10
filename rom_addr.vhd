--============================================================================--
-- Design unit  : Rom_controller module
--
-- File name    : Brom.vhd
--
-- Purpose      : read data from rom
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

use work.ROM_Package.all;

entity Brom is
    generic(
        width : integer:= 32;
	depth : integer:= 162;
	addr  : integer:=8);
    
     Port ( 
        clk :     in STD_LOGIC;
        rst_n :   in STD_LOGIC;
        CE : in STD_LOGIC;							--enable reading
--	rom_addr: in std_logic_vector (addr-1 downto 0);
        rom_data_o :      out STD_LOGIC_VECTOR(width-1 downto 0);
        DataIn_NewValid : out STD_LOGIC
        );
end Brom;

architecture rtl of Brom is
  type ROM_ARRAY is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
  signal rom_Tmp : STD_LOGIC_VECTOR(width-1 downto 0);                       --ROM_ARRAY  := (others => (others => '0'));
  signal internal_DataIn_NewValid : std_logic := '0';
  signal rom_addr : unsigned (addr-1 downto 0) := (others => '0');
--   signal internal_reading : std_logic := '0';

begin

    process(clk, rst_n)
    begin
        if (rst_n = '0') then
            rom_data_o <= (others => '0');
            internal_DataIn_NewValid <= '0';
        elsif rising_edge(clk) then
            if CE = '1' then
		if to_integer(rom_addr) < depth-1 then
                   rom_Tmp <= ROM_CONTENT(to_integer(unsigned(rom_addr)));        -- read data from ROM_CONTENT, rom_addr is the address of ROM_CONTENT
                   rom_addr <= rom_addr + 1;                        -- increment the address
                    internal_DataIn_NewValid <= '1';
                else 
                    internal_DataIn_NewValid <= '0';
              end if;
	    else 
		    internal_DataIn_NewValid <= '0';
	    end if;
        end if;
    end process;
    process(internal_DataIn_NewValid)
    begin
	if (internal_DataIn_NewValid = '1') then
	rom_data_o <= rom_Tmp;
	DataIn_NewValid <= internal_DataIn_NewValid;
	else
	rom_data_o <= (others => '0');
	DataIn_NewValid <= internal_DataIn_NewValid;
	end if;
   end process;
end rtl;
