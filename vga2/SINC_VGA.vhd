library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SINC_VGA is
port (clk : in std_logic;
		hsync, vsync, habilitado : out std_logic;
		pos_x : out integer range 0 to 800 := 0;
		pos_y : out integer range 0 to 525 := 0);
end SINC_VGA;

architecture COMP_SYNC_VGA of SINC_VGA is
signal x_pos : integer range 0 to 800 := 0;
signal y_pos : integer range 0 to 525 := 0;

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if x_pos < 800 then
				x_pos <= x_pos + 1;
			else
				x_pos <= 0;
				if y_pos < 525 then
					y_pos <= y_pos + 1;
				else
					y_pos <= 0;
				end if;
			end if;
			
			if (x_pos > 655 and x_pos < 752) then
				hsync <= '0';
			else
				hsync <= '1';
			end if;
			
			if (y_pos > 489 and y_pos < 492) then
				vsync <= '0';
			else
				vsync <= '1';
			end if;
			
			if (x_pos < 640 and y_pos < 480) then
				habilitado <= '1';
			else
				habilitado <= '0';
			end if;
			
			pos_x <= x_pos;
			pos_y <= y_pos;
		end if;
	end process;
end COMP_SYNC_VGA;