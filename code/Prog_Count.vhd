library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.const.all;

ENTITY Prog_Count IS
    PORT(state					: IN States;
			step 					: IN PL_cycles_range;
			reset, clk, flush	: IN std_logic;
			new_PC				: IN  addr_bus;
			error					: OUT bit;
			curr_PC				: OUT addr_bus);
END Prog_Count;

architecture behav of Prog_Count is
	signal PC_reg : std_logic_vector(data_width - 1 downto 0);
	signal error_reg : bit;
begin
	pc_proc : process (clk, reset, flush, step, state) is
	begin
		if (reset = '1') then
			PC_reg <= (others => '0');
			error_reg <= '0';
		else
			if (step = PL_cycles_range'high) then
				case state is
					WHEN States'(StateON) =>
						if (rising_edge(clk)) then
							if (PC_reg = X"FFFFFFFF") then
								error_reg <= '1';
							end if;
							PC_reg <= std_logic_vector(unsigned(PC_reg) + X"0000001");
						end if;
					WHEN States'(StateSTALL) =>
							if (flush = '1') then
								if (rising_edge(clk)) then
									PC_reg <= new_PC;
								end if;
							end if;
					WHEN others =>
						null;
				end case;
			end if;
		end if;
	end process pc_proc;

	curr_PC <= PC_reg;
end architecture behav;
