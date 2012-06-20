LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY Avail IS
    PORT(ops_rs1_rd, ops_rs2_rd, regs_rs1_avail, regs_rs2_avail, ops_stack_pop, stack_avail  : IN std_logic;
         ops_avail                                                                           : OUT std_logic
         );
END Avail;

architecture behav of Avail is
BEGIN
   PROCESS (ops_rs1_rd, ops_rs2_rd, regs_rs1_avail, regs_rs2_avail, ops_stack_pop, stack_avail)
   BEGIN
      if ((ops_rs1_rd = '1' and regs_rs1_avail = '0') or (ops_rs2_rd = '1' and regs_rs2_avail = '0') or (ops_stack_pop = '1' and stack_avail = '0')) then
         ops_avail <= '0';
      else
         ops_avail <= '1';
      end if;
   END PROCESS;
END behav;