library IEEE;
use IEEE.std_logic_1164.all;

entity mux2x1 is
    port (in1, in0  : in std_logic_vector (31 downto 0);
        sel       : in std_logic;
        f       : out std_logic_vector (31 downto 0));
end entity mux2x1;

architecture mux21Arch of mux2x1 is
begin
    process(in0, in1, sel)
    begin
        if sel = '0' then
            f <= in0;
        else
            f <= in1;
        end if;
    end process;
end mux21Arch;