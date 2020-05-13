LIBRARY IEEE;
use ieee.std_logic_1164.all; use ieee.std_logic_unsigned.all; use std.textio.all;USE IEEE.numeric_std.all;

ENTITY ram IS

PORT (clk : IN std_logic;
re : IN std_logic;
addr : IN std_logic_vector (31 DOWNTO 0); 
dataout : OUT std_logic_vector(15 DOWNTO 0); 
PCRest : OUT std_logic_vector(31 DOWNTO 0); 
PCINT : OUT std_logic_vector(31 DOWNTO 0); 

dataout_Stack: OUT std_logic_vector(31 DOWNTO 0); 
addrSTC  , datain : in std_logic_vector(31 DOWNTO 0); 
we , ram_en: IN std_logic );
END ram;


ARCHITECTURE sync_ram_a OF ram IS
type RamType is array(0 to 4095) of bit_vector(15 downto 0);
impure function InitRamFromFile (RamFileName : in string) return RamType is

    FILE RamFile: text is in RamFileName;
    variable RamFileLine: line;
    variable RAM: RamType;
    begin
    for I in RamType'range loop
        readline (RamFile,RamFileLine);
         read(RamFileLine,RAM(I));
    end loop;
    return RAM; 
end function;
    
signal RAM : RamType := InitRamFromFile("asm.data");
    
BEGIN



dataout <= "ZZZZZZZZZZZZZZZZ" when (addr = "XXXXXXXXXXXXXXXX")
else To_StdLogicVector(ram(to_integer(unsigned(addr)))) when (re = '1') and rising_edge(clk) ;


PCRest <=  To_StdLogicVector(ram(1)) &  To_StdLogicVector(ram(0));
PCINT <=  To_StdLogicVector(ram(3)) &  To_StdLogicVector(ram(2));
 

-----------------------------------------------------
------------------Second Cache ----------------------
dataout_Stack <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when (addrSTC = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
else ( To_StdLogicVector(ram(to_integer(unsigned(addrSTC +1)))) & To_StdLogicVector(ram(to_integer(unsigned(addrSTC)))) )when (ram_en = '1') and rising_edge(clk) and we = '0' ;


process(clk) is
    begin
        if (rising_edge(clk) and ram_en = '1') then
            if (we = '1') then
                ram(to_integer(unsigned(addrSTC))) <= to_bitvector (datain(15 downto 0)) ; 
                ram(to_integer(unsigned(addrSTC+1))) <= to_bitvector (datain(31 downto 16)); 
    
            end if;
        end if;
    end process;

END sync_ram_a;