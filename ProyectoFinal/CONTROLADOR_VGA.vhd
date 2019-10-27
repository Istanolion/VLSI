library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity CONTROLADOR_VGA is
port(	KEY : in std_logic_VECTOR (1 DOWNTO 0);
		MAX10_CLK1_50 : in STD_LOGIC;
		SW: in STD_LOGIC_VECTOR(4 downto 0);
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
SIGNAL columActiv : integer range 0 to 5:=0; --numero cero= ninguna columna es presionada 

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
	with SW select columActiv<= 1 when "00001",
		2 when "00010",
		3 when "00100",
		4 when "01000",
		5 when "10000",
		0 when others;

	senialVGA: process(div2)
	begin
			if rising_edge(div2) then
				if habilitado = '1' then
						IF (pos_y<360) then
							IF(pos_x<127 and pos_x>=0) then
								if columActiv=1 then
									VGA_R <= COLORGRIS(11 downto 8);
									VGA_G <= COLORGRIS(7 downto 4);
									VGA_B <= COLORGRIS(3 downto 0);
								ELSE
									VGA_R <= COLORBLANCO(11 downto 8);
									VGA_G <= COLORBLANCO(7 downto 4);
									VGA_B <= COLORBLANCO(3 downto 0);
								end if;
							elsif (pos_x>128 and pos_x<255) then 
								if columActiv=2 then
									VGA_R <= COLORGRIS(11 downto 8);
									VGA_G <= COLORGRIS(7 downto 4);
									VGA_B <= COLORGRIS(3 downto 0);
								ELSE
									VGA_R <= COLORBLANCO(11 downto 8);
									VGA_G <= COLORBLANCO(7 downto 4);
									VGA_B <= COLORBLANCO(3 downto 0);
								end if;
							elsif (pos_x<383 and pos_x>256) then
								if columActiv=3 then
									VGA_R <= COLORGRIS(11 downto 8);
									VGA_G <= COLORGRIS(7 downto 4);
									VGA_B <= COLORGRIS(3 downto 0);
								ELSE
									VGA_R <= COLORBLANCO(11 downto 8);
									VGA_G <= COLORBLANCO(7 downto 4);
									VGA_B <= COLORBLANCO(3 downto 0);
								end if;
							elsif (pos_x<511 and pos_x>385) then
								if columActiv=4 then
									VGA_R <= COLORGRIS(11 downto 8);
									VGA_G <= COLORGRIS(7 downto 4);
									VGA_B <= COLORGRIS(3 downto 0);
								ELSE
									VGA_R <= COLORBLANCO(11 downto 8);
									VGA_G <= COLORBLANCO(7 downto 4);
									VGA_B <= COLORBLANCO(3 downto 0);
								end if;
							elsif (pos_x>513) then
								if columActiv=5 then
									VGA_R <= COLORGRIS(11 downto 8);
									VGA_G <= COLORGRIS(7 downto 4);
									VGA_B <= COLORGRIS(3 downto 0);
								ELSE
									VGA_R <= COLORBLANCO(11 downto 8);
									VGA_G <= COLORBLANCO(7 downto 4);
									VGA_B <= COLORBLANCO(3 downto 0);
								end if;
							else
								VGA_R <= COLORNEGRO(11 downto 8);
								VGA_G <= COLORNEGRO(7 downto 4);
								VGA_B <= COLORNEGRO(3 downto 0);
							end if;
						else 
							IF(pos_x/=127 and pos_x/=128 and pos_x/=255 and pos_x/=256 and pos_x/=383 and pos_x/=384 and pos_x/=511 and pos_x/=512) then
								VGA_R <= COLORNEGRO(11 downto 8);
								VGA_G <= COLORNEGRO(7 downto 4);
								VGA_B <= COLORNEGRO(3 downto 0);
							else
								VGA_R <= COLORBLANCO(11 downto 8);
								VGA_G <= COLORBLANCO(7 downto 4);
								VGA_B <= COLORBLANCO(3 downto 0);
							end if;
						end if;
						
				else
					VGA_R <= "0000";
					VGA_G <= "0000";
					VGA_B <= "0000";
				end if;
			end if;
	end process;
	
end COMP_CONTROLADOR_VGA;