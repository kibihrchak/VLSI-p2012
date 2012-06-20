LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY IF_Out IS
PORT(   curr_PC 	: IN addr_bus;
        clk         : IN std_logic;
        state		: IN States;
        step 		: IN PL_cycles_range;
        in_data	    : IN data_bus;
        out_PC	    : OUT addr_bus;
        out_data	: OUT data_bus
);
END IF_Out;

ARCHITECTURE behav OF IF_Out IS
BEGIN
	PROCESS(state, curr_PC, in_data, clk, step)
	BEGIN
		if(state = States'(StateON) and rising_edge(clk)
        and step = PL_cycles_range'high) then
			out_PC <= curr_PC;
			out_data <= in_data;
		end if;
	END PROCESS;
END behav;
