LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY IF_State IS
    PORT(ID_State	: IN States;
			ID_Halt	: IN bit;
			step 		: IN PL_cycles_range;
			reset		: IN std_logic;
			state		: OUT States);
END IF_State;

ARCHITECTURE behav OF IF_State IS
	signal s : States;
BEGIN
	PROCESS(reset, ID_Halt, ID_State)
	BEGIN
		if(reset = '1') then
			s <= States'(StateON);
		elsif (ID_Halt = '1' and step=PL_cycles_range'high) then
			s <= States'(StateOFF);
		end if;
		if (ID_State = States'(StateSTALL)) then		
			s <= States'(StateSTALL);
		elsif (s = States'(StateSTALL)) then
			s <= States'(StateON);
		end if;
		state <= s;
	END PROCESS;
END behav;