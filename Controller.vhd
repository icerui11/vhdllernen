--============================================================================--
-- Design unit  : Rom_controller module
--
-- File name    : Brom.vhd
--
-- Purpose      : read data from rom
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

use work.ROM_Package.all;

entity Brom is
    generic(
        width : integer:= 32;
	depth : integer:= 162;
	addr  : integer:=8);
    
     Port ( 
        CE : in STD_LOGIC;							--enable reading
	rom_addr: in std_logic_vector (addr-1 downto 0);
        rom_data_o :      out STD_LOGIC_VECTOR(width-1 downto 0);
        DataIn_NewValid : out STD_LOGIC
        );
end Brom;

architecture rtl of Brom is
  type ROM_ARRAY is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
    constant ROM_CONTENT: ROM_ARRAY := (
    0 => X"3A303230",
    1 => X"30303030",
    2 => X"34303030",
    3 => X"3046410D",
    4 => X"0A3A3230",
    5 => X"30303030",
    6 => X"30303746",
    7 => X"46453746",
    8 => X"46463746",
    9 => X"30303830",
    10 => X"46463830",
    11 => X"30313830",
    12 => X"30303746",
    13 => X"46443030",
    14 => X"46463030",
    15 => X"36303230",
    16 => X"32303530",
    17 => X"31303130",
    18 => X"34303030",
    19 => X"30303630",
    20 => X"32303230",
    21 => X"35303130",
    22 => X"31303042",
    23 => X"0D0A3A32",
    24 => X"30303032",
    25 => X"30303030",
    26 => X"30323033",
    27 => X"30343035",
    28 => X"30363037",
    29 => X"30383039",
    30 => X"30373036",
    31 => X"30353034",
    32 => X"30333032",
    33 => X"30313032",
    34 => X"30323033",
    35 => X"30343035",
    36 => X"30363037",
    37 => X"30383039",
    38 => X"30373036",
    39 => X"30353034",
    40 => X"30333032",
    41 => X"30323039",
    42 => X"300D0A3A",
    43 => X"32303030",
    44 => X"34303030",
    45 => X"31303130",
    46 => X"31383230",
    47 => X"32383330",
    48 => X"33383430",
    49 => X"34383338",
    50 => X"33303238",
    51 => X"32303138",
    52 => X"31303130",
    53 => X"30383038",
    54 => X"30433130",
    55 => X"31343138",
    56 => X"31433230",
    57 => X"32343143",
    58 => X"31383134",
    59 => X"31303043",
    60 => X"30383038",
    61 => X"31430D0A",
    62 => X"3A323030",
    63 => X"30363030",
    64 => X"30303430",
    65 => X"34303630",
    66 => X"38304130",
    67 => X"43304531",
    68 => X"30313230",
    69 => X"45304330",
    70 => X"41303830",
    71 => X"36303430",
    72 => X"34303230",
    73 => X"32303330",
    74 => X"34303530",
    75 => X"36303730",
    76 => X"38303930",
    77 => X"37303630",
    78 => X"35303430",
    79 => X"33303230",
    80 => X"3239460D",
    81 => X"0A3A3230",
    82 => X"30303830",
    83 => X"30303030",
    84 => X"30313031",
    85 => X"30313031",
    86 => X"30313031",
    87 => X"30313031",
    88 => X"30313031",
    89 => X"30313031",
    90 => X"30313031",
    91 => X"30313031",
    92 => X"30313031",
    93 => X"30313031",
    94 => X"30313031",
    95 => X"30313031",
    96 => X"30313031",
    97 => X"30313031",
    98 => X"30313031",
    99 => X"30313431",
    100 => X"0D0A3A32",
    101 => X"30303041",
    102 => X"30303030",
    103 => X"31303130",
    104 => X"31303130",
    105 => X"31303130",
    106 => X"31303130",
    107 => X"31303130",
    108 => X"31303130",
    109 => X"31303130",
    110 => X"31303130",
    111 => X"31303130",
    112 => X"31303130",
    113 => X"31303130",
    114 => X"31303130",
    115 => X"31303130",
    116 => X"31303130",
    117 => X"31303130",
    118 => X"31303132",
    119 => X"300D0A3A",
    120 => X"32303030",
    121 => X"43303030",
    122 => X"30313031",
    123 => X"30313031",
    124 => X"30313031",
    125 => X"30313031",
    126 => X"30313031",
    127 => X"30313031",
    128 => X"30313031",
    129 => X"30313031",
    130 => X"30313031",
    131 => X"30313031",
    132 => X"30313031",
    133 => X"30313031",
    134 => X"30313031",
    135 => X"30313031",
    136 => X"30313031",
    137 => X"30313031",
    138 => X"30300D0A",
    139 => X"3A323030",
    140 => X"30453030",
    141 => X"30303130",
    142 => X"31303130",
    143 => X"31303130",
    144 => X"31303130",
    145 => X"31303130",
    146 => X"31303130",
    147 => X"31303130",
    148 => X"31303130",
    149 => X"31303130",
    150 => X"31303130",
    151 => X"31303130",
    152 => X"31303130",
    153 => X"31303130",
    154 => X"31303130",
    155 => X"31303130",
    156 => X"31303130",
    157 => X"3145300D",
    158 => X"0A3A3030",
    159 => X"30303030",
    160 => X"30314646",
    161 => X"0D0A0000");
  signal rom_Tmp : STD_LOGIC_VECTOR(width-1 downto 0);                       --ROM_ARRAY  := (others => (others => '0'));
  signal internal_DataIn_NewValid : std_logic := '0';
-- signal rom_addr : unsigned (addr-1 downto 0) := (others => '0');
--   signal internal_reading : std_logic := '0';

begin

    process(CE,rom_addr)
    begin
    --    if (rst_n = '0') then
    --       rom_data_o <= (others => '0');
     --       internal_DataIn_NewValid <= '0';
      --  elsif rising_edge(clk) then
        if CE = '0' then
            internal_DataIn_NewValid <= '0';
		    rom_data_o <= (others => '0');
         elsif (to_integer(unsigned(rom_addr))) < (depth) then
                rom_Tmp <= ROM_CONTENT(to_integer(unsigned(rom_addr)));        -- read data from ROM_CONTENT, rom_addr is the address of ROM_CONTENT
                internal_DataIn_NewValid <= '1';
                else 
                    internal_DataIn_NewValid <= '0';
                    rom_Tmp <= (others => '0');
                
	 end if;
	end process;

    process(internal_DataIn_NewValid)
    begin
	if (internal_DataIn_NewValid = '1') then
	rom_data_o <= rom_Tmp;
	DataIn_NewValid <= internal_DataIn_NewValid;
	else
	rom_data_o <= (others => '0');
	DataIn_NewValid <= internal_DataIn_NewValid;
	end if;
   end process;
end rtl;
