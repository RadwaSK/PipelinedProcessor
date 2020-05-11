library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Address_Extend is
    Port ( Extendin : in  STD_LOGIC_VECTOR (19 downto 0);
           Extendout  : out STD_LOGIC_VECTOR (31 downto 0));
end Address_Extend;

architecture Behavioral of Address_Extend is
begin
   Extendout <= "000000000000" & Extendin;
end Behavioral;
