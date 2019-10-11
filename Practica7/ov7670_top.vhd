----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Top level for the OV7670 camera project.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ov7670_top is
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
      
      btn           : in    STD_LOGIC
    );
end ov7670_top;

architecture Behavioral of ov7670_top is

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

   COMPONENT frame_buffer
   PORT (
      rdclock  : IN  STD_LOGIC;
      wren   : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      rdaddress : IN  STD_LOGIC_VECTOR(14 DOWNTO 0);
      data  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      wrclock  : IN  STD_LOGIC;
      wraddress : IN  STD_LOGIC_VECTOR(14 DOWNTO 0);
      q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
   END COMPONENT;

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
      clk50 : IN std_logic;
      vga_red : OUT std_logic_vector(2 downto 0);
      vga_green : OUT std_logic_vector(2 downto 0);
      vga_blue : OUT std_logic_vector(2 downto 1);
      vga_hsync : OUT std_logic;
      vga_vsync : OUT std_logic;
      
      frame_addr : OUT std_logic_vector(14 downto 0);
      frame_pixel : IN std_logic_vector(7 downto 0)         
      );
   END COMPONENT;
   
   signal frame_addr  : std_logic_vector(14 downto 0);
   signal frame_pixel : std_logic_vector(7 downto 0);

   signal capture_addr  : std_logic_vector(14 downto 0);
   signal capture_data  : std_logic_vector(7 downto 0);
   signal capture_we    : std_logic_vector(0 downto 0);
   signal resend : std_logic;
   signal config_finished : std_logic;

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

fb : frame_buffer PORT MAP (
    rdclock  => OV7670_PCLK,
     wren   => capture_we,
    rdaddress => capture_addr,
    data  => capture_data,
    wrclock  => clk50,
    wraddress => frame_addr,
    q => frame_pixel
  );
  
  led <= "0000000" & config_finished;
capture: ov7670_capture PORT MAP(
      pclk  => OV7670_PCLK,
      vsync => OV7670_VSYNC,
      href  => OV7670_HREF,
      d     => OV7670_D,
      addr  => capture_addr,
      dout  => capture_data,
      we    => capture_we(0)
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