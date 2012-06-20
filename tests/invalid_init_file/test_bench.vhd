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
    generic map ("../tests/invalid_init_file/ram_init_file_00")
    port map (en, clk, rd, wr, addr, data_in, data_out);
end architecture only;
