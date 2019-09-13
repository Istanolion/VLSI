LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Divisor IS 
PORT (
	clk_50MHz : IN  STD_LOGIC;	 --RELOJ TARJETA 50MHZ
	clk_80Hz   : OUT STD_LOGIC  --RELOJ A 40HZ
);
END Divisor;

ARCHITECTURE Behaivor OF Divisor IS
SIGNAL count  : INTEGER := 0;		--CONTADOR PARA LAS FRECUENCIAS
SIGNAL Estado : STD_LOGIC := '0';	--ESTADO DEL RELOJ 1

BEGIN
	PROCESS (clk_50MHz)
	BEGIN
		IF(clk_50MHz'EVENT AND clk_50MHz = '1') THEN
			
			IF (count < 625000) THEN
				count <= count + 1;
			ELSE
				Estado <= NOT Estado;
				count <= 0;
			END IF;
		END IF;
	END PROCESS;
	--asignacion de los estados a la salida
	clk_80Hz <= Estado;
END Behaivor;