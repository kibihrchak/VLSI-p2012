LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY ID_Out IS
    PORT(clk                                             : IN std_logic;
         step 		                                       : IN PL_cycles_range;
         state		                                       : IN States;
         PC 	                                          : IN addr_bus;
         instr_parts                                     : IN std_logic_vector(13 downto 0);
			imm_val, rs1_val, rs2_val                       : IN data_bus;
         out_PC, out_imm_val, out_rs1_val, out_rs2_val   : OUT data_bus;
         out_instr_parts                                 : OUT std_logic_vector(13 downto 0)
			);
END ID_Out;

ARCHITECTURE behav OF ID_Out IS
BEGIN
	PROCESS(state, clk, step)
	BEGIN
		if(state = States'(StateON) and step = PL_cycles_range'high and rising_edge(clk)) then
			out_PC            <= PC;
         out_instr_parts   <= instr_parts;
         out_imm_val       <= imm_val;
         out_rs1_val       <= rs1_val;
         out_rs2_val       <= rs2_val;
		end if;
	END PROCESS;
END behav;