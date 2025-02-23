LIBRARY IEEE;

USE IEEE.std_logic_1164.all;

ENTITY my_nDFF IS

GENERIC ( n : integer := 16);

PORT( Clk,Rst,enable : IN std_logic;
 d : IN std_logic_vector(n-1 DOWNTO 0);
  q : OUT std_logic_vector(n-1 DOWNTO 0));

END my_nDFF;

ARCHITECTURE a_my_nDFF OF my_nDFF IS

BEGIN

PROCESS (Clk,Rst,enable)

BEGIN

IF Rst = '1' THEN q <= (OTHERS=>'0');
--ELSIF Clk='1' THEN
--ELSIF (enable = '0' ) then null;
--clk'event
ELSIF (rising_edge(clk) and enable='1') then q <= d;
END IF;

END PROCESS;

END a_my_nDFF;