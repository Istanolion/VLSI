LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY interfazKeypad IS 
PORT(
numero : OUT INTEGER ; --numero presionado
activa : OUT STD_LOGIC; --activa la cerradura para decir que se esta mandando un nuevo numero
clk : IN STD_LOGIC;	--RELOJ PARA REFRESCAMIENTO
--COLUMNAS Y RENGLONES COL SERAN LAS QUE HACEN EL BARRIDO DEL KEYPAD
col : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
ren : IN STD_LOGIC_VECTOR (3 DOWNTO 0)
);
END interfazKeypad;
--El barrido ira mandando la señal high de columna en columna y reconocera que 
--renglon es el que esta cerrando el circuito, con estos dos valores
--se determinara que numero se esta presionando
--el barrido se hace con el reloj de 50MHz para que no sea molesto al usuario
ARCHITECTURE prueba OF interfazKeypad IS 
--la señal de barrido hara un corrimiento de bits para marcar una unica salida
SIGNAL barrido : STD_LOGIC_VECTOR (2 DOWNTO 0):="001";
--columna y renglon presionada
--renglon 0 es el de hasta arriba
--columna 0 es el la primera de izq a der
--se agrega el valor 4 para ver cuando no se esta presionando ningun boton, o se presionan
--dos o mas botones al mismo tiempo
SIGNAL pcol,pren : INTEGER RANGE 0 TO 4:=4;
--numero presionado para mandar a la cerradura
SIGNAL pNum : INTEGER RANGE 0 TO 9:=0;
--SE INGRESO NUEVO NUMERO?
SIGNAL prendido : STD_LOGIC:='0';
BEGIN
	PROCESS(clk)
	BEGIN
	--se asigna el valor a pren, dependiendo del valor devuelto de ren
		CASE ren IS
			WHEN "1110" => pren<=0;
			WHEN "1101" => pren<=1;
			WHEN "1011" => pren<=2; 
			WHEN "0111" => pren<=3;
			WHEN OTHERS => pren<=4;
		END CASE;
		--dependiendo la columna que este prendida se asigna ese valor a pcol
		CASE barrido IS
			WHEN "001" => pcol<=0;
			WHEN "010" => pcol<=1;
			WHEN "100" => pcol<=2;
			WHEN OTHERS => pcol<=4;
		END CASE;
		--IF(pren/=4 AND pcol/=4) THEN
			-- prendido<='1';
			 --asignacion del numero presionado viendo los valores de pren y pcol
			-- IF pren=0 THEN
			--	IF pcol=0 THEN
			--		pnum<=1;
			--	ELSIF pcol=1 THEN
			--		pnum<=2;
			--	ELSIF pcol=2 THEN
			--		pnum<=3;
			--	END IF;
			-- ELSIF pren=1 THEN
				--IF pcol=0 THEN
					--pnum<=4;
--				ELSIF pcol=1 THEN
	--				pnum<=5;
		--		ELSIF pcol=2 THEN
			--		pnum<=6;
				--END IF;
--			 ELSIF pren=2 THEN
	--			IF pcol=0 THEN
		--			pnum<=7;
			--	ELSIF pcol=1 THEN
				--	pnum<=8;
--				ELSIF pcol=2 THEN
	--				pnum<=9;
		--		END IF;
			--ELSIF pren=3 THEN
				--IF pcol=2 THEN
					--pnum<=0;
--				END IF;
	--		 END IF;
		--ELSE
			--no se ha presionado un solo boton
			--prendido<='0';
	--	END IF;
		IF pren=0 THEN 
			prendido<='1';
			pnum<=1;
		ELSE
			prendido<='0';
		END IF;
		barrido<=barrido(1 DOWNTO 0) & barrido(2);
	END PROCESS;
	--asignacion a las salidas
	col<=barrido;
	activa<=prendido;
	numero<=pnum;
END prueba;