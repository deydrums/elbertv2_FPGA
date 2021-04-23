--LIBRERIAS A UTILIZAR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity Pov is
--DECLARACION DE PUERTOS
port( clk 	: in std_logic;-----------------------RELOJ FPGA (12MHZ)
		ini 	: in std_logic;-----------------------INICIO/PARO DE CONTEO
		sensorhall : in std_logic;------------------RESETEO POR SENSOR HALL
		POVFPGA 	: out std_logic_vector(7 downto 0);---SALIDA CONECTADA A LOS LEDS (CONTEO)
		pov 	: out std_logic_vector(11 downto 0);--SALIDA LEDS POV
		resetmaquina: in std_logic;-----------------RESET PARA LA MAQUINA DE ESTADOS	
		color : out std_logic_vector(2 downto 0)----SALIDA ENCARGADA DE SWITCHEAR LOS TRANSISTORES
		);
end Pov;

architecture Behavioral of Pov is
--CONSTANTES Y SEÑALES A UTILIZAR 
constant delay_fin : integer := 16000;--------------CONSTANTE PARA EL FIN DE DELAY DEL POV
signal delay : integer range 0 to delay_fin := 0;---DELAY PARA EL RETRASO DEL POV
signal contador : integer range 0 to 89 :=0;--------SEÑAL PARA MULTIPLEXACION DE MENSAJES


TYPE State_type IS (PRIMERO,SEGUNDO,TERCERO,CUARTO);-------MAQUINA DE ESTADOS PARA EL MUESTREO DE DIFERENTES MENSAJES
SIGNAL State : State_Type;
signal cuenta: natural range 0 to 12000000*40;------CONTADOR PARA CONTROLAR EL TIEMPO EN CADA ESTADO
constant fincuenta : natural:=12000000*40;----------CONSTANTE PARA EL FIN DEL TIEMPO DE CADA ESTADO

signal flag:	std_logic;---------------------------BANDERA PARA EN CONTEO DE VUELTAS/SEG
signal seg: natural range 0 to 2**24-1;-------------SEÑAL PARA EL CONTEO DE UN SEGUNDO
constant finseg : natural:=12000000;----------------CONSTANTE PARA EL FIN DEL CONTEO DE SEGUNDOS

signal un:	integer range 0 to 9;
signal dec:	integer range 0 to 9;
signal cen:	integer range 0 to 9;

signal ux:	integer range 0 to 9;
signal dx:	integer range 0 to 9;
signal cx:	integer range 0 to 9;

--_________________________________________________MEMORIA PARA TODAS LAS LETRAS Y NUMEROS__________________________________________--							 
Type memoria is array (0 to 4) of Std_Logic_Vector(11 downto 0);

   signal centenas: memoria;
   signal decenas: memoria;
   signal unidades: memoria;

   signal A: memoria:=("000000000000", 
						  	  "111111011110", 
							  "111111011110", 
							  "000000000000", 
							  "111111111111");
							  
   signal B: memoria:=("000000000000", 
						  	  "011111011110", 
							  "011111011110", 
							  "100000100001", 
							  "111111111111");
							  
   signal C: memoria:=("000000000000", 
						  	  "011111111110", 
							  "011111111110", 
							  "011111111110", 
							  "111111111111");
							  
   signal D: memoria:=("000000000000", 
						  	  "011111111110", 
							  "011111111110", 
							  "100000000001", 
							  "111111111111");	
							  
   signal E: memoria:=("000000000000", 
						  	  "011110011110", 
							  "011110011110", 
							  "011111111110", 
							  "111111111111");
							  
   signal F: memoria:=("000000000000", 
						  	  "111110111110", 
							  "111110111110", 
							  "111111111110", 
							  "111111111111");
							  
   signal G: memoria:=("000000000000", 
						  	  "011110111110", 
							  "011110111110", 
							  "000000111110", 
							  "111111111111");
							  
   signal H: memoria:=("000000000000", 
						  	  "111110111111", 
							  "111110111111", 
							  "000000000000", 
							  "111111111111");
							  
   signal I: memoria:=("011111111110", 
						  	  "000000000000", 
							  "000000000000", 
							  "011111111110", 
							  "111111111111");
							  
   signal J: memoria:=("111111111100", 
						  	  "001111111110", 
							  "011111111110", 
							  "000000000000", 
							  "111111111111");
							  
   signal K: memoria:=("000000000000", 
						  	  "111110111111", 
							  "111101011111", 
							  "000011100000", 
							  "111111111111");
							  
   signal L: memoria:=("000000000000", 
						  	  "011111111111", 
							  "011111111111", 
							  "011111111111", 
							  "111111111111");
							  
   signal M: memoria:=("000000000000", 
						  	  "111111111101", 
							  "111111111101", 
							  "000000000000", 
							  "111111111111");

   signal N: memoria:=("000000000000", 
						  	  "111111110011", 
							  "111111001111", 
							  "000000000000", 
							  "111111111111");

   signal O: memoria:=("000000000000", 
						  	  "011111111110", 
							  "011111111110", 
							  "000000000000", 
							  "111111111111");

   signal P: memoria:=("000000000000", 
						  	  "111111011110", 
							  "111111011110", 
							  "111111000000", 
							  "111111111111");

   signal Q: memoria:=("100000000000", 
						  	  "101111111110", 
							  "101111111110", 
							  "000000000000", 
							  "111111111111");

   signal R: memoria:=("000000000000", 
						  	  "111110101110", 
							  "111101011110", 
							  "000011000000", 
							  "111111111111");	

   signal S: memoria:=("011111000001", 
						  	  "011110111110", 
							  "011110111110", 
							  "100001111110", 
							  "111111111111");
  
   signal T: memoria:=("111111111110", 
						  	  "000000000000", 
							  "000000000000", 
							  "111111111110", 
							  "111111111111");
						  
   signal U: memoria:=("000000000000", 
						  	  "011111111111", 
							  "011111111111", 
							  "000000000000", 
							  "111111111111");
							  
   signal V: memoria:=("100000000000", 
						  	  "011111111111", 
							  "011111111111", 
							  "100000000000", 
							  "111111111111");
							  
   signal X: memoria:=("000011000000", 
						  	  "111110111111", 
							  "111101011111", 
							  "000011100000", 
							  "111111111111");							  
   signal ESPACIO:   memoria:=("111111111111", 
									    "111111111111", 
									    "111111111111", 
									    "111111111111", 
									    "111111111111");
									  
   signal DOSPUNTOS: memoria:=("111111111111", 
						  	          "110001110001", 
							          "110001110001", 
						         	 "111111111111", 
							          "111111111111");
							  
   signal cero: memoria:=("000000000000", 
						  	     "011111111110", 
							     "011111111110", 
							     "000000000000", 
							     "111111111111");
							  
   signal uno: memoria:=("011111111011", 
						  	    "011111111101", 
							    "000000000000", 
							    "011111111111", 
							    "111111111111");
							  
   signal dos: memoria:=("000000011110", 
						  	    "011111011110", 
							    "011111011110", 
							    "011111000000", 
							    "111111111111");

   signal tres: memoria:=("011111011110", 
						  	     "011111011110", 
							     "011111011110", 
							     "000000000000", 
							     "111111111111");

   signal cuatro: memoria:=("111111000000", 
						  	       "111111011111", 
							       "111111011111", 
							       "000000000000", 
							       "111111111111");

   signal cinco: memoria:=("011111000000", 
						  	      "011111011110", 
							      "011111011110", 
							      "000000011110", 
							      "111111111111");
									
	signal seis: memoria:=("000000000000", 
						  	     "011111011110", 
							     "011111011110", 
							     "000000011110", 
							     "111111111111");

	signal siete: memoria:=("111111111110", 
						  	      "111111011110", 
							      "111111011110", 
							      "000000000000", 
							      "111111111111");
									
	signal ocho: memoria:=("000000000000", 
						  	     "011111011110", 
							     "011111011110", 
							     "000000000000", 
							     "111111111111");

	signal nueve: memoria:=("111111000000", 
						  	      "111111011110", 
							      "111111011110", 
							      "000000000000", 
							      "111111111111");
						
begin
-----PROCESO PARA EL CONTEO------
process(clk,sensorhall,cuenta)
begin
	if rising_edge(clk) then
			if sensorhall = '0' and cuenta >= 12000000*10 and cuenta <=12000000*30 then
				color <="111";
				pov <= "111111111111";
				contador <= 0;
				delay <= 0;
					else
						if ini = '1' then
							delay <= delay +1;
								if delay = delay_fin then
									delay <= 0;
									contador <= contador +1;
										if contador = 89 then
											contador <= 0;
										end if;		
								end if;	
								
							else
								delay <= 0;	
						end if;
					end if;
							
							
				case cen is
					when 0      =>  centenas <= cero;
					when 1      =>  centenas <= uno;
					when 2      =>  centenas <= dos;
					when 3      =>  centenas <= tres;
					when 4      =>  centenas <= cuatro;
					when 5      =>  centenas <= cinco;
					when 6      =>  centenas <= seis;
					when 7      =>  centenas <= siete;
					when 8      =>  centenas <= ocho;
					when 9      =>  centenas <= nueve;
					when others =>  centenas <= cero;
				end case;

				case dec is
					when 0      =>  decenas <= cero;
					when 1      =>  decenas <= uno;
					when 2      =>  decenas <= dos;
					when 3      =>  decenas <= tres;
					when 4      =>  decenas <= cuatro;
					when 5      =>  decenas <= cinco;
					when 6      =>  decenas <= seis;
					when 7      =>  decenas <= siete;
					when 8      =>  decenas <= ocho;
					when 9      =>  decenas <= nueve;
					when others =>  decenas <= cero;
					end case;

				case un is
					when 0      =>  unidades <= cero;
					when 1      =>  unidades <= uno;
					when 2      =>  unidades <= dos;
					when 3      =>  unidades <= tres;
					when 4      =>  unidades <= cuatro;
					when 5      =>  unidades <= cinco;
					when 6      =>  unidades <= seis;
					when 7      =>  unidades <= siete;
					when 8      =>  unidades <= ocho;
					when 9      =>  unidades <= nueve;
					when others =>  unidades <= cero;
				end case;
----------------------------------------MAQUINA DE ESTADOS PARA EL MUESTRE DE MENSAJES--------------------------------------------
				Case State IS
------------------------------------------------------PRIMER MENSAJE--------------------------------------------------------------
					When PRIMERO =>
							if(sensorhall = '0') then			
								flag <= '1';    
									end if;
						
									if contador >= 50 and contador <= 64 then
										color <="110";
										else
											color <="101";
									end if;
								if(sensorhall = '1' and flag = '1') then
									flag <= '0';

									if(ux <= 8) then
										ux <= ux + 1;
										else
											ux <= 0;
											if(dx <= 8) then
												dx <= dx + 1;
												else
													dx <= 0;
													if(cx <= 8) then
														cx <= cx + 1;
														else
															ux <= 0;
															dx <= 0;
															cx <= 0;
													end if;
											end if;
								     end if;
								  end if;
				
												if seg = finseg-1 then
														if (cx <= 0) and (dx<=0) and (ux<=4) then
																	cen <=2;
																	dec <=4;
																	un <=0;
														else if (cx <= 0) and (dx<=0) and (ux<=6) then
																	cen <=3;
																	dec <=0;
																	un <=0;
														else if (cx <= 0) and (dx<=0) and (ux<=7) then
																	cen <=4;
																	dec <=2;
																	un <=0;
														else if (cx <= 0) and (dx<=0) and (ux<=8) then
																	cen <=4;
																	dec <=8;
																	un <=0;
														else if (cx <= 0) and (dx<=0) and (ux<=9) then
																	cen <=5;
																	dec <=4;
																	un <=0;
														else if (cx <= 0) and (dx<=1) and (ux<=0) then
																	cen <=6;
																	dec <=0;
																	un <=0;
														else if (cx <= 0) and (dx<=1) and (ux<=1) then
																	cen <=6;
																	dec <=6;
																	un <=0;
														else if (cx <= 0) and (dx<=1) and (ux<=2) then
																	cen <=7;
																	dec <=2;
																	un <=0;			
														end if;	
														end if;	
														end if;	
														end if;
														end if;	
														end if;	
														end if;	
														end if;				
														
														seg<=0;
														ux<=0;
														dx<=0;
														cx<=0;
												else
													seg<=seg + 1;
												end if;		

			case contador is
			when 0 to 4        =>  POV <= V(contador);
			when 5 to 9        =>  POV <= E(contador-5);
			when 10 to 14      =>  POV <= L(contador-10);
			when 15 to 19      =>  POV <= O(contador-15);
			when 20 to 24      =>  POV <= C(contador-20);
			when 25 to 29      =>  POV <= I(contador-25);
			when 30 to 34      =>  POV <= D(contador-30);
			when 35 to 39      =>  POV <= A(contador-35);
			when 40 to 44      =>  POV <= D(contador-40);
			when 45 to 49      =>  POV <= DOSPUNTOS(contador-45);
			when 50 to 54      =>  POV <= centenas (contador-50);
			when 55 to 59      =>  POV <= decenas(contador-55);
			when 60 to 64      =>  POV <= unidades(contador-60);
			when 65 to 69      =>  POV <= ESPACIO(contador-65);
			when 70 to 74      =>  POV <= R(contador-70);
			when 75 to 79      =>  POV <= P(contador-75);
			when 80 to 84      =>  POV <= M(contador-80);
         when 85 to 89      =>  POV <= ESPACIO(contador-85);
			when others =>  		  POV <= "111111111111";
			end case;

				if cuenta = 12000000*10 then
					State<=SEGUNDO;
				end if;
------------------------------------------------------SEGUNDO MENSAJE--------------------------------------------------------------

			When SEGUNDO=>
			if(sensorhall = '0') then			    
         color <="111";	
		   else 
			color <="101";
			end if;
							
			
					case contador is
			when 0 to 4        =>  POV <= L(contador);
			when 5 to 9        =>  POV <= A(contador-5);
			when 10 to 14      =>  POV <= B(contador-10);
			when 15 to 19      =>  POV <= ESPACIO(contador-15);
			when 20 to 24      =>  POV <= E(contador-20);
			when 25 to 29      =>  POV <= L(contador-25);
			when 30 to 34      =>  POV <= E(contador-30);
			when 35 to 39      =>  POV <= C(contador-35);
			when 40 to 44      =>  POV <= T(contador-40);
			when 45 to 49      =>  POV <= R(contador-45);
			when 50 to 54      =>  POV <= O(contador-50);
			when 55 to 59      =>  POV <= N(contador-55);
			when 60 to 64      =>  POV <= I(contador-60);
			when 65 to 69      =>  POV <= C(contador-65);
			when 70 to 74      =>  POV <= A(contador-70);
			when 75 to 79      =>  POV <= ESPACIO(contador-75);
			when 80 to 84      =>  POV <= TRES(contador-80);
	      when 85 to 89      =>  POV <= ESPACIO(contador-85);
			when others =>  		  POV <= "111111111111";
			end case;

				if cuenta = 12000000*20 then
					State<=TERCERO;
				end if;
		
------------------------------------------------------TERCER MENSAJE--------------------------------------------------------------

			When TERCERO=>
			if(sensorhall = '0') then			    
         color <="111";	
		   else 
			color <="011";
			end if;

				case contador is
			when 0 to 4        =>  POV <= P(contador);
			when 5 to 9        =>  POV <= R(contador-5);
			when 10 to 14      =>  POV <= I(contador-10);
			when 15 to 19      =>  POV <= M(contador-15);
			when 20 to 24      =>  POV <= E(contador-20);
			when 25 to 29      =>  POV <= R(contador-25);
			when 30 to 34      =>  POV <= ESPACIO(contador-30);
			when 35 to 39      =>  POV <= S(contador-35);
			when 40 to 44      =>  POV <= E(contador-40);
			when 45 to 49      =>  POV <= M(contador-45);
			when 50 to 54      =>  POV <= E(contador-50);
			when 55 to 59      =>  POV <= S(contador-55);
			when 60 to 64      =>  POV <= T(contador-60);
			when 65 to 69      =>  POV <= R(contador-65);
			when 70 to 74      =>  POV <= E(contador-70);
			when 75 to 79      =>  POV <= UNO(contador-75);
			when 80 to 84      =>  POV <= NUEVE(contador-80);
			when 85 to 89      =>  POV <= ESPACIO(contador-85);
			when others =>  		  POV <= "111111111111";
			end case;
				
				if cuenta = 12000000*30 then
					State<=CUARTO;
				end if;		

				
------------------------------------------------------CUARTO MENSAJE--------------------------------------------------------------
				
				
	When CUARTO=>
			if(sensorhall = '0') then			    
			color <="101";
		   else 
			color <="101";
			end if;

				case contador is
			when 0 to 4        =>  POV <= E(contador);
			when 5 to 9        =>  POV <= X(contador-5);
			when 10 to 14      =>  POV <= P(contador-10);
			when 15 to 19      =>  POV <= O(contador-15);
			when 20 to 24      =>  POV <= L(contador-20);
			when 25 to 29      =>  POV <= A(contador-25);
			when 30 to 34      =>  POV <= B(contador-30);
			when 35 to 39      =>  POV <= ESPACIO(contador-35);
			when 40 to 44      =>  POV <= UNO(contador-40);
			when 45 to 49      =>  POV <= S(contador-45);
			when 50 to 54      =>  POV <= ESPACIO(contador-50);
			when 55 to 59      =>  POV <= DOS(contador-55);
			when 60 to 64      =>  POV <= CERO(contador-60);
			when 65 to 69      =>  POV <= UNO(contador-65);
			when 70 to 74      =>  POV <= NUEVE(contador-70);
			when 75 to 79      =>  POV <= ESPACIO(contador-75);
			when 80 to 84      =>  POV <= ESPACIO(contador-80);
			when 85 to 89      =>  POV <= ESPACIO(contador-85);
			when others =>  		  POV <= "111111111111";
			end case;
		
				if cuenta = 0  then
					State<=PRIMERO;
				end if;
				
			When others =>
				State <=PRIMERO;
				color <="110";
			end case;		

   end if;

end process;

----------------------------------------------CONTEO PARA LA MAQUINA DE ESTADOS------------------------------------------------------
process(clk, resetmaquina)
begin
	if rising_edge(clk) then
			if(resetmaquina = '0') then
				cuenta<=0;			
					else	
						if cuenta = fincuenta-1 then
							cuenta<=0;
							else
								cuenta<=cuenta + 1;
						end if;	
			end if;	
	end if;	
end process;
--------------------------------------------------------------------------------------------------------------------------------------

POVFPGA <= conv_std_logic_vector(CONTADOR, 8);---CONVIERTE DE DECIMAL A BINARIO
end Behavioral;

