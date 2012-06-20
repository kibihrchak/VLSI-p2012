library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.memory_package.all;

entity test_bench is
end entity test_bench;

architecture only of test_bench is
  signal en, clk, rd : std_logic;

  signal addr : addr_type;
  signal data_out : data_type;
begin
  ROM_instance : entity work.ROM(behav)
    generic map ("../tests/basic_ROM/rom_init_file_00")
    port map (en, clk, rd, addr, data_out);

  clock : process is
  begin
    clk <= '0';
    wait for 20 ns;
    clk <= '1';
    wait for 20 ns;
  end process clock;

  signals : process is
  begin
    rd <= '0';
    en <= '1';
    wait for 40 ns;

    addr <= X"00000000";
    wait for 5 ns;
    rd <= '1';
    wait for 30 ns;


    addr <= X"00000001";
    wait for 30 ns;

    en <= '0';
    wait for 45 ns;
    en <= '1';

    wait;
  end process signals;
end architecture only;
