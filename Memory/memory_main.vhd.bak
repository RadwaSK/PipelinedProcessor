LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

ENTITY memory_main IS
PORT (clk : IN std_logic;
    opcode : IN std_logic_vector(5 downto 0);
    int: IN std_logic;
    flags_in: IN std_logic_vector(3 downto 0);
    rdstALU :   IN std_logic_vector (2 downto 0);
    opflag: IN std_logic;
    aluout: IN std_logic_vector (31 downto 0);
    ea: IN std_logic_vector(31 downto 0);
    pc: In std_logic_vector(31 downto 0);
    dataout : IN std_logic_vector(31 DOWNTO 0);
    addr : OUT std_logic_vector (31 DOWNTO 0);
    w : OUT std_logic;
    ram_en : OUT std_logic;
    datain : OUT std_logic_vector (31 DOWNTO 0);
    memout: OUT std_logic_vector(31 DOWNTO 0);
    flags_output: OUT std_logic_vector(3 downto 0);
    opCodeFlagOut   :   out std_logic_vector (6 downto 0);
    RdstMem :   OUT std_logic_vector (2 downto 0);
    memBefOut   :   OUT std_logic_vector (31 downto 0);
    updateFR    : OUT std_logic
);

END memory_main;

architecture mymem of memory_main is
    component MUX_M IS
    PORT( val1 ,  val2 ,  val3 ,  val4  : IN std_logic_vector(31 DOWNTO 0);
        Sel : IN std_logic_vector(1 DOWNTO 0);
        Output : OUT std_logic_vector(31 DOWNTO 0));
    END component;

    component moc is port( 
        opcode : IN std_logic_vector(5 downto 0);
        int: IN std_logic;
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

    component Reg_SP IS

    
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

    component Mem_MS is
    generic ( size : integer := 16);

    port(clk, rst, enable : in std_logic;
        d : in std_logic_vector(size-1 downto 0);
        q : out std_logic_vector(size-1 downto 0)) ; 
    end component;

    component lvl_reg IS

    GENERIC ( n : integer := 32);

    PORT( Clk,Rst,enable : IN std_logic;
    d : IN std_logic_vector(n-1 DOWNTO 0);
    q : OUT std_logic_vector(n-1 DOWNTO 0));
    
    END component;


    component MUXMINI IS
    PORT( val1 ,  val2 : IN std_logic_vector(31 DOWNTO 0);
    Sel : IN std_logic;
    Output : OUT std_logic_vector(31 DOWNTO 0));

    END component;
    signal addrsel, idsel, datainsel: std_logic_vector(1 downto 0);
    signal outsel, ram_w, rst_sp, sp_update, out_flags, out_en : std_logic;
    signal mod_sp, target_addrs, ram_out, sp_out, cand_out, flags_ext, pc_inc: std_logic_vector(31 downto 0);
    signal opFlagCodeSig : std_logic_vector (6 downto 0);
    signal flagRegSig : std_logic_vector (3 downto 0);
    
    begin
        opFlagCodeSig <= opcode & opflag;
        flagRegSig <= cand_out(3 downto 0) when opflag = '1' else
                      flags_in;
        out_en <= not out_flags;
        pc_inc <= std_logic_vector(unsigned(pc) + 1);
        flags_ext <= x"0000000" & flags_in;
        moc_block: moc PORT MAP(opcode, int, opflag, addrsel, idsel, outsel, ram_en, w, sp_update, rst_sp, datainsel, out_flags);
        SP_UPD: spinc PORT MAP(idsel, sp_out, mod_sp);
        SP: Reg_SP PORT MAP(clk, rst_sp, sp_update, mod_sp, sp_out);
        M1: MUX_M PORT MAP(ea, mod_sp, sp_out, pc, addrsel, addr);
        INPSEL: MUX_M PORT MAP(aluout, pc, pc_inc, flags_ext, datainsel, datain);
        MMINI: MUXMINI PORT MAP(dataout, aluout, outsel, cand_out);
        OUTREG: Mem_MS generic map (32) PORT MAP(clk, rst_sp, out_en, cand_out, memout);
        FLAGS: Mem_MS GENERIC MAP(4) PORT MAP(clk, rst_sp, '1', flagRegSig, flags_output);
        --flags_output <= cand_out(3 downto 0) when out_flags = '1' else
        --                flags_in;
                        
        OpFlagOutComp : Mem_MS generic map (7) port map (clk, rst_sp, out_en, opFlagCodeSig, opCodeFlagOut);
        rdstComp      : Mem_MS generic map (3) port map (clk, rst_sp, out_en, rdstALU, RdstMem);
        
        memBefOut <= cand_out;
        updateFR <= out_flags;
end mymem;