library IEEE;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity incrementor32bit is
    port (inp       :   in std_logic_vector (31 downto 0);
          en        :   in std_logic;
          op        :   out std_logic_vector (31 downto 0);
          cout      :   out std_logic;
          clock     :   in std_logic);
end entity incrementor32bit;

architecture incrementor32bitArch of incrementor32bit is
begin

    op <= std_logic_vector(unsigned(inp) + 1) when en = '1' and clock = '1';
    cout <= '1' when en = '1' and clock = '1' and inp = "11111111111111111111111111111111" else
            '0' when en = '1' and clock = '1';
    
end incrementor32bitArch;