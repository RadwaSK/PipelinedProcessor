library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DOC is
    Port ( 
           IR   : in  STD_LOGIC_VECTOR (15 downto 0);
           stall   : in  STD_LOGIC;
	   IRregin : in STD_LOGIC_VECTOR (1 downto 0);-- read from ir register
	   
-------------------------------------------------------------------
	Rsrc1:    out   STD_LOGIC_VECTOR(2 downto 0);
	Rsrc2:    out   STD_LOGIC_VECTOR(2 downto 0);
	Rdst:     out   STD_LOGIC_VECTOR(2 downto 0); 
	Rsrc1Sel: out   STD_LOGIC_VECTOR(1 downto 0); 
	Rsrc2Sel: out   STD_LOGIC;  
	Opcode:   out   STD_LOGIC_VECTOR(5 downto 0);    
	Opflag:   out   STD_LOGIC;
	extend:   out   STD_LOGIC_VECTOR(19 downto 0); 
	IRflag:   out   STD_LOGIC_VECTOR(1 downto 0) -- write in ir register
 );
end DOC;

architecture Behavioral of DOC is
begin
process( IR , stall, IRregin)
	begin

--registers in rst signal equal zero 
if(IR= "1000100000000000") then
IRflag <= "00";
end if;


 -- EA or immediate 
if (IRregin = "00" or IRregin="UU") then
--one operand
if (IR(15 downto 13)= "000") then
	Rdst <= IR(9 downto 7);
	Rsrc1 <= IR(9 downto 7);
	Opcode <= IR(15 downto 10);
	IRflag <= "00";
	Rsrc1Sel<= "00";
	Rsrc2Sel <= '0';
	--note this
	opflag <= '0';
	
-- two operand
elsif (IR(15 downto 13)= "001") then
	--swap 
	if (IR(12 downto 10) = "000" ) then
	Opcode <= IR(15 downto 10);
	Rdst <= IR(9 downto 7);
	Rsrc1 <= IR(3 downto 1);
	Rsrc2 <= IR(9 downto 7);---note this
	IRflag <= "00";
	opflag <= '0';
	Rsrc1Sel <= "00";
	Rsrc2Sel <= '0';
	-- add & sub & or & and 
	elsif (IR(12 downto 10) = "011" or IR(12 downto 10) = "100" or IR(12 downto 10) = "101" or IR(12 downto 10) = "001") then
	Opcode <= IR(15 downto 10);
	Rdst <= IR(9 downto 7);
	Rsrc2 <= IR(6 downto 4);
	Rsrc1 <= IR(3 downto 1);
	IRflag <= "00";
	opflag <= '0';
	Rsrc1Sel <= "00";
	Rsrc2Sel <= '0';
	--IADD 
	elsif(IR(12 downto 10) = "010") then
	Opcode <= IR(15 downto 10);
	Rsrc1 <= IR(3 downto 1);-- note this
	Rdst <= IR(9 downto 7);
	IRflag <= "01";-- note this
	Rsrc1Sel <= "00"; --see this 
	Rsrc2Sel <= '0';
	opflag <= '0';
	--SHL % SHR
	elsif ( IR(12 downto 10) = "110" or IR(12 downto 10) = "111") then
	Opcode <= IR(15 downto 10);
	Rdst <= IR(9 downto 7);
	Rsrc1 <= IR(9 downto 7);
	IRflag <= "01";-- note this
	opflag <= '1';
	Rsrc1Sel <= "00";
	Rsrc2Sel <= '0';
	end if ;
-- memory
elsif (IR(15 downto 13)= "010") then
	--push
	if(IR(12 downto 10) = "000") then
	Rdst <= IR(9 downto 7);
	Opcode <= IR(15 downto 10);
	IRflag <= "00";
	opflag <= '0' ;
	Rsrc1 <= IR( 9 downto 7);
	Rsrc1Sel <="00";
	Rsrc2sel <='0';
	--pop
	elsif( IR(12 downto 10) = "001") then
	Rdst <= IR(9 downto 7); 
	Opcode <= IR(15 downto 10);
	IRflag <= "00";
	opflag <= '0' ;
	Rsrc1Sel <="00";
	Rsrc2sel <='0';
	
	-- LDM
	elsif (IR(12 downto 10) = "010" ) then
	Opcode <= IR(15 downto 10);
	Rdst <= IR(9 downto 7);
	IRflag <= "01";-- note this
	opflag <= '0';
	--LDD 
	elsif (IR(12 downto 10) = "011" ) then
	Opcode <= IR(15 downto 10);
	Rdst <= IR(9 downto 7);
	extend <= IR(3 downto 0) & "0000000000000000";
	IRflag <= "10"; 
	Rsrc2Sel <= '1';
	opflag <= '0';
	--STD
	elsif (IR(12 downto 10) = "100") then
	Opcode <= IR(15 downto 10);
	Rdst <= IR(9 downto 7);
	Rsrc1 <= IR(9 downto 7);
	extend <= IR(3 downto 0) & "0000000000000000";
	IRflag <= "10"; 
	Rsrc2Sel <= '1';
	opflag <= '0';

	end if;
--branch 
elsif ( IR(15 downto 13) = "011" ) then
	--RTI & RET
	if(IR(12 downto 10)="011" or IR(12 downto 10)="100" ) then
	Opcode <= IR(15 downto 10);
	Rdst   <= IR(9 downto 7);
	opflag <= '0'; --note this
	IRflag <= "10";
	-- jmp ,jz
	elsif (IR(12 downto 10)="000" or IR(12 downto 10)="001" or IR(12 downto 10)="010") then
	Opcode <= IR(15 downto 10);
	Rdst   <= IR(9 downto 7);
	Rsrc1 <= IR(9 downto 7);
	opflag <= '0'; --note this
	IRflag <= "10";
	Rsrc1Sel <="00";
	end if;
	--input and output
elsif ( IR(15 downto 10) = "100110" ) then
	Opcode <= IR(15 downto 10);
	opflag <= '0'; --note this
	IRflag <= "00";	
	end if;

--immediate
elsif(IRregin = "01") then
extend <= "0000"& IR ;--note this
Rsrc2Sel <= '1';
IRflag <= "00";
-- effective address
elsif (IRregin = "10") then
extend <= "0000" & IR;
Rsrc2Sel <= '1';
opflag <= '0';
IRflag <= "00";
end if;
	


end process;
end Behavioral;
