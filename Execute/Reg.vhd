library ieee;

use ieee.std_logic_1164.all;

entity GenReg is
    generic ( n : integer := 16);

    port(clk, rst, enable : in std_logic;
            d : in std_logic_vector(n-1 downto 0);
            q : out std_logic_vector(n-1 downto 0));

end GenReg;

architecture GenRegArch of GenReg is
begin

    process (clk , rst , enable)
    begin
        if rst = '1' then
            q <= (others=>'0');
        elsif ((clk = '0'))
            then q <= d;
        end if;
    end process;

end GenRegArch;