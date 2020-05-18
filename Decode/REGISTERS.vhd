LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY REGISTERS IS  
    PORT (Busin:INOUT std_logic_vector (15 DOWNTO 0);
	sel :in std_logic_vector(15 downto 0);
	  READendes :IN std_logic;
	  WRITEendes :IN std_logic;
	  READensou :IN std_logic;
	  WRITEensou :IN std_logic;
	  PCin :in std_logic ;
	  PCout :in std_logic;
	clk :in std_logic;
	rst :in std_logic
	    );   

END ENTITY REGISTERS;
ARCHITECTURE struct OF REGISTERS IS

COMPONENT decoder_3_8 IS

PORT( S : IN std_logic_vector(2 DOWNTO 0);
      en: IN std_logic;
    Output : OUT std_logic_vector(7 DOWNTO 0));

END COMPONENT ;
COMPONENT ANDer IS

 PORT   (
	A,B:IN std_logic ;
	o : out std_logic
         ); 
  
END COMPONENT;
COMPONENT regtri IS  
  PORT (buff1in : INout std_logic_vector(15 downto 0);
	   enwrite: in std_logic;
	   enread: in std_logic;
	  clk :in std_logic;
         rst :in std_logic );     

END COMPONENT regtri;

signal checksour,checkde,checkre,checkwr,checkwrde,checkrede,checkwrso,checkreso: std_logic_vector(7 downto 0);
signal PCWR,PCRE : std_logic;
BEGIN
de: decoder_3_8 port map (sel(2 downto 0),'1',checkde);
de2: decoder_3_8 port map (sel(8 downto 6),'1',checksour);
checkwrde(0)<=checksour(0) and WRITEensou;
checkwrso(0)<=checkde(0) and WRITEendes;
checkwr(0)<= checkwrso(0) or checkwrde(0);
checkreso(0)<=checksour(0)and READensou;
checkrede(0)<=checkde(0)and READendes;
checkre(0)<=checkreso(0) or checkrede(0);
R0: regtri port map(busin,checkwr(0),checkre(0),clk,rst);
checkwrde(1)<=checksour(1) and WRITEensou;
checkwrso(1)<=checkde(1) and WRITEendes;
checkwr(1)<= checkwrso(1) or checkwrde(1);
checkreso(1)<=checksour(1)and READensou;
checkrede(1)<=checkde(1)and READendes;
checkre(1)<=checkreso(1) or checkrede(1);
R1: regtri port map(busin,checkwr(1),checkre(1),clk,rst);
checkwrde(2)<=checksour(2) and WRITEensou;
checkwrso(2)<=checkde(2) and WRITEendes;
checkwr(2)<= checkwrso(2) or checkwrde(2);
checkreso(2)<=checksour(2)and READensou;
checkrede(2)<=checkde(2)and READendes;
checkre(2)<=checkreso(2) or checkrede(2);
R2: regtri port map(busin,checkwr(2),checkre(2),clk,rst);
checkwrde(3)<=checksour(3) and WRITEensou;
checkwrso(3)<=checkde(3) and WRITEendes;
checkwr(3)<= checkwrso(3) or checkwrde(3);
checkreso(3)<=checksour(3)and READensou;
checkrede(3)<=checkde(3)and READendes;
checkre(3)<=checkreso(3) or checkrede(3);
R3: regtri port map(busin,checkwr(3),checkre(3),clk,rst);
checkwrde(4)<=checksour(4) and WRITEensou;
checkwrso(4)<=checkde(4) and WRITEendes;
checkwr(4)<= checkwrso(4) or checkwrde(4);
checkreso(4)<=checksour(4)and READensou;
checkrede(4)<=checkde(4)and READendes;
checkre(4)<=checkreso(4) or checkrede(4);
R4: regtri port map(busin,checkwr(4),checkre(4),clk,rst);
checkwrde(5)<=checksour(5) and WRITEensou;
checkwrso(5)<=checkde(5) and WRITEendes;
checkwr(5)<= checkwrso(5) or checkwrde(5);
checkreso(5)<=checksour(5)and READensou;
checkrede(5)<=checkde(5)and READendes;
checkre(5)<=checkreso(5) or checkrede(5);
R5: regtri port map(busin,checkwr(5),checkre(5),clk,rst);
checkwrde(6)<=checksour(6) and WRITEensou;
checkwrso(6)<=checkde(6) and WRITEendes;
checkwr(6)<= checkwrso(6) or checkwrde(6);
checkreso(6)<=checksour(6)and READensou;
checkrede(6)<=checkde(6)and READendes;
checkre(6)<=checkreso(6) or checkrede(6);
R6: regtri port map(busin,checkwr(6),checkre(6),clk,rst);
checkwrde(7)<=checksour(7) and WRITEensou;
checkwrso(7)<=checkde(7) and WRITEendes;
checkwr(7)<= checkwrso(7) or checkwrde(7);
checkreso(7)<=checksour(7)and READensou;
checkrede(7)<=checkde(7)and READendes;
checkre(7)<=checkreso(7) or checkrede(7);
PCWR<=checkwr(7) or PCin;
PCRE<=checkre(7)or PCout;
R7PC: regtri port map(busin,PCWR,PCRE,clk,rst);
END struct;
