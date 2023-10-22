----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2023 12:21:29 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
 Port ( 
 clk: in std_logic;
 digits: in std_logic_vector (15 downto 0);
 an: out std_logic_vector (3 downto 0);
 cat: out std_logic_vector (6 downto 0)
 );
end SSD;

architecture Behavioral of SSD is

signal sel: std_logic_vector (1 downto 0);
signal cnt: std_logic_vector (15 downto 0); 
signal digit: std_logic_vector(3 downto 0);

begin

process(clk)
begin
if rising_edge(clk) then
    cnt <= cnt + 1;
end if;
end process;

sel<=cnt(15 downto 14);

process(sel)
begin
case sel is
    when "00" => an <= "1110";
    when "01" => an <= "1101";
    when "10" => an <= "1011";
    when "11" => an <= "0111";
    when others => an <= "1111";
end case;
end process;

process(digit, sel)
begin
case sel is 
    when "00" => digit <= digits(3 downto 0);
    when "01" => digit <= digits(7 downto 4);
    when "10" => digit <= digits(11 downto 8);
    when "11" => digit <= digits(15 downto 12);
end case;
end process;

process(digit)
begin
case digit is 
    when "0000" => cat <= "1000000";
    when "0001" => cat <= "1111001";
    when "0010" => cat <= "0100100";
    when "0011" => cat <= "0110000";
    when "0100" => cat <= "0011001";
    when "0101" => cat <= "0010010";
    when "0110" => cat <= "0000010";
    when "0111" => cat <= "1111000";
    when "1000" => cat <= "0000000";
    when "1001" => cat <= "0010000";
    when "1010" => cat <= "0001000";
    when "1011" => cat <= "0000011";
    when "1100" => cat <= "1000110";
    when "1101" => cat <= "0100001";
    when "1110" => cat <= "0000110";
    when "1111" => cat <= "0001110";
end case;
end process;

end Behavioral;
