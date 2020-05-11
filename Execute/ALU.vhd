library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;

entity ALU is
    port (A, B              :       in std_logic_vector (31 downto 0);
          F                 :       out std_logic_vector (31 downto 0);
          NOP, NopA, NopB, NotA, IncA, DecA, AswapB, AaddB, AsubB, AandB, AorB, AshlB, AshrB : in std_logic;
          Cin, ZFin, Nin    :       in std_logic;
          Cout, ZFout, Nout :       out std_logic;
          clock             :       in std_logic);
end entity ALU;

architecture ALU_arch of ALU is
component full32bitAdder is  
	port (A, B      :   IN   std_logic_vector (31 downto 0);
  		  Cin       :   IN   std_logic;
		  F         :   OUT  std_logic_vector (31 downto 0);
		  Cout      :   OUT  std_logic);
end component full32bitAdder;

component incrementor32bit is
    port (inp       :   in std_logic_vector (31 downto 0);
          en        :   in std_logic;
          op        :   out std_logic_vector (31 downto 0);
          cout      :   out std_logic;
          clock     :   in std_logic);
end component incrementor32bit;

component decrementor32bit is
    port (inp       :   in std_logic_vector (31 downto 0);
          en        :   in std_logic;
          op        :   out std_logic_vector (31 downto 0);
          clock     :   in std_logic);
end component decrementor32bit;

signal FIncrA, FDecrA, FAaddB, FAsubB, Fout     : std_logic_vector (31 downto 0);   
signal CIncrA, CAaddB, CAsubB, tempCout : std_logic;
signal notB : std_logic_vector (31 downto 0);
signal en, notCin   :   std_logic;

begin
    notB <= not B;
    notCin <= not Cin;
    AIncrementor : incrementor32bit port map (A, en, FIncrA, CIncrA, clock);
    ADecrementor : decrementor32bit port map (A, en, FDecrA, clock);
    
    Adder         : full32bitAdder  port map (A, B, Cin, FAaddB, CAaddB);
    Subtractor    : full32bitAdder  port map (A, notB, notCin, FAsubB, CAsubB);
    
    
    en <= NopA or NopB or NotA or IncA or DecA or AswapB 
            or AaddB or AsubB or AandB or AorB or AshlB or AshrB;

    Fout    <= A when NopA = '1' else 
               B when NopB = '1' else 
               not A when NotA = '1' else
               
               FIncrA when IncA = '1' else
               FDecrA when DecA = '1' else
               --FswapAB when AswapB = '1' else
               
               FAaddB when AaddB = '1' else
               FAsubB when AsubB = '1' else
               
               A and B when AandB = '1' else
               A or B when AorB = '1' else
               
               std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B)))) when AshlB = '1' else
               std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B)))) when AshrB = '1';
             
            
    tempCout <= CIncrA when IncA = '1' else
                CAaddB when AaddB = '1' else
                CAsubB when AsubB = '1' else
                A(32 - to_integer(unsigned(B))) when AshlB = '1' else
                A(to_integer(unsigned(B)) - 1) when AshrB = '1' else
                '0';
                

	F <= Fout when en = '1' and clock ='1';
    
    Cout <= tempCout when en = '1' and clock ='1' else
            Cin when en = '0';
    
    ZFout <= '1' when Fout = "00000000000000000000000000000000" and en = '1' and clock = '1' else
             '0' when en = '1' and clock = '1' else
             ZFin;
    
    Nout <= Fout(31) when en = '1' and clock = '1' else Nin;
    
end ALU_arch;