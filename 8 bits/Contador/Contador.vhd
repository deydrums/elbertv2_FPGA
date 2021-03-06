-- Se puede cambiar el tiempo del conteo modificando la constante DELAY_FIN
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity CONTA_8_BITS is

PORT( CLK 	: IN STD_LOGIC;-----------------------RELOJ FPGA A 12MHZ
		INI 	: IN STD_LOGIC;-----------------------BIT DE INICIO/PARO DEL CONTEO
		RESET : IN STD_LOGIC;-----------------------BIT DE RESETEO
		LED 	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);----SALIDA CONECTADA A LOS LEDS
		
		
		INI2 	: IN STD_LOGIC;
		RESET2 : IN STD_LOGIC;
		LED2 	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);

end CONTA_8_BITS;

architecture Behavioral of CONTA_8_BITS is

CONSTANT DELAY_FIN : INTEGER := 4_999_999;---------CONSTANTE PARA UN RETRASO DE 100mS
CONSTANT DELAY_FIN2 : INTEGER := 1_999_999;


SIGNAL DELAY : INTEGER RANGE 0 TO DELAY_FIN := 0;---SE?AL ENTERA PARA EL RETRASO
SIGNAL CONTADOR : INTEGER RANGE 0 TO 15 :=0;-------SE?AL ENTERA PARA EL CONTEO

SIGNAL DELAY2 : INTEGER RANGE 0 TO DELAY_FIN2 := 0;---SE?AL ENTERA PARA EL RETRASO
SIGNAL CONTADOR2 : INTEGER RANGE 0 TO 15 :=15;-------SE?AL ENTERA PARA EL CONTEO


begin

------PROCESO QUE SE ENCARGA DEL CONTEO---------
------------------------------------------------
PROCESS(CLK)
BEGIN
	IF RISING_EDGE(CLK) THEN
		IF RESET = '0' THEN
			CONTADOR <= 0;
			DELAY <= 0;
		ELSE
			IF INI = '0' THEN
				DELAY <= DELAY +1;
					IF DELAY = DELAY_FIN THEN
						DELAY <= 0;
						CONTADOR <= CONTADOR +1;
							IF CONTADOR = 15 THEN
								CONTADOR <= 0;
							END IF;
					END IF;
			ELSE
				DELAY <= 0;
			END IF;
		END IF;
	END IF;
END PROCESS;
------------------------------------------------


PROCESS(CLK)
BEGIN
	IF RISING_EDGE(CLK) THEN
		IF RESET2 = '0' THEN
			CONTADOR2 <= 15;
			DELAY2 <= 0;
		ELSE
			IF INI2 = '0' THEN
				DELAY2 <= DELAY2 +1;
					IF DELAY2 = DELAY_FIN2 THEN
						DELAY2 <= 0;
						CONTADOR2 <= CONTADOR2 -1;
							IF CONTADOR2 = 0 THEN
								CONTADOR2 <= 15;
							END IF;
					END IF;
			ELSE
				DELAY2 <= 0;
			END IF;
		END IF;
	END IF;
END PROCESS;











LED <= CONV_STD_LOGIC_VECTOR(CONTADOR, 8);---FUNCI?N QUE SE ENCARGA DE CONVERTIR AL ENTERO "CONTADOR" EN UN VECTOR
														---DE 8 BITS
LED2 <= CONV_STD_LOGIC_VECTOR(CONTADOR2, 8);
end Behavioral;
