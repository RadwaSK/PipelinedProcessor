library IEEE;
use ieee.numeric_std.all;
USE IEEE.std_logic_1164.all;

entity Execute is
    port (clock, OpFlagIn       :      in std_logic;
          OpCodeIn              :      in std_logic_vector (5 downto 0);
          Rsrc1Final, Rsrc2Final:      in std_logic_vector (31 downto 0);
          Asel, Bsel            :      in std_logic_vector (1 downto 0);
          ALUOutLast, MemOut    :      in std_logic_vector (31 downto 0);
          PC2, EADecode         :      in std_logic_vector (31 downto 0);
          RdstDec               :      in std_logic_vector (2 downto 0);
          FlagRegIn             :      in std_logic_vector (3 downto 0);
          FlagRegOut            :      out std_logic_vector (3 downto 0);
          PC3, EAALU            :      out std_logic_vector (31 downto 0);
          RdstALU               :      out std_logic_vector (2 downto 0);
          OpFlagOut             :      out std_logic;
          OpCodeOut             :      out std_logic_vector (5 downto 0);
          ALUOutput             :      out std_logic_vector (31 downto 0));
end entity Execute;

architecture Execute_Arch of Execute is
component mux4x1 is
    port (in3, in2, in1, in0  : std_logic_vector (31 downto 0);
          s       : std_logic_vector (1 downto 0);
          f       : out std_logic_vector (31 downto 0);
          en      : in std_logic);
end component mux4x1;

component EOC is
    port (OpCode            :       in std_logic_vector (5 downto 0);
          OpFlag            :       in std_logic;
          NOP, NopA, NopB, NotA, IncA, DecA, AswapB, AaddB, AsubB, AandB, AorB, AshlB, AshrB, JZ : out std_logic;
          Aen, Ben, reset   :       out std_logic);
end component EOC;

component Ex_M_S is
    generic (size : integer := 16);
    port(clk, rst, enable : in std_logic;
         d              : in std_logic_vector(size-1 downto 0);
         q              : out std_logic_vector(size-1 downto 0));
end component Ex_M_S;

component ALU_MS is
    generic (size : integer := 16);
    port(clk, rst, enable : in std_logic;
         d              : in std_logic_vector(size-1 downto 0);
         q              : out std_logic_vector(size-1 downto 0));
end component ALU_MS;

component m_s1bit is
    port(clk, rst, enable : in std_logic;
        d : in std_logic;
        q : out std_logic);
end component m_s1bit;

component ALU is
    port (A, B              :       in std_logic_vector (31 downto 0);
          F                 :       out std_logic_vector (31 downto 0);
          NOP, NopA, NopB, NotA, IncA, DecA, AswapB, AaddB, AsubB, AandB, AorB, AshlB, AshrB, JZ : in std_logic;
          Cin, ZFin, Nin    :       in std_logic;
          Cout, ZFout, Nout :       out std_logic);
end component ALU;

----------- SIGNALS -----------
signal NOPsig, NopAsig, NopBsig, NotAsig, IncAsig, DecAsig, AswapBsig, AaddBsig, AsubBsig, AandBsig, AorBsig, AshlBsig, AshrBsig, resetSig, JZSig : std_logic;
signal Amux, Bmux : std_logic_vector (31 downto 0);
signal AmuxEn, BmuxEn : std_logic;
signal ALUOutputSig : std_logic_vector (31 downto 0);
signal tempFR       : std_logic_vector (3 downto 0);
signal PC3Sig, EAALUSig   : std_logic_vector (31 downto 0);
signal RdstALUSig      : std_logic_vector (2 downto 0);
signal OpFlagOutSig    : std_logic;
signal OpCodeOutSig    : std_logic_vector (5 downto 0);

begin
    tempFR(3) <= '0';
    aluComp : ALU port map (Amux, Bmux, ALUOutputSig, NOPsig, NopAsig, NopBsig, NotAsig, IncAsig, DecAsig, AswapBsig, AaddBsig, AsubBsig, AandBsig, AorBsig, AshlBsig, AshrBsig, JZSig, FlagRegIn(2), FlagRegIn(0), FlagRegIn(1), tempFR(2), tempFR(0), tempFR(1));
    muxRsrc1: mux4x1 port map ("00000000000000000000000000000000", ALUOutLast, MemOut, Rsrc1Final, Asel, Amux, AmuxEn);
    muxRsrc2: mux4x1 port map ("00000000000000000000000000000000", ALUOutLast, MemOut, Rsrc2Final, Bsel, Bmux, BmuxEn);
    EOCComp : EOC port map (OpCodeIn, OpFlagIn, NOPsig, NopAsig, NopBsig, NotAsig, IncAsig, DecAsig, AswapBsig, AaddBsig, AsubBsig, AandBsig, AorBsig, AshlBsig, AshrBsig, JZSig, AmuxEn, BmuxEn, resetSig);
    PC3_reg : Ex_M_S generic  map (32) port map (clock, resetSig, '1', PC3Sig, PC3);
    EA_reg  : Ex_M_S generic  map (32) port map (clock, resetSig, '1', EAALUSig, EAALU);
    Rdst_reg: Ex_M_S generic  map (3) port map (clock, resetSig, '1', RdstALUSig, RdstALU);
    OpFlag_reg: m_s1bit port map (clock, resetSig, '1', OpFlagOutSig, OpFlagOut);
    OpCode_reg: Ex_M_S generic  map (6) port map (clock, resetSig, '1', OpCodeOutSig, OpCodeOut);
    ALUOut_reg: ALU_MS generic  map (32) port map (clock, resetSig, '1', ALUOutputSig, ALUOutput);

    -- signals to registers of E/M --
    PC3Sig <= PC2;
    EAALUSig <= EADecode;
    RdstALUSig <= RdstDec;
    OpFlagOutSig <= OpFlagIn;
    OpCodeOutSig <= OpCodeIn;
    -- output --
    FlagRegOut <= tempFR when clock = '1';
    
end Execute_Arch;