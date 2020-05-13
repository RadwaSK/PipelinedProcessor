LIBRARY IEEE;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.std_logic_1164.all;

ENTITY FetMpd IS

PORT( Clk , stall : IN std_logic;
  IRFlag: IN std_logic_vector(1 DOWNTO 0);
  outRam: in std_logic_vector(15 DOWNTO 0);
  RegDest , MemPC ,PCRest , PCINT: IN std_logic_vector(31 DOWNTO 0); 
  IR : inOUT std_logic_vector(15 DOWNTO 0);
  JZStates  : inOUT std_logic_vector(1 DOWNTO 0); -- 00 intial value  01 waiting for validation  10 you are correct  11 you need to flush
  PC  : OUT std_logic_vector(31 DOWNTO 0);
  PCout : inOUT std_logic_vector(31 DOWNTO 0);
  Regdecoder : OUT std_logic_vector(2 DOWNTO 0)) ; 
END FetMpd;


ARCHITECTURE a_FetMpd OF FetMpd IS

COMPONENT Reg IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enable : IN std_logic;
 d : IN std_logic_vector(n-1 DOWNTO 0);
  q : OUT std_logic_vector(n-1 DOWNTO 0));

end COMPONENT ; 


COMPONENT MUX IS
GENERIC ( n : integer := 32);
PORT( val1 ,  val2 ,  val3 ,  val4 ,  val5 : IN std_logic_vector(n-1 DOWNTO 0);
    Sel : IN std_logic_vector(2 DOWNTO 0);
    Output : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

signal Rst  : std_logic;
signal PCin , mux1out , mux2out: std_logic_vector(31 DOWNTO 0);
signal selt1 , selt2 : std_logic_vector(2 DOWNTO 0);
signal temp : std_logic_vector(1 DOWNTO 0) := "00";
signal  FSM : integer := 0;
signal  FSM_INT : integer := 0;
BEGIN
IRReg : Reg port map (Clk , Rst , '1' ,outRam , IR );
PCReg : Reg generic map (32) port map (Clk , Rst , '1' ,PCin , PCout );
M1 : MUX port map( "00000000000000000000000000000000" , "00000000000000000000000000000000" , "00000000000000000000000000000001" , "00000000000000000000000000000001" , "00000000000000000000000000000001"  , selt1,mux1out);
M2 : MUX port map (PCRest , PCINT , PCout , RegDest , MemPC ,selt2 , mux2out );
PCin <= mux2out + mux1out ; 
PC <= PCin; 
JZStates <= temp;

--FOC Logic 
identifier : process( Clk , outRam , IRFlag )
begin
  
  if (FSM < 5 and (outRam = "0110110000000000"  or outRam = "0111000000000000" )) then FSM <= FSM + 1;
  else
  FSM <= 0 ;
    end if;


  if (stall= '1' or FSM_INT = 1 or 
   (FSM < 4 and (outRam = "0110110000000000"  or outRam = "0111000000000000" ))  ) then 
    selt1 <= "000" ;
    selt2 <= "010" ;
    FSM_INT <= 0 ; 
  --Reset
  elsif  (outRam = "1000100000000000"  and IRFlag = "00" ) then
    selt1 <= "000" ;
    selt2 <= "000" ;
    --INT
  elsif  (outRam = "1001100000000000"  and IRFlag = "00" ) then
    selt1 <= "000" ;
    selt2 <= "001" ;
    FSM_INT<= 1;
    -- RTI and RETs
    elsif  ((outRam = "0110110000000000"  or outRam = "0111000000000000" ) and IRFlag = "00" and FSM = 4) then
      selt1 <= "000" ;
      selt2 <= "100";

      -- CALL  and JMP
      elsif  (( outRam (15 downto 10) = "011001"  or outRam(15 downto 10) = "011010" ) and IRFlag = "00" ) then
        selt1 <= "000" ;
        selt2 <= "011";
        Regdecoder <= outRam (9 downto 7);
        --JZ Static predection 
      elsif  ( outRam (15 downto 10) = "011000"  and IRFlag = "00" ) then
        selt1 <= "010" ;
        selt2 <= "010";  
        temp <= "01" ;
  else 
    selt1 <= "010" ;
    selt2 <= "010";
  end if ;
        -- I'm correct So, continue 
        if temp = "10" then 
        temp <= "00";
        end if ;
        -- I'm not correct So, correct the sequence 
        if temp = "11" then 
        temp <= "00";
        selt1 <= "000" ;
        selt2 <= "011";
        end if ;


end process ; -- identifier

end a_FetMpd ;