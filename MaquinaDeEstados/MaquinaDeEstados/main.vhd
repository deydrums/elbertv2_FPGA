
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
	Port(
		--Señales de control; reset y señal de reloj.
		clk:		in		std_logic;
		reset:	in		std_logic;
		led : out  STD_LOGIC_VECTOR(2 downto 0);
		--Push boton para el conteo.
		--Salidas para el control de los Display's.
		Enable:	out	std_logic_vector(2 downto 0);
		Display: out 	std_logic_vector(7 downto 0)
	);
end main;

architecture Behavioral of main is


   TYPE State_type IS (A,B,C);
	SIGNAL State : State_Type;
	
	signal cuenta: natural range 0 to 12000000*20;
   constant fincuenta : natural:=12000000*20;
	
	signal cuentaamarillo: natural range 0 to 12000000/4;			
   constant fincuentaamarillo : natural:=12000000/4;
	signal amarillo: std_logic;


signal bus_clk:	std_logic;
signal bus_reset:	std_logic;

signal bus_enable:	std_logic_vector(2 downto 0);
signal bus_display:	std_logic_vector(7 downto 0);
signal bus_display1:	integer range 0 to 9;
signal bus_display2: integer range 0 to 9;
signal bus_display3: integer range 0 to 9;


signal unidades:	integer range 0 to 9;
signal decenas:	integer range 0 to 9;
signal centenas:	integer range 0 to 9;



CONSTANT conta_retraso_fin 			  : INTEGER := 12000000;							  -- CONSTANTE PARA CONTEO EN SEGUNDOS
SIGNAL   conta_retraso 					  : INTEGER RANGE 0 TO CONTA_RETRASO_FIN := 0; -- CONTADOR DE TIEMPO HASTA UN SEGUNDO

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



	process(clk, reset, cuenta)
	begin
		if(reset = '0') then
			State <= A;
			unidades <= 1;
			decenas <= 1;
			conta_retraso <= 0;
	elsif rising_edge(clk) then
	
	
	Case State IS
	---------------------------------------------ESTADO A (SEMAFORO EN VERDE)-----------------------------------------------
		When A =>
			led <= "100";
			
					--display

			               conta_retraso <= conta_retraso +1;
								if conta_retraso = conta_retraso_fin then
									conta_retraso <= 0;
									unidades <= unidades -1;
										if unidades = 0 then
											unidades <=9;
											decenas <= decenas - 1;
												if decenas = 0 then
													decenas <= 1;
													end if;
												end if;
											end if;
			
			
			if cuenta = 12000000*11 then
				State<=B;
				unidades <=5;
			   decenas <= 0;
			end if;
  ----------------------------------------------ESTADO B (SEMAFORO EN AMARILLO)--------------------------------------------
		When B=>
		--display
					conta_retraso <= conta_retraso +1;
								if conta_retraso = conta_retraso_fin then
									conta_retraso <= 0;
									unidades <= unidades -1;
										if unidades = 0 then
											unidades <=9;

												end if;
													end if;
		--Brinklin led color amarillo
			if cuenta > 13000000*12 then
			if cuentaamarillo = fincuentaamarillo-1 then
			cuentaamarillo<=0;	
			amarillo <= not amarillo;
			else
				cuentaamarillo<=cuentaamarillo + 1;
			end if;	
			led(0)<=amarillo;
			led(2)<=amarillo;
			led(1)<='0';
			else
			led <= "101";
			end if;
			
			
			--CAMBIO DE ESTADO
			if cuenta = 12000000*15 then
				State<=C;
				unidades <=6;
				decenas <=0;
			end if;
			
  ---------------------------------------------ESTADO C (SEMAFORO EN ROJO)-----------------------------------------------------
			
		When C=>
			led <= "001";
			
					--display
						    conta_retraso <= conta_retraso +1;
								if conta_retraso = conta_retraso_fin then
									conta_retraso <= 0;
									unidades <= unidades -1;
										if unidades = 0 then
											unidades <=9;
												end if;
													end if;
			
			
			--CAMBIO DE ESTADO
			if cuenta = 0  then
				State<=A;
				unidades <=2;
				decenas <=1;
			end if;
			
		When others =>
			State <=A;
		end case;
	end if;
	

end process;


process(clk, reset)
begin
if rising_edge(clk) then
		if(reset = '0') then
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


end Behavioral;

