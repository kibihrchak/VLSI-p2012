library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.memory_package.all;

entity test_bench is
end entity test_bench;

architecture only of test_bench is
  signal en, clk, rd, wr : std_logic;

  signal addr : addr_type;
  signal data_in : data_type;
  signal data_out : data_type;

  signal start_verification : bit;

  constant curr_path : string := "../tests/basic_verification/";
begin
  RAM_instance : entity work.RAM(behav)
    generic map (curr_path & "ram_init_file_00")
    port map (en, clk, rd, wr, addr, data_in, data_out);

  verificator : entity work.verification(only)
    generic map (curr_path & "verification_file_00")
    port map (start_verification, addr, data_out);

  signals : process is
  begin
    start_verification <= '0';
    rd <= '0';
    wr <= '0';
    en <= '1';
    wait for 40 ns;

    addr <= (others => 'Z');
    rd <= '1';
    start_verification <= '1';

    wait;
  end process signals;
end architecture only;
