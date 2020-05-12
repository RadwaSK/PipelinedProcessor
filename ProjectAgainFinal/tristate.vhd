LIBRARY IEEE;

USE IEEE.std_logic_1164.all;

ENTITY buff IS
PORT( i : IN std_logic_vector(31 DOWNTO 0);en : in std_logic; o : out std_logic_vector(31 DOWNTO 0));
END buff;

ARCHITECTURE Mybuf OF buff IS

BEGIN


o <= i when en='1'
else (others => 'Z') ;

END Mybuf;