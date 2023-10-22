----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2023 12:54:46 PM
-- Design Name: 
-- Module Name: saqwdf - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

signal en: std_logic;
signal reset: std_logic;
signal digits: std_logic_vector(15 downto 0);
signal next_instruction_address: std_logic_vector(15 downto 0);
signal instruction, PCinc, sum, RD1, RD2, Ext_Imm, Ext_func, Ext_sa: std_logic_vector(15 downto 0);

signal func: std_logic_vector(2 downto 0);
signal sa: std_logic;
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWr, bne: std_logic;
signal ALUOp: std_logic_vector (2 downto 0);
signal AluRes: std_logic_vector (15 downto 0);
signal Zero: std_logic;
signal MemData: std_logic_vector(15 downto 0);
signal AluResNew: std_logic_vector(15 downto 0);
signal PCSrc1: std_logic;
signal PCSrc2: std_logic;
signal PCSrc: std_logic;
signal jumpAddress: std_logic_vector(15 downto 0);
signal BranchAdress: std_logic_vector(15 downto 0);
signal ZeroNeg: std_logic;

--mips pipeline
signal PCinc_IF_ID, Instruction_IF_ID : std_logic_vector(15 downto 0);
signal PCinc_ID_EX : std_logic_vector(15 downto 0);
signal RD2_ID_EX : std_logic_vector(15 downto 0);
signal RD1_ID_EX : std_logic_vector(15 downto 0);
signal Ext_imm_ID_EX : std_logic_vector(15 downto 0);
signal func_ID_EX, rd_ID_EX, rt_ID_EX, ALUOp_ID_EX: std_logic_vector(2 downto 0);
signal sa_ID_EX, MemtoReg_ID_EX, RegWrite_ID_EX, MemWrite_ID_EX, Branch_ID_EX, ALUsrc_ID_EX: std_logic;
signal BranchAdress_EX_MEM, ALURes_EX_MEM, RD2_EX_MEM: std_logic_vector(15 downto 0);
signal rd_EX_MEM: std_logic_vector(2 downto 0);
signal zero_EX_MEM, MemtoReg_EX_MEM, RegWrite_EX_MEM, MemWrite_EX_MEM, Branch_EX_MEM: std_logic;
signal MemData_MEM_WB, ALURes_MEM_WB: std_logic_vector(15 downto 0);
signal rd_MEM_WB: std_logic_vector(2 downto 0);
signal MemtoReg_MEM_WD, RegWrite_MEM_WB: std_logic;
signal rt, rd, rWA: std_logic_vector(2 downto 0);
signal RegDst_ID_EX : std_logic;
begin

mpg_PC:entity WORK.MPG port map(
btn=>btn(0),
clk=>clk,
 en=>en);

mpg_RESET:entity WORK.MPG port map(
btn=>btn(1), 
clk=>clk,
en=>reset);

ssd:entity WORK.SSD port map(
clk=>clk,
digits=>digits,
an=>an,
cat=>cat
);

unit_if:entity WORK.InstructionFetch port map(
clk=>clk, 
enPC=>en, 
en_reset=>reset, 
branch_address=>BranchAdress_EX_MEM, 
jump_address=>JumpAddress,
jump=>Jump, 
PCSrc=>PCSrc, 
instruction=>instruction,
next_instruction_address=>next_instruction_address);

instr_id: entity WORK.InstructionDecode  port map (
 clk=>clk,
 --en=>en,
 RegWrite=>RegWrite_MEM_WB,
 --instr=>instruction,
 RegDest=>RegDst,
 ExtOp=>ExtOp,
 instr=>Instruction_IF_ID,
 WD=>sum,
 en=>en,
 RD1=>RD1,
 RD2=>RD2,
 Ext_Imm=>Ext_Imm,
 funct=>func,
 sa=>sa,
 WA=> rd_MEM_WB,
 rt=>rt,
 rd=>rd
  );
  
instr_MC: entity WORK.UC port map(
 opcode=>Instruction_IF_ID(15 downto 13),
 func=>Instruction_IF_ID(2 downto 0),
 RegDst=>RegDst,
 ExtOp=>ExtOp,
 ALUSrc=>ALUSrc,
 Branch=>Branch,
 Bne=>bne,
 Jump=>Jump,
 MemWrite=>MemWrite,
 MemtoReg=>MemtoReg,
 RegWrite=>RegWr,
 ALUOp=>ALUOp
);

instr_EX: entity WORK.ExUnit port map(
 PCinc=>PCinc_ID_EX,
 RD1=>RD1_ID_EX,
 RD2=>RD2_ID_EX,
 Ext_Imm=>Ext_Imm_ID_EX,
 func=>func_ID_EX,
 sa=>sa_ID_EX,
 ALUSrc=>ALUsrc_ID_EX,
 AluOp=>ALUOp_ID_EX,
 BranchAddress=>BranchAdress,
 Zero=>Zero,
 ALURes=>AluRes,
 rt=>rt_ID_EX,
 rd=>rd_ID_EX,
 RegDst=>RegDst_ID_EX,
 rWA=>rWA
 );

instr_MEM: entity WORK.MEM port map(
 clk=>clk,
 en=>en,
 MemWrite=>MemWrite_EX_MEM,
 AluRes=>ALURes_EX_MEM,
 RD2=>RD2_EX_MEM,
 MemData=>MemData,
 AluResOut=>AluResNew
  );
  
-- sum <= RD1 + RD2;
-- Ext_func <= "0000000000000" & func;
-- Ext_sa <= "000000000000000" & sa;
 
   
--   with MemtoReg select
--       sum <= MemData when '1',
--             AluResNew when '0',
--             (others => '0') when others;

process(MemtoReg_MEM_WD) 
begin
    case (MemtoReg_MEM_WD) is 
        when '1' => sum <= MemData_MEM_WB;
        when '0' => sum <= ALURes_MEM_WB;
    end case;    
end process;

   --ZeroNeg <= not Zero_EX_MEM;
   PCSrc1 <= Zero_EX_MEM and Branch_EX_MEM;
  -- PCSrc2 <= ZeroNeg and bne;
   PCSrc <= PCSrc1;

 jumpAddress <= PCinc_IF_ID(15 downto 13) & Instruction_IF_ID(12 downto 0);
 
 --pipeline
 process(clk, instruction,next_instruction_address,RD1, RD2, Ext_Imm, func)
 begin
 if rising_edge(clk) then
    if en = '1' then
        PCinc_IF_ID <= next_instruction_address;
        Instruction_IF_ID <= instruction;
        
        PCinc_ID_EX<=PCinc_IF_ID;
        RD1_ID_EX <= RD1;
        RD2_ID_EX <= RD2;
        Ext_imm_ID_EX <= Ext_imm;
        sa_ID_EX <= sa;
        func_ID_EX <= func;
        rt_ID_EX <= rt;
        rd_ID_EX <= rd;
        MemtoReg_ID_EX <= MemtoReg;
        RegWrite_ID_EX <= RegWr;
        MemWrite_ID_EX <= MemWrite;
        Branch_ID_EX <= Branch;
        ALUsrc_ID_EX <= ALUSrc;
        ALUOp_ID_EX <= ALUOp;
        RegDst_ID_EX <= RegDst;
        
        BranchAdress_EX_MEM <= BranchAdress;
        zero_EX_MEM <= zero;
        ALURes_EX_MEM <= AluRes;
        RD2_EX_MEM <= RD2_ID_EX;
        rd_EX_MEM <= rWA;
        MemtoReg_EX_MEM <= MemtoReg_ID_EX;
        RegWrite_EX_MEM <= RegWrite_ID_EX;
        MemWrite_EX_MEM <= MemWrite_ID_EX;
        Branch_EX_MEM <= Branch_ID_EX;
        
        MemData_MEM_WB <= MemData;
        ALURes_MEM_WB <= AluResNew;
        rd_MEM_WB <= rd_EX_MEM;
        MemtoReg_MEM_WD <= MemtoReg_EX_MEM;
        RegWrite_MEM_WB <= RegWrite_EX_MEM;
        
    end if;
 end if;
 end process;
 
 
with sw(7 downto 5) select
        digits <=  instruction when "000", 
                   next_instruction_address when "001",
                   RD1_ID_EX when "010",
                   RD2_ID_EX when "011",
                   Ext_imm_ID_EX when "100",
                   AluRes when "101",
                   MemData when "110",
                   sum when "111",
                   (others => '0') when others; 

led(10 downto 0) <= ALUOP & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWr;


end Behavioral;
