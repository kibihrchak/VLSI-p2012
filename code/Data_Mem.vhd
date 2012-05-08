LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY Data_Mem IS
    PORT(error       : IN bit;
			step 		   : IN PL_cycles_range;
         state		   : IN States;
         ALU_out     : IN data_bus;
			rs2_val     : IN data_bus;
         instr_parts : IN std_logic_vector(3 downto 0);
			DM_read     : OUT std_logic;
         DM_write    : OUT std_logic;
         DM_addr     : OUT addr_bus;
         DM_data     : OUT data_bus
         );
END Data_Mem;

ARCHITECTURE behav OF Data_Mem IS
BEGIN
	PROCESS(error, state, step, instr_parts, rs2_val, ALU_out)
	BEGIN
		if(error='1') then
			DM_read  <= 'Z';
         DM_write <= 'Z';
			DM_addr  <= (others => 'Z');
         DM_data  <= (others => 'Z');
		else
			if (state = States'(StateON)) then
            if (step = PL_cycles_range'low) then
               if (instr_parts(1) = '1') then
                  DM_write <= 'Z';
                  DM_read <= '1';
                  DM_addr <= ALU_out;
                  DM_data <= (OTHERS => 'Z');
               elsif (instr_parts(0) = '1') then
                  DM_read  <= 'Z';
                  DM_write <= '1';
                  DM_addr <= ALU_out;
                  DM_data <= rs2_val;
               else
                  DM_read  <= 'Z';
                  DM_write <= 'Z';
                  DM_addr  <= (others => 'Z');
                  DM_data  <= (others => 'Z');
               end if;                     
				else
               DM_read  <= 'Z';
               DM_write <= 'Z';
               DM_addr  <= (others => 'Z');
               DM_data  <= (others => 'Z');
            end if;
		   else
               DM_read  <= 'Z';
               DM_write <= 'Z';
               DM_addr  <= (others => 'Z');
               DM_data  <= (others => 'Z');
			end if;
		end if;
	END PROCESS;
END behav;
