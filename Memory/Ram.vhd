LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

ENTITY ram IS
PORT (clk : IN std_logic;
w : IN std_logic;
en : IN std_logic;
addr : IN std_logic_vector (31 DOWNTO 0);
datain : IN std_logic_vector(31 DOWNTO 0);
dataout : OUT std_logic_vector(31 DOWNTO 0)
);
END ram;

ARCHITECTURE myram OF ram IS

type RamType is array(0 to 1048575) of std_logic_vector(31 downto 0);
signal ram_sig : RamType := (others => (others => '0'));
    
BEGIN

process(clk) is
begin
	if (rising_edge(clk) and en = '1') then
		if (w = '1') then
			ram_sig(to_integer(unsigned(addr))) <= datain; 
		else
			dataout <= ram_sig(to_integer(unsigned(addr)));
		end if;
	end if;
end process;

END myram;