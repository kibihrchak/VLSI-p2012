-- entity used for RAM content verification upon simulation completion
-- it does verification by reading from RAM via its given interface
--   by changing value on address lines and then waiting for change on
--   data lines
-- verification is one-shot process;
--   it starts on active `start_verification` signal
-- parent entity has to provide following preconditions:
--   - there are no other active users for memory which content is verified
--   - memory is prepared for reading (`rd` and `en` signals are 1)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.memory_package.all;
use std.textio.all;

entity verification is
  generic (verification_file: string);
  port (
    start_verification : in bit;
    
    mem_addr : out addr_type;
    mem_data : in data_type
  );
end entity verification;


architecture only of verification is
begin
  content_comp : process is
    file source_file : text open READ_MODE is verification_file;
    variable read_line : line;
    variable line_number : natural;
    variable parsed_data : parsed_line;
    variable parse_line_res : integer;

    variable memory_data : integer;
  begin
    wait on start_verification;

    if (start_verification = '1') then
      report "Verification started.";

      line_number := 0;

      line_loop: while not endfile(source_file) loop
        readline(source_file, read_line);
        line_number := line_number + 1;

        parse_line(
          read_line,
          line_number,
          abus_width,
          dbus_width,
          parsed_data,
          parse_line_res);

        if (parse_line_res = 0) then
          mem_addr <= 
            std_logic_vector(
              to_signed(parsed_data.address, abus_width));

          wait on mem_data;

          memory_data := to_integer(signed(mem_data)); 
          if (memory_data = parsed_data.data) then
            --report "Line " & natural'image(line_number) & " is OK.";
          else
            report "Line " & natural'image(line_number) & " differs: " &
              integer'image(memory_data) & ", expected " &
              integer'image(parsed_data.data) & ".";
          end if;
        end if;
      end loop;

      report "Verification completed.";
      wait;
    end if;
  end process content_comp;
end architecture only;
