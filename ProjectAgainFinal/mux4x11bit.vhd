library IEEE;
use IEEE.std_logic_1164.all;

entity mux4x1bit is
    port (in3, in2, in1, in0  : std_logic;
          s1, s0       : std_logic;
          f       : out std_logic);
end entity mux4x1bit;

architecture mux41bitArch of mux4x1bit is
component mux2x1bit is
    port (in1, in0  : in std_logic;
        sel       : in std_logic;
        f       : out std_logic);
end component mux2x1bit;

signal f0, f1 : std_logic;

begin
    m0 : mux2x1bit port map (in1, in0, s0, f0);
    m1 : mux2x1bit port map (in3, in2, s0, f1);

    with s1 select
        f <= f0 when '0',
             f1 when '1',
             '0' WHEN OTHERS;
end mux41bitArch;