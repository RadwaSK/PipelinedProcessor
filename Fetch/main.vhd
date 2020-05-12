LIBRARY IEEE;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.std_logic_1164.all;

ENTITY CPU_main IS
PORT( Clk,Rst : IN std_logic;

      INport: in STD_LOGIC_VECTOR(31 downto 0);
	MemOutput:in   STD_LOGIC_VECTOR(31 downto 0);--??
	OpCodeOpflag: out STD_LOGIC_VECTOR(6 downto 0);
	Rsrc1Final : out STD_LOGIC_VECTOR(31 downto 0);
	Rsrc2Final : out STD_LOGIC_VECTOR(31 downto 0);
	PCreg2: out STD_LOGIC_VECTOR(31 downto 0);
	Rdstreg: out STD_LOGIC_VECTOR (2 downto 0);--enable ?
	EAReg:  out STD_LOGIC_VECTOR(31 downto 0);
	IregoutFetch: out STD_LOGIC_VECTOR (1 downto 0)
 ) ; 

END CPU_main;


ARCHITECTURE a_CPU_main OF CPU_main IS

component Decode_stage IS
port(
	IR : in STD_LOGIC_VECTOR(15 downto 0);
	PC : in STD_LOGIC_VECTOR(31 downto 0);
	INport: in STD_LOGIC_VECTOR(31 downto 0);
	stall : in STD_LOGIC;
	Clk,Rst: IN std_logic;
	MemOutput:in   STD_LOGIC_VECTOR(31 downto 0);--??
	

	OpCodeOpflag: out STD_LOGIC_VECTOR(6 downto 0);
	Rsrc1Final : out STD_LOGIC_VECTOR(31 downto 0);
	Rsrc2Final : out STD_LOGIC_VECTOR(31 downto 0);
	PCreg2: out STD_LOGIC_VECTOR(31 downto 0);
	Rdstreg: out STD_LOGIC_VECTOR (2 downto 0);--enable ?
	EAReg:  out STD_LOGIC_VECTOR(31 downto 0);
	IregoutFetch: out STD_LOGIC_VECTOR (1 downto 0)
	

);
END component;

COMPONENT ram IS
PORT (clk : IN std_logic;
--we : IN std_logic;
re : IN std_logic;
addr : IN std_logic_vector (31 DOWNTO 0); 
--datain : IN std_logic_vector(15 DOWNTO 0);
dataout : OUT std_logic_vector(15 DOWNTO 0); 
PCRest : OUT std_logic_vector(31 DOWNTO 0); 
PCINT : OUT std_logic_vector(31 DOWNTO 0)); 
end COMPONENT ; 

COMPONENT HDU IS
port ( RdstALU, RdstDec :   in std_logic_vector(2 downto 0);
RamInp :   in std_logic_vector(15 downto 0);
IRregin : in std_logic_vector (1 downto 0);
Asel, Bsel  :       out std_logic_vector (1 downto 0);
OpFlagBeforeALU, Stall    :   out std_logic);
end COMPONENT ; 

COMPONENT FetMpd IS 
PORT( Clk , stall : IN std_logic;
  IRFlag: IN std_logic_vector(1 DOWNTO 0);
  outRam: in std_logic_vector(15 DOWNTO 0);
  RegDest , MemPC ,PCRest , PCINT: IN std_logic_vector(31 DOWNTO 0); 
  IR : inOUT std_logic_vector(15 DOWNTO 0);
  JZStates  : inOUT std_logic_vector(1 DOWNTO 0); -- 00 intial value  01 waiting for validation  10 you are correct  11 you need to flush
  PC  : OUT std_logic_vector(31 DOWNTO 0);
  PCout : inOUT std_logic_vector(31 DOWNTO 0);
  Regdecoder : OUT std_logic_vector(2 DOWNTO 0)) ; -- to get red Dest at call and jmp 
end COMPONENT ; 

signal RegDest , MemPC , PCINT , PCRest , PCout , PC: std_logic_vector(31 DOWNTO 0);
signal RamOut , IR: std_logic_vector(15 DOWNTO 0);
signal RdstALU, RdstDec , Regdecoder: std_logic_vector(2 DOWNTO 0);
signal IRregin , Asel, Bsel , JZStates : std_logic_vector(1 DOWNTO 0);
signal Stall , OpFlagBeforeALU: std_logic;
begin 

Memory : ram port map (Clk , '1' , PCout , RamOut , PCINT , PCRest);
Fetch : FetMpd port map (Clk , Stall , IRregin , RamOut , RegDest , MemPC , PCRest , PCINT , IR , JZStates , PC , PCout ,Regdecoder );
Hazard_Detection : HDU port map (RdstALU, RdstDec , RamOut , IRregin , Asel, Bsel , OpFlagBeforeALU, Stall);
Decode :Decode_stage port map (IR , PC , INPort , stall ,Clk , Rst ,MemOutput ,OpCodeOpflag,Rsrc1Final,Rsrc2Final,PCreg2,Rdstreg,EAReg,IRregin);

end a_CPU_main ;