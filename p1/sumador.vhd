LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY sumador IS 
PORT(
a,b : IN STD_LOGIC;
c,o : OUT STD_LOGIC);
END sumador;
ARCHITECTURE prueba OF sumador IS
BEGIN 
	c <= a XOR b;
	o <= a AND b;
END prueba;