library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity test_bench is
end entity test_bench;

architecture only of test_bench is
	signal clk : std_logic;
	signal reset : std_logic;
	
  signal pop : std_logic;
  signal push_rst : std_logic;
  signal data_in : std_logic_vector(31 downto 0);

  signal error_stack : std_logic;
  signal avail : std_logic;
  signal data_out : std_logic_vector(31 downto 0);
begin
  stack : entity work.Stack(behavioral)
    port map (
      clk,
      reset,

      pop,
      push_rst,
      data_in,
      
      error_stack,
      avail,
      data_out
    );

	clock_gen : process is
	begin
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
	end process clock_gen;
	
	signal_control : process
	begin
    wait for 25 ns;
    reset <= '1';

    wait for 50 ns;
    reset <= '0';

    wait for 5 ns;
    pop <= '1';

    push_rst <= '1';
    wait for 40 ns;
    
    push_rst <= '0';
    wait for 20 ns;

    data_in <= X"FEFEFEFE";
		wait;
	end process;
end architecture;
