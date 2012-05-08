LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY IF_State IS
    PORT(ID_State		: IN States;
			ID_Halt		: IN bit;
			step 			: IN PL_cycles_range;
			reset, clk 	: IN std_logic;
			state			: OUT States);
END IF_State;

architecture behav of IF_state is
	signal onoff 		: std_logic;
	signal onoff_ctrl : std_logic;
	signal s : States;
begin
	-- on off switch
	onoff_switch : process(clk, reset, onoff_ctrl) is
	begin
		if (reset = '1') then
			onoff <= '1';
		elsif (rising_edge(clk)) then
			if (onoff_ctrl = '1') then
				onoff <= '1';
			else
				onoff <= '0';
			end if;
		end if;
	end process;
	
	state_switch : process(s, onoff, step, ID_Halt) is
	begin
		-- onoff control
		if (onoff = '0') then
				onoff_ctrl <= '0';
		else
			if (step = PL_cycles_range'high and ID_Halt = '1' and s = States'(StateON)) then
				onoff_ctrl <= '0';
			else
				onoff_ctrl <= '1';
			end if;
		end if;
	end process;
	
	state_control : process(onoff, ID_State) is
	begin
		-- state control
		if (onoff = '0') then
			s <= states'(StateOFF);
		else
			if (ID_State = States'(StateSTALL)) then
				s <= states'(StateSTALL);
			else
				s <= states'(StateON);
			end if;
		end if;
	end process;
	
	state <= s;
	
end behav;
