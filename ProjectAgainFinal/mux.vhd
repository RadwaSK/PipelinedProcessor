LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY MUX IS
GENERIC ( n : integer := 32);
PORT( val1 ,  val2 ,  val3 ,  val4 ,  val5 : IN std_logic_vector(n-1 DOWNTO 0);
    Sel : IN std_logic_vector(2 DOWNTO 0);
    Output : OUT std_logic_vector(n-1 DOWNTO 0));

END ENTITY MUX;

ARCHITECTURE my_MUX OF MUX IS

BEGIN
  
output<= val1 when (Sel="000" )
else val2 when (Sel="001" )
else val3 when (Sel="010" )  
else val4 when (Sel="011")
else val5 when (Sel="100");


END my_MUX;




