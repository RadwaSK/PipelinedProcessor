LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

ENTITY moc IS

PORT ( enable: IN std_logic;
opcode : IN std_logic_vector(5 downto 0);
opflag: IN std_logic;
addrsel : OUT std_logic_vector(1 DOWNTO 0);
idsel : OUT std_logic_vector(1 DOWNTO 0);
outsel : OUT std_logic;
ram_en: OUT std_logic;
ram_w: OUT std_logic;
sp_update: OUT std_logic;
rst_sp: OUT std_logic
);

END moc;

architecture mymoc of moc is
    begin
    process (opcode, enable) is begin
            if(enable = '1' and opflag = '0') then
                if opcode = "010000" then
                    addrsel <= "10";
                    outsel <= '0';
                    idsel <= "01";
                    ram_en <= '1';
                    ram_w <= '1';
                    sp_update <= '1';
                    rst_sp <= '0';
                elsif opcode = "010001" then
                    addrsel <= "01";
                    outsel <= '1';
                    ram_en <= '1';
                    ram_w <= '0';
                    sp_update <= '1';
                    idsel <= "10";
                    rst_sp <= '0';
                elsif opcode = "010010" then
                    addrsel <= "00";
                    ram_en <= '0';
                    sp_update <= '0';
                    idsel <= "00";
                    rst_sp <= '0';
                elsif opcode = "010011" then
                    addrsel <= "00";
                    outsel <= '1';
                    ram_w <= '0';
                    ram_en <= '1';
                    sp_update <= '0';
                    idsel <= "00";
                    rst_sp <= '0';
                elsif opcode = "010100" then
                    addrsel <= "00";
                    outsel <= '0';
                    ram_w <= '1';
                    ram_en <= '1';
                    sp_update <= '1';
                    idsel <= "00";
                    rst_sp <= '0';
                    elsif opcode = "100010" then
                        addrsel <= "00";
                        rst_sp <= '1';
                        outsel <= '0';
                        ram_w <= '0';
                        ram_en <= '0';
                        idsel <= "00";
                end if;
                else
                    ram_en <= '0';
                    outsel <= '0';    
                    sp_update <= '0';   
                    idsel <= "00";  
            end if;
        end process;
end mymoc;