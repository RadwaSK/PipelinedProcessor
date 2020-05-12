library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.all;

entity EOC is
    port (OpCode            :       in std_logic_vector (5 downto 0);
          OpFlag            :       in std_logic;
          NOP, NopA, NopB, NotA, IncA, DecA, AswapB, AaddB, AsubB, AandB, AorB, AshlB, AshrB : out std_logic;
          Aen, Ben, reset   :       out std_logic);
end entity EOC;

architecture EOC_Arch of EOC is
type optionsArray is array (12 downto 0) of std_logic;
signal options : optionsArray;
signal AenSig, BenSig   :   std_logic;

begin
    process (OpCode, OpFlag) begin
        options(12 downto 0) <= (others => '0');
        AenSig <= '1';
        BenSig <= '1';
        reset  <= '0';
        if (OpFlag = '1'or OpCode = "000000" or OpCode = "100110") then
            options(0) <= '1';
            AenSig <= '0';
            BenSig <= '0';
        else
            -- 1 operand --
            if (OpCode(5 downto 3) = "000") then
                if (OpCode(2 downto 0) = "001") then
                    options(3) <= '1';
                elsif (OpCode(2 downto 0) = "010") then
                    options(4) <= '1';
                elsif (OpCode(2 downto 0) = "011") then
                    options(5) <= '1';
                elsif (OpCode(2 downto 0) = "100" or OpCode(2 downto 0) = "101") then
                    options(1) <= '1';
                else
                    options(0) <= '1';
                    AenSig <= '0';
                    BenSig <= '0';
                end if;
            end if;
            
            -- 2 operand --
            if (OpCode(5 downto 3) = "001") then
                if (OpCode(2 downto 0) = "000") then
                    options(6) <= '1';
                elsif (OpCode(2 downto 0) = "001" or OpCode(2 downto 0) = "010") then
                    options(7) <= '1';
                elsif (OpCode(2 downto 0) = "011") then
                    options(8) <= '1';
                elsif (OpCode(2 downto 0) = "100") then
                    options(9) <= '1';
                elsif (OpCode(2 downto 0) = "101") then
                    options(10) <= '1';
                elsif (OpCode(2 downto 0) = "110") then
                    options(11) <= '1';
                elsif (OpCode(2 downto 0) = "111") then
                    options(12) <= '1';
                else
                    options(0) <= '1';
                    AenSig <= '0';
                    BenSig <= '0';
                end if;
            end if;
            
            if (OpCode = "010010" or OpCode = "010100" or OpCode = "011000" or OpCode = "011001" or OpCode = "011010") then
                options(1) <= '1';
            end if;
            
            if (OpCode = "010000") then
                options(2) <= '1';
            end if;
            
            if (OpCode = "100010") then
                reset <= '1';
            end if;
            
        end if;
    end process;

    NOP <= options(0);
    NopA <= options(1);
    NopB <= options(2);
    NotA <= options(3);
    IncA <= options(4);
    DecA <= options(5);
    AswapB <= options(6);
    AaddB <= options(7);
    AsubB <= options(8);
    AandB <= options(9);
    AorB <= options(10);
    AshlB <= options(11);
    AshrB <= options(12);
    
    Aen <= AenSig;
    Ben <= BenSig;

end EOC_Arch;