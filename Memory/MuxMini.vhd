LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY MUXMINI IS
PORT( val1 ,  val2 : IN std_logic_vector(31 DOWNTO 0);
    Sel : IN std_logic;
    Output : OUT std_logic_vector(31 DOWNTO 0));

END ENTITY MUXMINI;

ARCHITECTURE my_MUX OF MUXMINI IS

BEGIN
  
output<= val1 when (Sel='0')
else val2 when (Sel='1');

END my_MUX;