----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:00 03/01/2019 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
	Port(
		--Señales de control; reset y señal de reloj.
		clk:		in		std_logic;
		reset:	in		std_logic;
		--Push boton para el conteo.
		cont_up:	in		std_logic;
		--Salidas para el control de los Display's.
		Enable:	out	std_logic_vector(2 downto 0);
		Display: out 	std_logic_vector(7 downto 0)
	);
end main;

architecture Behavioral of main is

signal bus_clk:	std_logic;
signal bus_reset:	std_logic;

signal bus_enable:	std_logic_vector(2 downto 0);
signal bus_display:	std_logic_vector(7 downto 0);
signal bus_display1:	integer range 0 to 9;
signal bus_display2: integer range 0 to 9;
signal bus_display3: integer range 0 to 9;

signal conteo: integer range 0 to 12000000;
signal flag:	std_logic;

signal unidades:	integer range 0 to 9;
signal decenas:	integer range 0 to 9;
signal centenas:	integer range 0 to 9;

component displays
	Port(
		clk:		in		std_logic;
		reset:	in		std_logic;
		
		enable:	out	std_logic_vector(2 downto 0);
		Display:	out	std_logic_vector(7 downto 0);
		
		Display1: in	integer range 0 to 9;
		Display2: in 	integer range 0 to 9;
		Display3: in 	integer range 0 to 9
	);
end component;

begin

	Inst_Displays: displays port map(
		clk => bus_clk,
		reset => bus_reset,
		enable => bus_enable,
		Display => bus_display,
		display1 => bus_display1,
		display2 => bus_display2,
		display3 => bus_display3
	);
	
	bus_clk <= clk;
	bus_reset <= reset;
	
	bus_display1 <= unidades;
	bus_display2 <= decenas;
	bus_display3 <= centenas;
	
	Enable <= bus_enable;
	Display <= bus_display;

	process(clk, reset)
		begin
		if(reset = '0') then
			conteo <= 0;
			unidades <= 0;
			decenas <= 0;
			centenas <= 0;
		elsif(rising_edge(clk)) then
			
			if(conteo = 1199999) then
				conteo <= 0;
				if(cont_up = '1') then
					flag <= '1';
				end if;
			else
				conteo <= conteo + 1;
			end if;
			
			if(cont_up = '0' and flag = '1') then
				flag <= '0';
				if(unidades <= 8) then
					unidades <= unidades + 1;
				else
					unidades <= 0;
					
					if(decenas <= 8) then
						decenas <= decenas + 1;
					else
						decenas <= 0;
						
						if(centenas <= 8) then
							centenas <= centenas + 1;
						else
							unidades <= 0;
							decenas <= 0;
							centenas <= 0;
						end if;
					end if;
				end if;
			end if;
			
			
		end if;
	end process;




end Behavioral;

