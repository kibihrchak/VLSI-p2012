LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY EX_Out IS
    PORT(clk                              : IN std_logic;
         step 		                        : IN PL_cycles_range;
         state		                        : IN States;
         PC 	                           : IN addr_bus;
         instr_parts                      : IN std_logic_vector(13 downto 0);
			result, rs2_val                  : IN data_bus; 
         out_PC, out_result, out_rs2_val  : OUT data_bus;
         out_instr_parts                  : OUT std_logic_vector(3 downto 0)
			);
END EX_Out;

ARCHITECTURE behav OF EX_Out IS
BEGIN
	PROCESS(state, clk, step)
	BEGIN
		if(state = States'(StateON) and step = PL_cycles_range'high and rising_edge(clk)) then
			out_PC            <= PC;
         out_instr_parts   <= instr_parts(3 downto 0);
			out_result        <= result;
         out_rs2_val       <= rs2_val;
		end if;
	END PROCESS;
END behav;