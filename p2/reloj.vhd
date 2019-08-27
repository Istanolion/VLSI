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
	ds : OUT INTEGER;
	m : OUT INTEGER;
	dm : OUT INTEGER;
	h : OUT INTEGER;
	dh : OUT INTEGER
);
END reloj;

ARCHITECTURE prueba OF reloj IS
SIGNAL selection : INTEGER RANGE 0 TO 6; --NOS AYUDARA A VER CUAL NUMERO ESTAMOS SELECCIONANDO
SIGNAL counter : INTEGER RANGE 0 TO 3:=0; --EL CONTADOR PARA VER SI SET ESTUVO POR DOS SEGUNDOS
SIGNAL estado_normal : STD_LOGIC :='0';--DETERMINA SI FUNCIONA NORMALMENTE O PASARA A SET
--SEÑALES PARA DETERMINAR EL NUMERO DE CADA DISPLAY
SIGNAL seg 		: INTEGER RANGE 0 TO 9:=0;
SIGNAL decseg 	: INTEGER RANGE 0 TO 9:=0;
SIGNAL min 		: INTEGER RANGE 0 TO 9:=0;
SIGNAL decmin 	: INTEGER RANGE 0 TO 9:=0;
SIGNAL hr 		: INTEGER RANGE 0 TO 9:=0;
SIGNAL dechr 	: INTEGER RANGE 0 TO 9:=0;
BEGIN
	PROCESS(clk,temporizador,set,sel)
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
			selection<=0;
		END IF;
	END IF;
	--FUNCIONAMIENTO NORMAL DEL RELOJ (24H)
		IF (clk'EVENT AND clk='1' AND estado_normal='1') THEN
			IF(seg < 9 ) THEN
				seg <= seg+1;
			ELSE
				seg<=0;
				IF (decseg < 6) THEN
					decseg <= decseg+1;
				ELSE
					decseg <= 0;
					IF min < 9 THEN
						min <= min+1;
					ELSE
						min <= 0;
						IF decmin < 6 THEN
							decmin <= decmin+1;
						ELSE
							decmin <= 0;
							IF hr < 9 THEN
								hr <= hr+1;
							ELSE 
								hr <= 0;
								IF dechr < 2 THEN 
									dechr <= dechr+1;
								ELSE
									dechr <= 0;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
		--Cuando se puede cambiar la hora, selection nos dira que digito cambiar (y debe de parpadear)
		--	el risign edge de set nos dira cuando aumentar el valor del digito seleccionado manteniendo su maxima numeracion.
		ELSIF (estado_normal='0') THEN
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
							IF(seg < 9 ) THEN
								seg <= seg+1;
							ELSE
								seg<=0;
							END IF;
						WHEN 1=>
							IF (decseg < 6) THEN
								decseg <= decseg+1;
							ELSE
								decseg <= 0;
							END IF;
						WHEN 2=>
							IF min < 9 THEN
								min <= min+1;
							ELSE
								min <= 0;
							END IF;
						WHEN 3=>
							IF decmin < 6 THEN
								decmin <= decmin+1;
							ELSE
								decmin <= 0;
							END IF;
						WHEN 4=>
							IF hr < 9 THEN
								hr <= hr+1;
							ELSE 
								hr <= 0;
							END IF;
						WHEN 5=>
							IF dechr < 2 THEN 
								dechr <= dechr+1;
							ELSE
								dechr <= 0;
							END IF;
					END CASE;
			END IF;
		END IF;
		
	END PROCESS;
	--se asignan los valores de salida de nuestro reloj 
	s<=seg;
	ds<=decseg;
	m<=min;
	dm<=decmin;
	h<=hr;
	dh<=dechr;
END prueba;