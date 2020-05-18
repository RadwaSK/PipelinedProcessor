LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY ANDer IS

 PORT   (
	A,B:IN std_logic ;
	o : out std_logic
         ); 
  
END ANDer;

ARCHITECTURE struct OF ANDer IS


BEGIN
o <= A AND B;
END struct;
