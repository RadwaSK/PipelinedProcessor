library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;

entity HDU is
    port (Rsrc1, Rsrc2, RdstALU, RdstMem    :   in std_logic_vector(2 downto 0);
          Asel, Bsel        :       out std_logic_vector (1 downto 0);
          OpFlagBeforeALU, Stall    :   out std_logic);
end entity HDU;

architecture HDU_Arch of HDU is

begin
    process (Rsrc1, Rsrc2, RdstALU, RdstMem) begin
        Asel <= "00";
        Bsel <= "00";
        OpFlagBeforeALU <= '0';
        Stall <= '0';
    end process;
end HDU_Arch;