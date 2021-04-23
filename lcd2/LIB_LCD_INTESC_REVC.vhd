----------------------------------------------------------------------------------
-- COPYRIGHT 2015 Jes�s Eduardo M�ndez Rosales
--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License
--along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
--
--							LIBRER�A LCD
--
-- Descripci�n: Con �sta librer�a podr�s implementar c�digos para una LCD 16x2 de manera
-- f�cil y r�pida, con todas las ventajas de utilizar una FPGA.
--
-- Caracter�sticas:
-- 
--	Los comandos que puedes utilizar son los siguientes:
--
-- LCD_INI() -> Inicializa la lcd.
--		 			 NOTA: Dentro de los par�ntesis poner un vector de 2 bits para encender o apagar
--					 		 el cursor y activar o desactivar el parpadeo.
--
--		"1x" -- Cursor ON
--		"0x" -- Cursor OFF
--		"x1" -- Parpadeo ON
--		"x0" -- Parpadeo OFF
--
--   Por ejemplo: LCD_INI("10") -- Inicializar LCD con cursor encendido y sin parpadeo 
--	
--			
-- CHAR() -> Manda una letra may�scula o min�scula
--
--				 IMPORTANTE: 1) Debido a que VHDL no es sensible a may�sculas y min�sculas, si se quiere
--								    escribir una letra may�scula se debe escribir una "M" antes de la letra.
--								 2) Si se quiere escribir la letra "S" may�scula, se declara "MAS"
--											
-- 	Por ejemplo: CHAR(A)  -- Escribe en la LCD la letra "a"
--						 CHAR(MA) -- Escribe en la LCD la letra "A"	
--						 CHAR(S)	 -- Escribe en la LCD la letra "s"
--						 CHAR(MAS)	 -- Escribe en la LCD la letra "S"	
--	
--
-- POS() -> Escribir en la posici�n que se indique.
--				NOTA: Dentro de los par�ntesis se dene poner la posici�n de la LCD a la que se quiere ir, empezando
--						por el rengl�n seguido de la posici�n vertical, ambos n�meros separados por una coma.
--		
--		Por ejemplo: POS(1,2) -- Manda cursor al rengl�n 1, poscici�n 2
--						 POS(2,4) -- Manda cursor al rengl�n 2, poscici�n 4		
--
--
-- CHAR_ASCII() -> Escribe un caracter a partir de su c�digo en ASCII
--						 NOTA: Dentro de los parentesis escribir x"(n�mero hex.)"
--
--		Por ejemplo: CHAR_ASCII(x"40") -- Escribe en la LCD el caracter "@"
--
--
-- CODIGO_FIN() -> Finaliza el c�digo. 
--						 NOTA: Dentro de los par�ntesis poner cualquier n�mero: 1,2,3,4...,8,9.
--
--
-- BUCLE_INI() -> Indica el inicio de un bucle. 
--						NOTA: Dentro de los par�ntesis poner cualquier n�mero: 1,2,3,4...,8,9.
--
--
-- BUCLE_FIN() -> Indica el final del bucle.
--						NOTA: Dentro de los par�ntesis poner cualquier n�mero: 1,2,3,4...,8,9.
--
--
-- INT_NUM() -> Escribe en la LCD un n�mero entero.
--					 NOTA: Dentro de los par�ntesis poner s�lo un n�mero que vaya del 0 al 9,
--						    si se quiere escribir otro n�mero entero se tiene que volver
--							 a llamar la funci�n
--
--
-- CREAR_CHAR() -> Funci�n que crea el caracter dise�ado previamente en "CARACTERES_ESPECIALES.vhd"
--                 NOTA: Dentro de los par�ntesis poner el nombre del caracter dibujado (CHAR1,CHAR2,CHAR3,..,CHAR8)
--								 
--
-- CHAR_CREADO() -> Escribe en la LCD el caracter creado por medio de la funci�n "CREAR_CHAR()"
--						  NOTA: Dentro de los par�ntesis poner el nombre del caracter creado.
--
--     Por ejemplo: 
--
--				Dentro de CARACTERES_ESPECIALES.vhd se dibujan los caracteres personalizados utilizando los vectores 
--				"CHAR_1", "CHAR_2","CHAR_3",...,"CHAR_7","CHAR_8"
--
--								 1 => [#] - Se activa el pixel de la matr�z.
--                       0 => [ ] - Se desactiva el pixel de la matriz.
--
-- 			Si se quiere crear el				Entonces CHAR_1 queda de la siguiente
--				siguiente caracter:					manera:
--												
--				  1  2  3  4  5						CHAR_1 <=
--  		  1 [ ][ ][ ][ ][ ]							"00000"&			
-- 		  2 [ ][ ][ ][ ][ ]							"00000"&			  
-- 		  3 [ ][#][ ][#][ ]							"01010"&   		  
-- 		  4 [ ][ ][ ][ ][ ]		=====>			"00000"&			   
-- 		  5 [#][ ][ ][ ][#]							"10001"&          
-- 		  6 [ ][#][#][#][ ]							"01110"&			  
-- 		  7 [ ][ ][ ][ ][ ]							"00000"&			  
-- 		  8 [ ][ ][ ][ ][ ]							"00000";			
--
--		
--			Como el caracter se cre� en el vector "CHAR_1",entonces se escribe en las funci�nes como "CHAR1"
--			
--			CREAR_CHAR(CHAR1)  -- Crea el caracter personalizado (CHAR1)
--			CHAR_CREADO(CHAR1) -- Muestra en la LCD el caracter creado (CHAR1)		
--
-- 
--
-- LIMPIAR_PANTALLA() -> Manda a limpiar la LCD.
--								 NOTA: �sta funci�n se activa poniendo dentro de los par�ntesis
--										 un '1' y se desactiva con un '0'. 
--
--		Por ejemplo: LIMPIAR_PANTALLA('1') -- Limpiar pantalla est� activado.
--						 LIMPIAR_PANTALLA('0') -- Limpiar pantalla est� desactivado.
--
--
--	Con los puertos de entrada "CORD" y "CORI" se hacen corrimientos a la derecha y a la
--	izquierda respectivamente. NOTA: La velocidad del corrimiento se puede cambiar 
-- modificando la variable "DELAY_COR".
--
-- Algunas funci�nes generan un vector ("BLCD") cuando se termin� de ejecutar dicha funci�n y
--	que puede ser utilizado como una bandera, el vector solo dura un ciclo de instruccion.
--	   
--		LCD_INI() ---------- BLCD <= x"01"
--		CHAR() ------------- BLCD <= x"02"
--		POS() -------------- BLCD <= x"03"
--	   CHAR_ASCII() ------- BLCD <= x"05"
-- 	INT_NUM() ---------- BLCD <= x"05"
--	   BUCLE_INI() -------- BLCD <= x"06"
--		BUCLE_FIN() -------- BLCD <= x"07"
--		LIMPIAR_PANTALLA() - BLCD <= x"08"
--	   CREAR_CHAR() ------- BLCD <= x"09"
--	 	CHAR_CREADO() ------ BLCD <= x"0A"
--
--
--		�IMPORTANTE!
--
--		Cada funci�n se acompa�a con " INSTRUCCION(NUM) <= (FUNCI�N) " como lo muestra el siguiente c�digo
-- 	demostrativo.
--
--
--                C�DIGO DEMOSTRATIVO
--
-- INSTRUCCION(0) <= LCD_INI("11"); --INICIALIZAMOS LCD, CURSOR A HOME, CURSOR ON, PARPADEO ON.
-- INSTRUCCION(1) <= POS(1,1);--------EMPEZAMOS A ESCRIBIR EN LA LINEA 1, POSICI�N 1
-- INSTRUCCION(2) <= CHAR(MH);--------ESCRIBIMOS EN LA LCD LA LETRA "h" MAYUSCULA
-- INSTRUCCION(3) <= CHAR(O);			
-- INSTRUCCION(4) <= CHAR(L);
-- INSTRUCCION(5) <= CHAR(A);
-- INSTRUCCION(6) <= CHAR_ASCII(x"21");--ESCRIBIMOS EL CARACTER "!"
-- INSTRUCCION(7) <= CODIGO_FIN(1);-----------FINALIZAMOS EL CODIGO
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
USE WORK.COMANDOS_LCD_REVC.ALL;

entity LIB_LCD_INTESC_REVC is


PORT(CLK: IN STD_LOGIC;

-------------------------------------------------------
-------------PUERTOS DE LA LCD (NO BORRAR)-------------
	  RS : OUT STD_LOGIC;									  --
	  RW : OUT STD_LOGIC;									  --
	  ENA : OUT STD_LOGIC;									  --
	  CORD : IN STD_LOGIC;									  --
	  CORI : IN STD_LOGIC;									  --
	  DATA_LCD: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);     --
	  BLCD :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ;    --
-------------------------------------------------------
	  
-----------------------------------------------------------
--------------ABAJO ESCRIBE TUS PUERTOS--------------------	
	
		reset:	in		std_logic;
		LD0 : out  STD_LOGIC;
		--Push boton para el conteo.
		cont_up:	in		std_logic
	
	
	
-----------------------------------------------------------
	  );



end LIB_LCD_INTESC_REVC;

architecture Behavioral of LIB_LCD_INTESC_REVC is

-----------------------------------------------------------------
---------------SE�ALES DE LA LCD (NO BORRAR)---------------------
TYPE RAM IS ARRAY (0 TO  60) OF STD_LOGIC_VECTOR(8 DOWNTO 0);  --
																					--
SIGNAL INSTRUCCION : RAM;													--
																					--
COMPONENT PROCESADOR_LCD_REVC is											--
																					--
PORT(CLK : IN STD_LOGIC;													--
	  VECTOR_MEM : IN STD_LOGIC_VECTOR(8 DOWNTO 0);					--
	  INC_DIR : OUT INTEGER RANGE 0 TO 1024;							--
	  CORD : IN STD_LOGIC;													--
	  CORI : IN STD_LOGIC;													--
	  RS : OUT STD_LOGIC;													--
	  RW : OUT STD_LOGIC;													--
	  DELAY_COR : IN INTEGER RANGE 0 TO 1000;							--
	  BD_LCD : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);			         --
	  ENA  : OUT STD_LOGIC;													--
	  C1A,C2A,C3A,C4A : IN STD_LOGIC_VECTOR(39 DOWNTO 0);       --
	  C5A,C6A,C7A,C8A : IN STD_LOGIC_VECTOR(39 DOWNTO 0);       --
	  DATA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)							--
		);																			--
																					--
end  COMPONENT PROCESADOR_LCD_REVC;										--
																					--
COMPONENT CARACTERES_ESPECIALES_REVC is										--
																					--
PORT( C1,C2,C3,C4:OUT STD_LOGIC_VECTOR(39 DOWNTO 0);				--
		C5,C6,C7,C8:OUT STD_LOGIC_VECTOR(39 DOWNTO 0);				--
		CLK : IN STD_LOGIC													--
		);																			--
																					--
end COMPONENT CARACTERES_ESPECIALES_REVC;									--
																					--
CONSTANT CHAR1 : INTEGER := 1;											--
CONSTANT CHAR2 : INTEGER := 2;											--
CONSTANT CHAR3 : INTEGER := 3;											--
CONSTANT CHAR4 : INTEGER := 4;											--
CONSTANT CHAR5 : INTEGER := 5;											--
CONSTANT CHAR6 : INTEGER := 6;											--
CONSTANT CHAR7 : INTEGER := 7;											--
CONSTANT CHAR8 : INTEGER := 8;											--
																					--
																					--
SIGNAL DIR : INTEGER RANGE 0 TO 1024 := 0;							--
SIGNAL VECTOR_MEM_S : STD_LOGIC_VECTOR(8 DOWNTO 0);				--
SIGNAL RS_S, RW_S, E_S : STD_LOGIC;										--
SIGNAL DATA_S : STD_LOGIC_VECTOR(7 DOWNTO 0);						--
SIGNAL DIR_S : INTEGER RANGE 0 TO 1024;								--
SIGNAL DELAY_COR : INTEGER RANGE 0 TO 1000;							--
SIGNAL C1S,C2S,C3S,C4S : STD_LOGIC_VECTOR(39 DOWNTO 0);	      --
SIGNAL C5S,C6S,C7S,C8S : STD_LOGIC_VECTOR(39 DOWNTO 0);  	   --
																					--
-----------------------------------------------------------------
-----------------------------------------------------------------


---------------------------------------------------------
--------------AGREGA TUS SE�ALES AQU�--------------------
signal cuenta: natural range 0 to 2**24-1;
constant fincuenta : natural:=12000000;
signal ledaux: std_logic;

signal conteo: integer range 0 to 12000000;
signal flag:	std_logic;

signal unidades:	integer range 0 to 9;
signal decenas:	integer range 0 to 9;
signal centenas:	integer range 0 to 9;

signal u:	integer range 0 to 9;
signal d:	integer range 0 to 9;
signal c:	integer range 0 to 9;
signal u22:	integer range 0 to 9;
signal d22:	integer range 0 to 9;
signal c22:	integer range 0 to 9;


signal dato1:	integer range 0 to 9;
signal dato2:	integer range 0 to 9;

---------------------------------------------------------

begin


-----------------------------------------------------------
------------COMPONENTES PARA LCD (NO BORRAR)---------------
U1 : PROCESADOR_LCD_REVC PORT MAP(CLK  => CLK,				--
									 VECTOR_MEM => VECTOR_MEM_S,	--
									 RS  => RS_S,						--
									 RW  => RW_S,						--
									 ENA => E_S,						--
									 INC_DIR => DIR_S,				--
									 DELAY_COR => DELAY_COR,		--
									 BD_LCD => BLCD,					--
									 CORD => CORD,						--
									 CORI => CORI,						--
									 C1A =>C1S,  					   --	
									 C2A =>C2S,							--
									 C3A =>C3S,							--
									 C4A =>C4S,							--
									 C5A =>C5S,							--
									 C6A =>C6S,							--
									 C7A =>C7S,							--
									 C8A =>C8S,							--
									 DATA  => DATA_S );				--
																			--
U2 : CARACTERES_ESPECIALES_REVC PORT MAP(C1 =>C1S,			--	
									C2 =>C2S,							--
									C3 =>C3S,							--
									C4 =>C4S,							--
									C5 =>C5S,							--
									C6 =>C6S,							--
									C7 =>C7S,						   --
									C8 =>C8S,							--
									CLK => CLK							--
									);										--
																			--
DIR <= DIR_S;															--
VECTOR_MEM_S <= INSTRUCCION(DIR);								--
																			--
RS <= RS_S;																--
RW <= RW_S;																--
ENA <= E_S;																--
DATA_LCD <= DATA_S;													--
-----------------------------------------------------------


DELAY_COR <= 500; --Modificar esta variable para la velocidad del corrimiento.

-------------------------------------------------------------------
-----------------ABAJO ESCRIBE TU C�DIGO EN VHDL-------------------

process(clk, reset)
		begin	
	IF RISING_EDGE(CLK) THEN		
		
		if(reset = '0') then
			conteo <= 0;
			unidades <= 0;
			decenas <= 0;
			centenas <= 0;
			cuenta<=0;
			ledaux<='0';
				else
				if(cont_up = '0') then
			   flag <= '1';
				end if;
		   	if(cont_up = '1' and flag = '1') then
				flag <= '0';
				

				if(u <= 8) then
					u <= u + 1;
				else
					u <= 0;
					if(d <= 8) then
						d <= d + 1;
					else
						d <= 0;
						
						if(c <= 8) then
							c <= c + 1;
						else
							u <= 0;
							d <= 0;
							c <= 0;
						end if;
				end if;
		end if;
				
							
				
				if conteo = 999 then
				conteo <=0;
				else 
				conteo <= conteo+1;
				end if;
				end if;
		end if;
		
		   if cuenta = (fincuenta -1)/2 then
			dato1<=conteo;
			u22 <= u;
			d22 <= d;
			c22 <= c;
			end if;
			
			if cuenta = fincuenta-1 then
			dato2<=conteo-dato1;
			unidades <=u;
			decenas <=d;
			centenas <=c;
			cuenta<=0;
			ledaux<=not ledaux;
			conteo <= 0;
			
         u<=0;
			d<=0;
			c<=0;
			else
				cuenta<=cuenta + 1;
			end if;		
		END IF;	
	end process;
	LD0<=ledaux;

-------------------------------------------------------------------



-----------------------------------------------------------------------------------------
-------------------------ABAJO ESCRIBE TU C�DIGO PARA LA LCD-----------------------------

INSTRUCCION (0) <= LCD_INI("00");
INSTRUCCION (1) <= CHAR_ASCII(x"46");
INSTRUCCION (2) <= CHAR_ASCII(x"72");
INSTRUCCION (3) <= CHAR_ASCII(x"65");
INSTRUCCION (4) <= CHAR_ASCII(x"63");
INSTRUCCION (5) <= CHAR_ASCII(x"75");
INSTRUCCION (6) <= CHAR_ASCII(x"65");
INSTRUCCION (7) <= CHAR_ASCII(x"6E");
INSTRUCCION (8) <= CHAR_ASCII(x"63");
INSTRUCCION (9) <= CHAR_ASCII(x"69");
INSTRUCCION (10) <= CHAR_ASCII(x"61");
INSTRUCCION (11) <= CHAR_ASCII(x"3A");

INSTRUCCION (12) <= BUCLE_INI(1) ;


INSTRUCCION (13) <= POS(2,4);
INSTRUCCION (14) <= INT_NUM(CENTENAS);

INSTRUCCION (15) <= POS(2,6);
INSTRUCCION (16) <= INT_NUM(DECENAS);

INSTRUCCION (17) <= POS(2,8);
INSTRUCCION (18) <= INT_NUM(UNIDADES);



INSTRUCCION (19) <= BUCLE_FIN(1);

INSTRUCCION (20) <= CODIGO_FIN(1);


-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------


end Behavioral;

