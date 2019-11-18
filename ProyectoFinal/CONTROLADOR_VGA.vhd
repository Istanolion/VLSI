library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity CONTROLADOR_VGA is
port(	KEY : in std_logic_VECTOR (1 DOWNTO 0);
		MAX10_CLK1_50 : in STD_LOGIC;
		SW: in STD_LOGIC_VECTOR(7 downto 0);
		VGA_HS, VGA_VS : out std_logic;
		VGA_R, VGA_G, VGA_B: out std_logic_vector(3 downto 0));
end CONTROLADOR_VGA;

architecture COMP_CONTROLADOR_VGA of CONTROLADOR_VGA is

signal div2 : std_logic := '0';
--resolución de la pantalla en pixeles x,y
signal pos_x : integer range 0 to 640 := 640;
signal pos_y : integer range 0 to 480 := 480;
signal habilitado : std_logic;

SIGNAL COLORBLANCO: STD_LOGIC_VECTOR (11 DOWNTO 0):="111111111111";--Codigo RGB del Color Blanco
SIGNAL COLORNEGRO:  STD_LOGIC_VECTOR (11 DOWNTO 0):="000000000000";--Codigo RGB del Color negro
SIGNAL COLORGRIS:   STD_LOGIC_VECTOR (11 DOWNTO 0):="101010101010";--Codigo RGB del Color gris

--Para ver que columna se esta presionando se utiliza un integer con rango
SIGNAL columActiv : integer range 0 to 8:=0; --numero cero= ninguna columna es presionada 

--Señal para especificar la señal al final
SIGNAL RGBCOLORS : STD_LOGIC_VECTOR (11 DOWNTO 0);
component SINC_VGA
port (clk : in std_logic;
		hsync, vsync, habilitado : out std_logic;
		pos_x : out integer range 0 to 800 := 0;
		pos_y : out integer range 0 to 525 := 0);
end component;

begin
	sincronizador: SINC_VGA port map (div2, VGA_HS, VGA_VS, habilitado, pos_x, pos_y);

	process(MAX10_CLK1_50)
	begin
		if rising_edge(MAX10_CLK1_50) then
			div2 <= not div2;
		end if;
	end process;
	with SW select columActiv<= 1 when "00000001",
		2 when "00000010",
		3 when "00000100",
		4 when "00001000",
		5 when "00010000",
		6 when "00100000",
		7 when "01000000",
		8 when "10000000",
		0 when others;

	senialVGA: process(div2)
	begin
			if rising_edge(div2) then
				if habilitado = '1' then
						IF (pos_y<360) then
							IF(pos_x<80 and pos_x>=0) then
								if columActiv=1 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
							elsif (pos_x>81 and pos_x<159) then 
								if columActiv=2 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
							elsif (pos_x<239 and pos_x>160) then
								if columActiv=3 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
							elsif (pos_x<319 and pos_x>240) then
								if columActiv=4 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
							elsif (pos_x<399 and pos_x>320) then
								if columActiv=5 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
							elsif (pos_x<479 and pos_x>400) then
								if columActiv=6 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
							elsif (pos_x<559 and pos_x>480) then
								if columActiv=7 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
							elsif (pos_x<640 and pos_x>560) then
								if columActiv=8 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
							else
								RGBCOLORS<=COLORNEGRO;
							end if;
						else 
							IF(pos_x/=80 and pos_x/=81 and pos_x/=160 and pos_x/=159 and pos_x/=240 and pos_x/=239 and pos_x/=320 and pos_x/=319 and pos_x/=400 and pos_x/=399 and pos_x/=480 and pos_x/=479 and pos_x/=560 and pos_x/=559) then
								RGBCOLORS<=COLORNEGRO;
							else
								RGBCOLORS<=COLORBLANCO;
							end if;
						end if;
					VGA_R <= RGBCOLORS(11 DOWNTO 8);
					VGA_G <= RGBCOLORS(7 DOWNTO 4);
					VGA_B <= RGBCOLORS(3 DOWNTO 0);
				else
					VGA_R <= "0000";
					VGA_G <= "0000";
					VGA_B <= "0000";
				end if;
			end if;
	end process;
	
end COMP_CONTROLADOR_VGA;