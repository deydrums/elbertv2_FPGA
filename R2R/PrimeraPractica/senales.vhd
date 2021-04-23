
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

---------------------------------------------------ENTRADAS Y SALIDAS---------------------------------------------------------
entity senales is
Port(
	clk:			in		std_logic;
	swt1:			in		std_logic;
	swt2:       in    std_logic;
	salida2:		out   std_logic;
	salida:		out	std_logic_vector(7 downto 0)
	
	);
end senales;
-------------------------------------------------------SEÑALES-----------------------------------------------------------------

architecture Behavioral of senales is
signal contador: integer range 0 to 4165;
signal contador2: integer range 0 to 47;

	signal cont: integer range 0 to 99999 :=0;
	signal temporal: std_logic;


begin
-----------------------------------------------------SEÑAL SENOIDAL-------------------------------------------------------------
 process(clk,contador)
	begin
	
if clk'event and clk='1' then
	if contador = 4165 then
		contador <=0;
		if contador2 = 47 then
			contador2<= 0;
		else
			contador2 <= contador2+1;
		end if;
	else
		contador <= contador +1;
	end if;

if (swt1 ='0') then
case contador2 is
	when 0 => salida <= "10000000";
	when 1 => salida <= "10010010";
	when 2 => salida <= "10100101";
	when 3 => salida <= "10110000";
	when 4 => salida <= "11000001";
	when 5 => salida <= "11010001";
	when 6 => salida <= "11011010";
	when 7 => salida <= "11100110";
	when 8 => salida <= "11110000";
	when 9 => salida <= "11110110";
	when 10 => salida <= "11111100";
	when 11 => salida <= "11111111";
	when 12 => salida <= "11111111";
	when 13 => salida <= "11111110";
	when 14 => salida <= "11111010";
	when 15 => salida <= "11110110";
	when 16 => salida <= "11101101";
	when 17 => salida <= "11100010";
	when 18 => salida <= "11011010";
	when 19 => salida <= "11001100";
	when 20 => salida <= "10111100";
	when 21 => salida <= "10110000";
	when 22 => salida <= "10011111";
	when 23 => salida <= "10001100";
	when 24 => salida <= "10000000";
	when 25 => salida <= "01101101";
	when 26 => salida <= "01011010";
	when 27 => salida <= "01001111";
	when 28 => salida <= "00111110";
	when 29 => salida <= "00101110";
	when 30 => salida <= "00100101";
	when 31 => salida <= "00011001";
	when 32 => salida <= "00001111";
	when 33 => salida <= "00001001";
	when 34 => salida <= "00000011";
	when 35 => salida <= "00000000";
	when 36 => salida <= "00000000";
	when 37 => salida <= "00000001";
	when 38 => salida <= "00000101";
	when 39 => salida <= "00001001";
	when 40 => salida <= "00010010";
	when 41 => salida <= "00011101";
	when 42 => salida <= "00100101";
	when 43 => salida <= "00110011";
	when 44 => salida <= "01000011";
	when 45 => salida <= "01001111";
	when 46 => salida <= "01100000";
	when 47 => salida <= "01110011";
	when others => salida   <= "00000000";
end case;
		else
			salida<= "00000000";
		end if;
end if;
end process;

---------------------------------------------------------------SEÑAL CUADRADA----------------------------------------------------------
process (clk,swt2,temporal)
begin

if clk'event and clk='1' then
      if (cont = 99999) then
		cont <=0;
		temporal <=not(temporal);
   else
      cont <=cont+1;
   end if;
	end if;
	if (swt2='1') then
			temporal <='0';
				salida2 <=temporal;
	else 
				salida2 <=temporal;
end if;
end process;
end Behavioral;

