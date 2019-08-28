LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY deco7Seg IS 
PORT(
numero : IN INTEGER RANGE 0 TO 9; --numero a decodificar
clk : IN STD_LOGIC;	--RELOJ PARA REFRESCAMIENTO
HEXu : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); --salidas a pines
HEXd : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
);
END deco7seg;
ARCHITECTURE prueba OF deco7seg IS 
signal unidades,decenas : INTEGER:=0;
BEGIN
	unidades<=numero mod 10;
	decenas <= numero /10;
	PROCESS(clk)--PROCESO DE REFRESCAMIENTO
	BEGIN
		IF(clk'EVENT AND clk='1') THEN --SI EL FLANCO ES POSITIVO SE ASIGNA EL VALOR.
			CASE unidades IS
				WHEN 0 => HEXu<="11000000";
				WHEN 1 => HEXu<="11111001";
				WHEN 2 => HEXu<="10100100";
				WHEN 3 => HEXu<="10110000";
				WHEN 4 => HEXu<="10011001";
				WHEN 5 => HEXu<="10010010";
				WHEN 6 => HEXu<="10000010";
				WHEN 7 => HEXu<="11111000";
				WHEN 8 => HEXu<="10000000";
				WHEN 9 => HEXu<="10010000";
				WHEN OTHERS  => HEXu<="11111111";
			END CASE;
			CASE decenas IS
				WHEN 0 => HEXd<="11000000";
				WHEN 1 => HEXd<="11111001";
				WHEN 2 => HEXd<="10100100";
				WHEN 3 => HEXd<="10110000";
				WHEN 4 => HEXd<="10011001";
				WHEN 5 => HEXd<="10010010";
				WHEN 6 => HEXd<="10000010";
				WHEN 7 => HEXd<="11111000";
				WHEN 8 => HEXd<="10000000";
				WHEN 9 => HEXd<="10010000";
				WHEN OTHERS  => HEXd<="11111111";
			END CASE;
		END IF;
	END PROCESS;

END prueba;