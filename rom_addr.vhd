--============================================================================--
-- Design unit  : Rom_controller module
--
-- File name    : Brom_addr.vhd
--
-- Purpose      : generate address to read data
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

entity Brom_addr is
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
end Brom_addr;

architecture rtl of Brom_addr is
	signal address : unsigned(31 downto 0) := (others => '0');

begin

    process(clk, rst_n)
    begin
        if (rst_n = '0') then
	    address <= (others => '0');
        elsif rising_edge(clk) then
            if CE = '1' then
                    address <= address + 1;                        -- increment the address
            end if;
        end if;
    end process;
	
    process(address)
	begin
	rom_addr <= std_logic_vector(address(addr-1 downto 0));
    end process;
end rtl;