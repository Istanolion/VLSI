LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY reloj IS
PORT (
	clk : IN STD_LOGIC; --reloj que nos marca la velocidad con la que va el reloj
	temporizador: IN STD_LOGIC; --para medir cuanto tiempo han sido presionado los botones (1hz)
	set : IN STD_LOGIC;
	sel : IN STD_LOGIC;
	--salidas para el decodificador a 7 segmentos
	s : OUT INTEGER;
	m : OUT INTEGER;
	h : OUT INTEGER
);
END reloj;

ARCHITECTURE prueba OF reloj IS
SIGNAL selection : INTEGER RANGE 0 TO 6; --NOS AYUDARA A VER CUAL NUMERO ESTAMOS SELECCIONANDO
SIGNAL counter : INTEGER RANGE 0 TO 3:=0; --EL CONTADOR PARA VER SI SET ESTUVO POR DOS SEGUNDOS
SIGNAL estado_normal : STD_LOGIC :='1';--DETERMINA SI FUNCIONA NORMALMENTE O PASARA A SET
--SEÑALES PARA DETERMINAR EL NUMERO DE CADA DISPLAY
SIGNAL seg,sseg 		: INTEGER RANGE 0 TO 59:=0;
SIGNAL min,smin 		: INTEGER RANGE 0 TO 59:=0;
SIGNAL hr,shr 		: INTEGER RANGE 0 TO 23:=0;
BEGIN
	PROCESS(clk,temporizador)
	BEGIN
	--Deteccion del boton set
	IF(temporizador'EVENT AND temporizador='1') THEN
		IF(set='1') THEN
			counter<=counter+1;
		ELSE 
			counter<=0;
		END IF;
		IF counter=2 THEN
			estado_normal <= NOT estado_normal;
		END IF;
	END IF;
	--FUNCIONAMIENTO NORMAL DEL RELOJ (24H)
		IF (clk'EVENT AND clk='1' AND estado_normal='1') THEN
			IF(seg < 59 ) THEN
				seg <= seg+1;
			ELSE
				seg<=0;
				IF min < 59 THEN
					min <= min+1;
				ELSE
					min <= 0;
					IF hr < 23 THEN
						hr <= hr+1;
					ELSE 
						hr <= 0;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	--Cuando se puede cambiar la hora, selection nos dira que digito cambiar (y debe de parpadear)
		--	el risign edge de set nos dira cuando aumentar el valor del digito seleccionado manteniendo su maxima numeracion.
		
	/*PRocESS(sel,set)
	BEGIN
		IF (estado_normal='0') THEN
			
			IF (sel'EVENT AND sel='1') THEN
				IF selection<6 THEN
					selection<=selection+1;
				ELSE
					selection<=0;
				END IF;
			END IF;
			IF (set'EVENT AND set='1') THEN
					CASE selection IS
						WHEN 0 =>
							IF(sseg < 9 ) THEN
								sseg <= sseg+1;
							ELSE
								sseg<=0;
							END IF;
						WHEN 1=>
							IF (sdecseg < 6) THEN
								sdecseg <= sdecseg+1;
							ELSE
								sdecseg <= 0;
							END IF;
						WHEN 2=>
							IF smin < 9 THEN
								smin <= smin+1;
							ELSE
								smin <= 0;
							END IF;
						WHEN 3=>
							IF sdecmin < 6 THEN
								sdecmin <= sdecmin+1;
							ELSE
								sdecmin <= 0;
							END IF;
						WHEN 4=>
							IF shr < 9 THEN
								shr <= shr+1;
							ELSE 
								shr <= 0;
							END IF;
						WHEN 5=>
							IF sdechr < 2 THEN 
								sdechr <= sdechr+1;
							ELSE
								sdechr <= 0;
							END IF;
						WHEN OTHERS=>
							sseg<=0;
					END CASE;
			END IF;
		END IF;
	END PROCESS;
	--se asignan los valores de salida de nuestro reloj 
	*/
	s<=seg ;
	m<=min  ;
	h<=hr ;
	
	
END prueba;