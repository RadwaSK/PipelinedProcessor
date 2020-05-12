LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY MUX IS
PORT( val1 ,  val2 ,  val3 ,  val4 : IN std_logic_vector(31 DOWNTO 0);
    Sel : IN std_logic_vector(2 DOWNTO 0);
    Output : OUT std_logic_vector(31 DOWNTO 0));

END ENTITY MUX;

ARCHITECTURE my_MUX OF MUX IS

BEGIN
  
output<= val1 when (Sel="00" )
else val2 when (Sel="01" )
else val3 when (Sel="10" )  
else val4 when (Sel="11");

END my_MUX;




