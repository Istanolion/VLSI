library ieee ;
use ieee.std_logic_1164.all ;

entity DIV_FREC is
port (	Cin : in std_logic;
	  		Cout : out std_logic);
end DIV_FREC;

architecture COMP_DIV_FREC of DIV_FREC is
constant cT: integer := 12;
signal c0,c1,c2,c3: integer range 0 to 1000;
signal D: std_logic := '0';

begin
	process(Cin)
	begin
		if (Cin'event and Cin='1') then
			c0 <= c0 + 1;
			if c0 = cT then
				c0 <= 0;
				c1 <= c1 + 1;
			elsif c1 = cT then
				c1 <= 0;
				c2 <= c2 + 1;
			elsif c2 = cT then
				c2 <= 0;
				c3 <= c3 + 1;
			elsif c3 = cT then
				c3 <= 0;
				D <= not D;
			end if;
		end if;
		Cout <= D;
	end process ;
end COMP_DIV_FREC ;