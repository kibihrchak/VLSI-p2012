LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY ALU_OP IS
    PORT(PC, rs1_val, rs2_val, imm_val : IN data_bus;
         instr_parts                   : IN std_logic_vector(13 downto 0);
         A, B                          : OUT data_bus
			);
END ALU_OP;

ARCHITECTURE behav OF ALU_OP IS
BEGIN
	PROCESS(instr_parts, PC, rs1_val, rs2_val, imm_val)
	BEGIN
		if(instr_parts(12) = '0') then
			A  <= PC;
      else 
         A  <= rs1_val;
		end if;
      
      if(instr_parts(11) = '0') then
			B  <= rs2_val;
      else 
         B  <= imm_val;
		end if;
	END PROCESS;
END behav;