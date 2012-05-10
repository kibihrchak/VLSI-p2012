library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity test_bench is
end entity test_bench;

architecture only of test_bench is
	signal clk : std_logic;
	signal reset : std_logic;
	
  signal rd_reset : std_logic;
  signal rd_index : std_logic_vector(5 - 1 downto 0);
  signal rd_val : std_logic_vector(31 downto 0);

  signal rs1_index : std_logic_vector(5 - 1 downto 0);
  signal rs1_avail : std_logic;
  signal rs1_val : std_logic_vector(31 downto 0);

  signal rs2_index : std_logic_vector(5 - 1 downto 0);
  signal rs2_avail : std_logic;
  signal rs2_val : std_logic_vector(31 downto 0);
begin
  registers : entity work.Regs(behavioral)
    port map (
      clk,
      reset,

      rd_reset,
      rd_index,
      rd_val,
      
      rs1_index,
      rs1_avail,
      rs1_val,

      rs2_index,
      rs2_avail,
      rs2_val
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
    reset <= '0';
    wait for 15 ns;

    reset <= '1';
    wait for 65 ns; 

    -- 80 ns
    reset <= '0';
    rs1_index <= std_logic_vector(to_unsigned(4, 5));

    wait for 40 ns;

    rs2_index <= std_logic_vector(to_unsigned(31, 5));
    rd_index <= std_logic_vector(to_unsigned(31, 5));
    rd_reset <= '1';

    wait for 12 ns;

    rs1_index <= std_logic_vector(to_unsigned(0, 5));

    wait for 28 ns;
    rd_reset <= '0';
    rd_val <= X"0F0F0F0F";

    wait for 160 ns;
    rs1_index <= std_logic_vector(to_unsigned(31, 5));

		wait;
	end process;
end architecture;
