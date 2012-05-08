LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY Instr_Fetch IS
	PORT (
		clk 			: IN std_logic;
		step 			: IN PL_cycles_range;
		reset 		: IN std_logic;
		ID_State 	: IN States;
		ID_Halt		: IN bit;
		IMEM_data 	: IN data_bus;
		flush			: IN std_logic;
		PC_new		: IN addr_bus;
		error			: IN bit;
		error_of		: OUT bit;
		IMEM_addr 	: OUT addr_bus;
		IMEM_rd 		: OUT bit;
		PC_out		: OUT read_data;
		data_out 	: OUT read_data
	);
END Instr_Fetch;

ARCHITECTURE behav OF Instr_Fetch IS
	signal s : States;
	signal PC: addr_bus;
begin
	state_control : ENTITY work.IF_State(behav)
		PORT MAP (ID_State, ID_Halt, step, reset, s);
		
	mem_acc : ENTITY work.IF_Bus(behav)
		PORT MAP (PC, s, step, reset, error, IMEM_rd, IMEM_addr);
			
	out_reg : ENTITY work.IF_Out(behav)
		PORT MAP (PC, s, step, IMEM_data, PC_out, data_out);
			
	prog_count : ENTITY work.Prog_Count(behav)
		PORT MAP (s, step, reset, clk, flush, PC_new, error_of, PC);
END behav;
