--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Sram_address_fsm_tb.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::SmartFusion2> <Die::M2S150TS> <Package::1152 FC>
-- Author: rui Yin
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Sram_address_fsm_tb IS
END Sram_address_fsm_tb;

ARCHITECTURE behavior OF Sram_address_fsm_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Sram_address_fsm
    PORT(
         clk : IN  std_logic;
         rst_n : IN  std_logic;
         CE : IN  std_logic;
         Eop : in STD_LOGIC;
         ready : IN  std_logic;
         finish : IN  std_logic;
         Datain_newvalid : OUT  std_logic;
         rom_addr : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
   
   --Inputs
   signal clk : std_logic := '0';
   signal rst_n : std_logic := '0';
   signal CE : std_logic := '0';
   signal Eop : STD_LOGIC :='0';
   signal ready : std_logic := '0';
   signal finish : std_logic := '0';

    --Outputs
   signal Datain_newvalid : std_logic;
   signal rom_addr : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN 

    -- Instantiate the Unit Under Test (UUT)
   uut: Sram_address_fsm PORT MAP (
          clk => clk,
          rst_n => rst_n,
          CE => CE,
          Eop => Eop,
          ready => ready,
          finish => finish,
          Datain_newvalid => Datain_newvalid,
          rom_addr => rom_addr
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
	
test_process : process
	begin
	 rst_n <= '0';
        wait for 40 ns; 
        rst_n <= '1';
        wait for 800 ns;
         rst_n <= '0';
        wait for 40 ns; 
        rst_n <= '1';
	wait;
        end process;
    -- Stimulus process
    stim_proc: process
    begin       
        -- initialize inputs
        CE <= '0';
        ready <= '0';
        finish <= '0';
        wait for clk_period*5;  -- Wait for 100 ns for global reset to finish
        
        CE <= '1';  -- Enable chip
        ready <= '1';  -- System is ready
        wait for clk_period*50;
        CE <= '0';
        wait for clk_period*5;
        -- Example scenario
        CE <= '1';  -- Enable chip
        ready <= '1';  -- System is ready
        finish <= '0';  -- Not finished yet
        wait for clk_period*178;  -- simulate for 200 ns
        
        -- Finish one cycle of operation
        finish <= '1';
        wait for clk_period*10;
        finish <= '0';  -- prepare for next operation
        -- Add more scenarios as needed
 --       wait for clk_period*10;
 --       finish <= '1';
        wait; -- will wait forever at the end of simulation
    end process;
process
begin 
     Eop <= '0';
     wait for clk_period*270;
     Eop <= '1';
     wait for clk_period*2;
     Eop <= '0';
     wait;
end process;
END;
