library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.const.all;

ENTITY Prog_Count IS
PORT(   state					: IN States;
        step 					: IN PL_cycles_range;
        reset, clk              : IN std_logic;
        flush	                : IN bit;
        new_PC				    : IN  addr_bus;
        error					: OUT bit;
        curr_PC				    : OUT addr_bus);
END Prog_Count;

architecture behav of Prog_Count is
	signal PC_reg, prev_PC : std_logic_vector(data_width - 1 downto 0);
	signal error_reg : bit;
begin
	pc_proc : process (clk, reset, flush, step, state) is
	begin
		if (reset = '1') then
			PC_reg <= (others => '0');
            error_reg <= '0';
		else
            if (step = PL_cycles_range'high and rising_edge(clk)) then
                case state is
                    WHEN States'(StateON) =>
                        if(state = States'(StateON) and PC_reg = X"FFFFFFFF") then
                            error_reg <= '1';
                            PC_reg <= prev_PC;  -- cuva se trenutna vrednost do zavrsetka rada
                        else
                            PC_reg <= std_logic_vector(unsigned(PC_reg) + X"0000001");
                            prev_PC <= PC_reg;
                        end if;
                    WHEN States'(StateSTALL) =>
                            if (flush = '1') then
                                    PC_reg <= new_PC;
                            end if;
                    WHEN others =>
                        null;
                end case;
            end if;
		end if;
	end process pc_proc;
    
    error <= error_reg;
    curr_PC <= PC_reg;
    
end architecture behav;
