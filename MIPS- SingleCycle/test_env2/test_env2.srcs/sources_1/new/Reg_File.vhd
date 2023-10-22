----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2023 01:37:43 PM
-- Design Name: 
-- Module Name: Reg_File - Behavioral
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

entity Reg_File is
 Port (
 clk :in std_logic;
 ra1 :in std_logic_vector(2 downto 0);
 ra2 :in std_logic_vector(2 downto 0);
 wa :in std_logic_vector(2 downto 0);
 wd :in std_logic_vector(15 downto 0);
 RegWr :in std_logic;
 rd1 :out std_logic_vector(15 downto 0);
 rd2 :out std_logic_vector(15 downto 0);
 en :in std_logic
  );
end Reg_File;

architecture Behavioral of Reg_File is

type reg_array is array(0 to 7)of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (
x"0000",
x"0000",
x"0000",
x"0000",
x"0000",
x"0011",
x"0101",
others => x"0000"
);

begin
process(clk)
begin
    if rising_edge(clk) then
        if RegWr = '1'and en = '1' then
            reg_file(conv_integer(wa))<=wd;
        end if;
    end if;
end process;

rd1<=reg_file(conv_integer(ra1));
rd2<=reg_file(conv_integer(ra2));

end Behavioral;
