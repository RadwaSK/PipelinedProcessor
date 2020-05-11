library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4x1 is
    Port ( SEL : in  STD_LOGIC_VECTOR (1 downto 0);     -- select input
           A   : in  STD_LOGIC_VECTOR (31 downto 0);     -- inputs
	   B   : in  STD_LOGIC_VECTOR (31 downto 0);
           C   : in  STD_LOGIC_VECTOR (31 downto 0);
           X   : out STD_LOGIC_VECTOR (31 downto 0));                        -- output
end mux_4x1;

architecture Behavioral of mux_4x1 is
begin
with SEL select
    X <= A when "00",
         B when "01",
         C when "10",
         "00000000000000000000000000000000"  when others;
end Behavioral;
