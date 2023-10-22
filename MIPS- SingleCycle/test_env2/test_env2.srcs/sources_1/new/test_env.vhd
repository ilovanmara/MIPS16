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
branch_address=>BranchAdress, 
jump_address=>JumpAddress,
jump=>Jump, 
PCSrc=>PCSrc, 
instruction=>instruction,
next_instruction_address=>next_instruction_address);

instr_id: entity WORK.InstructionDecode  port map (
 clk=>clk,
 --en=>en,
 RegWrite=>RegWr,
 --instr=>instruction,
 RegDest=>RegDst,
 ExtOp=>ExtOp,
 instr=>instruction,
 WD=>sum,
 en=>en,
 RD1=>RD1,
 RD2=>RD2,
 Ext_Imm=>Ext_Imm,
 funct=>func,
 sa=>sa
  );
  
instr_MC: entity WORK.UC port map(
 opcode=>instruction(15 downto 13),
 func=>instruction(2 downto 0),
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
 PCinc=>next_instruction_address,
 RD1=>RD1,
 RD2=>RD2,
 Ext_Imm=>Ext_Imm,
 func=>func,
 sa=>sa,
 ALUSrc=>ALUSrc,
 AluOp=>ALUOp,
 BranchAddress=>BranchAdress,
 Zero=>Zero,
 ALURes=>AluRes
 );

instr_MEM: entity WORK.MEM port map(
 clk=>clk,
 en=>en,
 MemWrite=>MemWrite,
 AluRes=>AluRes,
 RD2=>RD2,
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

process(MemtoReg) 
begin
    case (MemtoReg) is 
        when '1' => sum <= MemData;
        when '0' => sum <= AluResNew;
    end case;    
end process;

   ZeroNeg <= not Zero;
   PCSrc1 <= Zero and Branch;
   PCSrc2 <= ZeroNeg and bne;
   PCSrc <= PCSrc1 or PCSrc2;

 jumpAddress <= next_instruction_address(15 downto 13) & Instruction(12 downto 0);
 
with sw(7 downto 5) select
        digits <=  instruction when "000", 
                   next_instruction_address when "001",
                   RD1 when "010",
                   RD2 when "011",
                   Ext_Imm when "100",
                   AluRes when "101",
                   MemData when "110",
                   sum when "111",
                   (others => '0') when others; 

led(10 downto 0) <= ALUOP & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWr;


end Behavioral;
