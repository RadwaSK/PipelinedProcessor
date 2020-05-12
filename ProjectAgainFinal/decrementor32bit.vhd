library IEEE;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity decrementor32bit is
    port (inp       :   in std_logic_vector (31 downto 0);
          en        :   in std_logic;
          op        :   out std_logic_vector (31 downto 0);
          clock     :   in std_logic);
end entity decrementor32bit;

architecture decrementor32bitArch of decrementor32bit is
signal tempOp : std_logic_vector (31 downto 0);

begin
    op <= tempOp;
    
    process (clock, inp, en) begin
        if (clock = '1') then
            if (en = '1') then
                if (inp = "00000000000000000000000000000000") then
                    tempOp <= "00000000000000000000000000000000";
                else
                    tempOp <= std_logic_vector(unsigned(inp) - 1);
                end if;
            end if;
        end if;
    end process;
    
end decrementor32bitArch;