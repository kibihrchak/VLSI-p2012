library ieee;
use ieee.std_logic_1164.all;


package stackpkg is
  constant datawid : integer := 32;
  subtype data is std_logic_vector(datawid - 1 downto 0);

  constant stack_size : integer := 1024;
  subtype sp_type is natural range 0 to stack_size - 1;

  constant clktowrite : integer := 6;
  subtype availcount is integer range 0 to clktowrite - 1;
end package stackpkg;