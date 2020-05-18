LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY registerFile IS  
    PORT (
	Rsrc1:    in   STD_LOGIC_VECTOR(2 downto 0);
	Rsrc2:    in   STD_LOGIC_VECTOR(2 downto 0);
	RFetch:   in   STD_LOGIC_VECTOR(2 downto 0);
	Rdst:     in   STD_LOGIC_VECTOR(2 downto 0);
	MemOutput:in   STD_LOGIC_VECTOR(31 downto 0);

	--enread:   in  STD_Logic;
	enwrite:  in  STD_logic;

	Rsrc1v:   out  STD_LOGIC_VECTOR(31 downto 0);
	Rsrc2v:   out  STD_LOGIC_VECTOR(31 downto 0);
	--------------------------------------------
	Rsrc1vFetch: out  STD_LOGIC_VECTOR(31 downto 0);
	Rsrc2vFetch: out  STD_LOGIC_VECTOR(31 downto 0);
	-------------------------------------------
	f1 : out  STD_LOGIC_VECTOR(31 downto 0);
	d1 : out  STD_LOGIC_VECTOR(31 downto 0);
	d2 : out  STD_LOGIC_VECTOR(31 downto 0);
	--------------------------------------------
	clk :     in   std_logic;
	rst :     in   std_logic

	    );   

END ENTITY registerFile;

ARCHITECTURE struct OF registerFile IS

COMPONENT decoder_3_8 IS

PORT( S : IN std_logic_vector(2 DOWNTO 0);
      en: IN std_logic;
    Output : OUT std_logic_vector(7 DOWNTO 0));

END COMPONENT ;


COMPONENT regtri IS  
    PORT (
	buff1in : IN std_logic_vector(31 downto 0);
	bufflout: out std_logic_vector(31 downto 0);

	enwrite: in std_logic;
	enread: in std_logic;

	 clk :in std_logic;
         rst :in std_logic );   

END COMPONENT regtri;

COMPONENT my_nDFF IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enable : IN std_logic;
 d : IN std_logic_vector(n-1 DOWNTO 0);
  q : OUT std_logic_vector(n-1 DOWNTO 0));

END COMPONENT my_nDFF;

signal decsrc1out ,decsrc2out , decrdstout: std_logic_vector(7 downto 0);
signal enwR0,enwR1 , enwR2 , enwR3 ,enwR4 ,enwR5,enwR6,enwR7: std_logic;
signal enrR0 , enrR1 , enrR2 , enrR3, enrR4 , enrR5 , enrR6 ,enrR7 : std_logic;
signal outR0 , outR1 , outR2 ,outR3,outR4,outR5,outR6,outR7 : std_logic_vector (31 downto 0);
 Signal s_clk : std_logic := '1';
BEGIN
-- decoder
decsrc1: decoder_3_8 port map (Rsrc1,'1',decsrc1out);
decsrc2: decoder_3_8 port map (Rsrc2,'1',decsrc2out);
decrdst: decoder_3_8 port map (Rdst,'1',decrdstout);

--R0
enrR0 <= (decsrc1out(0) or decsrc2out(0)) ;--and enread;
enwR0 <= decrdstout(0) and enwrite;
R0: regtri port map(MemOutput,outR0, enwR0,enrR0,clk,rst );

--R1
enrR1 <= (decsrc1out(1) or decsrc2out(1));-- and enread;
enwR1 <= decrdstout(1) and enwrite;
R1: regtri port map(MemOutput,outR1,enwR1,enrR1 ,clk,rst );

--R2
enrR2 <= (decsrc1out(2) or decsrc2out(2)) ;--and enread;
enwR2 <= decrdstout(2) and  enwrite;
R2: regtri port map(MemOutput,outR2, enwR2,enrR2 ,clk,rst );

--R3
enrR3 <= (decsrc1out(3) or decsrc2out(3)) ;--and enread;
enwR3 <= decrdstout(3) and enwrite;
R3: regtri port map(MemOutput,outR3,enwR3,enrR3 ,clk,rst );

--R4
enrR4 <= (decsrc1out(4) or decsrc2out(4)) ;--and enread;
enwR4 <= decrdstout(4) and enwrite;
R4: regtri port map(MemOutput,outR4,enwR4,enrR4 ,clk,rst );

--R5
enrR5 <= (decsrc1out(5) or decsrc2out(5)) ;--and enread;
enwR5 <= decrdstout(5) and enwrite;
R5: regtri port map(MemOutput,outR5,enwR5,enrR5 ,clk,rst );

--R6
enrR6 <= (decsrc1out(6) or decsrc2out(6)) ;--and enread;
enwR6 <= decrdstout(6) and enwrite;
R6: regtri port map(MemOutput,outR6,enwR6,enrR6 ,clk,rst );

--R7
enrR7 <= (decsrc1out(7) or decsrc2out(7)) ; --and enread;
enwR7 <= decrdstout(7) and enwrite;
R7: regtri port map(MemOutput,outR7,enwR7,enrR7 ,clk,rst );

s_Clk <= not S_Clk after 20 ps;
process (s_clk)
begin 
 if(clk='1') then
	if(Rsrc1="000")  then
	d1<=outR0;
	elsif (Rsrc1 ="001" ) then
	d1<=outR1;
	elsif (Rsrc1 ="010" ) then
	d1<=outR2;
	elsif (Rsrc1 ="011" ) then
	d1<=outR3;
	elsif (Rsrc1 ="100" ) then
	d1<=outR4;
	elsif (Rsrc1 ="101" ) then
	d1<=outR5;
	elsif (Rsrc1 ="110" ) then
	d1<=outR6;
	elsif (Rsrc1 ="111" ) then
	d1<=outR7;	
	end if;

	if(Rsrc2="000")  then
	d2<=outR0;
	elsif (Rsrc2 ="001" ) then
	d2<=outR1;
	elsif (Rsrc2 ="010" ) then
	d2<=outR2;
	elsif (Rsrc2 ="011" ) then
	d2<=outR3;
	elsif (Rsrc2 ="100" ) then
	d2<=outR4;
	elsif (Rsrc2 ="101" ) then
	d2<=outR5;
	elsif (Rsrc2 ="110" ) then
	d2<=outR6;
	elsif (Rsrc2 ="111" ) then
	d2<=outR7;	
	end if;
	
	if(RFetch="000")  then
	f1<=outR0;
	elsif (RFetch ="001" ) then
	f1<=outR1;
	elsif (RFetch ="010" ) then
	f1<=outR2;
	elsif (RFetch ="011" ) then
	f1<=outR3;
	elsif (RFetch ="100" ) then
	f1<=outR4;
	elsif (RFetch ="101" ) then
	f1<=outR5;
	elsif (RFetch ="110" ) then
	f1<=outR6;
	elsif (RFetch ="111" ) then
	f1<=outR7;	
	end if;
end if;
end process;

END struct;
