LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY WB_State IS
   PORT( step     	: IN PL_cycles_range;
         reset, clk	: IN std_logic;
         MEM_State 	: IN States;
         state    	: OUT States
        );
END WB_State;

architecture behav of WB_State is
	signal onoff 		: bit;
	signal onoff_ctrl : bit;
begin
	-- on off switch
	onoff_switch : process(reset, onoff_ctrl, step, clk) is
	begin
		if (reset = '1') then
			onoff <= '0';
		elsif (rising_edge(clk)) then
			if (onoff_ctrl = '1') then
				onoff <= '1';
			else
				onoff <= '0';
			end if;
		end if;
	end process;

  	state_switch : process(onoff, step, MEM_State) is
	begin
		-- onoff control
		if (onoff = '0') then
         if (step = PL_cycles_range'high and MEM_State = States'(StateON)) then
				onoff_ctrl <= '1';
         else
            onoff_ctrl <= '0';
         end if;
		else
			if (step = PL_cycles_range'high and MEM_State = States'(StateOFF)) then
				onoff_ctrl <= '0';
			else
				onoff_ctrl <= '1';
			end if;
		end if;
	end process;
  
  
   
   -- state control   
	state_control : process(onoff) is
	begin
      if (onoff = '0') then
         state <= states'(StateOFF);
      else
         state <= states'(StateON);
      end if;
   end process;
end behav;
