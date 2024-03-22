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

library src;
use src.ROM_Package.all;

entity Brom is
    generic(
    width : integer:= 32;
	depth : integer:= 128;
	addr  : integer:=8);
    
     Port ( 
        CE :              in STD_LOGIC;							--enable reading
	    rom_addr:         in std_logic_vector (addr-1 downto 0);
	    clk:              in std_logic;
	    rst_n:            in std_logic;
        rom_data_o :      out STD_LOGIC_VECTOR(width-1 downto 0);
        DataIn_NewValid : out STD_LOGIC
        );
attribute syn_preserve : boolean;
attribute syn_preserve of rom_data_o : signal is true;
end Brom;

architecture rtl of Brom is
  type ROM_ARRAY is array (0 to depth-1) of std_logic_vector(width-1 downto 0);

--  signal rom_Tmp : STD_LOGIC_VECTOR(width-1 downto 0);                       --ROM_ARRAY  := (others => (others => '0'));
  signal internal_DataIn_NewValid : std_logic := '0';
 -- signal rom_addr : unsigned (addr-1 downto 0) := (others => '0');
--   signal internal_reading : std_logic := '0';

begin

    process(clk, rst_n, CE)
    begin
      if(rst_n = '0') then
        rom_data_o <= (others => '0');
        internal_DataIn_NewValid <= '0';
        elsif rising_edge(clk) then
            if CE = '1' then
            --    elsif (to_integer(unsigned(rom_addr))) < (depth) then
              rom_data_o <= ROM_CONTENT(to_integer(unsigned(rom_addr)));        -- read data from ROM_CONTENT, rom_addr is the address of ROM_CONTENT
              internal_DataIn_NewValid <= '1';
	  --       else
		--       internal_DataIn_NewValid <= '0';
	     --      rom_Tmp <= (others => '0');
            end if;
        --    end if; 
        end if;
     end process;
 --  rom_data_o <= rom_Tmp;
   DataIn_NewValid <= internal_DataIn_NewValid;
end rtl;
