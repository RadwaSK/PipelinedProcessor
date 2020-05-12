LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

ENTITY memory_main IS

PORT (clk : IN std_logic;
opcode : IN std_logic_vector(5 downto 0);
flags_in: IN std_logic_vector(3 downto 0);
opflag: IN std_logic;
aluout: IN std_logic_vector (31 downto 0);
ea: IN std_logic_vector(19 downto 0);
pc: In std_logic_vector(31 downto 0);
enable: IN std_logic;
addr : OUT std_logic_vector (31 DOWNTO 0);
dataout : IN std_logic_vector(31 DOWNTO 0);
w : OUT std_logic;
ram_en : OUT std_logic;
datain : OUT std_logic_vector (31 DOWNTO 0);
memout: OUT std_logic_vector(31 DOWNTO 0);
flags_output: OUT std_logic_vector(3 downto 0)
);

END memory_main;

architecture mymem of memory_main is

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
        rst_sp: OUT std_logic;
        datainsel: OUT std_logic_vector(1 DOWNTO 0);
        out_flags: OUT std_logic
    );
    
    END component;

    component Reg IS

    
    PORT( Clk,Rst,enable : IN std_logic;
     d : IN std_logic_vector(31 DOWNTO 0);
     q : OUT std_logic_vector(31 DOWNTO 0));
    
    END component;

    component spinc IS
    PORT(
        sel : IN std_logic_vector(1 DOWNTO 0);
        sp : IN std_logic_vector(31 DOWNTO 0);
        spnew : OUT std_logic_vector(31 DOWNTO 0)
    );

    END component;

    component MUXMINI IS
    PORT( val1 ,  val2 : IN std_logic_vector(31 DOWNTO 0);
        Sel : IN std_logic;
        Output : OUT std_logic_vector(31 DOWNTO 0));

    END component;

    component lvl_reg IS

    GENERIC ( n : integer := 32);

    PORT( Clk,Rst,enable : IN std_logic;
    d : IN std_logic_vector(n-1 DOWNTO 0);
    q : OUT std_logic_vector(n-1 DOWNTO 0));
    
    END component;

    signal addrsel, idsel, datainsel: std_logic_vector(1 downto 0);
    signal outsel, ram_w, rst_sp, sp_update, out_flags, out_en : std_logic;
    signal ex_ea, mod_sp, target_addrs, ram_out, sp_out, cand_out, flags_ext, pc_inc: std_logic_vector(31 downto 0);
    begin
        ex_ea <= x"000" & ea;
        out_en <= not out_flags;
        pc_inc <= pc+1;
        flags_ext <= x"0000000" & flags_in;
        moc_block: moc PORT MAP(enable, opcode, opflag, addrsel, idsel, outsel, ram_en, w, sp_update, rst_sp, datainsel, out_flags);
        SP_UPD: spinc PORT MAP(idsel, sp_out, mod_sp);
        SP: Reg PORT MAP(clk, rst_sp, sp_update, mod_sp, sp_out);
        M1: MUX PORT MAP(ex_ea, mod_sp, sp_out, pc, addrsel, addr);
        INPSEL: MUX PORT MAP(aluout, pc, pc_inc, flags_ext, datainsel, datain);
        MMINI: MUXMINI PORT MAP(dataout, aluout, outsel, cand_out);
        OUTREG: lvl_reg PORT MAP(clk, rst_sp, out_en, cand_out, memout);
        FLAGS: lvl_reg GENERIC MAP(4) PORT MAP(clk, rst_sp, out_flags, cand_out(3 downto 0), flags_output);
end mymem;