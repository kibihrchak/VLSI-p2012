--LIBRARY ieee;
--USE ieee.std_logic_1164.all;
--USE ieee.std_logic_signed.all;
--
--USE work.const.all;
--
--ENTITY ID_State IS
--   PORT( EX_jmp   : IN std_logic;
--         EX_flush : IN std_logic;
--         reset    : IN std_logic;
--         step     : IN PL_cycles_range;
--         IF_State : IN States;
--         ops_avail: IN std_logic;
--         halt     : IN bit;
--         state    : OUT States
--       );
--END ID_State;
--
--architecture behav of ID_State is
--	signal onoff 		: bit;
--	signal onoff_ctrl : bit;
--	signal s : States;
--begin
--	-- on off switch
--	onoff_switch : process(reset, onoff_ctrl, step) is
--	begin
--		if (reset = '1') then
--			onoff <= '0';
--		elsif (step = PL_cycles_range'low) then
--			if (onoff_ctrl = '1') then
--				onoff <= '1';
--			else
--				onoff <= '0';
--			end if;
--		end if;
--	end process;
--	
--   -- on off control
--   state_switch : process(onoff, halt, EX_flush, EX_jmp, IF_State, ops_avail) is
--   begin
--      if (onoff = '0') then
--         onoff_ctrl <= '0';
--      elsif (halt = '1' or EX_flush = '1')then
--         onoff_ctrl <= '0';
--      else
--         onoff_ctrl <= '1';
--      end if;
--      if (IF_State = States'(StateON) and EX_jmp = '0' and EX_flush = '0' and ops_avail = '1') then
--         onoff_ctrl <= '1';
--      end if;
--   end process;
--   
--   -- state control   
--	state_control : process(onoff, EX_jmp, ops_avail, IF_State) is
--	begin
--      if (onoff = '0') then
--         s <= states'(StateOFF);
--      elsif((IF_State = States'(StateSTALL)) or (EX_jmp = '1') or (ops_avail = '0'))then
--         s <= states'(StateSTALL);
--      end if;
--   end process;
--	
--   state <= s;
--	
--end behav;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY ID_State IS
   PORT( EX_jmp   : IN std_logic;
         EX_flush : IN std_logic;
         reset, clk    : IN std_logic;
         step     : IN PL_cycles_range;
         IF_State : IN States;
         ops_avail: IN std_logic;
         halt     : IN bit;
         state    : OUT States
       );
END ID_State;

architecture behav of ID_State is
	signal onoff 		: bit;
	signal onoff_ctrl : bit;
	signal s : States;
begin
	-- on off switch
	onoff_switch : process(clk, reset, onoff_ctrl) is
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
	
	state_switch : process(s, onoff, step, halt, EX_jmp, EX_flush, IF_State) is
	begin
		-- onoff control
      if (onoff = '0') then
         if (step = PL_cycles_range'high and IF_State = States'(StateON)) then
				onoff_ctrl <= '1';
         else
            onoff_ctrl <= '0';
         end if;
		else
			if (step = PL_cycles_range'high) then
            if ((s = states'(StateSTALL) and EX_flush = '1') or halt = '1') then
               onoff_ctrl <= '0';
            else
               onoff_ctrl <= '1';
            end if;
			else
				onoff_ctrl <= '1';
			end if;
		end if;
	end process;
	
   
	state_control : process(onoff, halt, EX_jmp, ops_avail) is
	begin
		-- state control
		if (onoff = '0') then
			s <= states'(StateOFF);
		else
			if (EX_jmp = '1' or ops_avail = '0') then
				s <= states'(StateSTALL);
			else
				s <= states'(StateON);
			end if;
		end if;
	end process;
	
	state <= s;
	
end behav;