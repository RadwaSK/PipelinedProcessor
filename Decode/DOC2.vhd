library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DOC is
    Port ( 
           IR   : in  STD_LOGIC_VECTOR (15 downto 0);
           stall   : in  STD_LOGIC;
	   IRregin : in STD_LOGIC_VECTOR (1 downto 0);
	   
-------------------------------------------------------------------
	Rsrc1:    out   STD_LOGIC_VECTOR(2 downto 0);
	Rsrc2:    out   STD_LOGIC_VECTOR(2 downto 0);
	Rdst:     out   STD_LOGIC_VECTOR(2 downto 0); 
	Rsrc1Sel: out   STD_LOGIC_VECTOR(1 downto 0); 
	Rsrc2Sel: out   STD_LOGIC;  
	Opcode:   out   STD_LOGIC_VECTOR(5 downto 0);    
	Opflag:   out   STD_LOGIC;
	extend:   out   STD_LOGIC_VECTOR(19 downto 0); 
	IRflag:   out   STD_LOGIC_VECTOR(1 downto 0)
 );
end DOC;

architecture Behavioral of DOC is
begin


end Behavioral;
