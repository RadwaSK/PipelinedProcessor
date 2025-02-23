LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY regtri IS  
    PORT (
	buff1in : IN std_logic_vector(31 downto 0);
	bufflout: out std_logic_vector(31 downto 0);

	enwrite: in std_logic;
	enread: in std_logic;

	 clk :in std_logic;
         rst :in std_logic );   

END ENTITY regtri;

ARCHITECTURE struct OF regtri IS

COMPONENT my_nDFF IS

GENERIC ( n : integer := 16);

PORT( Clk,Rst,enable : IN std_logic; d : IN std_logic_vector(n-1 DOWNTO 0); q : OUT std_logic_vector(n-1 DOWNTO 0));

END COMPONENT ;

COMPONENT buff IS
PORT( i : IN std_logic_vector(31 DOWNTO 0);en : in std_logic; o : out std_logic_vector(31 DOWNTO 0));
END COMPONENT ;

signal r1sigout : std_logic_vector(31 downto 0);

BEGIN
r1out: buff port map (r1sigout,enread ,bufflout);
Reg: my_nDFF generic map (N => 32) port map(Clk,Rst,enwrite,buff1in,r1sigout);

END struct;
