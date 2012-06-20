LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY MEM_Out IS
PORT(   clk         : IN std_logic;
        step 		: IN PL_cycles_range;
        state		: IN States;
        result      : IN data_bus;
        out_result  : OUT data_bus
);
END MEM_Out;

ARCHITECTURE behav OF MEM_Out IS
BEGIN
	PROCESS(state, clk, step)
	BEGIN
		if(state = States'(StateON) and step = PL_cycles_range'high and rising_edge(clk)) then
			out_result        <= result;
		end if;
	END PROCESS;
END behav;