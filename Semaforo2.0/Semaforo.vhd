LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Semaforo IS 
PORT ( Btn_coche : in STD_LOGIC;
		 CLK  : in STD_LOGIC;
		 test : in STD_LOGIC;	--switch que cambia el tiempo de los estados a 1 segundo para realizar pruebas
		 Hex0 : out STD_LOGIC_VECTOR (7 downto 0);
		 Hex1 : out STD_LOGIC_VECTOR (7 downto 0);
		 Hex2 : out STD_LOGIC_VECTOR (7 downto 0);
		 Hex3 : out STD_LOGIC_VECTOR (7 downto 0)
);
END Semaforo;


ARCHITECTURE prueba OF Semaforo IS

COMPONENT Divisor 
PORT (
	clk_50MHz : IN  STD_LOGIC;	 --RELOJ TARJETA 50MHZ
	clk_80Hz   : OUT STD_LOGIC  --RELOJ A 40HZ
);
END COMPONENT;

COMPONENT SevenSeg 
PORT( Clk    : IN  STD_LOGIC;	 							--RELOJ PARA REFRESCAMIENTO
		Estado : IN  STD_LOGIC_VECTOR (1 downto 0); 	--Indica si esta en Verde, Amarillo o Rojo
		HEX    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)	--Siete Segmentos
);	
END COMPONENT;

Signal Reloj, Btn : STD_LOGIC := '0';
-- Señales que se usaran para saber el color del semáforo
SIGNAL E_Hex0 , E_Hex1 : STD_LOGIC_VECTOR (1 downto 0) := "11";
SIGNAL E_Hex2 , E_Hex3 : STD_LOGIC_VECTOR (1 downto 0) := "11";
-- Estados a usar 
TYPE Mis_Estados is (RojoVerdeA, RojoAmarilloA, VerdeRojoA, AmarilloRojoA, 
							CR_ARojoVerde, CR_ARojoAmarillo, CR_AVerdeRojo, CR_AAmarilloRojo,
							AR_CV, AR_CA);
SIGNAL D_bus, Q_bus : Mis_Estados := RojoVerdeA;

--Tiempos a usar en cada estado
CONSTANT timeMax : integer := 400; --400/80 = 5 seg
constant timeVR : integer := 400; --400/80 = 5 seg
constant timeVA : integer := 160; --160/80 = 2 seg
constant timeTest : integer := 80; --80/80 = 1 seg
constant time3s : integer := 240; -- 240/80 =3 segundos

--tiempo enviado al contador que manejara los estados
SIGNAL tempo : integer range 0 to timeMax := 0;
 
BEGIN
		
	Watch : Divisor PORT MAP(clk_50MHz => CLK, clk_80Hz => Reloj);

---- Registro de estado	
	PROCESS(Reloj, Btn)
		VARIABLE cont: integer range 0 to timeMax;
	BEGIN
		-- Funcionamiento normal de la avenida
		IF (Reloj'EVENT AND Reloj = '1') AND Btn = '0' THEN
			cont:= cont + 1;
			IF cont = tempo THEN
				Q_bus <= D_bus;
				cont:=0;
			END IF;
		-- Funcionamiento con el boton presionado
		ELSIF (Reloj'EVENT AND Reloj = '1') AND Btn = '1' then 
			cont:= cont + 1;
			IF cont = tempo THEN
				Q_bus <= D_bus;
				cont:=0;
			END IF;
		END IF;
	END PROCESS;
	
--- Logica de los estados.

	PROCESS(Q_bus, Btn_coche, Reloj, Btn)

	BEGIN
		
		CASE Q_bus IS
			WHEN RojoVerdeA =>
				E_Hex0 <= "10"; E_Hex1 <= "00";
				E_Hex2 <= "10"; E_Hex3 <= "10";
				
				IF Btn_coche = '0' then 
					D_bus <= CR_ARojoVerde;
					Btn <= '1';
				else
					D_bus <= RojoAmarilloA;
					Btn <= '0';
				end if;	
				
				if test = '0' then
					tempo <= timeVR;
				else
					tempo <= timeTest;
				end if;
				
			WHEN RojoAmarilloA => 
				E_Hex0 <= "10"; E_Hex1 <= "01";
				E_Hex2 <= "10"; E_Hex3 <= "10";
				
				IF Btn_coche = '0' then 
					D_bus <= CR_ARojoAmarillo;
					Btn <= '1';
				else
					D_bus <= VerdeRojoA;
					Btn <= '0';
				end if;		
				
				if test = '0' then
					tempo <= timeVA;
				else
					tempo <= timeTest;
				end if;
				
				
				
			WHEN VerdeRojoA => 
				E_Hex0 <= "00"; E_Hex1 <= "10";
				E_Hex2 <= "10"; E_Hex3 <= "10";
				
				IF Btn_coche = '0' then 
					D_bus <= CR_AVerdeRojo;
					Btn <= '1';
				else
					D_bus <= AmarilloRojoA;
					Btn <= '0';
				end if;		
				
				if test = '0' then
					tempo <= timeVR;
				else
					tempo <= timeTest;
				end if;
				
				
				
			WHEN  AmarilloRojoA => 
				E_Hex0 <= "01"; E_Hex1 <= "10";
				E_Hex2 <= "10"; E_Hex3 <= "10";
				
				IF Btn_coche = '0' then 
					D_bus <= CR_AAmarilloRojo;
					Btn <= '1';
				else
					D_bus <= RojoVerdeA;
					Btn <= '0';
				end if;		
				
				if test = '0' then
					tempo <= timeVA;
				else
					tempo <= timeTest;
				end if;
			
				
							
			WHEN CR_ARojoVerde => 
				E_Hex0 <= "10"; E_Hex1 <= "00";
				E_Hex2 <= "10"; E_Hex3 <= "10";
				D_bus <= CR_ARojoAmarillo;
				
				if test = '0' then
					tempo <= timeVR;
				else
					tempo <= timeTest;
				end if;
							
			WHEN CR_ARojoAmarillo => 
				E_Hex0 <= "10"; E_Hex1 <= "01";
				E_Hex2 <= "10"; E_Hex3 <= "10";
				D_bus <= AR_CV;
				
				if test = '0' then
					tempo <= timeVA;
				else
					tempo <= timeTest;
				end if;
				
				
				
			WHEN CR_AVerdeRojo => 
				E_Hex0 <= "00"; E_Hex1 <= "10";
				E_Hex2 <= "10"; E_Hex3 <= "10";
				D_bus <= CR_AAmarilloRojo;
				
				if test = '0' then
					tempo <= time3s;
				else
					tempo <= timeTest;
				end if;
				
			WHEN CR_AAmarilloRojo =>
				E_Hex0 <= "01"; E_Hex1 <= "10";
				E_Hex2 <= "10"; E_Hex3 <= "10";
				D_bus <= AR_Cv;
				
				if test = '0' then
					tempo <= timeVA;
				else
					tempo <= timeTest;
				end if;
				
				
			WHEN AR_CV => 
				E_Hex0 <= "10"; E_Hex1 <= "10";
				E_Hex2 <= "00"; E_Hex3 <= "00";
				D_bus <= AR_CA;
				
				if test = '0' then
					tempo <= timeVR;
				else
					tempo <= timeTest;
				end if;
				
				
			WHEN others =>
				E_Hex0 <= "10"; E_Hex1 <= "10";
				E_Hex2 <= "01"; E_Hex3 <= "01";
				D_bus <= RojoVerdeA;
				
				if test = '0' then
					tempo <= timeVA;
				else
					tempo <= timeTest;
				end if;
				
				
		END CASE;
	END PROCESS;

	-- Enviar las señales a los 7 segmetos
	
	S0 : SevenSeg PORT MAP(Clk => CLK, Estado => E_Hex0 ,HEX => hex0);
	S1 : SevenSeg PORT MAP(Clk => CLK, Estado => E_Hex1 ,HEX => hex1);
	S2 : SevenSeg PORT MAP(Clk => CLK, Estado => E_Hex2 ,HEX => hex2);
	S3 : SevenSeg PORT MAP(Clk => CLK, Estado => E_Hex3 ,HEX => hex3);

END prueba;











