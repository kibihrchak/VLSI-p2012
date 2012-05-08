library ieee;
use ieee.std_logic_1164.all;


entity test_bench is
end entity test_bench;


architecture only of test_bench is
	signal outReset : std_logic;
	signal outClk : std_logic;
	signal reset : std_logic;
begin
	res : entity work.Reset(struct)
		port map (outReset, outClk, reset);

	signal_gen : process is
	begin
		outReset <= '0';

		wait for 90 ns;

		outReset <= '1';

		wait for 35 ns;

		outReset <= '0';

		wait for 35 ns;

		outReset <= '1';

		wait for 35 ns;

		outReset <= '0';


		wait;
	end process signal_gen;

	clock_gen : process is
	begin
		outClk <= '0';
		wait for 20 ns;
		outClk <= '1';
		wait for 20 ns;
	end process clock_gen;
end architecture only;
