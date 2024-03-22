--============================================================================--
-- Design unit  : Rom_controller module
--
-- File name    : Rom_top_tb.vhd
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

--use work.Brom.all;

entity Rom_top_tb is
    generic(
	width : integer:= 32;
	depth : integer:= 162;
	addr  : integer:=8);
end entity Rom_top_tb;

architecture rtl of Rom_top_tb is
    -- Signals
    signal clk : std_logic := '0';
    signal rst_n : std_logic := '0';
    signal CE : std_logic := '0';
    signal rom_data_o : std_logic_vector(31 downto 0);
    signal DataIn_NewValid : std_logic;

begin 
--instantiate the DUT
DUT : entity work.Rom_top(rtl)

        generic map (
            width => 32,
            depth => 162,
            addr  => 8
        )
        port map (
            clk => clk,
            rst_n => rst_n,
            CE => CE,
            rom_data_o => rom_data_o,
            DataIn_NewValid => DataIn_NewValid
        );
    clk_process : process
    begin
	wait for 10ns;
	clk <= '1';
	wait for 10ns;
	clk <= '0';

    end process;

 gen_CE: process
   begin
    CE <= '0';
    wait for 10 ns; 
    CE <= '1';
    wait for 10 ns;
    CE <= '1';
    wait;
end process;

gen_rst_n : process
    begin
	rst_n <= '1';
        wait for 10ns;
	rst_n <= '0';
        wait for 10ns;
        rst_n <= '1';
	wait for 3600ns;
	rst_n <= '1';
        wait;
    end process;

end rtl;
