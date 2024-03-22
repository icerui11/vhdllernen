library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity dataio_controller_fsm_tb is
end dataio_controller_fsm_tb;

architecture test of dataio_controller_fsm_tb is

    signal clk : std_logic := '0';
    signal rst_n : std_logic := '1';
    signal ready : std_logic := '0';
    signal AwaitingConfig : std_logic := '0';
    signal finish : std_logic := '0';
    signal ready_Ext : std_logic := '0';
    signal forcestop : std_logic := '0';
    signal ram_en : std_logic;
    signal Datain_valid : std_logic;
 --   signal rom_addr : std_logic_vector(7 downto 0);
    signal rom_en : std_logic;
  --  type state_type is (idle, s0, s1, s2);
  --  signal curr_state, next_state : state_type;

begin
    
    uut: entity work.dataio_controller_fsm
        generic map (
            addr_width => 8,
            Rom_addr_depth => 128
        )
        port map (
            clk => clk,
            rst_n => rst_n,
            ready => ready,
            AwaitingConfig => AwaitingConfig,
            finish => finish,
            ready_Ext => ready_Ext,
            forcestop => forcestop,
            ram_en => ram_en,
            Datain_valid => Datain_valid,
  --          rom_addr => rom_addr,
            rom_en => rom_en
        );

    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    rst_process : process
    begin
        rst_n <= '0';
        wait for 20 ns;
        rst_n <= '1';
	wait for 400 ns;
        rst_n <= '0';
        wait for 30 ns;
        rst_n <= '1';
	wait;
    end process;

process
begin
     AwaitingConfig <= '1';
     wait for 40 ns;
     AwaitingConfig <= '0';
     wait for 80 ns;
     AwaitingConfig <= '1';
     wait for 30 ns;
     AwaitingConfig <= '0';
     wait for 270 ns;
     AwaitingConfig <= '1';
     wait for 80 ns;
     AwaitingConfig <= '0';
     wait for 370 ns;
     AwaitingConfig <= '1';
     wait for 80 ns;
     AwaitingConfig <= '0';
     wait for 4000 ns;
end process;

process
begin 
      ready_Ext <= '1';
      wait for 320 ns;
      ready_Ext <= '0';
      wait for 40 ns;      
      ready_Ext <= '1';
      wait for 80 ns;      
      ready_Ext <= '1';
      wait;
end process;

    test : process
    begin

        ready <= '0';
        wait for 40 ns;
        ready <= '1';
        
	wait for 800ns;
	forcestop <= '1';
	wait for 30ns;
	forcestop <= '0';
        wait for 400 ns;
        finish <= '1';
        
        
        wait for 100 ns;
        assert false report "Simulation finished" severity note;
        wait;
    end process;
end test;
