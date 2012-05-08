LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY EXecution IS
   PORT (clk, reset                    : IN std_logic;
         step                          : IN PL_cycles_range;
         ID_State                      : IN States;
         PC, rs1_val, rs2_val, imm_val : IN data_bus;
         instr_parts                   : IN std_logic_vector(13 downto 0);
         EX_State                      : OUT States;
         flush, jmp                    : OUT std_logic;
         error_of                      : OUT bit;
         out_PC, out_ALU, out_rs2_val, new_PC  : OUT data_bus;
         out_instr_parts               : OUT std_logic_vector(3 downto 0)    
	);
END EXecution;

ARCHITECTURE behav OF EXecution IS
   signal s         : States;
   signal A, B, result  : data_bus;
BEGIN
	state_control : ENTITY work.EX_State(behav)
		PORT MAP (step, reset, clk, ID_State, s);	
   
   alu_operators : ENTITY work.ALU_OP(behav)
      PORT MAP (PC, rs1_val, rs2_val, imm_val, instr_parts, A, B);
   
   condition : ENTITY work.Condition(behav)
      PORT MAP (rs1_val, rs2_val, instr_parts, flush);
      
   alu : ENTITY work.ALU(behav)
      PORT MAP(s, A, B, instr_parts, error_of, result);
      
   ex_out : ENTITY work.EX_Out(behav)
      PORT MAP(clk, step, s, PC, instr_parts, result, rs2_val, out_PC, out_ALU, out_rs2_val, out_instr_parts);
      
   EX_State <= s;
   new_PC <= result;
   
   jmp_ctr : process (instr_parts(13), s) is
   begin
      if (s = States'(StateON)) then
         jmp <= instr_parts(13);
      else
         jmp <= '0';
      end if;
   end process;
--   jmp <= instr_parts(13) and s = States'(StateON); 
      
END behav;