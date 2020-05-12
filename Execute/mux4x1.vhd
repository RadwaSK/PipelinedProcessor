library IEEE;
use IEEE.std_logic_1164.all;

entity mux4x1 is
    port (in3, in2, in1, in0  : std_logic_vector (31 downto 0);
          s       : std_logic_vector (1 downto 0);
          f       : out std_logic_vector (31 downto 0);
          en      : in std_logic);
end entity mux4x1;

architecture mux41Arch of mux4x1 is
component mux2x1 is
    port (in1, in0  : in std_logic_vector (31 downto 0);
        sel       : in std_logic;
        f       : out std_logic_vector (31 downto 0));
end component mux2x1;

signal f0, f1 : std_logic_vector (31 downto 0);

begin
    m0 : mux2x1 port map (in1, in0, s(0), f0);
    m1 : mux2x1 port map (in3, in2, s(0), f1);


    f <= f0 when s(1) = '0' and en = '1' else
         f1 when s(1) = '1' and en = '1';
         
end mux41Arch;