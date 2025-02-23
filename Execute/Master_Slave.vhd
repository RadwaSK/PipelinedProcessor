library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Ex_M_S is
    generic ( size : integer := 16);

    port(clk, rst, enable : in std_logic;
        d : in std_logic_vector(size-1 downto 0);
        q : out std_logic_vector(size-1 downto 0));
end Ex_M_S;

architecture Ex_M_SArch of Ex_M_S is

component GenReg is
    generic ( n : integer := 16);
    port( clk,rst,enable : in std_logic;
        d : in std_logic_vector(n-1 downto 0);
        q : out std_logic_vector(n-1 downto 0));
end component ; 

signal temp : std_logic_vector(size-1 downto 0) ; 
signal notclk  : std_logic; 

begin
    notclk <= not clk; 
    master : GenReg generic map (size) port map (notclk, rst , enable, d, temp);
    slave : GenReg generic map (size) port map (clk, rst, enable, temp, q);

end Ex_M_SArch;