LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY MEMory IS
   PORT (clk, reset                    : IN std_logic;
         step                          : IN PL_cycles_range;
         EX_State                      : IN States;
         PC, ALU_out, rs2_val: IN data_bus;
         instr_parts                   : IN std_logic_vector(3 downto 0);
         error                         : IN bit;
         MEM_State                     : OUT States;
         DM_read, DM_write             : OUT std_logic;
         DM_addr, out_result           : OUT data_bus;
         DM_data                       : INOUT data_bus
	);
END MEMory;

ARCHITECTURE behav OF MEMory IS
   signal s       : States;
   signal result  : data_bus;
BEGIN
	state_control : ENTITY work.MEM_State(behav)
		PORT MAP (step, reset, clk, EX_State, s);	
   
   result_select : ENTITY work.Res_Sel(behav)
      PORT MAP (PC, ALU_out, DM_data, instr_parts, result);

   data_memory : ENTITY work.Data_Mem(behav)
      PORT MAP (error, step, s, ALU_out, rs2_val, instr_parts, DM_read, DM_write, DM_addr, DM_data);
   
   memory_out  : ENTITY work.MEM_Out(behav)
      PORT MAP (clk, step, s, result, out_result);
   
   MEM_State <= s;

END behav;