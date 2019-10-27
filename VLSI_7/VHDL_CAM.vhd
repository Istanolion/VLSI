----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Top level for the OV7670 camera project.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VHDL_CAM is
    Port (
		
      clk50        : in    STD_LOGIC;
		
      OV7670_SIOC  : out   STD_LOGIC;
      OV7670_SIOD  : inout STD_LOGIC;
      OV7670_RESET : out   STD_LOGIC;
      OV7670_PWDN  : out   STD_LOGIC;
      OV7670_VSYNC : in    STD_LOGIC;
      OV7670_HREF  : in    STD_LOGIC;
      OV7670_PCLK  : in    STD_LOGIC;
      OV7670_XCLK  : out   STD_LOGIC;
      OV7670_D     : in    STD_LOGIC_VECTOR(7 downto 0);

      LED          : out    STD_LOGIC_VECTOR(7 downto 0);

      vga_red      : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_green    : out   STD_LOGIC_VECTOR(2 downto 0);
      vga_blue     : out   STD_LOGIC_VECTOR(2 downto 1);
      vga_hsync    : out   STD_LOGIC;
      vga_vsync    : out   STD_LOGIC;
      
      btn          : in    STD_LOGIC:='1'
    );
end VHDL_CAM;

architecture Behavioral of VHDL_CAM is

   COMPONENT debounce
   PORT(
      clk : IN std_logic;
      i : IN std_logic;          
      o : OUT std_logic
      );
   END COMPONENT;

   COMPONENT ov7670_controller
   PORT(
      clk   : IN    std_logic;    
      resend: IN    std_logic;    
      config_finished : out std_logic;
      siod  : INOUT std_logic;      
      sioc  : OUT   std_logic;
      reset : OUT   std_logic;
      pwdn  : OUT   std_logic;
      xclk  : OUT   std_logic
      );
   END COMPONENT;

-- RAM_CAM HACE LA FUNCION DE FRAME BUFFER

--   COMPONENT frame_buffer
--   PORT (
--      clka  : IN  STD_LOGIC;
--      wea   : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
--      addra : IN  STD_LOGIC_VECTOR(14 DOWNTO 0);
--      dina  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
--      clkb  : IN  STD_LOGIC;
--      addrb : IN  STD_LOGIC_VECTOR(14 DOWNTO 0);
--      doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
--   );
--   END COMPONENT;

   COMPONENT ov7670_capture
   PORT(
      pclk : IN std_logic;
      vsync : IN std_logic;
      href  : IN std_logic;
      d     : IN std_logic_vector(7 downto 0);          
      addr  : OUT std_logic_vector(14 downto 0);
      dout  : OUT std_logic_vector(7 downto 0);
      we    : OUT std_logic
      );
   END COMPONENT;


   COMPONENT vga
   PORT(
      clk50 	: IN std_logic;
      vga_red 		: OUT std_logic_vector(2 downto 0);
      vga_green : OUT std_logic_vector(2 downto 0);
      vga_blue : OUT std_logic_vector(2 downto 1);
      vga_hsync : OUT std_logic;
      vga_vsync : OUT std_logic;
      
      frame_addr : OUT std_logic_vector(14 downto 0);
      frame_pixel : IN std_logic_vector(7 downto 0)         
      );
   END COMPONENT;
	
-- COMPONENTE DE RAM (agregado por nosotros) 
	COMPONENT RAM_CAM
	PORT(
		data			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress	: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		wraddress	: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		wrclock		: IN STD_LOGIC  := '1';
		wren			: IN STD_LOGIC  := '0';
		q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;
   
   signal frame_addr  : std_logic_vector(14 downto 0);
   signal frame_pixel : std_logic_vector(7 downto 0);

   signal capture_addr  : std_logic_vector(14 downto 0);
   signal capture_data  : std_logic_vector(7 downto 0);
   signal capture_we    : std_logic;
   signal resend : std_logic;
   signal config_finished : std_logic;
	
	signal cl1,cl : std_logic_vector(7 downto 0):= "11100000";
	signal cl2 : std_logic_vector(7 downto 0):= "00011100";
	signal cl3 : std_logic_vector(7 downto 0):= "00000011";
	signal cont: integer range 0 to 5:= 0;

begin
btn_debounce: debounce PORT MAP(
      clk => clk50,
      i   => btn,
      o   => resend
   );

   Inst_vga: vga PORT MAP(
      clk50       => clk50,
      vga_red     => vga_red,
      vga_green   => vga_green,
      vga_blue    => vga_blue,
      vga_hsync   => vga_hsync,
      vga_vsync   => vga_vsync,
      frame_addr  => frame_addr,
      frame_pixel => frame_pixel
   );

-- LA INSTANCIA DE RAM HACE LA FUNCION DE FRAME BUFFER
			
--fb : frame_buffer
--  PORT MAP (
--    clka  => OV7670_PCLK,
--    wea   => capture_we,
--    addra => capture_addr,
--    dina  => capture_data,
--    
--    clkb  => clk50,
--    addrb => frame_addr,
--    doutb => frame_pixel
--  );
  
inst_ram: RAM_CAM PORT MAP(
		--	RECIBE EL DATO DE LA CAMARA
		data			=> capture_data,
		-- DIRECCION DE DONDE LEERA EL VGA
		rdaddress	=> frame_addr,
		-- RELOJ DE LECTURA DEL VGA
		rdclock		=> clk50,
		-- DIRECCION DE ESCRITURA DE LA CAMARA A LA RAM
		wraddress	=> capture_addr,
		-- RELOJ DE ESCRITURA A LA RAM
		wrclock		=> OV7670_PCLK,
		-- ENABLE DE ESCRITURA 
		wren			=> capture_we,
		-- DATO QUE LEE EL VGA DESDE LA RAM
		q				=> frame_pixel
		);
		
		led <= "0000000" & config_finished;
  
capture: ov7670_capture PORT MAP(
      pclk  => OV7670_PCLK,
      vsync => OV7670_VSYNC,
      href  => OV7670_HREF,
      d     => OV7670_D,
      addr  => capture_addr,
      dout  => capture_data,
      we    => capture_we
   );
  
controller: ov7670_controller PORT MAP(
      clk   => clk50,
      sioc  => ov7670_sioc,
      resend => resend,
      config_finished => config_finished,
      siod  => ov7670_siod,
      pwdn  => OV7670_PWDN,
      reset => OV7670_RESET,
      xclk  => OV7670_XCLK
   );


end Behavioral;