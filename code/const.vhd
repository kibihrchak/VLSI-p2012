library ieee;
use ieee.std_logic_1164.all;

package const is
	constant addr_width : positive := 32;
	constant data_width : positive := 32;
	
	subtype addr_bus is std_logic_vector(addr_width - 1 downto 0);
	subtype data_bus is std_logic_vector(data_width - 1 downto 0);
	
	subtype read_data is std_logic_vector(data_width - 1 downto 0);
	
	constant PL_cycles : positive := 2;
	subtype PL_cycles_range is natural range 0 to PL_cycles - 1;
	
	type States is (StateOFF, StateON, StateSTALL);
end package;
