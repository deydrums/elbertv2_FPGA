library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
			

entity main is

Port(
		--Señales de control; reset y señal de reloj.
		clk 	: in std_logic;-----------------------RELOJ FPGA (12MHZ)
		numero:	in		std_logic_vector(3 downto 0);
	   numero2:	in		std_logic_vector(3 downto 0);
	   operacion:	in		std_logic_vector(3 downto 0);
		salida: out 	std_logic_vector(7 downto 0)
	);
end main;

architecture Behavioral of main is

signal suma, resta, multiplicacion: integer := 0;
begin

process (clk)
	begin

        case (operacion) is
            when "1110" => 
					suma <= conv_integer(std_logic_vector(numero)) + conv_integer(std_logic_vector(numero2));
					salida <= conv_std_logic_vector(suma, 8);
            when "1101" => 
					resta <= conv_integer(std_logic_vector(numero)) - conv_integer(std_logic_vector(numero2));
					salida <= conv_std_logic_vector(resta, 8);
            when "1011" =>  
					multiplicacion <= conv_integer(std_logic_vector(numero)) * conv_integer(std_logic_vector(numero2));	
					salida <= conv_std_logic_vector(multiplicacion, 8);					
            when "0111" => 
				   if numero = numero2 then
						salida <= "11111111";
					elsif numero /= numero2 then
						salida <= "00000000";
					end if;
            when others => salida <= "00000000";
        end case;


				


--suma <= CONV_INTEGER (std_logic_vector(numero)) + CONV_INTEGER (std_logic_vector(numero2));
--salida <= conv_std_logic_vector(suma, 8);


   --if numero = numero2 then
    --  salida <= "00000000";
  -- elsif numero /= numero2 then
  --    salida <= "11111111";
 --  end if;
			

end process;

end Behavioral;

