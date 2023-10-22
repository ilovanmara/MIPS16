----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2023 10:22:30 AM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
 Port (
 opcode: in std_logic_vector(2 downto 0);
 func: in std_logic_vector(2 downto 0);
 RegDst: out std_logic;
 ExtOp: out std_logic;
 ALUSrc: out std_logic;
 Branch: out std_logic;
 Bne: out std_logic;
 Jump: out std_logic;
 MemWrite: out std_logic;
 MemtoReg: out std_logic;
 RegWrite: out std_logic;
 ALUOp: out std_logic_vector(2 downto 0)
  );
end UC;

architecture Behavioral of UC is

begin

process(opcode)
begin
case(opcode) is
    when "000" => RegDst <= '1';-- pt r
                RegWrite<= '1';
                ExtOp<= '0';
                ALUSrc<= '0';
                Branch<='0';
                bne<='0';
                Jump<='0';
                MemWrite<='0';
                MemtoReg<='0';
                ALUOp <= "000";
    when "001" => RegDst <= '0';--addi
                RegWrite<= '1';
                ExtOp<= '1';
                ALUSrc<= '1';
                Branch<='0';
                bne<='0';
                Jump<='0';
                MemWrite<='0';
                MemtoReg<='0';
                ALUOp <= "001";
     when "010" => RegDst <= '0';--lw
                RegWrite<= '1';
                ExtOp<= '1';
                ALUSrc<= '1';
                Branch<='0';
                bne<='0';
                Jump<='0';
                MemWrite<='0';
                MemtoReg<='1';
                ALUOp <= "001";
     when "100" => RegDst <= '0';--beq
                RegWrite<= '0';
                ExtOp<= '1';
                ALUSrc<= '0';
                Branch<='1';
                bne<='0';
                Jump<='0';
                MemWrite<='0';
                MemtoReg<='0';
                ALUOp <= "010";
     when "101" => RegDst <= '0';--bne
                RegWrite<= '0';
                ExtOp<= '1';
                ALUSrc<= '0';
                Branch<='0';
                bne<='1';
                Jump<='0';
                MemWrite<='0';
                MemtoReg<='0';
                ALUOp <= "010";
     when "011" => RegDst <= '0';--sw
                RegWrite<= '0';
                ExtOp<= '1';
                ALUSrc<= '1';
                Branch<='0';
                bne<='0';
                Jump<='0';
                MemWrite<='1';
                MemtoReg<='0';
                ALUOp <= "001";
      when "110" => -- andi
                 RegDst <= '0';
                ExtOp<= '1';
                Branch<='0';
                bne<='0';
                Jump<='0';
                MemWrite<='1';
                MemtoReg<='0';
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "110";
     when "111" => RegDst <= '0';--jump
                RegWrite<= '0';
                ExtOp<= '0';
                ALUSrc<= '0';
                Branch<='0';
                bne<='0';
                Jump<='1';
                MemWrite<='0';
                MemtoReg<='0';
                ALUOp <= "000";
    when others => RegDst <= '0';
                RegWrite<= '0';
                ExtOp<= '0';
                ALUSrc<= '0';
                Branch<='0';
                bne<='0';
                Jump<='0';
                MemWrite<='0';
                MemtoReg<='0';
                ALUOp <= "000";       
end case;
end process;

end Behavioral;
