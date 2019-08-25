LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY divFreq IS 
PORT (
	clk : IN STD_LOGIC;
	clk1 : OUT STD_LOGIC;
	clk2 : OUT STD_LOGIC 
);
END divFreq;

ARCHITECTURE prueba OF divFreq IS
SIGNAL count : INTEGER :=0;
SIGNAL state1 : STD_LOGIC:='0';
SIGNAL state2 : STD_LOGIC:='0';	
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
	clk1<=state1;
	clk2<=state2;
END prueba;