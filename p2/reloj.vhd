LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY reloj IS
PORT (
	LEDR0: OUT STD_LOGIC;
	clk : IN STD_LOGIC; --reloj que nos marca la velocidad con la que va el reloj
	temporizador: IN STD_LOGIC; --para medir cuanto tiempo han sido presionado los botones (1hz)
	set : IN STD_LOGIC;
	sel : IN STD_LOGIC;
	--salidas para el decodificador a 7 segmentos
	su : OUT INTEGER;
	mu : OUT INTEGER;
	hu : OUT INTEGER;
	sd : OUT INTEGER;
	md : OUT INTEGER;
	hd : OUT INTEGER
);
END reloj;

ARCHITECTURE prueba OF reloj IS
SIGNAL selection : INTEGER RANGE 0 TO 6; --NOS AYUDARA A VER CUAL NUMERO ESTAMOS SELECCIONANDO
SIGNAL counter : INTEGER RANGE 0 TO 3:=0; --EL CONTADOR PARA VER SI SET ESTUVO POR DOS SEGUNDOS
SIGNAL estado_normal : STD_LOGIC :='1';--DETERMINA SI FUNCIONA NORMALMENTE O PASARA A SET
--SEÑALES PARA DETERMINAR EL NUMERO DE CADA DISPLAY
SIGNAL seg,segd		: INTEGER RANGE 0 TO 9:=0;
SIGNAL min,mind,hr		: INTEGER RANGE 0 TO 9:=0;
SIGNAL hrd 		: INTEGER RANGE 0 TO 3:=0;
SIGNAL tsu,tmu,thu,tsd,tmd,thd: INTEGER RANGE 0 TO 9:=0;
SIGNAL ssegu,ssegd,sminu,smind,shru,shrd: INTEGER RANGE 0 TO 9:=0;
BEGIN
	/*ssegu<=0;
			ssegd<=0;
			sminu<=0;
			smind<=0;
			shru<=0;
			shrd<=0;*/
	PROCESS(clk,temporizador)
	BEGIN
	
	--Deteccion del boton set
	IF(temporizador'EVENT AND temporizador='1') THEN
		IF(set='0') THEN
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
			IF(seg < 9 ) THEN
				seg <= tsu+1;
			ELSE
				seg<=0;
				IF segd<5 THEN
					segd<=tsd+1;
				ELSE
					segd<=0;
					IF min < 9 THEN
						min <= tmu+1;
					ELSE
						min <= 0;
						IF mind <5 THEN
							mind<=tmd+1;
						ELSE
							mind<=0;
							IF hr < 9 AND hrd<2 THEN
								hr <= thu+1;
							ELSE 
								IF hrd<2 THEN
									hrd<=thd+1;
									hr <= 0;
								ELSif hr<3 THEN
									hr<=thd+1;
								ELSE
									hrd<=0;
									hr<=0;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	--Cuando se puede cambiar la hora, selection nos dira que digito cambiar (y debe de parpadear)
		--	el risign edge de set nos dira cuando aumentar el valor del digito seleccionado manteniendo su maxima numeracion.
		
	PRocESS(sel,set)
	BEGIN
		IF (estado_normal='0') THEN
			
			IF (sel'EVENT AND sel='0') THEN
				IF selection<5 THEN
					selection<=selection+1;
				ELSE
					selection<=0;
				END IF;
			END IF;
			IF (set'EVENT AND set='0') THEN
				
					CASE selection IS
						WHEN 0 =>
							IF(ssegu < 9 ) THEN
								ssegu <= ssegu+1;
							ELSE
								ssegu<=0;
							END IF;
						WHEN 1 =>
							IF(ssegd < 5 ) THEN
								ssegd <= ssegd+1;
							ELSE
								ssegd<=0;
							END IF;
						WHEN 2=>
							IF sminu < 9 THEN
								sminu <= sminu+1;
							ELSE
								sminu <= 0;
							END IF;
						WHEN 3=>
							IF smind < 5 THEN
								smind <= smind+1;
							ELSE
								smind <= 0;
							END IF;
						WHEN 4=>
							IF shru < 9 AND shrd<2 THEN
								shru <= shru+1;
							ELSE 
								IF shrd<2 THEN
									shru <= 0;
								ELSIF shru<3 THEN
									shru <=shru+1;
								ELSE
									shru<=0;
								END IF;
							END IF;
						WHEN 5=>
							IF shrd < 2 THEN
								shrd <= shrd+1;
							ELSE 
								shrd <= 0;
							END IF;
						WHEN OTHERS=>
						
					END CASE;
			END IF;
		
		END IF;
	END PROCESS;
	--se asignan los valores de salida de nuestro reloj 
	
	WITH seg+ssegu SELECT tsu <=
		seg+ssegu WHEN 0 TO 9,
		seg+ssegu-10 WHEN OTHERS;
	WITH segd+ssegd SELECT tsd <=
		segd+ssegd WHEN 0 TO 5,
		segd+ssegd-6 WHEN OTHERS;
	WITH min+sminu SELECT tmu <=
		min+sminu WHEN 0 TO 9,
		min+sminu-10 WHEN OTHERS;
	WITH mind+smind SELECT tmd <=
		mind+smind WHEN 0 TO 5,
		mind+smind-6 WHEN OTHERS;
	WITH hr+shru SELECT thu <=
		hr+shru WHEN 0 TO 9,
		hr+shru-10 WHEN OTHERS;
	WITH hrd+shrd SELECT thd <=
		hrd+shrd WHEN 0 TO 2,
		hrd+shrd-10 WHEN OTHERS;
	
		su<=tsu;
		mu<=tmu;
		hu<=thu;
		sd<=tsd;
		md<=tmd;
		hd<=thd;
		
	LEDR0<=estado_normal;
END prueba;