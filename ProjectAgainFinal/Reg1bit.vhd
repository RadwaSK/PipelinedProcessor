library ieee;
use ieee.std_logic_1164.all;

entity reg1bit is
    port(clk, rst, enable : in std_logic;
         d : in std_logic;
         q : out std_logic);
end entity reg1bit;

architecture reg1bitArch of reg1bit is
begin

    process (clk,rst,enable)
    begin
        if rst = '1' then
            q <= '0';
        elsif ((clk = '0')) then
            q <= d;
        end if;
    end process;
end reg1bitArch;