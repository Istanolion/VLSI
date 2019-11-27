
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity piano is
    Port ( clk : in  STD_LOGIC;
           a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c : in  STD_LOGIC;
           d : in  STD_LOGIC;
		     e : in STD_LOGIC;
		     f : in STD_LOGIC;
		     g : in STD_LOGIC;
			  h : in STD_LOGIC;
			  
           parlante : inout  STD_LOGIC);
end piano;

architecture tiles of piano is

signal cont : std_logic_vector (16 downto 0);
constant cont_max: std_logic_vector :="11011101111100100";  -- frecuencia de LA

signal cont1 : std_logic_vector (17 downto 0);
constant cont_max1: std_logic_vector :="101110110001010010";  -- fecuencia de DO

signal cont2 : std_logic_vector (17 downto 0);
constant cont_max2: std_logic_vector :="100101000110100111";  -- fecuencia de MI

signal cont3 : std_logic_vector (16 downto 0);
constant cont_max3: std_logic_vector :="11111001000111111";  --frecuencia de SOL

signal cont4 : std_logic_vector (17 downto 0);
constant cont_max4: std_logic_vector :="101001100100011001";  --frecuencia de RE

signal cont5 : std_logic_vector (17 downto 0);
constant cont_max5: std_logic_vector :="100010111101001000";  --frecuencia de FA

signal cont6 : std_logic_vector (16 downto 0);
constant cont_max6: std_logic_vector :="11000101101110111";  --frecuencia de SI

signal cont7 : std_logic_vector (18 downto 0);
constant cont_max7: std_logic_vector :="111011101111100100";  -- frecuencia de DO#

	begin
	process (clk)
		begin
		if clk'event and clk= '1' then
			cont <= cont+1;
			if cont= cont_max then
				cont <="00000000000000000";
			end if;
		end if;
	end process;

	process (clk)
		begin
		if clk'event and clk= '1' then
			cont1 <= cont1+1;
			if cont1= cont_max1 then
				cont1 <="000000000000000000";
			end if;
		end if;
	end process;

	process (clk)
		begin
		if clk'event and clk= '1' then
			cont2 <= cont2+1;
			if cont2= cont_max2 then
				cont2 <="000000000000000000";
			end if;
		end if;
	end process;

	process (clk)
	begin
		if clk'event and clk= '1' then
			cont3 <= cont3+1;
			if cont3= cont_max3 then
				cont3 <= "00000000000000000";
			end if;
		end if;
	end process;

	process (clk)
		begin
		if clk'event and clk= '1' then
			cont4 <= cont4+1;
			if cont4= cont_max4 then
				cont4 <= "000000000000000000";
			end if;
		end if;
	end process;

	process (clk)
		begin
		if clk'event and clk= '1' then
			cont5 <= cont5+1;
			if cont5= cont_max5 then
				cont5 <= "000000000000000000";
			end if;
		end if;
	end process;

	process (clk)
		begin
		if clk'event and clk= '1' then
			cont6 <= cont6+1;
			if cont6= cont_max6 then
				cont6 <= "00000000000000000";
			end if;
		end if;
	end process;
	
		process (clk)
		begin
		if clk'event and clk= '1' then
			cont7 <= cont7+1;
			if cont7= cont_max7 then
				cont7 <= "0000000000000000000";
			end if;
		end if;
	end process;

	process (parlante) 
		begin
		if h= '1' then parlante <= cont7 (18);
		elsif a= '1' then parlante <= cont1 (17);
		elsif b= '1' then parlante <= cont4 (17);
		elsif c= '1' then parlante <= cont2 (17);
		elsif d= '1' then parlante <= cont5 (17);
		elsif e= '1' then parlante <= cont3 (16);
		elsif f= '1' then parlante <= cont (16);
		elsif g= '1' then parlante <= cont6 (16);
		else 
			parlante <= '0';
		end if;
	end process;

	--DO, RE, MI, Do
	--do re mi do
	--mi, fa sol,
	--mi fa sol
	--sol la sol fa mi
	--
end tiles;
		

