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


type rom_type is array (0 to 18) of integer range 0 to 9; 
type twoInts is array (0 to 1) of integer range 0 to 9;
Signal notas:rom_type:=(4,3,5,2,4,7,5,4,2,3,4,7,4,2,6,1,5,7,3);
signal index: integer range 0 to 18:=0;
signal playingnote: twoInts := (1,1);
signal mov_y1,mov_y2,mov_y3,mov_y4,mov_y5,mov_y6,mov_y7,mov_y8 : integer range 0 to 480 := 0;


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
						IF (pos_y<320) then
							IF(pos_x<80 and pos_x>=0) then
								if columActiv=1 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
								if (playingnote(0)=1 or playingnote(1)=1) then
									if (pos_y >mov_y1-160 and pos_y<mov_y1)then
										RGBCOLORS<=COLORNEGRO;
										if(mov_y1=160 ) then
											if(playingnote(0)=1 and pos_X=79 ) then
												playingnote(1)<=notas(index);
											elsif (playingnote(1)=1 and pos_X=79) then
												playingnote(1)<=notas(index);
											end if;
											
										end if;
									end if;
								end if;
							elsif (pos_x>81 and pos_x<159) then 
								if columActiv=2 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
								if (playingnote(0)=2 or playingnote(1)=2) then
									if (pos_y >mov_y2-160 and pos_y<mov_y2)then
										RGBCOLORS<=COLORNEGRO;
										if(mov_y2=160 ) then
											if(playingnote(0)=2 and pos_X=158) then
												playingnote(1)<=notas(index);
											elsif (playingnote(1)=2 and pos_X=158) then
												playingnote(0)<=notas(index);
											end if;
											
										end if;
									end if;
								end if;
							elsif (pos_x<239 and pos_x>160) then
								if columActiv=3 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
								if (playingnote(0)=3 or playingnote(1)=3) then
									if (pos_y >mov_y3-160 and pos_y<mov_y3)then
										RGBCOLORS<=COLORNEGRO;
										if(mov_y3=160 ) then
											if(playingnote(0)=3 and pos_X=238) then
												playingnote(1)<=notas(index);
											elsif (playingnote(1)=3 and pos_X=238) then
												playingnote(0)<=notas(index);
											end if;
											
										end if;
									end if;
								end if;
							elsif (pos_x<319 and pos_x>240) then
								if columActiv=4 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
								if (playingnote(0)=4 or playingnote(1)=4) then
									if (pos_y >mov_y4-160 and pos_y<mov_y4)then
										RGBCOLORS<=COLORNEGRO;
										if(mov_y4=160 ) then
											if(playingnote(0)=4 and pos_X=318) then
												playingnote(1)<=notas(index);
											elsif (playingnote(1)=4 and pos_X=318) then
												playingnote(0)<=notas(index);
											end if;
											
										end if;
									end if;
								end if;
							elsif (pos_x<399 and pos_x>320) then
								if columActiv=5 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
								if (playingnote(0)=5 or playingnote(1)=5) then
									if (pos_y >mov_y5-160 and pos_y<mov_y5)then
										RGBCOLORS<=COLORNEGRO;
										if(mov_y5=160 ) then
											if(playingnote(0)=5 and pos_X=398) then
												playingnote(1)<=notas(index);
											elsif (playingnote(1)=5 and pos_X=398) then
												playingnote(0)<=notas(index);
											end if;
											
										end if;
									end if;
								end if;
							elsif (pos_x<479 and pos_x>400) then
								if columActiv=6 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
								if (playingnote(0)=6 or playingnote(1)=6) then
									if (pos_y >mov_y6-160 and pos_y<mov_y6)then
										RGBCOLORS<=COLORNEGRO;
										if(mov_y6=160 ) then
											if(playingnote(0)=6 and pos_X=478) then
												playingnote(1)<=notas(index);
											elsif (playingnote(1)=6 and pos_X=478) then
												playingnote(0)<=notas(index);
											end if;
											
										end if;
									end if;
								end if;
							elsif (pos_x<559 and pos_x>480) then
								if columActiv=7 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
								if (playingnote(0)=7 or playingnote(1)=7) then
									if (pos_y >mov_y7-160 and pos_y<mov_y7)then
										RGBCOLORS<=COLORNEGRO;
										if(mov_y7=160 ) then
											if(playingnote(0)=7 and pos_X=558) then
												playingnote(1)<=notas(index);
											elsif (playingnote(1)=7 and pos_X=558) then
												playingnote(0)<=notas(index);
											end if;
											
										end if;
									end if;
								end if;
							elsif (pos_x<638 and pos_x>560) then
								if columActiv=8 then
									RGBCOLORS<=COLORGRIS;
								ELSE
									RGBCOLORS<=COLORBLANCO;
								end if;
								if (playingnote(0)=8 or playingnote(1)=8) then
									if (pos_y >mov_y8-160 and pos_y<mov_y8)then
										RGBCOLORS<=COLORNEGRO;
										if(mov_y8=160 ) then
											if(playingnote(0)=8 and pos_X=638) then
												playingnote(1)<=notas(index);
											elsif (playingnote(1)=8 and pos_X=638) then
												playingnote(0)<=notas(index);
											end if;
											
										end if;
									end if;
								end if;
							elsif (pos_x>=638 ) then
								RGBCOLORS<=COLORNEGRO;
							else
								RGBCOLORS<=COLORNEGRO;
							end if;
							---Muestra el Score
							if (pos_x<639 and pos_x>439 AND pos_y<105 and pos_y>4) THEN
								RGBCOLORS<=COLORNEGRO;
							end if;
							--Distribucion de las teclas negras (parte inferior)
						else 
							IF(pos_x/=80 and pos_x/=81 and pos_x/=160 and pos_x/=159 and pos_x/=240 and pos_x/=239 and pos_x/=320 and pos_x/=319 and pos_x/=400 and pos_x/=399 and pos_x/=480 and pos_x/=479 and pos_x/=560 and pos_x/=559) then
								RGBCOLORS<=COLORNEGRO;
							else
								RGBCOLORS<=COLORBLANCO;
							end if;
						end if;
						--Se mandan el color a pantalla
					VGA_R <= RGBCOLORS(11 DOWNTO 8);
					VGA_G <= RGBCOLORS(7 DOWNTO 4);
					VGA_B <= RGBCOLORS(3 DOWNTO 0);
				else
				--si no esta activo
					VGA_R <= "0000";
					VGA_G <= "0000";
					VGA_B <= "0000";
				end if;
				--aplica el mov a las notas cuando se termino de dibujar un cuadro
				if pos_y=480 and pos_x=639 then
					if (playingnote(0)=1 or playingnote(1)=1) then
						mov_y1<=mov_y1+1;
					else
						mov_y1<=0;
					end if;
					if (playingnote(0)=2 or playingnote(1)=2) then
						mov_y2<=mov_y2+1;
					else
						mov_y2<=0;
					end if;
					if (playingnote(0)=3 or playingnote(1)=3) then
						mov_y3<=mov_y3+1;
					else
						mov_y3<=0;
					end if;
					if (playingnote(0)=4 or playingnote(1)=4) then
						mov_y4<=mov_y4+1;
					else
						mov_y4<=0;
					end if;
					if (playingnote(0)=5 or playingnote(1)=5) then
						mov_y5<=mov_y5+1;
					else
						mov_y5<=0;
					end if;
					if (playingnote(0)=6 or playingnote(1)=6) then
						mov_y6<=mov_y6+1;
					else
						mov_y6<=0;
					end if;
					if (playingnote(0)=7 or playingnote(1)=7) then
						mov_y7<=mov_y7+1;
					else
						mov_y7<=0;
					end if;
					if (playingnote(0)=8 or playingnote(1)=8) then
						mov_y8<=mov_y8+1;
					else
						mov_y8<=0;
					end if;
					--Se cambia el indice de la nota que se esta tocando cada que alguna nota llegue al 160
					if(mov_y1=160 or mov_y2=160 or mov_y3=160 or mov_y4=160 or mov_y5=160 or mov_y6=160 or mov_y7=160 or mov_y8=160) then
						if (index <18) then
							index<=index+1;
						else
							index<=0;
						end if;
					end if;
				end if;
			end if;
	end process;
	
end COMP_CONTROLADOR_VGA;