----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 08:34:43 PM
-- Design Name: 
-- Module Name: ExUnit - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ExUnit is
 Port ( 
 PCinc : in std_logic_vector(15 downto 0);
 RD1: in std_logic_vector(15 downto 0);
 RD2: in std_logic_vector(15 downto 0);
 Ext_Imm: in Std_logic_vector(15 downto 0);
 func: in std_logic_vector(2 downto 0);
 sa: in std_logic;
 ALUSrc: in std_logic;
 AluOp: in std_logic_vector(2 downto 0);
 BranchAddress : out std_logic_vector(15 downto 0);
 Zero: out std_logic;
 ALURes: out std_logic_vector(15 downto 0);
 rt: in std_logic_vector(2 downto 0);
 rd: in std_logic_vector(2 downto 0);
 RegDst: in std_logic;
 rWA: out std_logic_vector(2 downto 0)
 );
end ExUnit;

architecture Behavioral of ExUnit is

signal AluIn: std_logic_vector(15 downto 0);
signal AluCtrl: std_logic_vector(2 downto 0);
signal ALUResAux : STD_LOGIC_VECTOR(15 downto 0);

begin

--vedem ce inta in alu
process(ALUSrc)
begin
case ALUSrc is 
    when '0' => AluIn <= RD2;
    when '1' => AluIn <= Ext_Imm;
end case;
end process;

process(AluOp, func)
begin
case AluOp is 
    when "000" =>
    case func is
        when "000" => AluCtrl <= "000";
        when "001" => AluCtrl <= "001";
        when "010" => AluCtrl <= "010";
        when "011" => AluCtrl <= "011";
        when "100" => AluCtrl <= "100";
        when others =>AluCtrl <= "000";
    end case;
    when "001" => AluCtrl <= "000";
    when "010" => AluCtrl <= "001";
    when "110" => AluCtrl <= "100";
    when others => AluCtrl <= "000";
end case;
end process;

process(AluCtrl, RD1, AluIn, sa, ALUResAux)
begin
case AluCtrl is 
    when "000" => ALUResAux <= RD1 + AluIn;
    when "001" => ALUResAux <= RD1 - AluIn;
    when "100" => ALUResAux<=RD1 and AluIn;			
    when others => ALUResAux <= (others => '0');              
    end case;   
            
end process;

process(ALUResAux)
begin
case ALUResAux is
    when X"0000" => Zero <= '1';
    when others => Zero <= '0';
end case; 
end process;

ALURes <= ALUResAux;
BranchAddress <= PCinc + Ext_Imm;

process(RegDst, rt, rd)
begin
case (RegDst) is 
    when '0' => rWA <= rt;
    when '1' => rWA <= rd;
 end case;
end process;


end Behavioral;
