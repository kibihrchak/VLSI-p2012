library ieee;
use ieee.std_logic_1164.all;

entity IMEM is
	generic (
		wordLength: integer := 32;
		addressLength : integer := 32
	);
	port (
		clk: in std_logic;
		rd : in std_logic;
		ABUS: in std_logic_vector((addressLength - 1) downto 0);
		DBUS: out std_logic_vector((wordLength - 1) downto 0)
	);
end entity;

architecture behavioral of IMEM is
begin	
	read : process (clk, rd, ABUS)
	begin
		if (rising_edge(clk)) then
			if (rd = '1') then
				DBUS <= X"DEAD" & ABUS(15 downto 0);
			else
				DBUS <= (others => 'Z');
			end if;
		end if;
	end process;
end;
