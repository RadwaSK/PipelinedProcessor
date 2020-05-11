LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

ENTITY memory IS

PORT (clk : IN std_logic;
opcode : IN std_logic_vector(5 downto 0);
opflag: IN std_logic;
aluout: IN std_logic_vector (31 downto 0);
ea: IN std_logic_vector(19 downto 0);
pc: In std_logic_vector(31 downto 0);
enable: IN std_logic
);

END memory;

architecture mymem of memory is

    component MUX IS
    PORT( val1 ,  val2 ,  val3 ,  val4  : IN std_logic_vector(31 DOWNTO 0);
        Sel : IN std_logic_vector(1 DOWNTO 0);
        Output : OUT std_logic_vector(31 DOWNTO 0));
    END component;

    component moc is port( 
    enable: IN std_logic;
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
    
    END component;

    component Reg IS

    
    PORT( Clk,Rst,enable : IN std_logic;
     d : IN std_logic_vector(31 DOWNTO 0);
     q : OUT std_logic_vector(31 DOWNTO 0));
    
    END component;

    component ram IS
        PORT (clk : IN std_logic;
        w : IN std_logic;
        en : IN std_logic;
        addr : IN std_logic_vector (31 DOWNTO 0);
        datain : IN std_logic_vector(31 DOWNTO 0);
        dataout : OUT std_logic_vector(31 DOWNTO 0)
        );
    END component;

    component spinc IS
    PORT(
        sel : IN std_logic_vector(1 DOWNTO 0);
        sp : IN std_logic_vector(31 DOWNTO 0);
        spnew : OUT std_logic_vector(31 DOWNTO 0)
    );

    END component;

    signal addrsel, idsel: std_logic_vector(1 downto 0);
    signal outsel, ram_en, ram_w, rst_sp, sp_update : std_logic;
    signal ex_ea, mod_sp, target_addrs, ram_out, sp_out: std_logic_vector(31 downto 0);
    begin
        ex_ea <= x"000" & ea;
        moc_block: moc PORT MAP(enable, opcode, opflag, addrsel, idsel, outsel, ram_en, ram_w, sp_update, rst_sp);
        SP_UPD: spinc PORT MAP(idsel, sp_out, mod_sp);
        SP: Reg PORT MAP(clk, rst_sp, sp_update, mod_sp, sp_out);
        M1: MUX PORT MAP(ex_ea, mod_sp, sp_out, pc, addrsel, target_addrs);
        RM: ram PORT MAP(clk, ram_w, ram_en, target_addrs, aluout, ram_out);
    
end mymem;