LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY Condition IS
PORT(rs1_val, rs2_val  : IN data_bus;
     instr_parts       : IN std_logic_vector(13 downto 0);
     flush             : OUT bit
);
END Condition;

ARCHITECTURE behav OF Condition IS
BEGIN
	PROCESS(instr_parts, rs1_val, rs2_val)
	BEGIN
		CASE instr_parts(10 downto 8) is
         -- nema skoka
         WHEN "000" =>  flush <= '0';
         -- obavezan skok
         WHEN "001" =>  flush <= '1';
         -- beq
         WHEN "010" =>  if (rs1_val = rs2_val) then
                           flush <= '1';
                        else 
                           flush <= '0';
                        end if;
         -- bnq
         WHEN "011" =>  if (rs1_val /= rs2_val) then
                           flush <= '1';
                        else 
                           flush <= '0';
                        end if;
         -- bgt
         WHEN "100" =>  if (rs1_val > rs2_val) then
                           flush <= '1';
                        else 
                           flush <= '0';
                        end if;
         -- blt
         WHEN "101" =>  if (rs1_val < rs2_val) then
                           flush <= '1';
                        else 
                           flush <= '0';
                        end if;
         -- bge
         WHEN "110" =>  if (rs1_val >= rs2_val) then
                           flush <= '1';
                        else 
                           flush <= '0';
                        end if;
         -- ble
         WHEN "111" =>  if (rs1_val <= rs2_val) then
                           flush <= '1';
                        else 
                           flush <= '0';
                        end if;
         WHEN OTHERS => null;
      end CASE;
	END PROCESS;
END behav;