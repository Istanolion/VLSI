LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY total IS 
PORT(
	LEDR0 : OUT STD_LOGIC;
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
	LEDR0 : OUT STD_LOGIC;
	clk : IN STD_LOGIC; --reloj que nos marca la velocidad con la que va el reloj
	temporizador: IN STD_LOGIC; --para medir cuanto tiempo han sido presionado los botones (1hz)
	set : IN STD_LOGIC;
	sel : IN STD_LOGIC;
	estado: OUT STD_LOGIC;
	sel7s : OUT INTEGER RANGE 0 TO 6;
	--salidas para el decodificador a 7 segmentos
	su : OUT INTEGER;
	mu : OUT INTEGER;
	hu : OUT INTEGER;
	sd : OUT INTEGER;
	md : OUT INTEGER;
	hd : OUT INTEGER
);
END COMPONENT;
--DECODIFICADOR DEL 7 SEGMENTOS
COMPONENT deco7Seg IS 
PORT(
	numero : IN INTEGER;
	clk :IN STD_LOGIC;
	HEX : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
);
END COMPONENT;
--MULTIPLEXOR DE VEL DE RELOJ
COMPONENT MUXreloj IS
PORT (
	clk50hz : IN STD_LOGIC;
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
SIGNAL sl7s : INTEGER RANGE 0 TO 6;

SIGNAL s7s1,s7s2,s7s3,s7s4,s7s5,s7s6: STD_LOGIC:='0';
SIGNAL clk7s1,clk7s2,clk7s3,clk7s4,clk7s5,clk7s6: STD_LOGIC:='0';
SIGNAL clk1h,clk4h,clkp,clkReloj,state : STD_LOGIC:='0';
Signal seg,min,hr,segd,mind,hrd : INTEGER RANGE 0 TO 9:=0;
BEGIN
	div : divFreq PORT MAP (clk=>clk50Hz,clk1=>clk1h,clk2=>clk4h,clk3=>clkp);
	mux : MUXreloj PORT MAP (clk50hz=>clk50Hz,clk1=>clk1h, clk2=>clk4h, vel=>velocidad, salida=>clkReloj);
	watch : reloj PORT MAP (clk=>clkReloj,temporizador=>clk1h,set=>setting,sel=>selection,
				su=>seg,mu=>min,hu=>hr,sd=>segd,md=>mind,hd=>hrd,LEDR0=>LEDR0,sel7s=>sl7s,estado=>state); 
---Freq of 7segDeco
	clk7s1<= clkp WHEN sl7s=0 AND state='0' ELSE
	clk50HZ WHEN sl7s/=0 OR state='1';
	clk7s2<= clkp WHEN sl7s=1 AND state='0' ELSE
	clk50HZ WHEN sl7s/=1 OR state='1';
	clk7s3<= clkp WHEN sl7s=2 AND state='0' ELSE
	clk50HZ WHEN sl7s/=2 OR state='1';
	clk7s4<= clkp WHEN sl7s=3 AND state='0' ELSE
	clk50HZ WHEN sl7s/=3 OR state='1';
	clk7s5<= clkp WHEN sl7s=4 AND state='0' ELSE
	clk50HZ WHEN sl7s/=4 OR state='1';
	clk7s6<= clkp WHEN sl7s=5 AND state='0' ELSE
	clk50HZ WHEN sl7s/=5 OR state='1';
		--parpadeo

	--Instancias de los decodficadores 7 segmentos
	HSu : deco7seg PORT MAP (numero=>seg,clk=>clk7s1,HEX=>HEX0);
	HMu : deco7seg PORT MAP (numero=>min,clk=>clk7s3,HEX=>HEX2);
	HHu : deco7seg PORT MAP (numero=>hr,clk=>clk7s5,HEX=>HEX4);
	HSd : deco7seg PORT MAP (numero=>segD,clk=>clk7s2,HEX=>HEX1);
	HMd : deco7seg PORT MAP (numero=>minD,clk=>clk7s4,HEX=>HEX3);
	HHd : deco7seg PORT MAP (numero=>hrD,clk=>clk7s6,HEX=>HEX5);
	
END prueba;