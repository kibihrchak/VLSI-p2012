library ieee;
use ieee.std_logic_1164.all;

entity Reset is
	port (
		outReset : in std_logic;
		outClk : in std_logic;
		
		reset : out std_logic
	);
end entity Reset;

architecture struct of Reset is
	signal d_ff_out : std_logic;
begin
	delay_ff : entity work.d_ff(behavioral)
		port map (outReset, outClk, d_ff_out);
	reset <= d_ff_out or outReset;
end architecture struct;
