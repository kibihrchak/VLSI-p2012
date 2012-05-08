library ieee;
use ieee.std_logic_1164.all;

use work.const.all;


entity PL_Step is
	port (
		reset : in std_logic;
		clk : in std_logic;
		pl_step : out PL_cycles_range
	);
end entity PL_Step;

architecture behavioral of PL_Step is
begin
	step_gen : process (reset, clk) is
		variable step : PL_cycles_range := PL_cycles_range'low;
	begin
		if (reset = '1') then
			step := PL_cycles_range'low;
		else
			if (rising_edge(clk)) then
				step := (step + 1) rem PL_cycles;
			end if;
		end if;
		pl_step <= step;
	end process step_gen;
end architecture behavioral;
