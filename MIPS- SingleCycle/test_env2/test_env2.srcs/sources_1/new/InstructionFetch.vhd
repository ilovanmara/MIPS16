----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2023 10:52:07 PM
-- Design Name: 
-- Module Name: UNITATE_IF - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionFetch is
    Port(   clk: in std_logic;
            enPC: in std_logic;
            en_reset: in std_logic;
            branch_address: in std_logic_vector(15 downto 0);
            jump_address: in std_logic_vector(15 downto 0);
            jump: in std_logic;
            PCSrc: in std_logic;
            instruction: out std_logic_vector(15 downto 0);
            next_instruction_address: out std_logic_vector(15 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is

signal PC: std_logic_vector(15 downto 0) := (others => '0');
signal outMux1: std_logic_vector(15 downto 0);
signal outMux2: std_logic_vector(15 downto 0);
signal outsum: std_logic_vector(15 downto 0);
type ROMArray is array (0 to 255) of std_logic_vector(15 downto 0);
signal ROM: ROMArray := (

----codul meu
B"000_000_000_001_0_000",--0010 1
B"000_000_000_011_0_000",--0030 2
B"001_000_100_0_000001",--2201 3
B"001_000_101_0_001010",--228A 4
--B"001_000_110_0_000000",--2300 4
B"100_001_101_0_001001",--878A 5
B"010_001_010_0_000000",--5901 6
B"000_010_000_111_0_000",--2381 7
B"110_111_111_0_000001",--238 8
B"100_111_100_0_000010",--BE00 9
B"000_010_011_011_0_000",--0DA0 10 
B"111_0000000001100",--E00C 11
B"000_011_010_011_0_001",--0DA1 12
B"001_001_001_0_000001",--2481 13
--B"001_110_110_0_000001",--3B01
B"1110000000000100",--E005 14
B"011_001_011_0000000", --15
others => X"0000" --NoOp (ADD $0, $0, $0)
);

begin

process(clk, enPC, en_reset, PC, outMux2)
begin
    if rising_edge(clk) then
        if en_reset = '1' then 
            PC <= x"0000"; 
        elsif enPC = '1' then
            PC <= outMux2;
        end if;
    end if;
end process;

process(PCSrc, branch_address, outMux1, outsum)
begin
    case PCSrc is
        when '0' => outMux1 <= outsum;
        when '1' => outMux1 <= branch_address;
    end case;
end process;

process(jump, outMux2, outMux1, jump_address)
begin 
    case jump is
        when '0' => outMux2 <= outMux1;
        when '1' => outMux2 <= jump_address;
    end case;
end process;

outsum <= PC + 1;
next_instruction_address <= outsum;
instruction <= ROM(conv_integer(PC(7 downto 0)));

end Behavioral;