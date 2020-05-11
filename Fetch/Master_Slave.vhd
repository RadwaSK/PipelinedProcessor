LIBRARY IEEE;
use ieee.numeric_std.all;
USE IEEE.std_logic_1164.all;

ENTITY M_S IS

GENERIC ( size : integer := 16);

PORT( Clk,Rst,enable : IN std_logic;
 d : IN std_logic_vector(size-1 DOWNTO 0);
  q : OUT std_logic_vector(size-1 DOWNTO 0));

END M_S;

ARCHITECTURE a_Reg OF M_S IS

COMPONENT Reg IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enable : IN std_logic;
 d : IN std_logic_vector(n-1 DOWNTO 0);
  q : OUT std_logic_vector(n-1 DOWNTO 0));

end COMPONENT ; 

signal temp : std_logic_vector(size-1 DOWNTO 0) ; 
signal notclk  : std_logic; 
BEGIN
notclk <= not Clk; 
Master : Reg generic map (size) port map (notclk , Rst , '1' ,d , temp );
Slave : Reg generic map (size) port map ( Clk , Rst , '1' ,temp , q );

END a_Reg;