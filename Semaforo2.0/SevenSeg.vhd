LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SevenSeg IS 
PORT( Clk    : IN  STD_LOGIC;	 							--RELOJ PARA REFRESCAMIENTO
		Estado : IN  STD_LOGIC_VECTOR (1 downto 0); 	--Indica si esta en Verde, Amarillo o Rojo
		HEX    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)	--Siete Segmentos
);	
END SevenSeg;

ARCHITECTURE prueba OF SevenSeg IS 

	SIGNAL state: STD_LOGIC:='1';
	
BEGIN
	PROCESS(clk)--PROCESO DE REFRESCAMIENTO
	BEGIN
		IF(Clk'EVENT AND Clk='1') THEN 
			IF state='1' THEN
				CASE Estado IS 
					wHEN "00" => HEX <="11000001"; --V
					WHEN "01" => HEX <="10001000"; --A
					WHEN "10" => HEX <="10101111"; --r
					WHEN OTHERS => HEX <="11111111";
			END CASE;
			ELSE
				HEX<="11111111";
			END IF;
			state<=NOT state;
		END IF;
	END PROCESS;

END prueba;