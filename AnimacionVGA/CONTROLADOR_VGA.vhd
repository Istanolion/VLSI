library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity CONTROLADOR_VGA is
port(	clk, sum, res : in std_logic;
		xychanger : in std_logic;
		sel : in STD_LOGIC_VECTOR(3 downto 0);
		hsync, vsync : out std_logic;
		VGA_R, VGA_G, VGA_B: out std_logic_vector(3 downto 0));
end CONTROLADOR_VGA;

architecture COMP_CONTROLADOR_VGA of CONTROLADOR_VGA is

signal div2 : std_logic := '0';
signal pos_x : integer range 0 to 640 := 640;
signal pos_y : integer range 0 to 480 := 480;
signal habilitado : std_logic;
signal mov_x : integer range 0 to 640 := 300;
signal mov_y : integer range 0 to 480 := 300;
signal clk_2Hz	 : std_logic := '0';
signal clk_4Hz	 : std_logic := '0';
signal div2h : integer range 0 to 25000000 := 0;
signal div4h : integer range 0 to 12500000 := 0;

type rom_type is array (0 to 15,0 to 15) of std_logic;

constant ROM : rom_type:=(
('0','0','0','0','0','1','1','1','1','1','1','0','0','0','0','0'),
('0','0','0','1','1','1','1','1','1','1','1','1','1','0','0','0'),
('0','0','1','1','1','1','1','1','1','1','1','1','1','1','0','0'),
('0','1','1','1','1','1','1','1','1','1','0','1','1','1','1','0'),
('0','1','1','1','1','1','1','1','1','1','1','1','1','1','1','0'),
('1','1','1','1','1','1','1','1','1','1','1','1','1','1','0','0'),
('1','1','1','1','1','1','1','1','1','1','1','1','1','0','0','0'),
('1','1','1','1','1','1','1','1','1','1','1','1','0','0','0','0'),
('1','1','1','1','1','1','1','1','1','1','1','0','0','0','0','0'),
('1','1','1','1','1','1','1','1','1','1','1','1','0','0','0','0'),
('1','1','1','1','1','1','1','1','1','1','1','1','1','0','0','0'),
('0','1','1','1','1','1','1','1','1','1','1','1','1','1','0','0'),
('0','1','1','1','1','1','1','1','1','1','1','1','1','1','1','0'),
('0','0','1','1','1','1','1','1','1','1','1','1','1','1','0','0'),
('0','0','0','1','1','1','1','1','1','1','1','1','1','0','0','0'),
('0','0','0','0','0','1','1','1','1','1','1','0','0','0','0','0'));
constant ROM2 : rom_type:=(
('0','0','0','0','0','1','0','0','0','0','0','0','0','0','0','0'),
('0','0','0','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('0','0','1','0','1','1','0','0','0','0','0','0','0','0','0','0'),
('0','1','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('0','1','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('1','1','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('1','1','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('1','1','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('1','1','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('1','1','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('1','1','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('0','1','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('0','1','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('0','0','1','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('0','0','0','1','1','1','0','0','0','0','0','0','0','0','0','0'),
('0','0','0','0','0','1','0','0','0','0','0','0','0','0','0','0'));

component SINC_VGA
port (clk : in std_logic;
		hsync, vsync, habilitado : out std_logic;
		pos_x : out integer range 0 to 800 := 0;
		pos_y : out integer range 0 to 525 := 0);
end component;

begin
	sincronizador: SINC_VGA port map (div2, hsync, vsync, habilitado, pos_x, pos_y);
	process(clk)
	begin
		if rising_edge(clk) then
			div2 <= not div2;
			if (div2h<25000000) then
				div2h<=div2h+1;
			else
				div2h<=0;
				clk_2Hz<=not clk_2Hz;
			end if;
			if (div4h<625000) then
				div4h<=div4h+1;
			else
				div4h<=0;
				clk_4Hz<=not clk_4Hz;
			end if;
		end if;
	end process;
	process(clk_4Hz)
	begin
	if(clk_4hz='1') then
		If xychanger='1' then
			if sum='0' then
				if mov_y<480 then
					mov_y<=mov_y+1;
				else 
					mov_y<=0;
				end if;
			elsif res='0' then
				if mov_y>0 then
					mov_y<=mov_y-1;
				else
					mov_y<=480;
				end if;
			end if;
		else 
			if sum='0' then
				if mov_x<640 then
					mov_x<=mov_x+1;
				else 
					mov_x<=0;
				end if;
			elsif res='0' then
				if mov_x>0 then
					mov_x<=mov_x-1;
				else
					mov_x<=640;
				end if;
			end if;
		end if;
	end if;
	end process;
	senialVGA: process(div2)

	variable colorRGB : std_logic_vector(11	downto 0) := (others => '0');
	
	begin
			if rising_edge(div2) then
				
				if habilitado = '1' then
					Case sel is
						when "0000" =>
						--Pacman solitario
							IF pos_x>=300 And pos_x<316 And pos_y>=300 and pos_y<316 then
								if ROM(pos_y-300,pos_x-300)='1'then
									colorRGB:= "1111"&"1111"&"0000"; --color Amarillo
								elsif ROM(pos_y-300,pos_x-300)='0'then
									colorRGB:= "0000"&"0000"&"0000"; --color Negro
								else
									colorRGB:= "0000"&"0000"&"0000"; --color Negro
								end if; 
							else
								colorRGB:= "0000"&"0000"&"0000"; --color Negro
							End if;
						when "0001" => -- Pantalla pacman Animado
							if(clk_2Hz='0') then
								IF pos_x>=300 And pos_x<316 And pos_y>=300 and pos_y<316 then
									if ROM(pos_y-300,pos_x-300)='1'then
										colorRGB:= "1111"&"1111"&"0000"; --color Amarillo
									elsif ROM(pos_y-300,pos_x-300)='0'then
										colorRGB:= "0000"&"0000"&"0000"; --color Negro
									else
										colorRGB:= "0000"&"0000"&"0000"; --color Negro
									end if; 
								else
									colorRGB:= "0000"&"0000"&"0000"; --color Negro
								End if;
							else
								IF pos_x>=300 And pos_x<316 And pos_y>=300 and pos_y<316 then
									if ROM2(pos_y-300,pos_x-300)='1'then
										colorRGB:= "1111"&"1111"&"0000"; --color Amarillo
									elsif ROM(pos_y-300,pos_x-300)='0'then
										colorRGB:= "0000"&"0000"&"0000"; --color Negro
									else
										colorRGB:= "0000"&"0000"&"0000"; --color Negro
									end if; 
								else
									colorRGB:= "0000"&"0000"&"0000"; --color Negro
								End if;
							End if;
						when "0010" => -- bitmap movible
							IF pos_x>=mov_x And pos_x<(mov_x+16) And pos_y>=mov_y and pos_y<(mov_y+16) then
								if ROM(pos_y-mov_y,pos_x-mov_x)='1'then
									colorRGB:= "1111"&"1111"&"0000"; --color Amarillo
								elsif ROM(pos_y-mov_y,pos_x-mov_x)='0'then
									colorRGB:= "0000"&"0000"&"0000"; --color Negro
								else
									colorRGB:= "0000"&"0000"&"0000"; --color Negro
								end if; 
							else
								colorRGB:= "0000"&"0000"&"0000"; --color Negro
							End if;
							
						when others =>
							colorRGB := "0000"&"0000"&"1111"; -- Pantallazo azul
					END CASE;
					
					VGA_R <= colorRGB(11 downto 8);
					VGA_G <= colorRGB(7 downto 4);
					VGA_B <= colorRGB(3 downto 0);
				else
					VGA_R <= "0000";
					VGA_G <= "0000";
					VGA_B <= "0000";
				end if;
			end if;
	end process;
	
end COMP_CONTROLADOR_VGA;