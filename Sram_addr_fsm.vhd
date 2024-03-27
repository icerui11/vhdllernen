--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Sram_address_fsm.vhd
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Sram_address_fsm is
    generic(
	width : integer:= 32;
	depth : integer:= 128;
	addr  : integer:=7);
    
     Port ( 
        clk : in STD_LOGIC;
        rst_n : in STD_LOGIC;
        CE : in STD_LOGIC;
        Eop : in STD_LOGIC;
        ready : in std_logic;
        finish : in std_logic;
        Datain_newvalid : out std_logic;
	rom_addr: out std_logic_vector (addr-1 downto 0)
    );
end Sram_address_fsm;

architecture rtl of Sram_address_fsm is
	signal address : unsigned(addr-1 downto 0) := (others => '0');
    signal Datain_newvalid_temp : std_logic := '0';
    type state_type is (idle, write, write_done);
    signal current_state, next_state : state_type;
    signal Datain_complete : std_logic := '0';
begin
    process(clk, rst_n)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                current_state <= idle;
            else
              current_state <= next_state;
            end if;
        end if;
    end process;
    
    process(current_state, CE, ready, finish, Eop)
    begin
--        Datain_complete <= '0';
          case current_state is 
            when idle =>               --detemine if the new compression has arrived by finish signal
              Datain_complete <= '0';
              if finish = '0' then  
                if Datain_complete = '0' then                               --if the data is not complete then go to write state
                    next_state <= write;
                else
                    next_state <= write_done;
                end if;
              else
                Datain_complete <= '0';
                next_state <= idle;
              end if;
            when write =>
              if address >= (depth-1) then                            --when the ready high and address is greater than depth then go to complete state
                 Datain_complete <= '1';
                 next_state <= write_done;  
                elsif ready = '0' or finish = '1' then
                   next_state <= idle;                                                
                else                                         -- ready is high and finish low CE is high then go to write state
                   Datain_complete <= '0';
                   next_state <= write;                           --stay in write state, until the address is greater than depth-1
                end if;
            when write_done =>
              if Eop = '1' then
                next_state <= idle;
              else
                next_state <= write_done;
              end if;
            
            when others =>
                next_state <= idle;
          end case;
    end process;

address_inc: process(clk, rst_n, CE)
begin
    if rising_edge(clk) then
      if rst_n = '0' then
        address <= (others => '0');
        Datain_newvalid_temp <= '0';
      else
        if Datain_complete = '0' and  CE = '1' and next_state = write then
            if address >= (depth-1) then
              address <= (others => '0');
              Datain_newvalid_temp <= '0';
            elsif CE = '0' then
            address <= address;
            Datain_newvalid_temp <= '0';
            else
                address <= address + 1;
                Datain_newvalid_temp <= '1';
            end if;
        else
            address <= (others => '0');
            Datain_newvalid_temp <= '0';
        end if;
      end if;
    end if;
end process;

        rom_addr <= std_logic_vector(address(addr-1 downto 0));
        Datain_newvalid <= Datain_newvalid_temp;
end rtl;