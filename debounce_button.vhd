------------------------------------------------------------------
-- Name        : debouncer.vhd
-- Description : Debounce push button
-- Designed by : RUI Yin
--            让forcestop signal在按下按钮时为1，松开按钮时为0 , 想让forcestop变成事实的低有效 
-- Date        : 17/03/2024
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity debouncer is
   port 
   (
      clk      : in std_logic;
      rst_n      : in std_logic;
      
      pbutton  : in std_logic;
      forcestop_db   : out std_logic
   );
end entity;

architecture rtl of debouncer is
-------------------------------------------------------------------------
-- Clock definitions
------------------------------------------------------------------------- 
  constant SYS_FREQ     : natural := 100_000;		-- Clock freq. in kHz
  constant SYS_PERIOD   : natural := 1_000_000/SYS_FREQ; 	 -- In nanosec., 10 nsec for 100MHz clock
  constant DIV_DEB      : natural := 500_000/SYS_PERIOD;     -- Clock divider for 500us from 100MHz
  constant DIV_DEB_W    : natural := integer(ceil(log2(real(DIV_DEB+1))));	        -- 计算计数器所需位宽

  
-------------------------------------------------------------------------
-- Size definitions
------------------------------------------------------------------------- 
  constant DEB_LEN		: natural := 32;			
  constant DEB_LEN_W	   : natural := integer(ceil(log2(real(DEB_LEN+1))));			
  constant DEB_THRES_LO	: natural := DEB_LEN/10;			                         --from low to aktive
  constant DEB_THRES_HI	: natural := 9*DEB_LEN/10;	                               --from aktive to low
   signal cnt_deb     : unsigned(DIV_DEB_W-1 downto 0);
   signal clk_en      : std_logic;
   signal cnt_threshold : unsigned(DEB_LEN_W-1 downto 0);
   signal pb_deb_i       : std_logic;
   signal pbutton_s   : std_logic;
   
begin
   
   -- downcounter for input clock freq. division   
   process (rst, clk)
   begin
      if (rst = '1') then
         cnt_deb <= (others => '0');
         clk_en   <= '0';
      elsif (rising_edge(clk)) then
         if (cnt_deb = 0) then
            cnt_deb <= to_unsigned(DIV_DEB, cnt_deb'length);
            clk_en   <= '1';                                                --sample value is only used to update during periods when clk_en is 1
         else  
            cnt_deb <= cnt_deb-1;                                           --each clk rising edge, cnt_deb decrease 1 before the counter equals 0
            clk_en   <= '0';                                            
         end if;  
      end if;
   end process;      

   -- sample pushbutton and debounce   
   process (rst, clk)
   begin
      if (rst = '1') then
         cnt_threshold <= (others => '0');
         pbutton_s     <= '0';
         pb_deb_i      <= '0';
      elsif (rising_edge(clk)) then
         pbutton_s     <= pbutton;
         if (pbutton_s = '1' and clk_en = '1') then
            if (cnt_threshold < (DEB_LEN-1) ) then
               cnt_threshold <= cnt_threshold + 1;
            end if;  
         end if;  
         if (pbutton_s = '0' and clk_en = '1') then
            if (cnt_threshold > 0 ) then
               cnt_threshold <= cnt_threshold - 1;
            end if;  
         end if;  
         
         -- Activate output with hysteresis
         if (pb_deb_i = '1' and (cnt_threshold > DEB_THRES_HI)) then               -- when the counter is greater than the threshold, the output is 0，because i want to make the forcestop signal low effective
            pb_deb_i <= '0';
         end if;
         if (pb_deb_i = '0' and (cnt_threshold < DEB_THRES_LO)) then
            pb_deb_i <= '1';
         end if;
      
      end if;
   end process;      
   
   forcestop_db <= pb_deb_i;                                                    --forcestop signal 
end rtl;