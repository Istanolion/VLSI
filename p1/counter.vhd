LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY counter IS
    Port ( clk : in  STD_LOGIC;     -- input clock
           -- LEDs to display count
           led : out  STD_LOGIC_VECTOR (17 DOWNTO 0)
			 );  
END counter;

ARCHITECTURE Behavioral OF counter IS
    SIGNAL count   : STD_LOGIC_VECTOR (17 DOWNTO 0) := X"0000"&"00";
BEGIN
    -- counter
    PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1' AND (NOT COUNT="111101000110111100")) THEN
				count <= count + '1';   -- counting up
        END IF;
    END PROCESS;
    
    -- display count on LEDs
    LED <= NOT count;
    
END Behavioral;