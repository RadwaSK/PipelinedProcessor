LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY MUX_M IS
PORT( val1 ,  val2 ,  val3 ,  val4 : IN std_logic_vector(31 DOWNTO 0);
    Sel : IN std_logic_vector(1 DOWNTO 0);
    Output : OUT std_logic_vector(31 DOWNTO 0));

END ENTITY MUX_M;

ARCHITECTURE my_MUX OF MUX_M IS

BEGIN
  
output<= val1 when (Sel="00" )
else val2 when (Sel="01" )
else val3 when (Sel="10" )  
else val4 when (Sel="11");

END my_MUX;




