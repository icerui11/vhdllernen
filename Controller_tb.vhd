library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.ROM_Package.all;

entity Brom_tb is
end Brom_tb;

architecture tb of Brom_tb is
  -- Constants for testbench
  constant width : integer := 32;
  constant depth : integer := 162;
  constant addr  : integer := 8;
  
  -- Signals for testbench
  signal CE : std_logic := '0';
  signal rom_addr_tb: std_logic_vector (addr-1 downto 0);
  signal rom_data_o_tb : std_logic_vector(width-1 downto 0);
  signal DataIn_NewValid_tb : std_logic := '0';

  -- Component declaration
  component Brom is
    generic (
      width : integer;
      depth : integer;
      addr  : integer
    );
    port (
      CE : in std_logic;
      rom_addr: in std_logic_vector (addr-1 downto 0);
      rom_data_o : out std_logic_vector(width-1 downto 0);
      DataIn_NewValid : out std_logic
    );
  end component;

begin
  -- Instantiate Brom component
  UUT: Brom 
    generic map (
      width => width,
      depth => depth,
      addr  => addr
    )
    port map (
      CE => CE,
      rom_addr => rom_addr_tb,
      rom_data_o => rom_data_o_tb,
      DataIn_NewValid => DataIn_NewValid_tb
    );

    test_process : process
    begin
	wait for 40ns;
	CE <= '0';
	wait for 20ns;
	CE <= '1';
        wait;
    end process;
	
 process(CE)
begin
        if (CE = '0') then
	    rom_addr_tb <= (others => '0');
        
         elsif CE = '1' then
                    rom_addr_tb <= std_logic_vector(unsigned(rom_addr_tb) + 1);                        -- increment the address
           
        end if;
    end process;
  
end tb;

