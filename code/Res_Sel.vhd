LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY Res_Sel IS
    PORT(PC, ALU_out, data_out   : IN data_bus;
         instr_parts             : IN std_logic_vector(3 downto 0);
         result                  : OUT data_bus
			);
END Res_Sel;

ARCHITECTURE behav OF Res_Sel IS
BEGIN
	PROCESS(instr_parts, ALU_out, PC, data_out)
	BEGIN
		CASE instr_parts (3 downto 2) IS
         WHEN "00"   => result <= ALU_out;
         WHEN "01"   => result <= PC;
         WHEN "10"   => result <= data_out;
         WHEN OTHERS => result <= (OTHERS => 'X');
      end CASE;
	END PROCESS;
END behav;