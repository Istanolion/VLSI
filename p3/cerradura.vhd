LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY cerradura IS 
PORT (
	clk : IN STD_LOGIC;
	--BOTONES PARA LLENAR NUESTRO NUMERO DE 7SEG, (LO RECIBE DE LA INTERGFAZ A LA MATRIZ)
	--los mismos numeros deberan de servir para poner la nueva contraseña
	numero: IN INTEGER;
	estado : IN STD_LOGIC;
	--ESTADO NOS SIRVE PARA VER CUANDO RECIBIMOS UN NUEVO NUMERO
	--switch SET(NUEVA CONTRASEÑA) 
	swSet : IN STD_LOGIC;
	--boton RESET(BORRA EL NUMERO)
	butReset : IN STD_LOGIC;
	--las salidas hacia los 7seg donde 0 es el 7seg de la derecha
	salidaNum0 : OUT INTEGER;
	salidaNum1 : OUT INTEGER;
	salidaNum2 : OUT INTEGER;
	salidaNum3 : OUT INTEGER;
	salidaNum4 : OUT INTEGER;
	--SALIDA LED DE ABIERTO/CERRADO
	led : OUT STD_LOGIC
);
END cerradura;
ARCHITECTURE prueba OF cerradura IS
SIGNAL sn0,sn1,sn2,sn3,sn4 : INTEGER RANGE 0 TO 10:=10;
SIGNAL count : INTEGER:=50000;
--SE INICIA EN 10 PARA QUE NUESTRO DECODIFICADOR APAGE LOS 7SEG de inicio
--sEÑAL DE CONTRASEÑA psw0 unidad
SIGNAL psw0 : INTEGER RANGE 0 TO 10:=1;
SIGNAL psw1 : INTEGER RANGE 0 TO 10:=1;
SIGNAL psw2 : INTEGER RANGE 0 TO 10:=0;
SIGNAL psw3 : INTEGER RANGE 0 TO 10:=1;
SIGNAL psw4 : INTEGER RANGE 0 TO 10:=0;
--Esta abierta la cerradura? opcion predeterminada no (0)
SIGNAL abierto : STD_LOGIC:='0';
BEGIN
	PROCESS(clk,estado)
	BEGIN
		IF (clk'EVENT AND clk='1') THEN
			--si se presiona el boton asigna valores 
			IF estado='1' AND sn4=10 AND count=50000 THEN
			--corriemiento de los numeros en el display
				sn4<=sn3;
				sn3<=sn2;
				sn2<=sn1;
				sn1<=sn0;
				--asigna el valor al 7seg de la derecha
				sn0<=numero;
				count<=0;
			ELSIF estado='0' THEN
				count<=count+1;
			END IF;
			--si se presiona el boton de reset se apagan todos los leds (se pone valor de 10
			--por que nuestro decoficador interpreta ese numero como 7seg apagado)
			IF (butReset='0') THEN
				sn4<=10;
				sn3<=10;
				sn2<=10;
				sn1<=10;
				sn0<=10;
				abierto<='0';
			END IF;
			--si se presiona el boton set y estan los 5 7seg con algun numero 
			--se cambiara la contraseña y se dira que esta cerrado
			IF (swSet='1' AND sn4/=10) THEN
				psw4<=sn4;
				psw3<=sn3;
				psw2<=sn2;
				psw1<=sn1;
				psw0<=sn0;
				abierto<='0';
			END IF;
			--si coinciden los valores con la contraseña guardada diremos que esta abierto
			IF psw4=sn4 AND psw3=sn3 AND psw2=sn2 AND psw1=sn1 AND psw0=sn0  AND swSet='0' THEN
				abierto<='1';
			END IF;
		END IF;
		--se asignan los valores a las salidass
		salidaNum0<=sn0;
		salidaNum1<=sn1;
		salidaNum2<=sn2;
		salidaNum3<=sn3;
		salidaNum4<=sn4;
		led<=abierto;
	END PROCESS;
END prueba;