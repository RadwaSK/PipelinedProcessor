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
	--enwrite:  in  STD_logic;

	Rsrc1v:   out  STD_LOGIC_VECTOR(31 downto 0);
	Rsrc2v:   out  STD_LOGIC_VECTOR(31 downto 0);
	--------------------------------------------
	Rsrc1vFetch: out  STD_LOGIC_VECTOR(31 downto 0);
	Rsrc2vFetch: out  STD_LOGIC_VECTOR(31 downto 0);
	-------------------------------------------
	f1 : out  STD_LOGIC_VECTOR(31 downto 0);

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
signal outR0 , outR1 , outR2 ,outR3,outR4,outR5,outR6,outR7 ,d1 ,d2 : std_logic_vector (31 downto 0);

BEGIN
-- decoder
decsrc1: decoder_3_8 port map (Rsrc1,'1',decsrc1out);
decsrc2: decoder_3_8 port map (Rsrc2,'1',decsrc2out);
decrdst: decoder_3_8 port map (Rdst,'1',decrdstout);

--R0
enrR0 <= (decsrc1out(0) or decsrc2out(0)) ;--and enread;
enwR0 <= decrdstout(0) ;--and enwrite;
R0: regtri port map(MemOutput,outR0, enwR0,enrR0,clk,rst );

--R1
enrR1 <= (decsrc1out(1) or decsrc2out(1));-- and enread;
enwR1 <= decrdstout(1) ;--and enwrite;
R1: regtri port map(MemOutput,outR1,enwR1,enrR1 ,clk,rst );

--R2
enrR2 <= (decsrc1out(2) or decsrc2out(2)) ;--and enread;
enwR2 <= decrdstout(2) ;--and enwrite;
R2: regtri port map(MemOutput,outR2, enwR2,enrR2 ,clk,rst );

--R3
enrR3 <= (decsrc1out(3) or decsrc2out(3)) ;--and enread;
enwR3 <= decrdstout(3) ;--and enwrite;
R3: regtri port map(MemOutput,outR3,enwR3,enrR3 ,clk,rst );

--R4
enrR4 <= (decsrc1out(4) or decsrc2out(4)) ;--and enread;
enwR4 <= decrdstout(4) ;--and enwrite;
R4: regtri port map(MemOutput,outR4,enwR4,enrR4 ,clk,rst );

--R5
enrR5 <= (decsrc1out(5) or decsrc2out(5)) ;--and enread;
enwR5 <= decrdstout(5) ;--and enwrite;
R5: regtri port map(MemOutput,outR5,enwR5,enrR5 ,clk,rst );

--R6
enrR6 <= (decsrc1out(6) or decsrc2out(6)) ;--and enread;
enwR6 <= decrdstout(6) ;--and enwrite;
R6: regtri port map(MemOutput,outR6,enwR6,enrR6 ,clk,rst );

--R7
enrR7 <= (decsrc1out(7) or decsrc2out(7)) ; --and enread;
enwR7 <= decrdstout(7) ; --and enwrite;
R7: regtri port map(MemOutput,outR7,enwR7,enrR7 ,clk,rst );

--Rsrc1
d1 <=   outR0 when Rsrc1="000" else
        outR1 when Rsrc1="001" else
        outR2 when Rsrc1="010" else
        outR3 when Rsrc1="011" else
	outR4 when Rsrc1="100" else
	outR5 when Rsrc1="101" else
	outR6 when Rsrc1="110" else
	outR7 when Rsrc1="111";

f1 <=   outR0 when RFetch="000" else
        outR1 when RFetch="001" else
        outR2 when RFetch="010" else
        outR3 when RFetch="011" else
	outR4 when RFetch="100" else
	outR5 when RFetch="101" else
	outR6 when RFetch="110" else
	outR7 when RFetch="111";

src1: my_nDFF generic map (N => 32) port map(Clk,Rst,'1',d1,Rsrc1v);
src1Fetch: my_nDFF generic map (N => 32) port map(Clk,Rst,'1',d1,Rsrc1vfetch);
--Rsrc2
d2 <=   outR0 when Rsrc2="000" else
	outR1 when Rsrc2="001" else
	outR2 when Rsrc2="010" else
	outR3 when Rsrc2="011" else
	outR4 when Rsrc2="100" else
	outR5 when Rsrc2="101" else
	outR6 when Rsrc2="110" else
	outR7 when Rsrc2="111";
src2: my_nDFF generic map (N => 32) port map(Clk,Rst,'1',d2,Rsrc2v);
src2fetch: my_nDFF generic map (N => 32) port map(Clk,Rst,'1',d2,Rsrc2vfetch);

END struct;
