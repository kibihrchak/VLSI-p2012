LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY RW_Dest IS
PORT(   step 		: IN PL_cycles_range;
		state		: IN States;
        dst_rd_wr   : IN std_logic;
        rd_rst      : OUT std_logic
);
END RW_Dest;

architecture behav of RW_Dest is
BEGIN
   PROCESS (state, step, dst_rd_wr)
   BEGIN
      if (state = States'(StateON) and step = PL_cycles_range'high and dst_rd_wr = '1') then
         rd_rst <= '1';
      else
         rd_rst <= '0';
      end if;
   END PROCESS;
END behav;