library ieee;
use ieee.std_logic_1164.all;

entity TSB is generic (wordLength:integer := 32);
	port( enable : IN STD_LOGIC;
         TSB_IN : in std_logic_vector ((wordLength-1) downto 0);
         TSB_OUT : out std_logic_vector ((wordLength-1) downto 0):= x"00000007"
	);
end tsb;

architecture behavioral of tsb is
	begin	
	-- if enable is 1 then put value from input to output, else put nop
			TSB_OUT<=TSB_IN when enable='1'	else
			x"00000007";
end architecture behavioral;	