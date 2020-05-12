library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity m_s1bit is
    port(clk, rst, enable : in std_logic;
        d : in std_logic;
        q : out std_logic);
end entity m_s1bit;

architecture m_s1bitarch of m_s1bit is
component reg1bit is
    port(clk, rst, enable : in std_logic;
         d : in std_logic;
         q : out std_logic);
end component reg1bit;

signal temp : std_logic; 
signal notclk  : std_logic; 

begin
    notclk <= not clk; 
    master : reg1bit port map (notclk, rst , enable, d, temp);
    slave : reg1bit port map (clk, rst, enable, temp, q);
end m_s1bitarch;