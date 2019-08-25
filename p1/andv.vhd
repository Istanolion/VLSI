LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY andv IS 
PORT(
a : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
b : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
c : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END andv;
ARCHITECTURE prueba OF andv IS
BEGIN 
	c <= "00" & (a (1 DOWNTO 0) AND b (1 DOWNTO 0));
END prueba;