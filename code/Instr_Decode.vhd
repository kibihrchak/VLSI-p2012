LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY Instr_Decode IS
   PORT (clk, reset, EX_jmp, EX_flush        : IN std_logic;
         step                                : IN PL_cycles_range;
         IF_State                            : IN States;
         instr_Word, PC                      : IN data_bus;
         rs1_avail, rs2_avail, stack_avail   : IN std_logic;
         rs1_val, rs2_val, stack_Word        : IN data_bus;
         out_ID_State                        : OUT States;
         out_halt, error_oc                  : OUT bit;
         rd_reset, pop, push                 : OUT std_logic;
         rs1_index, rs2_index, rd_index      : OUT std_logic_vector(4 downto 0);
         out_PC, imm_val                     : OUT data_bus;
         out_instr_parts                     : OUT std_logic_vector(13 downto 0);
         out_rs1_val, out_rs2_val            : OUT data_bus
	);
END Instr_Decode;

ARCHITECTURE behav OF Instr_Decode IS
   signal ops_avail, ops_stack_pop, ops_rs1_rd, ops_rs2_rd, dst_stack_push, dst_rd_wr : std_logic;
   signal instr_parts   : std_logic_vector(13 downto 0);
   signal imm_stack     : data_bus;
   signal s             : States;
   signal halt, error   : bit;
begin
	state_control : ENTITY work.ID_State(behav)
		PORT MAP (EX_jmp, EX_flush, reset, clk, step, IF_State, ops_avail, halt, s);
   
   out_ID_State <= s;
   
	instr_decoder : ENTITY work.ID_Block(behav)
		PORT MAP (step, s, instr_Word, stack_Word, halt, error, instr_parts, 
                imm_stack, ops_stack_pop, ops_rs1_rd, ops_rs2_rd, rs1_index,
                rs2_index, rd_index, dst_stack_push, dst_rd_wr);
   
	reg_dest : ENTITY work.RW_Dest(behav)
		PORT MAP (step, s, dst_rd_wr, rd_reset);
      
   stack_dest : ENTITY work.RW_Stack(behav)
		PORT MAP (step, s, ops_stack_pop, dst_stack_push, pop, push);
      
   avail : ENTITY work.Avail(behav)
		PORT MAP (ops_rs1_rd, ops_rs2_rd, rs1_avail, rs2_avail, ops_stack_pop, stack_avail, ops_avail);
      
   out_reg : ENTITY work.ID_Out(behav)
		PORT MAP (clk, step, s, PC, instr_parts, imm_stack, rs1_val, rs2_val, out_PC, imm_val, out_rs1_val, out_rs2_val, out_instr_parts);

   signal_ctrl : process (error, halt, s) is
   begin
      if (s = States'(StateON)) then
         error_oc <= error;
         out_halt <= halt;
      else
         error_oc <= '0';
         out_halt <= '0';
      end if;
   end process;

   
END behav;