----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2023 12:35:39 PM
-- Design Name: 
-- Module Name: InstructionDecode - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionDecode is
 Port (
 clk: in std_logic;
 RegWrite: in std_logic;
 RegDest: in std_logic;
 ExtOp: in std_logic;
 instr: in std_logic_vector(15 downto 0);
 WD: in std_logic_vector(15 downto 0);
 en: in std_logic;
 RD1: out std_logic_vector(15 downto 0);
 RD2: out std_logic_vector(15 downto 0);
 Ext_Imm: out std_logic_vector(15 downto 0);
 funct: out std_logic_vector(2 downto 0);
 sa: out std_logic
  );
end InstructionDecode;

architecture Behavioral of InstructionDecode is

signal RegDestMuxOut: std_logic_vector (2 downto 0);
signal WA: std_logic_vector (2 downto 0);
signal RA1: std_logic_vector (2 downto 0);
signal RA2: std_logic_vector (2 downto 0);
begin


RA1 <= instr(12 downto 10);
RA2 <= instr(9 downto 7);

process(RegDest, RegDestMuxOut, instr)
begin
case RegDest is 
    when '0' => RegDestMuxOut <= instr(9 downto 7);
    when '1' => RegDestMuxOut <= instr(6 downto 4);
    when others => RegDestMuxOut <= "000";
end case;
end process;

REG_FILE: entity WORK.Reg_file port map(
clk=>clk,
ra1=>RA1,
ra2=>RA2,
wa=>RegDestMuxOut, 
wd=>WD, 
RegWr=>RegWrite,
rd1=>RD1, 
rd2=>RD2,
en=>en 
);

Ext_Imm(6 downto 0) <= Instr(6 downto 0); 
process(ExtOp, instr)
begin
case ExtOp is 
    when '0' => Ext_Imm(15 downto 7) <= "000000000";
    when '1' => Ext_Imm(15 downto 7) <= (others => instr(6));
end case;
end process;

funct <= instr(2 downto 0);
sa<= instr(3);

end Behavioral;


