library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;


entity WB is
    port (  clk : in std_logic;
            Rdstin :   in std_logic_vector(2 downto 0);
            Ramout :   in std_logic_vector(31 downto 0);
            OPcode_Flag : in std_logic_vector (6 downto 0);
            outport , Regout :   out std_logic_vector(31 downto 0);
            Rdstout :   out std_logic_vector(2 downto 0);
            writeEn : out std_logic
            );
end entity WB;


architecture WB_Arch of WB is
    begin

    identifier : process( clk , Ramout )
    begin
        if clk = '1' and OPcode_Flag (0) = '0' then 
            if  OPcode_Flag (6 downto 1 ) = "000001"   or OPcode_Flag (6 downto 1 ) = "000010" or OPcode_Flag (6 downto 1 ) = "000011" or -- 1 op
                OPcode_Flag (6 downto 4 ) = "001"   or -- 2 op 
                OPcode_Flag (6 downto 1 ) = "010001" or OPcode_Flag (6 downto 1 ) = "010010" or OPcode_Flag (6 downto 1 ) = "010011"  --memory 
                then 
                Regout<= Ramout;
                Rdstout<= Rdstin;
                writeEn <= '1';

            elsif OPcode_Flag (6 downto 1 ) = "000100" then 
                outport<= Ramout;
            else
                writeEn <= '0';

            end if; 

        else 
            writeEn <= '0';

        end if;
        
    end process ; -- identifier


end WB_Arch;