LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY divFreq IS 
PORT (
	clk : IN STD_LOGIC;		--RELOJ TARJETA 50MHZ
	clk1 : OUT STD_LOGIC;   --RELOJ A 1HZ
	clk2 : OUT STD_LOGIC;	--RELOJ A 4HZ
	clk3 : OUT STD_LOGIC		--RELOJ PARA EL 7 SEG PARPADEANTE
);
END divFreq;

ARCHITECTURE prueba OF divFreq IS
SIGNAL count : INTEGER :=0;		--CONTADOR PARA LAS FRECUENCIAS
SIGNAL state1 : STD_LOGIC:='0';	--ESTADO DEL RELOJ 1
SIGNAL state2 : STD_LOGIC:='0';	--ESTADO DEL RELOJ 2
SIGNAL state3 : STD_LOGIC:='0';	--ESTADO DEL RELOJ 3
BEGIN
	PROCESS (clk)
	BEGIN
		IF(clk'EVENT AND clk='1') THEN
			count<=count+1;
		END IF;
		IF (count=50000) THEN
			state1<=NOT state1;
		END IF;
		IF ( (count mod 1250= 0) AND count/=0) THEN
			state2<=NOT state2;
		END IF;
		IF (count=50000) THEN 
			count<=0;
		END IF;
	END PROCESS;
	--asignacion de los estados a las salidas
	clk1<=state1;
	clk2<=state2;
	clk3<=state3;
END prueba;