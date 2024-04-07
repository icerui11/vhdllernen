--============================================================================--
-- Design unit  : datacontroller module
--
-- File name    : dataio_controller_fsm.vhd
--
-- Purpose      : control the data 
--
-- Note         :
--
-- Library      : 
--
-- Author       : Rui Yin


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity dataio_controller_fsm is
	generic (
		     addr_width     : integer := 8;
             Rom_addr_depth : integer := 128
	);
	port (
        clk :            in std_logic;
        rst_n :          in std_logic;
        ready :          in std_logic;
        AwaitingConfig : in std_logic;
        finish :         in std_logic;        
        forcestop :      in std_logic;
        Dataout_newvalid : in std_logic;
        reset_bram_addr : out std_logic;
        ram_en :         out std_logic
	);
end dataio_controller_fsm;


architecture rtl of dataio_controller_fsm is
	type state_type is (idle, s0, s1, s2, s3, Com_finish);
    signal curr_state, next_state : state_type;
    signal ram_en_temp : std_logic := '0';
    signal reset_bram_addr_temp : std_logic := '0';
begin

  process (clk, rst_n)
    begin 
      if rising_edge(clk) then
        if rst_n = '0' then
          curr_state <= idle;
        elsif forcestop = '1' then
          curr_state <= idle;
        else
          curr_state <= next_state;
        end if;
      end if;
    end process;

    process (curr_state, ready, AwaitingConfig, finish, Dataout_newvalid)
      begin
        case curr_state is
            when idle =>
                if AwaitingConfig = '1' then
                    next_state <= s0;  
                elsif ready = '1' then
                    next_state <= s1;
		else
                    next_state <= idle;
                end if;
            when s0 =>                                      --configuration phase
                if AwaitingConfig = '0' then
                    if ready = '1' then            --configuration is done, assert ready
                       next_state <= s1;
		                else 
                       next_state <= s0;
		                end if;
                 else 
                     next_state <= s0;
                end if;
            when s1 =>                                                 --raw datain phase
                if AwaitingConfig = '1' then
                    next_state <= s0;
                else
                    next_state <= s2;
                end if;

            when s2 =>                                        --compressed dataout phase and raw datain
              if finish = '0' then 		            
                 if Dataout_newvalid = '1' then   
                     next_state <= s2;
                 else
		                 next_state <= s3;                      --wait for Dataout_newvalid,no dataout
                 end if;
              else 
                  next_state <= Com_finish;
	 	          end if;
	        when s3 =>                                          --wait for Dataout_newvalid
		      if finish = '1' then
		        next_state <= Com_finish;                     
		      elsif Dataout_newvalid = '1' then
                         next_state <= s2;
                      else 
                         next_state <= s3;
		      end if;
            when Com_finish =>                                   --finish the whole compression process
               if AwaitingConfig = '1' then
                  next_state <= s0;
               else
                  next_state <= Com_finish;
               end if;
            
            when others =>
	              next_state <= idle;
            end case;
    end process;

reset_bram_addr_temp <= '1' when curr_state = Com_finish         --reset bram_addr when the whole compression process is finished
else '0';



process (clk)
begin
  if rising_edge(clk) then
     reset_bram_addr <= reset_bram_addr_temp;
  end if;
end process;


process (clk, rst_n)
begin
  if rising_edge(clk) then
    if rst_n = '0' then
      ram_en_temp <= '0';
    elsif ((curr_state = s2) and (Dataout_newvalid = '1'))  then                   --dont need finished signal because It has already been judged in the bram_addr module
      ram_en_temp <= '1';
    else
      ram_en_temp <= '0';
    end if;
  end if;
end process;

ram_en <= ram_en_temp;

end rtl;