--============================================================================--
-- Design unit  : bram module
--
-- File name    : Bram_addr.vhd
--
-- Purpose      : generate address to write data
--
-- Note         :
--
-- Library      : 
--
-- Author       : Rui Yin
--
-- Instantiates : 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity bram_addr_outnew is
    generic(
	width : integer:= 64;
	addr_depth : integer:=256;
	addr  : integer:=8);
    
     Port ( 
        clk : in STD_LOGIC;
        rst_n : in STD_LOGIC;
        finish :in std_logic;
        wen : in STD_LOGIC;
        dataout_newvalid : in std_logic;                                        --indicate when data output
	    ram_addr: out std_logic_vector (addr-1 downto 0)
    );
end bram_addr_outnew ;

architecture rtl of bram_addr_outnew  is
	signal address : unsigned(addr-1 downto 0) := (others => '0');

begin

    process(clk, rst_n, wen, finish)
    begin
	   if rising_edge(clk) then
          if rst_n = '0' then 
            address <= (others => '0');
          elsif ((address < addr_depth) and dataout_newvalid = '1') then
                address <= address + 1;
              elsif finish = '1' then
                address <= (others => '0'); 
	          else
                address <= address;  
              end if;
	   end if;
    end process;
	
	ram_addr <= std_logic_vector(address(addr-1 downto 0));
end rtl;