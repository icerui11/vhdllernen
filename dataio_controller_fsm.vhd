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
        ready_Ext :      in std_logic;
        forcestop :      in std_logic;
        ram_en :         out std_logic;
        Datain_valid :   out std_logic;
  --      rom_addr :       out std_logic_vector(addr_width-1 downto 0);
        rom_en :         out std_logic
	);
end dataio_controller_fsm;


architecture rtl of dataio_controller_fsm is
	type state_type is (idle, s0, s1, s2, s3);
    signal curr_state, next_state : state_type;
   
--    signal rom_addr_count : unsigned(addr_width-1 downto 0) := (others => '0');
    signal rom_en_temp : std_logic := '0';
    signal Datain_valid_temp : std_logic := '0';
    signal ram_en_temp : std_logic := '0';
begin

  process (clk, rst_n)
    begin 
    if rst_n = '0' then
      curr_state <= idle;
    elsif rising_edge(clk) then
      curr_state <= next_state;
    end if;
  end process;

    process (curr_state, ready, AwaitingConfig, finish, ready_Ext, forcestop)
      begin
         Datain_valid_temp <= '0';
         rom_en_temp <= '0';
         ram_en_temp <= '0';

        case curr_state is
            when idle =>
                  Datain_valid_temp <= '0';
                  rom_en_temp <= '0';
                  ram_en_temp <= '0';
--                  rom_addr_count <= (others => '0');
                if AwaitingConfig = '1' then
                    next_state <= s0;  
                elsif ready = '1' then
                    next_state <= s1;
		else
                    next_state <= idle;
                end if;
            when s0 =>                                      --configuration phase
                if forcestop = '1' then
                    next_state <= idle;
                elsif AwaitingConfig = '0' then
                    if ready = '1' then            --configuration is done, assert ready
                       next_state <= s1;
		    else 
                       next_state <= s0;
		    end if;
                 else 
                     next_state <= s0;
                end if;
            when s1 =>                                                 --raw datain phase
                if forcestop = '1' then
                   next_state <= idle;
             --   elsif rom_addr_count < Rom_addr_depth then
                elsif AwaitingConfig = '1' then
                    rom_en_temp <= '0';
                    ram_en_temp <= '0';
                    Datain_valid_temp <= '0';
                    next_state <= s0;
                else
                    rom_en_temp <= '1';
                    Datain_valid_temp <= '1';
                    next_state <= s2;
                end if;

            when s2 =>                                        --compressed dataout phase and raw datain
                if forcestop = '1' then
                    next_state <= idle;
                else
                  if finish = '0' then 
		             if ready_Ext= '0' then
                        ram_en_temp <= '0';                     --wait for ready_Ext
                        rom_en_temp <= '0';
                        Datain_valid_temp <= '0';
		                next_state <= s3;
                     else
		                ram_en_temp <= '1';
                        rom_en_temp <= '1';
                        Datain_valid_temp <= '1';
                          next_state <= s2;
                    end if;
                  else
		            next_state <= idle;
                    rom_en_temp <= '0';
                    Datain_valid_temp <= '0';
                    ram_en_temp <= '0';
                  end if;
	 	        end if;
	        when s3 =>                                          --wait for ready_Ext
		      if finish = '1' then
		        next_state <= idle;
		      elsif ready_Ext = '1' then
                         next_state <= s2;
                      else 
                         next_state <= s3;
                         rom_en_temp <= '0';
                         Datain_valid_temp <= '0';
                         ram_en_temp <= '0';
		      end if;
                when others =>
	              next_state <= idle;
            end case;
    end process;
    Datain_valid <= Datain_valid_temp;
    rom_en <= rom_en_temp;
    ram_en <= ram_en_temp;

 
end rtl;