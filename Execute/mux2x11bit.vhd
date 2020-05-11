library IEEE;
use IEEE.std_logic_1164.all;

entity mux2x1bit is
    port (in1, in0  : in std_logic;
        sel       : in std_logic;
        f       : out std_logic);
end entity mux2x1bit;

architecture mux21bitArch of mux2x1bit is
begin
    process(in0, in1, sel)
    begin
        if sel = '0' then
            f <= in0;
        else
            f <= in1;
        end if;
    end process;
end mux21bitArch;