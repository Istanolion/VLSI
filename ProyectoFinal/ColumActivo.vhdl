library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity ColumActivo is
    Port ( 	data : in std_logic_vector(7 downto 0);
				clk : in std_logic;
				frame_addr : out std_logic_vector(14 downto 0);
            activo    : out  integer range 0 to 9) ;
end ColumActivo;

architecture Behavioral of ColumActivo is
	-- Timing constants
	constant hRez       : natural := 800;
   constant vRez       : natural := 600;

   constant hMaxCount  : natural := 1056;
   constant hStartSync : natural := 840;
   constant hEndSync   : natural := 968;
   constant vMaxCount  : natural := 628;
   constant vStartSync : natural := 601;
   constant vEndSync   : natural := 605;
   constant hsync_active : std_logic := '1';
   constant vsync_active : std_logic := '1';

   signal hCounter : unsigned(10 downto 0) := (others => '0');
   signal vCounter : unsigned(9 downto 0) := (others => '0');
   signal address : unsigned(16 downto 0) := (others => '0');
   signal blank : std_logic := '1';

   
begin
	frame_addr <= std_logic_vector(address(16 downto 2));
	process(clk)
	begin
		if rising_edge(clk) then
			-- Count the lines and rows      
         if hCounter = hMaxCount-1 then
            hCounter <= (others => '0');
            if vCounter = vMaxCount-1 then
               vCounter <= (others => '0');
            else
               vCounter <= vCounter+1;
            end if;
         else
            hCounter <= hCounter+1;
         end if;
			if blank = '0' then
				if hCounter>0 and hCounter<80 and data="11111111" then
					activo<= 1;
				elsif hCounter>80 and hCounter<160 and data="11111111" then
					activo<=2;
				elsif hCounter>160 and hCounter<240 and data="11111111" then
					activo<=3;
				elsif hCounter>240 and hCounter<320 and data="11111111" then
					activo<=4;
				elsif hCounter>320 and hCounter<400 and data="11111111" then
					activo<=5;
				elsif hCounter>400 and hCounter<480 and data="11111111" then
					activo<=6;
				elsif hCounter>480 and hCounter<560 and data="11111111" then
					activo<=7;
				elsif hCounter>560 and hCounter<640 and data="11111111" then
					activo<=8;
				else
					activo<=0;
				end if;
			end if;
			 if vCounter  >= vRez then
            address <= (others => '0');
            blank <= '1';
         else 
            if hCounter  >= 80 and hCounter  < 720 then
               blank <= '0';
               if hCounter = 719 then
                  if vCounter(1 downto 0) /= "11" then
                     address <= address - 639;
                  else
                      address <= address+1;
                  end if;
               else
                  address <= address+1;
               end if;
            else
               blank <= '1';
            end if;
         end if;
		end if;
	end process;
end Behavioral;
