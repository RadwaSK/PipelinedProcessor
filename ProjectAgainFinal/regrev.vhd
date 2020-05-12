LIBRARY IEEE;

USE IEEE.std_logic_1164.all;

ENTITY myrev_nDFF IS

GENERIC ( n : integer := 16);

PORT( Clk,Rst,enable : IN std_logic;
 d : IN std_logic_vector(n-1 DOWNTO 0);
  q : OUT std_logic_vector(n-1 DOWNTO 0));

END myrev_nDFF;

ARCHITECTURE a_my_nDFF OF myrev_nDFF IS

BEGIN

PROCESS (Clk,Rst,enable)

BEGIN

IF Rst = '1' THEN q <= (OTHERS=>'0');
ELSIF (falling_edge(clk) and enable='1') then q <= d;
END IF;

END PROCESS;

END a_my_nDFF;
