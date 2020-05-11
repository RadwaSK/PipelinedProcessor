LIBRARY IEEE;

USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;


ENTITY Reg IS

PORT( Clk,Rst,enable : IN std_logic;
 d : IN std_logic_vector(31 DOWNTO 0);
 q : OUT std_logic_vector(31 DOWNTO 0));

END Reg;

ARCHITECTURE a_Reg OF Reg IS

BEGIN

PROCESS (Clk,Rst,enable)

BEGIN

IF Rst = '1' THEN

    q <= x"00000FFF";

ELSIF (rising_edge(clk) and enable = '1') then q <= d;

END IF;

END PROCESS;

END a_Reg;