LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY Error_Block IS
    PORT(error_PC, error_OC, error_St, error_OF : IN bit;
         error                                  : OUT bit
			);
END Error_Block;

ARCHITECTURE behav OF Error_Block IS
BEGIN
	error <= error_PC or error_OC or error_St or error_OF;
END behav;