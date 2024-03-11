library IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Prom_tb is
GENERIC(
    addr_width : integer := 16384; -- store 128 elements (512 bytes)
    addr_bits  : integer := 14; -- required bits to store 128 elements
    data_width : integer := 32 -- each element has 32-bits
    );
end Prom_tb;

architecture arch of Prom_tb is
    signal addr : std_logic_vector(addr_bits-1 downto 0);
    signal data :  std_logic_vector(data_width-1 downto 0);
component prom is
 generic(
    addr_width : integer := 16384; -- store 128 elements (512 bytes)
    addr_bits  : integer := 14; -- required bits to store 128 elements
    data_width : integer := 32 -- each element has 32-bits
    );
  PORT(
    addr : IN std_logic_vector(addr_bits-1 downto 0);
    data : OUT std_logic_vector(data_width-1 downto 0)
    );
end component;
begin
DUT:prom
   generic map(
    addr_width => 16384, -- store 128 elements (512 bytes)
    addr_bits  => 14, -- required bits to store 128 elements
    data_width => 32 -- each element has 32-bits
    )
   port map(
	addr => addr,
        data => data);


  stimulus : process 
  begin
    wait for 100 ns;
	addr <= std_logic_vector(to_unsigned(to_integer(unsigned(addr)) + 1, addr'length));
    wait for 10 ns;
	addr <= addr;

    wait for 10ns;
  end process stimulus;
  
end arch;