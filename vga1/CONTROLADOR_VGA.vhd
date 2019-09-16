library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity CONTROLADOR_VGA is
port(	clk, reset, jump : in std_logic;
		sel : in STD_LOGIC_VECTOR(3 downto 0);
		hsync, vsync : out std_logic;
		VGA_R, VGA_G, VGA_B: out std_logic_vector(3 downto 0));
end CONTROLADOR_VGA;

architecture COMP_CONTROLADOR_VGA of CONTROLADOR_VGA is

signal div2 : std_logic := '0';
signal pos_x : integer range 0 to 640 := 640;
signal pos_y : integer range 0 to 480 := 480;
signal habilitado : std_logic;

signal clk_40Hz : std_logic := '0'; 
signal clk_20Hz : std_logic := '0';

signal div20 : integer range 0 to 2500000 := 0;
signal div40 : integer range 0 to 1250000 := 0;
signal tempo : integer range 0 to 270 := 0;
signal grado : integer range 0 to 35 := 0;


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
			if (div40 < 1250000) then
				div40 <= div40 + 1;
			else 
				div40 <= 0;
				clk_40Hz <= NOT clk_40Hz;
			end if;
			if (div20 < 2500000) then
				div20 <= div20 + 1;
			else
				div20 <= 0;
				clk_20Hz <= NOT clk_20Hz;
			end if;
		end if;
	end process;
	
	process(clk_40Hz)
	begin
		If clk_40Hz'event AND clk_40Hz = '1' then
			if (tempo < 271) then
				tempo <= tempo + 1;
			else
				tempo <= 0;
			end if;
		end if;
	end process;
	
	process(clk_20Hz)
	begin
		If clk_20Hz'event AND clk_20Hz = '1' then
			if (grado < 36) then
				grado <= grado + 1;
			else
				grado <= 0;
			end if;
		end if;
	end process;
	
	senialVGA: process(div2)

	variable colorRGB : std_logic_vector(11	downto 0) := (others => '0');
	
	begin
			if rising_edge(div2) then
				if habilitado = '1' then
					
					Case sel is
					when "0000" => -- Pantalla roja
						colorRGB := "1111"&"0000"&"0000"; -- Rojo
					
					when "0001" => -- Pantalla azul cielo
						colorRGB := "0101"&"1101"&"1111"; -- Azul cielo
					
					when "0011" => -- Pantalla rosa
						colorRGB := "1111"&"0000"&"1000"; -- Rosa
					
					when "0010" => -- Pantalla negra
						colorRGB := "0000"&"0000"&"0000"; -- Negro
					
					when "0110" => -- cuadro rojo en el centro
						if (pos_x > 280 AND pos_x < 360 AND pos_y > 200 AND pos_y < 280  ) then
							colorRGB := "1111"&"0000"&"0000";
						else
							colorRGB := "0000"&"0000"&"0000"; 
						end if;
					
					when "0111" => -- linea horizontal de 5 pixeles de ancho
						if (pos_x > 120 AND pos_x < 400 AND pos_y > 200 AND pos_y < 206  ) then
							colorRGB := "0000"&"0101"&"0001";
						else
							colorRGB := "1110"&"1110"&"1110"; 
						end if;
					
					when "0101" => -- linea a 45 grados de 5 pixeles de ancho
					
						if (pos_x > 200 AND pos_x < 206 AND pos_y = 400) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 201 AND pos_x < 207 AND pos_y = 399) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 202 AND pos_x < 208 AND pos_y = 398) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 203 AND pos_x < 209 AND pos_y = 397) then
							colorRGB := "0000"&"0101"&"0001";	
						elsif (pos_x > 204 AND pos_x < 210 AND pos_y = 396) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 205 AND pos_x < 211 AND pos_y = 395) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 206 AND pos_x < 212 AND pos_y = 394) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 207 AND pos_x < 213 AND pos_y = 393) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 208 AND pos_x < 214 AND pos_y = 392) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 209 AND pos_x < 215 AND pos_y = 391) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 210 AND pos_x < 216 AND pos_y = 390) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 211 AND pos_x < 217 AND pos_y = 389) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 212 AND pos_x < 218 AND pos_y = 388) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 213 AND pos_x < 219 AND pos_y = 387) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 214 AND pos_x < 220 AND pos_y = 386) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 215 AND pos_x < 221 AND pos_y = 385) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 216 AND pos_x < 222 AND pos_y = 384) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 217 AND pos_x < 223 AND pos_y = 383) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 218 AND pos_x < 224 AND pos_y = 382) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 219 AND pos_x < 225 AND pos_y = 381) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 220 AND pos_x < 226 AND pos_y = 380) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 221 AND pos_x < 227 AND pos_y = 379) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 222 AND pos_x < 228 AND pos_y = 378) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 223 AND pos_x < 229 AND pos_y = 377) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 224 AND pos_x < 230 AND pos_y = 376) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 225 AND pos_x < 231 AND pos_y = 375) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 226 AND pos_x < 232 AND pos_y = 374) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 227 AND pos_x < 233 AND pos_y = 373) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 228 AND pos_x < 234 AND pos_y = 372) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 229 AND pos_x < 235 AND pos_y = 371) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 230 AND pos_x < 236 AND pos_y = 370) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 231 AND pos_x < 237 AND pos_y = 369) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 232 AND pos_x < 238 AND pos_y = 368) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 233 AND pos_x < 239 AND pos_y = 367) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 234 AND pos_x < 240 AND pos_y = 366) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 235 AND pos_x < 241 AND pos_y = 365) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 236 AND pos_x < 242 AND pos_y = 364) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 237 AND pos_x < 243 AND pos_y = 363) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 238 AND pos_x < 244 AND pos_y = 362) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 239 AND pos_x < 245 AND pos_y = 361) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 240 AND pos_x < 246 AND pos_y = 360) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 241 AND pos_x < 247 AND pos_y = 359) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 242 AND pos_x < 248 AND pos_y = 358) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 243 AND pos_x < 249 AND pos_y = 357) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 244 AND pos_x < 250 AND pos_y = 356) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 245 AND pos_x < 251 AND pos_y = 355) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 246 AND pos_x < 252 AND pos_y = 354) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 247 AND pos_x < 253 AND pos_y = 353) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 248 AND pos_x < 254 AND pos_y = 352) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 249 AND pos_x < 255 AND pos_y = 351) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 250 AND pos_x < 256 AND pos_y = 350) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 251 AND pos_x < 257 AND pos_y = 349) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 252 AND pos_x < 258 AND pos_y = 348) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 253 AND pos_x < 259 AND pos_y = 347) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 254 AND pos_x < 260 AND pos_y = 346) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 255 AND pos_x < 261 AND pos_y = 345) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 256 AND pos_x < 262 AND pos_y = 344) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 257 AND pos_x < 263 AND pos_y = 343) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 258 AND pos_x < 264 AND pos_y = 342) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 259 AND pos_x < 265 AND pos_y = 341) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 260 AND pos_x < 266 AND pos_y = 340) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 261 AND pos_x < 267 AND pos_y = 339) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 262 AND pos_x < 268 AND pos_y = 338) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 263 AND pos_x < 269 AND pos_y = 337) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 264 AND pos_x < 270 AND pos_y = 336) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 265 AND pos_x < 271 AND pos_y = 335) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 266 AND pos_x < 272 AND pos_y = 334) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 267 AND pos_x < 273 AND pos_y = 333) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 268 AND pos_x < 274 AND pos_y = 332) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 269 AND pos_x < 275 AND pos_y = 331) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 270 AND pos_x < 276 AND pos_y = 330) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 271 AND pos_x < 277 AND pos_y = 329) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 272 AND pos_x < 278 AND pos_y = 328) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 273 AND pos_x < 279 AND pos_y = 327) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 274 AND pos_x < 280 AND pos_y = 326) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 275 AND pos_x < 281 AND pos_y = 325) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 276 AND pos_x < 282 AND pos_y = 324) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 277 AND pos_x < 283 AND pos_y = 323) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 278 AND pos_x < 284 AND pos_y = 322) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 279 AND pos_x < 285 AND pos_y = 321) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 280 AND pos_x < 286 AND pos_y = 320) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 281 AND pos_x < 287 AND pos_y = 319) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 282 AND pos_x < 288 AND pos_y = 318) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 283 AND pos_x < 289 AND pos_y = 317) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 284 AND pos_x < 290 AND pos_y = 316) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 285 AND pos_x < 291 AND pos_y = 315) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 286 AND pos_x < 292 AND pos_y = 314) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 287 AND pos_x < 293 AND pos_y = 313) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 288 AND pos_x < 294 AND pos_y = 312) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 289 AND pos_x < 295 AND pos_y = 311) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 290 AND pos_x < 296 AND pos_y = 310) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 291 AND pos_x < 297 AND pos_y = 309) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 292 AND pos_x < 298 AND pos_y = 308) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 293 AND pos_x < 299 AND pos_y = 307) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 294 AND pos_x < 300 AND pos_y = 306) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 295 AND pos_x < 301 AND pos_y = 305) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 296 AND pos_x < 302 AND pos_y = 304) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 297 AND pos_x < 303 AND pos_y = 303) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 298 AND pos_x < 304 AND pos_y = 302) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 299 AND pos_x < 305 AND pos_y = 301) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 300 AND pos_x < 306 AND pos_y = 300) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 301 AND pos_x < 307 AND pos_y = 299) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 302 AND pos_x < 308 AND pos_y = 298) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 303 AND pos_x < 309 AND pos_y = 297) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 304 AND pos_x < 310 AND pos_y = 296) then
							colorRGB := "0000"&"0101"&"0001";
						elsif (pos_x > 305 AND pos_x < 311 AND pos_y = 295) then
							colorRGB := "0000"&"0101"&"0001";
						else
							colorRGB := "1110"&"1110"&"1110"; 
						end if;
		
					when "0100" => -- Circulo en el centro
--						pos_x > 268 AND pos_x < 372 AND pos_y > 187 AND pos_y < 293 
--						mitad x => 640/2 = 320
--						mitad y => 480/2 = 240
						
						if (pos_x > 314 AND pos_x < 327 AND pos_y = 187) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 309 AND pos_x < 333 AND pos_y = 188) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 305 AND pos_x < 337 AND pos_y = 189) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 303 AND pos_x < 339 AND pos_y = 190) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 300 AND pos_x < 342 AND pos_y = 191) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 298 AND pos_x < 344 AND pos_y = 192) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 296 AND pos_x < 346 AND pos_y = 193) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 295 AND pos_x < 348 AND pos_y = 194) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 293 AND pos_x < 349 AND pos_y = 195) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 291 AND pos_x < 351 AND pos_y = 196) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 290 AND pos_x < 352 AND pos_y = 197) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 289 AND pos_x < 353 AND pos_y = 198) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 288 AND pos_x < 354 AND pos_y = 199) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 286 AND pos_x < 356 AND pos_y = 200) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 285 AND pos_x < 357 AND pos_y = 201) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 284 AND pos_x < 358 AND pos_y = 202) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 283 AND pos_x < 359 AND pos_y > 202 AND pos_y < 205) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 282 AND pos_x < 360 AND pos_y = 205) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 281 AND pos_x < 361 AND pos_y = 206) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 280 AND pos_x < 362 AND pos_y = 207) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 279 AND pos_x < 363 AND pos_y > 207 AND pos_y < 210) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 278 AND pos_x < 364 AND pos_y = 210) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 277 AND pos_x < 365 AND pos_y > 210 AND pos_y < 213) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 276 AND pos_x < 366 AND pos_y = 213) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 275 AND pos_x < 367 AND pos_y > 213 AND pos_y < 216) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 274 AND pos_x < 368 AND pos_y > 215 AND pos_y < 218) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 273 AND pos_x < 369 AND pos_y > 217 AND pos_y < 221) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 272 AND pos_x < 370 AND pos_y > 220 AND pos_y < 224) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 271 AND pos_x < 371 AND pos_y > 223 AND pos_y < 228) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 270 AND pos_x < 372 AND pos_y > 227 AND pos_y < 233) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 269 AND pos_x < 373 AND pos_y > 232 AND pos_y < 247) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 270 AND pos_x < 372 AND pos_y > 246 AND pos_y < 253) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 271 AND pos_x < 371 AND pos_y > 252 AND pos_y < 256) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 272 AND pos_x < 370 AND pos_y > 255 AND pos_y < 259) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 273 AND pos_x < 369 AND pos_y > 258 AND pos_y < 262) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 274 AND pos_x < 368 AND pos_y > 261 AND pos_y < 264) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 275 AND pos_x < 367 AND pos_y > 263 AND pos_y < 266) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 276 AND pos_x < 366 AND pos_y = 266) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 277 AND pos_x < 365 AND pos_y > 266 AND pos_y < 268) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 278 AND pos_x < 364 AND pos_y > 267 AND pos_y < 270) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 279 AND pos_x < 363 AND pos_y = 270) then
							colorRGB := "1111"&"0000"&"0000";	
						elsif (pos_x > 280 AND pos_x < 362 AND pos_y = 271) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 281 AND pos_x < 361 AND pos_y = 272) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 282 AND pos_x < 360 AND pos_y > 272 AND pos_y < 275) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 283 AND pos_x < 359 AND pos_y = 275) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 284 AND pos_x < 358 AND pos_y = 276) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 285 AND pos_x < 357 AND pos_y = 277) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 286 AND pos_x < 356 AND pos_y = 278) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 288 AND pos_x < 354 AND pos_y = 279) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 289 AND pos_x < 353 AND pos_y = 280) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 290 AND pos_x < 352 AND pos_y = 281) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 292 AND pos_x < 350 AND pos_y = 282) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 293 AND pos_x < 349 AND pos_y = 283) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 295 AND pos_x < 347 AND pos_y = 284) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 297 AND pos_x < 345 AND pos_y = 285) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 299 AND pos_x < 343 AND pos_y = 286) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 301 AND pos_x < 341 AND pos_y = 287) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 304 AND pos_x < 338 AND pos_y = 288) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 308 AND pos_x < 334 AND pos_y = 289) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 313 AND pos_x < 329 AND pos_y = 290) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 318 AND pos_x < 324 AND pos_y = 291) then
							colorRGB := "1111"&"0000"&"0000";
						else
							colorRGB := "0000"&"0000"&"0000"; 
						end if;
						
					when "1100" => -- Circunferencia de 5 pixeles de radio
--						pos_x > 268 AND pos_x < 372 AND pos_y > 187 AND pos_y < 293 
--						mitad x => 640/2 = 320
--						mitad y => 480/2 = 240
						
						if (pos_x > 314 AND pos_x < 327 AND pos_y = 187) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 309 AND pos_x < 333 AND pos_y = 188) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 305 AND pos_x < 337 AND pos_y = 189) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 303 AND pos_x < 339 AND pos_y = 190) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 300 AND pos_x < 342 AND pos_y = 191) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 298 AND pos_x < 314) OR (pos_x > 327 AND pos_x < 344)) AND pos_y = 192) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 296 AND pos_x < 309) OR (pos_x > 333 AND pos_x < 346)) AND pos_y = 193) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 295 AND pos_x < 305) OR (pos_x > 337 AND pos_x < 348)) AND pos_y = 194) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 293 AND pos_x < 303) OR (pos_x > 339 AND pos_x < 349)) AND pos_y = 195) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 291 AND pos_x < 300) OR (pos_x > 342 AND pos_x < 351)) AND pos_y = 196) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 290 AND pos_x < 298) OR (pos_x > 344 AND pos_x < 352)) AND pos_y = 197) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 289 AND pos_x < 296) OR (pos_x > 346 AND pos_x < 353)) AND pos_y = 198) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 288 AND pos_x < 295) OR (pos_x > 348 AND pos_x < 354)) AND pos_y = 199) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 286 AND pos_x < 293) OR (pos_x > 349 AND pos_x < 356)) AND pos_y = 200) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 285 AND pos_x < 291) OR (pos_x > 351 AND pos_x < 357)) AND pos_y = 201) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 284 AND pos_x < 290) OR (pos_x > 352 AND pos_x < 358)) AND pos_y = 202) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 283 AND pos_x < 289) OR (pos_x > 353 AND pos_x < 359)) AND pos_y > 202 AND pos_y < 205) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 282 AND pos_x < 288) OR (pos_x > 354 AND pos_x < 360)) AND pos_y = 205) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 281 AND pos_x < 286) OR (pos_x > 356 AND pos_x < 361)) AND pos_y = 206) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 280 AND pos_x < 285) OR (pos_x > 357 AND pos_x < 362)) AND pos_y = 207) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 279 AND pos_x < 284) OR (pos_x > 358 AND pos_x < 363)) AND pos_y > 207 AND pos_y < 210) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 278 AND pos_x < 283) OR (pos_x > 359 AND pos_x < 364)) AND pos_y = 210) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 277 AND pos_x < 282) OR (pos_x > 360 AND pos_x < 365)) AND pos_y > 210 AND pos_y < 213) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 276 AND pos_x < 281) OR (pos_x > 361 AND pos_x < 366)) AND pos_y = 213) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 275 AND pos_x < 280) OR (pos_x > 362 AND pos_x < 367)) AND pos_y > 213 AND pos_y < 216) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 274 AND pos_x < 279) OR (pos_x > 363 AND pos_x < 368)) AND pos_y > 215 AND pos_y < 218) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 273 AND pos_x < 278) OR (pos_x > 364 AND pos_x < 369)) AND pos_y > 217 AND pos_y < 221) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 272 AND pos_x < 277) OR (pos_x > 365 AND pos_x < 370)) AND pos_y > 220 AND pos_y < 224) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 271 AND pos_x < 276) OR (pos_x > 366 AND pos_x < 371)) AND pos_y > 223 AND pos_y < 228) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 270 AND pos_x < 275) OR (pos_x > 367 AND pos_x < 372)) AND pos_y > 227 AND pos_y < 233) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 269 AND pos_x < 274) OR (pos_x > 368 AND pos_x < 373)) AND pos_y > 232 AND pos_y < 247) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 270 AND pos_x < 275) OR (pos_x > 367 AND pos_x < 372)) AND pos_y > 246 AND pos_y < 253) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 271 AND pos_x < 276) OR (pos_x > 366 AND pos_x < 371)) AND pos_y > 252 AND pos_y < 256) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 272 AND pos_x < 277) OR (pos_x > 365 AND pos_x < 370)) AND pos_y > 255 AND pos_y < 259) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 273 AND pos_x < 278) OR (pos_x > 364 AND pos_x < 369)) AND pos_y > 258 AND pos_y < 262) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 274 AND pos_x < 279) OR (pos_x > 363 AND pos_x < 368)) AND pos_y > 261 AND pos_y < 264) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 275 AND pos_x < 280) OR (pos_x > 362 AND pos_x < 367)) AND pos_y > 263 AND pos_y < 266) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 276 AND pos_x < 281) OR (pos_x > 361 AND pos_x < 366)) AND pos_y = 266) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 277 AND pos_x < 282) OR (pos_x > 360 AND pos_x < 365)) AND pos_y > 266 AND pos_y < 268) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 278 AND pos_x < 283) OR (pos_x > 359 AND pos_x < 364)) AND pos_y > 267 AND pos_y < 270) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 279 AND pos_x < 284) OR (pos_x > 358 AND pos_x < 363)) AND pos_y = 270) then
							colorRGB := "1111"&"0000"&"0000";	
						elsif (((pos_x > 280 AND pos_x < 285) OR (pos_x > 357 AND pos_x < 362)) AND pos_y = 271) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 281 AND pos_x < 286) OR (pos_x > 356 AND pos_x < 361)) AND pos_y = 272) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 282 AND pos_x < 288) OR (pos_x > 354 AND pos_x < 360)) AND pos_y > 272 AND pos_y < 275) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 283 AND pos_x < 289) OR (pos_x > 353 AND pos_x < 359)) AND pos_y = 275) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 284 AND pos_x < 290) OR (pos_x > 352 AND pos_x < 358)) AND pos_y = 276) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 285 AND pos_x < 292) OR (pos_x > 350 AND pos_x < 357)) AND pos_y = 277) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 286 AND pos_x < 293) OR (pos_x > 349 AND pos_x < 356)) AND pos_y = 278) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 288 AND pos_x < 295) OR (pos_x > 347 AND pos_x < 354)) AND pos_y = 279) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 289 AND pos_x < 297) OR (pos_x > 345 AND pos_x < 353)) AND pos_y = 280) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 290 AND pos_x < 299) OR (pos_x > 343 AND pos_x < 352)) AND pos_y = 281) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 292 AND pos_x < 301) OR (pos_x > 341 AND pos_x < 350)) AND pos_y = 282) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 293 AND pos_x < 304) OR (pos_x > 338 AND pos_x < 349)) AND pos_y = 283) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 295 AND pos_x < 308) OR (pos_x > 334	AND pos_x < 347)) AND pos_y = 284) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 297 AND pos_x < 313) OR (pos_x > 329 AND pos_x < 345)) AND pos_y = 285) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (((pos_x > 299 AND pos_x < 318) OR (pos_x > 324 AND pos_x < 343)) AND pos_y = 286) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 301 AND pos_x < 341 AND pos_y = 287) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 304 AND pos_x < 338 AND pos_y = 288) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 308 AND pos_x < 334 AND pos_y = 289) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 313 AND pos_x < 329 AND pos_y = 290) then
							colorRGB := "1111"&"0000"&"0000";
						elsif (pos_x > 318 AND pos_x < 324 AND pos_y = 291) then
							colorRGB := "1111"&"0000"&"0000";
						else
							colorRGB := "1111"&"1111"&"1111"; 
						end if;	
						
					when "1101" => -- Cuadro en movimiento de izquierda a derecha
						case tempo is
							when 0 => 
								if (pos_x > 0 AND pos_x < 100 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else 
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 1 => 
								if (pos_x > 2 AND pos_x < 102 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 2 => 
								if (pos_x > 4 AND pos_x < 104 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 3 => 
								if (pos_x > 6 AND pos_x < 106 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 4 => 
								if (pos_x > 8 AND pos_x < 108 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 5 => 
								if (pos_x > 10 AND pos_x < 110 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 6 => 
								if (pos_x > 12 AND pos_x < 112 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 7 => 
								if (pos_x > 14 AND pos_x < 114 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 8 => 
								if (pos_x > 16 AND pos_x < 116 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 9 => 
								if (pos_x > 18 AND pos_x < 118 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 10 => 
								if (pos_x > 20 AND pos_x < 120 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 11 => 
								if (pos_x > 22 AND pos_x < 122 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 12 => 
								if (pos_x > 24 AND pos_x < 124 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 13 => 
								if (pos_x > 26 AND pos_x < 126 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 14 => 
								if (pos_x > 28 AND pos_x < 128 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 15 => 
								if (pos_x > 30 AND pos_x < 130 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 16 => 
								if (pos_x > 32 AND pos_x < 132 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 17 => 
								if (pos_x > 34 AND pos_x < 134 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 18 => 
								if (pos_x > 36 AND pos_x < 136 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 19 => 
								if (pos_x > 38 AND pos_x < 138 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 20 => 
								if (pos_x > 40 AND pos_x < 140 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 21 => 
								if (pos_x > 42 AND pos_x < 142 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 22 => 
								if (pos_x > 44 AND pos_x < 144 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 23 => 
								if (pos_x > 46 AND pos_x < 146 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 24 => 
								if (pos_x > 48 AND pos_x < 148 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 25 => 
								if (pos_x > 50 AND pos_x < 150 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 26 => 
								if (pos_x > 52 AND pos_x < 152 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 27 => 
								if (pos_x > 54 AND pos_x < 154 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 28 => 
								if (pos_x > 56 AND pos_x < 156 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 29 => 
								if (pos_x > 58 AND pos_x < 158 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 30 => 
								if (pos_x > 60 AND pos_x < 160 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 31 => 
								if (pos_x > 62 AND pos_x < 162 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 32 => 
								if (pos_x > 64 AND pos_x < 164 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 33 => 
								if (pos_x > 66 AND pos_x < 166 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 34 => 
								if (pos_x > 68 AND pos_x < 168 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 35 => 
								if (pos_x > 70 AND pos_x < 170 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 36 => 
								if (pos_x > 72 AND pos_x < 172 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 37 => 
								if (pos_x > 74 AND pos_x < 174 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 38 => 
								if (pos_x > 76 AND pos_x < 176 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 39 => 
								if (pos_x > 78 AND pos_x < 178 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 40 => 
								if (pos_x > 80 AND pos_x < 180 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 41 => 
								if (pos_x > 82 AND pos_x < 182 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 42 => 
								if (pos_x > 84 AND pos_x < 184 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 43 => 
								if (pos_x > 86 AND pos_x < 186 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 44 => 
								if (pos_x > 88 AND pos_x < 188 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 45 => 
								if (pos_x > 90 AND pos_x < 190 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 46 => 
								if (pos_x > 92 AND pos_x < 192 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 47 => 
								if (pos_x > 94 AND pos_x < 194 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 48 => 
								if (pos_x > 96 AND pos_x < 196 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 49 => 
								if (pos_x > 98 AND pos_x < 198 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 50 => 
								if (pos_x > 100 AND pos_x < 200 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 51 => 
								if (pos_x > 102 AND pos_x < 202 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 52 => 
								if (pos_x > 104 AND pos_x < 204 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 53 => 
								if (pos_x > 106 AND pos_x < 206 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 54 => 
								if (pos_x > 108 AND pos_x < 208 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 55 => 
								if (pos_x > 110 AND pos_x < 210 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 56 => 
								if (pos_x > 112 AND pos_x < 212 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 57 => 
								if (pos_x > 114 AND pos_x < 214 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 58 => 
								if (pos_x > 116 AND pos_x < 216 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 59 => 
								if (pos_x > 118 AND pos_x < 218 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 60 => 
								if (pos_x > 120 AND pos_x < 220 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 61 => 
								if (pos_x > 122 AND pos_x < 222 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 62 => 
								if (pos_x > 124 AND pos_x < 224 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 63 => 
								if (pos_x > 126 AND pos_x < 226 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 64 => 
								if (pos_x > 128 AND pos_x < 228 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 65 => 
								if (pos_x > 130 AND pos_x < 230 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 66 => 
								if (pos_x > 132 AND pos_x < 232 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 67 => 
								if (pos_x > 134 AND pos_x < 234 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 68 => 
								if (pos_x > 136 AND pos_x < 236 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 69 => 
								if (pos_x > 138 AND pos_x < 238 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 70 => 
								if (pos_x > 140 AND pos_x < 240 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 71 => 
								if (pos_x > 142 AND pos_x < 242 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 72 => 
								if (pos_x > 144 AND pos_x < 244 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 73 => 
								if (pos_x > 146 AND pos_x < 246 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 74 => 
								if (pos_x > 148 AND pos_x < 248 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 75 => 
								if (pos_x > 150 AND pos_x < 250 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 76 => 
								if (pos_x > 152 AND pos_x < 252 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 77 => 
								if (pos_x > 154 AND pos_x < 254 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 78 => 
								if (pos_x > 156 AND pos_x < 256 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 79 => 
								if (pos_x > 158 AND pos_x < 258 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 80 => 
								if (pos_x > 160 AND pos_x < 260 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 81 => 
								if (pos_x > 162 AND pos_x < 262 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 82 => 
								if (pos_x > 164 AND pos_x < 264 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 83 => 
								if (pos_x > 166 AND pos_x < 266 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 84 => 
								if (pos_x > 168 AND pos_x < 268 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 85 => 
								if (pos_x > 170 AND pos_x < 270 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 86 => 
								if (pos_x > 172 AND pos_x < 272 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 87 => 
								if (pos_x > 174 AND pos_x < 274 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 88 => 
								if (pos_x > 176 AND pos_x < 276 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 89 => 
								if (pos_x > 178 AND pos_x < 278 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 90 => 
								if (pos_x > 180 AND pos_x < 280 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 91 => 
								if (pos_x > 182 AND pos_x < 282 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 92 => 
								if (pos_x > 184 AND pos_x < 284 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 93 =>	
								if (pos_x > 186 AND pos_x < 286 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 94 => 
								if (pos_x > 188 AND pos_x < 288 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 95 => 
								if (pos_x > 190 AND pos_x < 290 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 96 => 
								if (pos_x > 192 AND pos_x < 292 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 97 => 
								if (pos_x > 194 AND pos_x < 294 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 98 => 
								if (pos_x > 196 AND pos_x < 296 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 99 => 
								if (pos_x > 198 AND pos_x < 298 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 100 => 
								if (pos_x > 200 AND pos_x < 300 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;							
							when 101 => 
								if (pos_x > 202 AND pos_x < 302 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 102 => 
								if (pos_x > 204 AND pos_x < 304 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 103 => 
								if (pos_x > 206 AND pos_x < 306 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 104 => 
								if (pos_x > 208 AND pos_x < 308 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 105 => 
								if (pos_x > 210 AND pos_x < 310 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 106 => 
								if (pos_x > 212 AND pos_x < 312 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 107 => 
								if (pos_x > 214 AND pos_x < 314 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 108 => 
								if (pos_x > 216 AND pos_x < 316 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 109 => 
								if (pos_x > 218 AND pos_x < 318 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 110 => 
								if (pos_x > 220 AND pos_x < 320 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 111 => 
								if (pos_x > 222 AND pos_x < 322 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 112 => 
								if (pos_x > 224 AND pos_x < 324 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 113 => 
								if (pos_x > 226 AND pos_x < 326 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 114 => 
								if (pos_x > 228 AND pos_x < 328 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 115 => 
								if (pos_x > 230 AND pos_x < 330 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 116 => 
								if (pos_x > 232 AND pos_x < 332 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 117 => 
								if (pos_x > 234 AND pos_x < 334 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 118 => 
								if (pos_x > 236 AND pos_x < 336 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 119 => 
								if (pos_x > 238 AND pos_x < 338 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 120 => 
								if (pos_x > 240 AND pos_x < 340 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 121 => 
								if (pos_x > 242 AND pos_x < 342 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 122 => 
								if (pos_x > 244 AND pos_x < 344 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 123 => 
								if (pos_x > 246 AND pos_x < 346 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 124 => 
								if (pos_x > 248 AND pos_x < 348 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 125 => 
								if (pos_x > 250 AND pos_x < 350 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 126 => 
								if (pos_x > 252 AND pos_x < 352 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 127 => 
								if (pos_x > 254 AND pos_x < 354 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 128 => 
								if (pos_x > 256 AND pos_x < 356 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 129 => 
								if (pos_x > 258 AND pos_x < 358 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 130 => 
								if (pos_x > 260 AND pos_x < 360 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 131 => 
								if (pos_x > 262 AND pos_x < 362 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 132 => 
								if (pos_x > 264 AND pos_x < 364 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 133 => 
								if (pos_x > 266 AND pos_x < 366 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 134 => 
								if (pos_x > 268 AND pos_x < 368 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 135 => 
								if (pos_x > 270 AND pos_x < 370 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 136 => 
								if (pos_x > 272 AND pos_x < 372 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 137 => 
								if (pos_x > 274 AND pos_x < 374 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 138 => 
								if (pos_x > 276 AND pos_x < 376 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 139 => 
								if (pos_x > 278 AND pos_x < 378 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 140 => 
								if (pos_x > 280 AND pos_x < 380 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 141 => 
								if (pos_x > 282 AND pos_x < 382 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 142 => 
								if (pos_x > 284 AND pos_x < 384 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 143 => 
								if (pos_x > 286 AND pos_x < 386 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 144 => 
								if (pos_x > 288 AND pos_x < 388 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 145 => 
								if (pos_x > 290 AND pos_x < 390 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 146 => 
								if (pos_x > 292 AND pos_x < 392 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 147 => 
								if (pos_x > 294 AND pos_x < 394 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 148 => 
								if (pos_x > 296 AND pos_x < 396 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 149 => 
								if (pos_x > 298 AND pos_x < 398 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 150 => 
								if (pos_x > 300 AND pos_x < 400 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 151 => 
								if (pos_x > 302 AND pos_x < 402 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 152 => 
								if (pos_x > 304 AND pos_x < 404 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 153 => 
								if (pos_x > 306 AND pos_x < 406 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 154 => 
								if (pos_x > 308 AND pos_x < 408 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 155 => 
								if (pos_x > 310 AND pos_x < 410 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 156 => 
								if (pos_x > 312 AND pos_x < 412 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 157 => 
								if (pos_x > 314 AND pos_x < 414 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 158 => 
								if (pos_x > 316 AND pos_x < 416 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 159 => 
								if (pos_x > 318 AND pos_x < 418 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 160 => 
								if (pos_x > 320 AND pos_x < 420 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 161 => 
								if (pos_x > 322 AND pos_x < 422 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 162 => 
								if (pos_x > 324 AND pos_x < 424 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 163 => 
								if (pos_x > 326 AND pos_x < 426 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 164 => 
								if (pos_x > 328 AND pos_x < 428 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 165 => 
								if (pos_x > 330 AND pos_x < 430 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 166 => 
								if (pos_x > 332 AND pos_x < 432 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 167 => 
								if (pos_x > 334 AND pos_x < 434 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 168 => 
								if (pos_x > 336 AND pos_x < 436 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 169 => 
								if (pos_x > 338 AND pos_x < 438 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 170 => 
								if (pos_x > 340 AND pos_x < 440 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 171 => 
								if (pos_x > 342 AND pos_x < 442 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 172 => 
								if (pos_x > 344 AND pos_x < 444 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 173 => 
								if (pos_x > 346 AND pos_x < 446 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 174 => 
								if (pos_x > 348 AND pos_x < 448 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 175 => 
								if (pos_x > 350 AND pos_x < 450 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 176 => 
								if (pos_x > 352 AND pos_x < 452 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 177 => 
								if (pos_x > 354 AND pos_x < 454 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 178 => 
								if (pos_x > 356 AND pos_x < 456 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 179 => 
								if (pos_x > 358 AND pos_x < 458 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 180 => 
								if (pos_x > 360 AND pos_x < 460 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 181 => 
								if (pos_x > 362 AND pos_x < 462 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 182 => 
								if (pos_x > 364 AND pos_x < 464 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 183 => 
								if (pos_x > 366 AND pos_x < 466 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 184 => 
								if (pos_x > 368 AND pos_x < 468 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 185 => 
								if (pos_x > 370 AND pos_x < 470 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 186 => 
								if (pos_x > 372 AND pos_x < 472 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 187 => 
								if (pos_x > 374 AND pos_x < 474 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 188 => 
								if (pos_x > 376 AND pos_x < 476 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 189 => 
								if (pos_x > 378 AND pos_x < 478 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 190 => 
								if (pos_x > 380 AND pos_x < 480 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 191 => 
								if (pos_x > 382 AND pos_x < 482 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 192 => 
								if (pos_x > 384 AND pos_x < 484 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 193 =>	
								if (pos_x > 386 AND pos_x < 486 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 194 => 
								if (pos_x > 388 AND pos_x < 488 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 195 => 
								if (pos_x > 390 AND pos_x < 490 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 196 => 
								if (pos_x > 392 AND pos_x < 492 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 197 => 
								if (pos_x > 394 AND pos_x < 494 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 198 => 
								if (pos_x > 396 AND pos_x < 496 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 199 => 
								if (pos_x > 398 AND pos_x < 498 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 200 => 
								if (pos_x > 400 AND pos_x < 500 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 201 => 
								if (pos_x > 402 AND pos_x < 502 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 202 => 
								if (pos_x > 404 AND pos_x < 504 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 203 => 
								if (pos_x > 406 AND pos_x < 506 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 204 => 
								if (pos_x > 408 AND pos_x < 508 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 205 => 
								if (pos_x > 410 AND pos_x < 510 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 206 => 
								if (pos_x > 412 AND pos_x < 512 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 207 => 
								if (pos_x > 414 AND pos_x < 514 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 208 => 
								if (pos_x > 416 AND pos_x < 516 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 209 => 
								if (pos_x > 418 AND pos_x < 518 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 210 => 
								if (pos_x > 420 AND pos_x < 520 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 211 => 
								if (pos_x > 422 AND pos_x < 522 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 212 => 
								if (pos_x > 424 AND pos_x < 524 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 213 => 
								if (pos_x > 426 AND pos_x < 526 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 214 => 
								if (pos_x > 428 AND pos_x < 528 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 215 => 
								if (pos_x > 430 AND pos_x < 530 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 216 => 
								if (pos_x > 432 AND pos_x < 532 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 217 => 
								if (pos_x > 434 AND pos_x < 534 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 218 => 
								if (pos_x > 436 AND pos_x < 536 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 219 => 
								if (pos_x > 438 AND pos_x < 538 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 220 => 
								if (pos_x > 440 AND pos_x < 540 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 221 => 
								if (pos_x > 442 AND pos_x < 542 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 222 => 
								if (pos_x > 444 AND pos_x < 544 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 223 => 
								if (pos_x > 446 AND pos_x < 546 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 224 => 
								if (pos_x > 448 AND pos_x < 548 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 225 => 
								if (pos_x > 450 AND pos_x < 550 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 226 => 
								if (pos_x > 452 AND pos_x < 552 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 227 => 
								if (pos_x > 454 AND pos_x < 554 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 228 => 
								if (pos_x > 456 AND pos_x < 556 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 229 => 
								if (pos_x > 458 AND pos_x < 558 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 230 => 
								if (pos_x > 460 AND pos_x < 560 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 231 => 
								if (pos_x > 462 AND pos_x < 562 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 232 => 
								if (pos_x > 464 AND pos_x < 564 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 233 => 
								if (pos_x > 466 AND pos_x < 566 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 234 => 
								if (pos_x > 468 AND pos_x < 568 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 235 => 
								if (pos_x > 470 AND pos_x < 570 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 236 => 
								if (pos_x > 472 AND pos_x < 572 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 237 => 
								if (pos_x > 474 AND pos_x < 574 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 238 => 
								if (pos_x > 476 AND pos_x < 576 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 239 => 
								if (pos_x > 478 AND pos_x < 578 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 240 => 
								if (pos_x > 480 AND pos_x < 580 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 241 => 
								if (pos_x > 482 AND pos_x < 582 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 242 => 
								if (pos_x > 484 AND pos_x < 584 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 243 => 
								if (pos_x > 486 AND pos_x < 586 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 244 => 
								if (pos_x > 488 AND pos_x < 588 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 245 => 
								if (pos_x > 490 AND pos_x < 590 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 246 => 
								if (pos_x > 492 AND pos_x < 592 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 247 => 
								if (pos_x > 494 AND pos_x < 594 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 248 => 
								if (pos_x > 496 AND pos_x < 596 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 249 => 
								if (pos_x > 498 AND pos_x < 598 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 250 => 
								if (pos_x > 500 AND pos_x < 600 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 251 => 
								if (pos_x > 502 AND pos_x < 602 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 252 => 
								if (pos_x > 504 AND pos_x < 604 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 253 => 
								if (pos_x > 506 AND pos_x < 606 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 254 => 
								if (pos_x > 508 AND pos_x < 608 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 255 => 
								if (pos_x > 510 AND pos_x < 610 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 256 => 
								if (pos_x > 512 AND pos_x < 612 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 257 => 
								if (pos_x > 514 AND pos_x < 614 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 258 => 
								if (pos_x > 516 AND pos_x < 616 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 259 => 
								if (pos_x > 518 AND pos_x < 618 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 260 => 
								if (pos_x > 520 AND pos_x < 620 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 261 => 
								if (pos_x > 522 AND pos_x < 622 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 262 => 
								if (pos_x > 524 AND pos_x < 624 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 263 => 
								if (pos_x > 526 AND pos_x < 626 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 264 => 
								if (pos_x > 528 AND pos_x < 628 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 265 => 
								if (pos_x > 530 AND pos_x < 630 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 266 => 
								if (pos_x > 532 AND pos_x < 632 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 267 => 
								if (pos_x > 534 AND pos_x < 634 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 268 => 
								if (pos_x > 536 AND pos_x < 636 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when 269 => 
								if (pos_x > 538 AND pos_x < 638 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111"; 
								end if;
							when others =>
								if (pos_x > 540 AND pos_x < 640 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
							end case;
						
					when "1111" => -- Recta que gira en el centro
--						mitad x => 640/2 = 320
--						mitad y => 480/2 = 240
						Case grado is 
							when 0 => -- 0 grados
								if (pos_x > 270 AND pos_x < 370 AND pos_y > 236 AND pos_y < 244) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
							when 1 => -- 5 grados
								if (pos_x > 280 AND pos_x < 360 AND pos_y > 236 AND pos_y < 244) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 270 AND pos_x < 281 AND pos_y > 237 AND pos_y < 245) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 359 AND pos_x < 370 AND pos_y > 235 AND pos_y < 243) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
							when 2 => --10 grados
								if (pos_x > 300 AND pos_x < 340 AND pos_y > 236 AND pos_y < 244) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 272 AND pos_x < 301 AND pos_y > 237 AND pos_y < 245) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 339 AND pos_x < 368 AND pos_y > 235 AND pos_y < 243) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
							when 3 => --15 grados
								if (pos_x > 310 AND pos_x < 330 AND pos_y > 236 AND pos_y < 244) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 291 AND pos_x < 311 AND pos_y > 237 AND pos_y < 245) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 274 AND pos_x < 292 AND pos_y > 238 AND pos_y < 246) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 329 AND pos_x < 349 AND pos_y > 235 AND pos_y < 243) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 348 AND pos_x < 366 AND pos_y > 234 AND pos_y < 242) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
							when 4 => --20 grados
							when 5 => --25 grados
							when 6 => --30 grados
							when 7 => --35 grados
							when 8 => --40 grados
							when 9 => --45 grados
							when 10 => --50 grados
							when 11 => --55 grados
							when 12 => --60 grados
							when 13 => --65 grados
							when 14 => --70 grados
							when 15 => --75 grados
							when 16 => --80 grados
							when 17 => --85 grados
								if (pos_x > 316 AND pos_x < 324 AND pos_y > 200 AND pos_y < 280) then
									colorRGB := "1111"&"0000"&"0000";
								elsif (pos_x > 317 AND pos_x < 325 AND pos_y > 190 AND pos_y < 199) then  
									colorRGB := "1111"&"0000"&"0000";
								elsif (pos_x > 315 AND pos_x < 323 AND pos_y > 279 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
							when 18 => --90 grados
								if (pos_x > 316 AND pos_x < 324 AND pos_y > 190 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
							when 19 => --95 grados
								if (pos_x > 316 AND pos_x < 324 AND pos_y > 200 AND pos_y < 280) then
									colorRGB := "1111"&"0000"&"0000";
								elsif (pos_x > 315 AND pos_x < 323 AND pos_y > 190 AND pos_y < 199) then  
									colorRGB := "1111"&"0000"&"0000";
								elsif (pos_x > 317 AND pos_x < 325 AND pos_y > 279 AND pos_y < 290) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
							when 20 => --100 grados
							when 21 => --105 grados
							when 22 => --110 grados
							when 23 => --115 grados
							when 24 => --120 grados
							when 25 => --125 grados
							when 26 => --130 grados
							when 27 => --135 grados
							when 28 => --140 grados
							when 29 => --145 grados
							when 30 => --150 grados
							when 31 => --155 grados
							when 32 => --160 grados
							when 33 => --165 grados
								if (pos_x > 310 AND pos_x < 330 AND pos_y > 236 AND pos_y < 244) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 291 AND pos_x < 311 AND pos_y > 235 AND pos_y < 243) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 274 AND pos_x < 292 AND pos_y > 234 AND pos_y < 242) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 329 AND pos_x < 349 AND pos_y > 237 AND pos_y < 245) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 348 AND pos_x < 366 AND pos_y > 238 AND pos_y < 246) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
							when 34 => --170 grados
								if (pos_x > 300 AND pos_x < 340 AND pos_y > 236 AND pos_y < 244) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 272 AND pos_x < 301 AND pos_y > 235 AND pos_y < 243) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 339 AND pos_x < 368 AND pos_y > 237 AND pos_y < 245) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
							when  others => --175 grados
								if (pos_x > 280 AND pos_x < 360 AND pos_y > 236 AND pos_y < 244) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 270 AND pos_x < 281 AND pos_y > 235 AND pos_y < 243) then
									colorRGB := "1111"&"0000"&"0000";
								elsif(pos_x > 359 AND pos_x < 370 AND pos_y > 237 AND pos_y < 245) then
									colorRGB := "1111"&"0000"&"0000";
								else
									colorRGB := "1111"&"1111"&"1111";
								end if;
						end case;
					
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