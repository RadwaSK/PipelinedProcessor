library IEEE;
use IEEE.std_logic_1164.all;

entity full32bitAdder is  
	port (A, B      :   IN   std_logic_vector (31 downto 0);
  		  Cin       :   IN   std_logic;
		  F         :   OUT  std_logic_vector (31 downto 0);
		  Cout      :   OUT  std_logic);
end entity full32bitAdder;

architecture    full32Arch  of full32bitAdder is

component full1bitAdder is
    port(x, y, cin      :   IN std_logic;
        cout, sum       :   OUT std_logic);
end component;

signal carry : std_logic_vector (31 downto 0);

begin
loop1:  for i in 0 to 31 generate
            g0: if i = 0 generate
                    f0: full1bitAdder port map (A(i), B(i), Cin, carry(i), F(i));
            end generate g0;
        
            gx: if i > 0 generate
                    f1: full1bitAdder port map  (A(i), B(i), carry(i-1), carry(i), F(i));
            end generate gx;
        end generate;
    cout <= carry(31);
    
end full32Arch;