library ieee;
use ieee.std_logic_1164.all;


package regpkg is
  constant datawid : integer := 32;
  subtype data is std_logic_vector(datawid - 1 downto 0);

  constant regselwid : integer := 5;
  subtype regsel is std_logic_vector(regselwid - 1 downto 0);

  constant regcnt : integer := 2**regselwid;
  subtype regcnttype is integer range 0 to regcnt - 1;

  constant clktowrite : integer := 4;
  subtype availcount is integer range 0 to clktowrite - 1;
end package regpkg;
