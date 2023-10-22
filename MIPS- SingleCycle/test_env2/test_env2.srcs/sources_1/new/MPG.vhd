----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2023 06:45:32 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

entity MPG is
Port ( 
signal btn:in std_logic;
signal clk:in std_logic;
signal en:out std_logic
);
end MPG;

architecture Behavioral of MPG is

signal count: std_logic_vector(31 downto 0);
signal Q1: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;

begin

en<= Q2 and (not Q3);

process(clk)
begin
if rising_edge(clk) then
    count<=count+1;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
    if count(15 downto 0) = "1111111111111111" then
       Q1 <= btn;
    end if;
end if; 
end process;

process(clk)
begin
if rising_edge(clk) then
    Q2 <= Q1;
    Q3 <= Q2;
end if;
end process;

end Behavioral;
