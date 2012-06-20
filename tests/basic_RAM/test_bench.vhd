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
begin
  RAM_instance : entity work.RAM(behav)
    generic map ("../tests/basic_RAM/ram_init_file_00")
    port map (en, clk, rd, wr, addr, data_in, data_out);

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
    wr <= '0';
    en <= '1';
    wait for 40 ns;

    addr <= X"00000000";
    wait for 5 ns;
    rd <= '1';
    wait for 30 ns;


    addr <= X"00000001";
    data_in <= X"DEADBEEF";
    wr <= '1';
    wait for 30 ns;

    wr <= '0';

    wait;
  end process signals;
end architecture only;
