LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY IF_Bus IS
    PORT(
			curr_PC 	: IN addr_bus;
			state		: IN States;
			step 		: IN PL_cycles_range;
			reset		: IN std_logic;
			error		: IN bit;
			IB_Read	: OUT bit;
			IB_Addr	: OUT addr_bus);
END IF_Bus;

ARCHITECTURE behav OF IF_Bus IS
BEGIN
	PROCESS(step, reset, error, state)
	BEGIN
		if(reset = '1' or error='1') then
			IB_Read <= '0';
			IB_Addr <= (others => 'Z');
		else
			case state is
				when States'(StateON) =>
					if (step = PL_cycles_range'low) then
						IB_Read <= '1';
						IB_Addr <= curr_PC;
					else
						IB_Read <= '0';
						IB_Addr <= (others => 'Z');
					end if;
				when others =>
					IB_Read <= '0';
					IB_Addr <= (others => 'Z');
			end case;
		end if;
	END PROCESS;
END behav;
