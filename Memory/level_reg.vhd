LIBRARY IEEE;

USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;


ENTITY lvl_reg IS

GENERIC ( n : integer := 32);

PORT( Clk,Rst,enable : IN std_logic;
 d : IN std_logic_vector(n-1 DOWNTO 0);
 q : OUT std_logic_vector(n-1 DOWNTO 0));
END lvl_reg;

ARCHITECTURE mylvlreg OF lvl_reg IS

BEGIN

PROCESS (Clk,Rst,enable)

BEGIN

IF Rst = '1' THEN

    q <= x"00000000";

ELSIF (clk = '1' and enable = '1') then q <= d;

END IF;

END PROCESS;

END mylvlreg;