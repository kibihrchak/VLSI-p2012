LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY CPU_Active IS
PORT(   IF_State, ID_State, EX_State, MEM_State, WB_State  : IN States;
        active_CPU                                         : OUT bit
        );
END CPU_Active;

ARCHITECTURE behav OF CPU_Active IS
BEGIN
   PROCESS (IF_State, ID_State, EX_State, MEM_State, WB_State) IS
   BEGIN
      if (IF_State = States'(StateON) or ID_State = States'(StateON) or  EX_State = States'(StateON) or  MEM_State = States'(StateON) or WB_State = States'(StateON)) then
         active_CPU <= '1';
      else 
         active_CPU <= '0';
      end if;
   END PROCESS;
END behav;