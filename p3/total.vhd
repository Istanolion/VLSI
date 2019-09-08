LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY total IS 
PORT(
	colum : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
	rengl : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
	SW0 : IN STD_LOGIC;
	LEDR0 : OUT STD_LOGIC;
	--------------------------
	--ESTOS FUERON PUESTOS PARA COMPROBAR LOGICA DEL KEYPAD
	--Y EL ULTIMO PA VER CUANDO OCURRE LA  ACTIVACION DEL KEYPAD
	LEDR1 : OUT STD_LOGIC;
	LEDR2 : OUT STD_LOGIC;
	LEDR3 : OUT STD_LOGIC;
	LEDR4 : OUT STD_LOGIC;
	-------------------------
	KEY0 : IN STD_LOGIC;
	MAX10_CLK1_50 : IN STD_LOGIC;
	HEX0: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	HEX1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);	
	HEX2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	HEX3 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	HEX4 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) 
);
END total;


ARCHITECTURE prueba OF total IS 

COMPONENT interfazKeypad IS 
PORT(
numero : OUT INTEGER ; --numero presionado
activa : OUT STD_LOGIC; --activa la cerradura para decir que se esta mandando un nuevo numero
clk : IN STD_LOGIC;	--RELOJ PARA REFRESCAMIENTO
--COLUMNAS Y RENGLONES COL SERAN LAS QUE HACEN EL BARRIDO DEL KEYPAD
col : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
ren : IN STD_LOGIC_VECTOR (3 DOWNTO 0)
);
END COMPONENT;
COMPONENT cerradura IS 
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
END COMPONENT;

COMPONENT deco7Seg IS 
PORT(
numero : IN INTEGER ; --numero a decodificar
clk : IN STD_LOGIC;	--RELOJ PARA REFRESCAMIENTO
HEX : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) --salidas a pines
);
END COMPONENT;
SIGNAL num,cnum0,cnum1,cnum2,cnum3,cnum4 : INTEGER RANGE 0 TO 10:=10;
SIGNAL actik,s2 : STD_LOGIC:='0';
SIGNAL l7seg0,l7seg1,l7seg2,l7seg3,l7seg4 : STD_LOGIC_VECTOR (7 DOWNTO 0):="11111111";

BEGIN
	ik : interfazKeypad PORT MAP (numero=>num,activa=>actik,clk=>MAX10_CLK1_50,col=>colum,
	ren=>rengl);
	cr : cerradura PORT MAP (clk=>MAX10_CLK1_50,numero=>num,estado=>actik,swSet=>SW0,
	butReset=>KEY0,salidaNum0=>cnum0,salidaNum1=>cnum1,salidaNum2=>cnum2,
	salidaNum3=>cnum3,salidaNum4=>cnum4,led=>s2);
	H0 : deco7seg PORT MAP (numero=>cnum0,clk=>MAX10_CLK1_50,HEX=>HEX0);
	H1 : deco7seg PORT MAP (numero=>cnum1,clk=>MAX10_CLK1_50,HEX=>HEX1);
	H2 : deco7seg PORT MAP (numero=>cnum2,clk=>MAX10_CLK1_50,HEX=>HEX2);
	H3 : deco7seg PORT MAP (numero=>cnum3,clk=>MAX10_CLK1_50,HEX=>HEX3);
	H4 : deco7seg PORT MAP (numero=>cnum4,clk=>MAX10_CLK1_50,HEX=>HEX4);
	---PRUEBAS
	LEDR0<=rengl(0);
	LEDR1<=rengl(1);
	LEDR2<=rengl(2);
	LEDR3<=rengl(3);
	LEDR4<=actik;
END prueba;