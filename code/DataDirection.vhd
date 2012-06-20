LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY DataDirection IS
PORT(   DM_dataRd, DM_dataWr    : IN data_bus;
        instr_parts             : IN std_logic_vector(3 downto 0);    
        DM_dataRS, DM_dataDB    : OUT data_bus         
	);
END DataDirection;

ARCHITECTURE behav OF DataDirection IS
BEGIN
    PROCESS(instr_parts, DM_dataRd, DM_dataWr)
    BEGIN
        CASE instr_parts (1 downto 0) IS
            WHEN "01"   => DM_dataDB <= DM_dataWr; DM_dataRS <= (OTHERS => 'X');
            WHEN "10"   => DM_dataRS <= DM_dataRd; DM_dataDB <= (OTHERS => 'X');
            WHEN OTHERS => DM_dataRS <= (OTHERS => 'X');    DM_dataDB <= (OTHERS => 'X');
        end CASE;
    END PROCESS;
end ARCHITECTURE;