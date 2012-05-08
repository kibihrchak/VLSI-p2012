library ieee;
use ieee.std_logic_1164.all;

entity d_ff is
	port (
		d, clk: in std_logic;
		q : out std_logic
	);
end entity d_ff;

architecture behavioral of d_ff is
begin
	behavior : process is
	begin
		wait until clk = '1';
		q <= d;
	end process behavior;
end architecture behavioral;
