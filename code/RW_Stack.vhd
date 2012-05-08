LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY RW_Stack IS
    PORT(step 			                  : IN PL_cycles_range;
			state			                  : IN States;
         ops_stack_pop, dst_stack_push : IN std_logic; 
         stack_pop, stack_rst          : OUT std_logic
         );
END RW_Stack;

architecture behav of RW_Stack is
BEGIN
   PROCESS (state, step, dst_stack_push, ops_stack_pop)
   BEGIN
      if (state = States'(StateON) and step = PL_cycles_range'high) then
         if (dst_stack_push = '1') then
            stack_pop <= '0';
            stack_rst <= '1';
         elsif (ops_stack_pop = '1') then
            stack_pop <= '1';
            stack_rst  <= '0';
         else
            stack_pop <= '0';
            stack_rst  <= '0';
         end if;
      else
         stack_pop <= '0';
         stack_rst  <= '0';
      end if;
   END PROCESS;
END behav;