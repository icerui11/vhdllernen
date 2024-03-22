LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY debounce_tb IS
END debounce_tb;

ARCHITECTURE behavior OF debounce_tb IS 

    -- Component declaration for the unit under test (UUT)
    COMPONENT debounce
    PORT(
         clk : IN  std_logic;
         reset_n : IN  std_logic;
         button : IN  std_logic;
         forcestop_db : OUT  std_logic
        );
    END COMPONENT;

   --Clock period definitions
   constant clk_period : time := 20ns;

   -- Declare signals for testbench
   signal clk : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal button : std_logic := '0';
   signal forcestop_db : std_logic;

BEGIN
   -- Instantiate the Unit Under Test (UUT)
   uut: debounce PORT MAP (
      clk => clk,
      reset_n => reset_n,
      button => button,
      forcestop_db => forcestop_db
    );

   -- Clock process definitions
   clk_process :process
   begin
       clk <= '0';
       wait for clk_period/2;
       clk <= '1';
       wait for clk_period/2;
   end process;

   -- Stimulus process
   rst_proc: process
   begin       
      -- Reset initialization
      reset_n <= '0';
      wait for clk_period;
      reset_n <= '1';
       wait for 1000000*clk_period;
      reset_n <= '0';
       wait for 2000000*clk_period;
       reset_n <= '1';
	wait;

   end process;
   
   process
   begin
      -- Apply button signal
      button <= '1'; -- Initial value
      wait for 2000000*clk_period;    
      -- Test with button pressed
      button <= '0';
      wait for 2500000*clk_period; 
      -- Test with button released
      button <= '1';
      wait for 8000000*clk_period; 
      button <= '0';
      wait for 2000000*clk_period; 
      -- Test with button pressed again
      button <= '1';
      wait for 2000000*clk_period;
      button <= '0';
      wait for 1500000*clk_period;

      button <= '1';
      wait for 4000000*clk_period;
      button <= '0';
      wait for 10000000*clk_period;
      button <= '1';
      -- End of simulation
      wait;
   end process;
END;
