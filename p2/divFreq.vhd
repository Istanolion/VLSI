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
SIGNAL count,count2 : INTEGER :=0;		--CONTADOR PARA LAS FRECUENCIAS
SIGNAL state1 : STD_LOGIC:='0';	--ESTADO DEL RELOJ 1
SIGNAL state2 : STD_LOGIC:='0';	--ESTADO DEL RELOJ 2
SIGNAL state3 : STD_LOGIC:='0';	--ESTADO DEL RELOJ 3
BEGIN
	PROCESS (clk)
	BEGIN
		IF(clk'EVENT AND clk='1') THEN
			count<=count+1;
			count2<=count2+1;
		END IF;
		IF (count=25000000) THEN
			state1<=NOT state1;
			count<=0;
		END IF;
		IF ( (count2 =6250000)) THEN
			state2<=NOT state2;
			count2<=0;
		END IF;
	END PROCESS;
	--asignacion de los estados a las salidas
	clk1<=state1;
	clk2<=state2;
	clk3<=state3;
END prueba;