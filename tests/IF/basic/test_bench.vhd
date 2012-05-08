library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.const.all;

entity test_bench is
end entity test_bench;

architecture only of test_bench is
	signal clk : std_logic;
	signal step: PL_cycles_range;
	signal reset : std_logic;
	
	signal IMEM_rd : std_logic;
	signal IMEM_rd_bit : bit;
	signal IMEM_addr : std_logic_vector(addr_width - 1 downto 0);
	signal IMEM_data : std_logic_vector(data_width - 1 downto 0);

	signal err : bit;
	signal err_IF : bit;

	signal IFout_PC : std_logic_vector(data_width - 1 downto 0);
	signal IFout_instr : std_logic_vector(data_width - 1 downto 0);

	signal ID_state : States;
	signal ID_halt : bit;
	signal EX_flush : std_logic;
	signal EX_newPC : std_logic_vector(data_width - 1 downto 0);
begin
	instr_mem : entity work.IMEM(behavioral)
		port map (clk, IMEM_rd, IMEM_addr, IMEM_data);
	
	IMEM_rd<= to_StdULogic(IMEM_rd_bit);
	
	instr_fetch : entity work.Instr_Fetch(behav)
		port map (
			clk, step, reset,
			ID_state,	ID_halt,
			IMEM_data,
			EX_flush, EX_newPC,
			err, err_IF,
			IMEM_addr, IMEM_rd_bit,
			IFout_PC, IFout_instr
		);

	pl_step_gen : entity work.PL_Step(behavioral)
		port map (reset, clk, step);

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
		err <= '0';
		ID_state <= States'(StateOFF);
		ID_halt <= '0';
		EX_flush <= '0';
		-- EX_newPC <= (others => '0');
		EX_newPC <= std_logic_vector(to_unsigned(0, data_width));

		wait for 45 ns;

		reset <= '1';

		wait for 60 ns;

		reset <= '0';

		wait;
	end process;
end architecture;
