library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.memory_package.all;

entity ROM is
  generic (init_file_path: string);
  port (
    en : in std_logic;
    clk : in std_logic;

    rd : in std_logic;

    addr : in addr_type;
    data_out : out data_type
  );
end entity ROM;

-- reading from ROM is synchronous
architecture behav of ROM is
  signal mem: memory;
begin
  output : process (en, rd, addr, clk) is
  begin
    if (not (en = '1')) then
      data_out <= (others => 'Z');
    else
      if (rising_edge(clk)) then
        -- synchronous response
        if (rd = '1') then
          data_out <= mem(to_integer(signed(addr))) after mem_delay;
        else
          data_out <= (others => 'Z') after mem_delay;
        end if;
      end if;
    end if;
  end process output;

  input : process is
  begin
    -- ROM initialization
    report "Initializing ROM. Source file: " & init_file_path;
    init_memory(mem, init_file_path);
    wait;
  end process input;
end architecture behav;
