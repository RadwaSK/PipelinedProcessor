library ieee;

use ieee.std_logic_1164.all;

entity MemReg is
    generic ( n : integer := 16);

    port(clk, rst, enable : in std_logic;
            d : in std_logic_vector(n-1 downto 0);
            q : out std_logic_vector(n-1 downto 0));

end MemReg;

architecture MemRegArch of MemReg is
signal tempClk : std_logic := '0';

begin
    process begin
        wait for 10 ps;
        tempClk <= not tempClk;
    end process;
    
    process (tempClk, clk, rst, enable)
    begin
        if rst = '1' then
            q <= (others=>'0');
        elsif ((clk = '0'))
            then q <= d;
        end if;
    end process;

end MemRegArch;