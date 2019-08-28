LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY total IS 
PORT(
	clk50Hz : IN STD_LOGIC;
	selection: IN STD_LOGIC;
	setting: IN STD_LOGIC;
	velocidad : IN STD_LOGIC;
	HEX0: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	HEX1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);	
	HEX2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	HEX3 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	HEX4 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	HEX5 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) 
);
END total;

ARCHITECTURE prueba OF total IS 
--Funcionalidad del reloj
COMPONENT reloj IS
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
END COMPONENT;
--DECODIFICADOR DEL 7 SEGMENTOS
COMPONENT deco7Seg IS 
PORT(
	numero : IN INTEGER RANGE 0 TO 9;
	clk :IN STD_LOGIC;
	HEXu : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	HEXd : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
);
END COMPONENT;
--MULTIPLEXOR DE VEL DE RELOJ
COMPONENT MUXreloj IS
PORT (
	clk1 : IN STD_LOGIC;
	clk2 : IN STD_LOGIC;
	vel : IN STD_LOGIC;
	salida : OUT STD_LOGIC
);
END COMPONENT;
--DIVISOR DE FRECUENCIAS
COMPONENT divFreq IS
PORT (	
	clk : IN STD_LOGIC;		--RELOJ TARJETA 50MHZ
	clk1 : OUT STD_LOGIC;   --RELOJ A 1HZ
	clk2 : OUT STD_LOGIC;	--RELOJ A 4HZ
	clk3 : OUT STD_LOGIC		--RELOJ PARA EL 7 SEG PARPADEANTE
);
END COMPONENT;
SIGNAL clk1h,clk4h,clkp,clkReloj : STD_LOGIC:='0';
Signal seg,min,hr : INTEGER:=0;
BEGIN
	div : divFreq PORT MAP (clk=>clk50Hz,clk1=>clk1h,clk2=>clk4h,clk3=>clkp);
	mux : MUXreloj PORT MAP (clk1=>clk1h, clk2=>clk4h, vel=>velocidad, salida=>clkReloj);
	watch : reloj PORT MAP (clk=>clkReloj,temporizador=>clk1h,set=>setting,sel=>selection,
				s=>seg,m=>min,h=>hr); 
	--Instancias de los decodficadores 7 segmentos
	HS : deco7seg PORT MAP (numero=>seg,clk=>clk50hz,HEXu=>HEX0,Hexd=>HEX1);
	HM : deco7seg PORT MAP (numero=>min,clk=>clk50hz,HEXu=>HEX2,Hexd=>HEX3);
	HH : deco7seg PORT MAP (numero=>hr,clk=>clk50hz,HEXu=>HEX4,Hexd=>HEX5);
	
END prueba;