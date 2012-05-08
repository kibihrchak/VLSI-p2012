library ieee;
use ieee.std_logic_1164.all;

use work.const.all;


entity test_bench is
end entity test_bench;

architecture only of test_bench is
	signal reset : std_logic;
	signal reset_int : std_logic;
	signal clk : std_logic;
	signal step : PL_cycles_range;
begin
	step_gen : entity work.PL_Step(behavioral)
		port map (reset_int, clk, step);

	reset_ctrl : entity work.Reset(struct)
		port map (reset, clk, reset_int);

	signal_gen : process is
	begin
		reset <= '0';
		wait for 45 ns;
		reset <= '1'; 
		wait for 65 ns;
		reset <= '0';

		wait;
	end process signal_gen;

	clock_gen : process is
	begin
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
	end process clock_gen;
end architecture only;
