----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:32:23 03/01/2019 
-- Design Name: 
-- Module Name:    displays - Behavioral 
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

entity displays is
	Port(
		clk:		in		std_logic;
		reset:	in		std_logic;
		
		enable:	out	std_logic_vector(2 downto 0);
		Display:	out	std_logic_vector(7 downto 0);
		
		Display1: in	integer range 0 to 9;
		Display2: in 	integer range 0 to 9;
		Display3: in 	integer range 0 to 9
	);
end displays;

architecture Behavioral of displays is

signal cont_multiplexacion:	integer range 0 to 12000000;
signal estado_enable:	std_logic_vector(2 downto 0);
signal estado_display:	integer range 0 to 9;

begin
	
	enable <= estado_enable;
	
		process(clk, reset)
		begin
		
		if(reset = '0') then
			estado_enable <= "111";
			cont_multiplexacion <= 0;
		elsif(rising_edge(clk)) then
			
			if(cont_multiplexacion = 12000) then
				cont_multiplexacion <= 0;
				if(estado_enable = "001") then
					estado_enable <= "010";
					estado_display <= display2;
				elsif(estado_enable = "010") then
					estado_enable <= "100";
					estado_display <= display3;
				elsif(estado_enable = "100") then
					estado_enable <= "001";
					estado_display <= display1;
				else
					estado_enable <= "001";
				end if;
			else
				cont_multiplexacion <= cont_multiplexacion + 1;
			end if;
			
			
			case estado_display is
				 when 0 => 
					Display <= "00111111";
				 when 1 => 
					Display <= "00000110";
				 when 2 => 
					Display <= "01011011";
				 when 3 => 
					Display <= "01001111";
				 when 4 => 
					Display <= "01100110";
				 when 5 => 
					Display <= "01101101";
				 when 6 => 
					Display <= "01111101";
				 when 7 => 
					Display <= "00000111";
				 when 8 => 
					Display <= "01111111";
				 when 9 => 
					Display <= "01100111";
				 when others => 
					Display <= "00000000";
			end case;
			
		end if;
	
	end process;

end Behavioral;

