
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity Proyecto is
    Port ( CLK: in  STD_LOGIC;
			  INI: in  STD_LOGIC;
			  RESET: in  STD_LOGIC;
           DISPLAY : out  STD_LOGIC_VECTOR(6 DOWNTO 0);
			  MUX: out STD_LOGIC_VECTOR(1 DOWNTO 0)
);
end Proyecto;
architecture Behavioral of Proyecto is
type MAQUINA is (UNIDADES, DECENAS);
signal EDO_P,EDO_F : MAQUINA := UNIDADES;

constant CONTA_RETRASO_FIN : integer := 49_999_999;
constant CONTA_SW_FIN : integer := 499_999;

signal CONTA_UNIDADES, CONTA_DECENAS : integer range 0 to 9 :=0;
signal CONTA_RETRASO: integer range 0 to CONTA_RETRASO_FIN:=0;
signal CONTA_SWITCH: integer range 0 to CONTA_SW_FIN:=0;
signal CONTADOR_PRINCIPAL: integer range 0 to 9:=0;

begin
process(CLK)
begin
	if RISING_EDGE(CLK) then
		if RESET = '1' then
			CONTA_UNIDADES <=0;
			CONTA_DECENAS <=0;
			CONTA_RETRASO <=0;
		else
			if INI = '1' then
				CONTA_RETRASO <= CONTA_RETRASO + 1;
				if CONTA_RETRASO = CONTA_RETRASO_FIN then
					CONTA_RETRASO <=0;
					CONTA_UNIDADES <= CONTA_UNIDADES +1;
						if CONTA_UNIDADES = 9 then
							CONTA_UNIDADES <= 0;
							CONTA_DECENAS <= CONTA_DECENAS +1;
							 if CONTA_DECENAS = 9 then
								CONTA_DECENAS <=0;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end process;
				
process (EDO_P)
begin
	CASE EDO_P IS
	WHEN UNIDADES =>
		EDO_F<= DECENAS;
		MUX <="01";
	WHEN DECENAS =>
		EDO_F<= UNIDADES;
		MUX <="10";
	WHEN OTHERS => NULL;
	END CASE;
end process;

process (CLK)
begin
	 if RISING_EDGE(CLK) then
		CONTA_SWITCH <= CONTA_SWITCH +1;
		if CONTA_SWITCH = CONTA_SW_FIN then
			CONTA_SWITCH <=0;
			EDO_P <= EDO_F;
			end if;
		end if;
end process;
			
CONTADOR_PRINCIPAL <= CONTA_UNIDADES WHEN EDO_P = UNIDADES ELSE 
							 CONTA_DECENAS;
			
DISPLAY <= "1000000" WHEN CONTADOR_PRINCIPAL = 0 ELSE
	  		  "1111001" WHEN CONTADOR_PRINCIPAL = 1 ELSE					  
			  "0100100" WHEN CONTADOR_PRINCIPAL = 2 ELSE
			  "0110000" WHEN CONTADOR_PRINCIPAL = 3 ELSE
			  "0011001" WHEN CONTADOR_PRINCIPAL = 4 ELSE
			  "0010010" WHEN CONTADOR_PRINCIPAL = 5 ELSE
			  "0000010" WHEN CONTADOR_PRINCIPAL = 6 ELSE
			  "1111000" WHEN CONTADOR_PRINCIPAL = 7 ELSE
			  "0000000" WHEN CONTADOR_PRINCIPAL = 8 ELSE
		     "0010000";
end Behavioral;

--DISPLAY <= "0000001" WHEN CONTADOR_PRINCIPAL = 0 ELSE
--	  		  "1001111" WHEN CONTADOR_PRINCIPAL = 1 ELSE					  
--			  "0010010" WHEN CONTADOR_PRINCIPAL = 2 ELSE
--			  "0000110" WHEN CONTADOR_PRINCIPAL = 3 ELSE
--			  "1001100" WHEN CONTADOR_PRINCIPAL = 4 ELSE
--			  "0100100" WHEN CONTADOR_PRINCIPAL = 5 ELSE
--			  "0100000" WHEN CONTADOR_PRINCIPAL = 6 ELSE
--			  "0001111" WHEN CONTADOR_PRINCIPAL = 7 ELSE
--			  "0000000" WHEN CONTADOR_PRINCIPAL = 8 ELSE
--		     "0000100";#