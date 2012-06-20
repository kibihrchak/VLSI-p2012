library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.memory_package.all;

entity RAM is
  generic (init_file_path: string);
  port (
    en : in std_logic;
    clk : in std_logic;

    rd : in std_logic;
    wr : in std_logic;

    addr : in addr_type;
    data_in : in data_type;
    data_out : out data_type;

    verification : in bit
  );
end entity RAM;

-- reading from RAM is synchronous
-- writing to RAM is synchronous
-- there is special reading mode for verification
architecture behav of RAM is
  signal mem: memory;

  signal output_enabled: std_logic;
begin
  -- needed because output lags for one clock if location
  --   is changed on the same clock
  out_ctrl : process (en, rd, clk, verification) is
  begin
    if (verification = '1') then
      output_enabled <= '1';
    else
      if (not (en = '1')) then
        -- memory not selected
        output_enabled <= '0';
      else
        if (rising_edge(clk)) then
          -- synchronous response
          if (rd = '1') then
            output_enabled <= '1';
          else
            output_enabled <= '0';
          end if;
        end if;
      end if;
    end if;
  end process out_ctrl;

  output : process (output_enabled, addr, mem) is
  begin
    if (output_enabled = '1') then
      -- verification mode reading
      data_out <= mem(to_integer(signed(addr)));
    else
      data_out <= (others => 'Z');
    end if;
  end process output;

  input : process is
  begin
    -- RAM initialization
    -- had to put it here instead in separate process because it would not initialize memory
    report "Initializing RAM. Source file: " & init_file_path;
    init_memory(mem, init_file_path);

    -- write operation will cycle in following loop
    loop
      if (en = '1' and wr = '1' and rising_edge(clk)) then
        mem(to_integer(signed(addr))) <= data_in;
      end if;

      wait on clk, en, wr, addr;
    end loop;
  end process input;
end architecture behav;
