library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library BROM;
use BROM.ROM_Package.all;

entity TopLevel is
    Port (
        clk         : in  std_logic;
        rst_n       : in  std_logic;
        CE          : in  std_logic;
        rom_addr    : in  std_logic_vector(7 downto 0); -- Assuming 8-bit address for simplicity
        rom_data_o  : out std_logic_vector(31 downto 0) -- Assuming 32-bit data width
    );
end TopLevel;

architecture Behavioral of TopLevel is
    component Brom_data
        port(
            CE          : in  std_logic;
            rom_addr    : in  std_logic_vector(7 downto 0);
            clk         : in  std_logic;
            rst_n       : in  std_logic;
            rom_data_o  : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Instance of Brom_data
    begin
        U_Brom_data: Brom_data
        port map (
            CE => CE,
            rom_addr => rom_addr,
            clk => clk,
            rst_n => rst_n,
            rom_data_o => rom_data_o
        );
end Behavioral;
