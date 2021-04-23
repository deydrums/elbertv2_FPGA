library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity main is
PORT( a,b 	: in std_logic;
		o 	: out std_logic
		);
end main;

architecture Behavioral of main is

begin

o <= a and b;

end Behavioral;

