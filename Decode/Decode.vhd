LIBRARY IEEE;

USE IEEE.std_logic_1164.all;

ENTITY Decode IS
port(
	
	IR : in STD_LOGIC_VECTOR(15 downto 0);
	PC : in STD_LOGIC_VECTOR(31 downto 0);
	INport: in STD_LOGIC_VECTOR(31 downto 0);
	stall : in STD_LOGIC;
	Clk,Rst: IN std_logic;
  MemOutput:in   STD_LOGIC_VECTOR(31 downto 0);
  Rdstout : in  STD_LOGIC_VECTOR(2 downto 0);
  wr_en : in STD_LOGIC ; 

	RFetch:   in   STD_LOGIC_VECTOR(2 downto 0);

	OpCodeOpflag: out STD_LOGIC_VECTOR(6 downto 0);
	Rsrc1Final : out STD_LOGIC_VECTOR(31 downto 0);
	Rsrc2Final : out STD_LOGIC_VECTOR(31 downto 0);
	f1 : out  STD_LOGIC_VECTOR(31 downto 0);
	PCreg2: out STD_LOGIC_VECTOR(31 downto 0);
	Rdstreg: out STD_LOGIC_VECTOR (2 downto 0);--enable ?
	EAReg:  out STD_LOGIC_VECTOR(31 downto 0);
	IregoutFetch: out STD_LOGIC_VECTOR (1 downto 0);
  JZStates : inout STD_LOGIC_VECTOR (1 downto 0)
  
);
END Decode;

ARCHITECTURE use_DOC OF Decode IS

Component myrev_nDFF IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enable : IN std_logic;
 d : IN std_logic_vector(n-1 DOWNTO 0);
  q : OUT std_logic_vector(n-1 DOWNTO 0));
END Component myrev_nDFF;

Component mux_4x1 is
    Port ( SEL : in  STD_LOGIC_VECTOR (1 downto 0);     -- select input
           A   : in  STD_LOGIC_VECTOR (31 downto 0);     -- inputs
	   B   : in  STD_LOGIC_VECTOR (31 downto 0);
           C   : in  STD_LOGIC_VECTOR (31 downto 0);
           X   : out STD_LOGIC_VECTOR (31 downto 0));                        -- output
end component mux_4x1;

Component Address_Extend is
    Port ( Extendin : in  STD_LOGIC_VECTOR (19 downto 0);
           Extendout  : out STD_LOGIC_VECTOR (31 downto 0));
end Component Address_Extend;

Component mux_2x1 is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (31 downto 0);
           B   : in  STD_LOGIC_VECTOR (31 downto 0);
           X   : out STD_LOGIC_VECTOR (31 downto 0));
end Component mux_2x1;

Component my_nDFF IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enable : IN std_logic;
 d : IN std_logic_vector(n-1 DOWNTO 0);
  q : OUT std_logic_vector(n-1 DOWNTO 0));
END Component my_nDFF;

Component DOC is
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
end Component DOC;

component registerFile IS  
    PORT (
	Rsrc1:    in   STD_LOGIC_VECTOR(2 downto 0);
	Rsrc2:    in   STD_LOGIC_VECTOR(2 downto 0);
	Rdst:     in   STD_LOGIC_VECTOR(2 downto 0);
	MemOutput:in   STD_LOGIC_VECTOR(31 downto 0);

	--enread:   in  STD_Logic;
	--enwrite:  in  STD_logic;

	Rsrc1v:   out  STD_LOGIC_VECTOR(31 downto 0);
	Rsrc2v:   out  STD_LOGIC_VECTOR(31 downto 0);
	--------------------------------------------
	Rsrc1vFetch: out  STD_LOGIC_VECTOR(31 downto 0);
	Rsrc2vFetch: out  STD_LOGIC_VECTOR(31 downto 0);
	

	clk :     in   std_logic;
	rst :     in   std_logic

	    );
end component;

signal IRflagwire,IRreginwire , Rsrc1Selw :  STD_LOGIC_VECTOR(1 downto 0);
signal Rsrc1w,Rsrc2w,Rdstw : STD_LOGIC_VECTOR(2 downto 0);
signal Rsrc1vw,Rsrc2vw,RSRC1FINALw,RSRC2FINALw , EAaddressw,Rsrc1vFetchw,Rsrc2vFetchw,RSRC1FETCHFINALw,RSRC2FetchFINALw: STD_LOGIC_VECTOR(31 downto 0);
signal Rsrc2Selw , Opflagw: STD_LOGIC;
signal extendw : STD_LOGIC_VECTOR(19 downto 0); 
signal Opcodew : STD_LOGIC_VECTOR(5 downto 0);
signal Opfull : STD_LOGIC_VECTOR(6 downto 0);
--signal RdstFull : STD_LOGIC_VECTOR(4 downto 0);


BEGIN

xDOC: DOC port map(IR,stall,IRreginwire,Rsrc1w,Rsrc2w,Rdstw,Rsrc1Selw,Rsrc2Selw,Opcodew,Opflagw,extendw,IRflagwire);
IRFlagRegister: my_nDFF generic map (N => 2) port map(clk,rst,'1',IRflagwire,IRreginwire);
xregisterfile: registerFile port map(Rsrc1w,Rsrc2w,Rdstw,MemOutput,Rsrc1vw,Rsrc2vw,Rsrc1vFetchw,Rsrc2vFetchw,clk,rst);
-------------------------
--for fetch
Rsrc2muxfetch: mux_2x1 port map(Rsrc2Selw,Rsrc1vFetchw,EAaddressw,RSRC2FetchFINALw);
----------------------------------
Rsrc2mux: mux_2x1 port map(Rsrc2Selw,Rsrc2vw,EAaddressw,RSRC2FINALw);
Rsrc2RegFinal: myrev_nDFF generic map (N => 32) port map(clk,rst,'1',RSRC2FINALw,Rsrc2Final);

Addextend: Address_Extend port map (extendw,EAaddressw);
------------------------------------
--for fetch
Rsrc1muxfetch: mux_4x1 port map( Rsrc1Selw , Rsrc2vFetchw , PC , INport , RSRC1fetchFINALw );

-----------------------------------------

Rsrc1mux: mux_4x1 port map( Rsrc1Selw , Rsrc1vw , PC , INport , RSRC1FINALw );
Rsrc1RegFinal: myrev_nDFF generic map (N => 32) port map(clk,rst,'1',RSRC1FINALw,Rsrc1Final);

--registers
OpFull <= Opcodew & Opflagw;
Opcoderegister: myrev_nDFF generic map (N => 7) port map(clk,rst,'1',OpFull,OpCodeOpflag);

PCreg: myrev_nDFF generic map (N => 32) port map(clk,rst,'1',PC,PCreg2);

--
Rdstregister : myrev_nDFF generic map (N => 3) port map(clk,rst,'1',Rdstw,Rdstreg);
--
EAregister: myrev_nDFF generic map (N => 32) port map(clk,rst,'1',EAaddressw,EAReg);

END use_DOC;
