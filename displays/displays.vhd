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
				if(estado_enable = "110") then
					estado_enable <= "101";
					estado_display <= display2;
				elsif(estado_enable = "101") then
					estado_enable <= "011";
					estado_display <= display3;
				elsif(estado_enable = "011") then
					estado_enable <= "110";
					estado_display <= display1;
				else
					estado_enable <= "110";
				end if;
			else
				cont_multiplexacion <= cont_multiplexacion + 1;
			end if;
			
			
			case estado_display is
				 when 0 => 
					Display <= "11000000";
				 when 1 => 
					Display <= "11111001";
				 when 2 => 
					Display <= "10100100";
				 when 3 => 
					Display <= "10110000";
				 when 4 => 
					Display <= "10011001";
				 when 5 => 
					Display <= "10010010";
				 when 6 => 
					Display <= "10000010";
				 when 7 => 
					Display <= "11111000";
				 when 8 => 
					Display <= "10000000";
				 when 9 => 
					Display <= "10011000";
				 when others => 
					Display <= "11111111";
			end case;
			
		end if;
	
	end process;

end Behavioral;

