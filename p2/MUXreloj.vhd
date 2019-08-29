LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY MUXreloj IS
PORT (
clk50hz : IN STD_LOGIC;
clk1 : IN STD_LOGIC;
clk2 : IN STD_LOGIC;
vel : IN STD_LOGIC;
salida : OUT STD_LOGIC
);
END MUXreloj;

ARCHITECTURE prueba OF MUXreloj IS
BEGIN
	PROCESS(clk50hz)
	BEGIN
	IF (clk50hz'EVENT AND clk50hz='1') THEN
		IF(vel='0') THEN
			salida<=clk1;
		ELSE
			salida<=clk2;
		END IF;
	END IF;
	END PROCESS;
END prueba;