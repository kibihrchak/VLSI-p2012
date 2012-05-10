LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY PL_CPU IS
   PORT (clk, reset                                         : IN std_logic;
         step                                               : IN PL_cycles_range;
         IMEM_data, rs1_val, rs2_val, stack_Word            : IN data_bus;
         error                                              : IN bit;
         rs1_avail, rs2_avail, stack_avail                  : IN std_logic;
         error_PC, error_ID, error_EX, IMEM_rd              : OUT bit;
         IMEM_addr 	                                       : OUT addr_bus;
         rd_reset, pop, push                                : OUT std_logic;
         rs1_index, rs2_index, rd_index                     : OUT std_logic_vector(4 downto 0);
         DM_read, DM_write                                  : OUT std_logic;
         DM_addr                                            : OUT data_bus;
         DM_data                                            : INOUT data_bus
	);
END PL_CPU;

ARCHITECTURE behav OF PL_CPU IS
   signal halt                                                                                                 : bit;
   signal flush, jmp                                                                                           : std_logic;
   signal IF_State, ID_State, EX_State, MEM_State, WB_State                                                    : States;
   signal PC_new, PC_ID, PC_IF, PC_EX, data_out, imm_val, out_rs1_val, out_rs2_val, out_ALU, out_rs2_val_EX    : data_bus;
   signal out_result                                                                                           : data_bus;
   signal instr_parts_ID                                                                                       : std_logic_vector(13 downto 0);
   signal instr_parts_EX                                                                                       : std_logic_vector(3 downto 0);
BEGIN
	instr_fetch : ENTITY work.Instr_fetch(behav)
		PORT MAP (clk, step, reset, ID_State, halt, IMEM_data, flush, PC_new, error, error_PC, IMEM_addr, IMEM_rd, PC_IF, data_out, IF_State);	
   
   instr_decode : ENTITY work.Instr_decode(behav)
      PORT MAP (clk, reset, jmp, flush, step, IF_State, data_out, PC_IF, rs1_avail, rs2_avail, stack_avail, rs1_val, rs2_val, stack_Word, 
                ID_State, halt, error_ID, rd_reset, pop, push, rs1_index, rs2_index, rd_index, PC_ID, imm_val, instr_parts_ID, out_rs1_val, out_rs2_val);

   execution : ENTITY work.EXecution(behav)
      PORT MAP (clk, reset, step, ID_State, PC_ID, out_rs1_val, out_rs2_val, imm_val, instr_parts_ID, EX_State, flush, jmp, error_EX, PC_EX, out_ALU, PC_new, out_rs2_val_EX, instr_parts_EX);
   
   memory : ENTITY work.MEMory(behav)
      PORT MAP (clk, reset, step, EX_State, PC_EX, out_ALU, out_rs2_val_EX, instr_parts_EX, error, MEM_State, DM_read, DM_write, DM_addr, out_result, DM_data);
   
   write_back : ENTITY work.WB_State(behav)
      PORT MAP (step, reset, clk, MEM_State, WB_State);   

END behav;