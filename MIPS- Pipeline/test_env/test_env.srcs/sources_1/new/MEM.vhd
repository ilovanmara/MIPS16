----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2023 08:56:17 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
 Port (
 clk : in std_logic;
 en : in std_logic;
 MemWrite : in std_logic;
 AluRes : in std_logic_vector (15 downto 0);
 RD2 : in std_logic_vector(15 downto 0);
 MemData : out std_logic_vector (15 downto 0);
 AluResOut : out std_logic_vector (15 downto 0)
  );
end MEM;

architecture Behavioral of MEM is

type mem_type is array (0 to 15) of std_logic_vector(15 downto 0);
signal MemRam : mem_type := (
    X"0008",
    X"0007",
    X"000A",
    X"0004",
    X"0005",
    X"0006",
    X"0002",
    X"0001",
    X"0009",
    X"0008",
    others => X"0000"
);

begin

process(clk)
begin
if rising_edge(clk) then
    if en = '1' then
        if MemWrite = '1' then
            MemRam(CONV_INTEGER(AluRes(4 downto 0))) <= RD2;
        end if;
    end if;
end if;

end process;

MemData <=MemRam(conv_integer(AluRes(4 downto 0)));
AluResOut <= AluRes;

end Behavioral;
