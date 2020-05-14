library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;

entity HDU is
    port ( 
            clk : in std_logic ;
            RdstALU, RdstDec :   in std_logic_vector(2 downto 0);
            RamInp :   in std_logic_vector(15 downto 0);
            IRregin : in std_logic_vector (1 downto 0);
          Asel, Bsel  :       out std_logic_vector (1 downto 0);
          OpFlagBeforeALU, Stall    :   out std_logic);
end entity HDU;

architecture HDU_Arch of HDU is

signal Rsrc1 : std_logic_vector(2 downto 0);
signal Rsrc2 : std_logic_vector(2 downto 0);

begin
    -- get sources 
	Asel <= "00";
	Bsel <="00";
    process ( clk , RamInp, RdstALU, RdstDec , IRregin)
    if clk = '1' then 
    variable n : integer := 0;
    begin
        if (IRregin = "00") then 
            -- 1  operant 
            if RamInp (15 downto 13) = "000"  and  (RamInp (12 downto 10) = "001" or 
            RamInp (12 downto 10) = "010" or  RamInp (12 downto 10) = "011" or  RamInp (12 downto 10) = "100" )then 

                    Rsrc1 <= RamInp (9 downto 7) ;
                    n := 1;

            -- 2 operant
            elsif RamInp (15 downto 13) = "001" and (RamInp (12 downto 10) = "001" or RamInp (12 downto 10) = "011" or RamInp (12 downto 10) = "100" or RamInp (12 downto 10) = "101" )
            then
                    
                Rsrc1 <= RamInp (3 downto 1) ;
                Rsrc2 <= RamInp (6 downto 4) ;
                n := 2;
                -- 2 operant 
            elsif RamInp (15 downto 13) = "001" and (RamInp (12 downto 10) = "110" or RamInp (12 downto 10) = "111" )
            then

                Rsrc1 <= RamInp (9 downto 7) ;
                n := 1;
            elsif RamInp (15 downto 13) = "001" and (RamInp (12 downto 10) = "000" )
            then

                Rsrc1 <= RamInp (9 downto 7) ;
                Rsrc2 <= RamInp (3 downto 1) ;
                n := 2;

            elsif RamInp (15 downto 13) = "001" and (RamInp (12 downto 10) = "010" )
            then

                Rsrc1 <= RamInp (3 downto 1) ;
                n := 1;


                -- Memory 
            elsif RamInp (15 downto 13) = "010" and (RamInp (12 downto 10) = "100" or RamInp (12 downto 10) = "000" ) then
                Rsrc1 <= RamInp (9 downto 7) ;
                n := 1 ; 
            -- Branch 
            elsif RamInp (15 downto 13) = "011" and (RamInp (12 downto 10) = "000" or RamInp (12 downto 10) = "001" or RamInp (12 downto 10) = "010" ) then
                Rsrc1 <= RamInp (9 downto 7) ;
                n := 1 ; 


            else
                n := 0 ; 

            end if;


        if n = 1 then
            if Rsrc1 = RdstALU or Rsrc1 = RdstDec then 
                Stall <= '1';
            else
                Stall <= '0';
            end if ;
        end if ;

        if n = 2 then 
            if Rsrc1 = RdstALU or Rsrc1 = RdstDec or Rsrc2 = RdstALU or Rsrc2 = RdstDec then 
                Stall <= '1';
            else
                Stall <= '0';
            end if ; 
         end if ;
    end if;
            end if ; 
    end process;
end HDU_Arch;