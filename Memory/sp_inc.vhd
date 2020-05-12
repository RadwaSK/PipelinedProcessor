LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY spinc IS
PORT(
    sel : IN std_logic_vector(1 DOWNTO 0);
    sp : IN std_logic_vector(31 DOWNTO 0);
    spnew : OUT std_logic_vector(31 DOWNTO 0)
);

END ENTITY spinc;

ARCHITECTURE myspinc OF spinc IS

BEGIN
  
spnew <= sp when (Sel="00")
else sp-2 when (Sel="01")
else sp+2 when (Sel="10");

END myspinc;