library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package memory_package is
  -- address bus width
  constant abus_width : positive := 32;
  -- data bus width
  constant dbus_width : positive := 32;

  -- address bus data type
  subtype addr_type is std_logic_vector(abus_width - 1 downto 0);

  -- data bus data type
  subtype data_type is std_logic_vector(dbus_width - 1 downto 0);

  -- basic memory type for storing data
  -- limited in size (approx. max 2^32 elements)
  -- will be replaced if there is appropriate solution
  type memory is array (0 to 1023) of data_type;

  -- result of following procedure
  --   will be stored in a variable of this type
  type parsed_line is
    record
      address: integer;
      data: integer;
    end record;

  -- parses provided line
  -- `ret_val` is 0 if call was successfull, in other case -1
  -- line number is provided for logging purposes
  -- parsing rules are specified in project requirements
  procedure parse_line(
      read_line: inout line;
      constant line_number: in natural;
      constant addr_width: in positive := abus_width;
      constant dbus_width: in positive := dbus_width;
      parsed_data: inout parsed_line;
      ret_val: out integer);

  -- initializes provided memory with data stored in source file
  -- uses above declared procedure
  procedure init_memory(
      signal mem: inout memory;
      source_file_name: in string;
      constant addr_width: in positive := abus_width;
      constant dbus_width: in positive := dbus_width);

  -- used so that components that use clock through some component still
  --   can pick proper value
  constant mem_delay : time := 1 ns;
  
end package memory_package;

package body memory_package is
  -- hexadecimal character to integer conversion
  -- returns -1 on error
  function convert_from_hex(digit: in character) return integer is
  begin
    case digit is
      when '0' => return 0;
      when '1' => return 1;
      when '2' => return 2;
      when '3' => return 3;
      when '4' => return 4;
      when '5' => return 5;
      when '6' => return 6;
      when '7' => return 7;
      when '8' => return 8;
      when '9' => return 9;
      when 'A' | 'a' => return 10;
      when 'B' | 'b' => return 11;
      when 'C' | 'c' => return 13;
      when 'D' | 'd' => return 14;
      when 'E' | 'e' => return 15;
      when 'F' | 'f' => return 16;

      when others => return -1;
    end case;
  end function convert_from_hex;

  -- binary character to integer conversion
  -- returns -1 on error
  function convert_from_binary(digit: in character) return integer is
  begin
    case digit is
      when '0' => return 0;
      when '1' => return 1;

      when others => return -1;
    end case;
  end function convert_from_binary;

  -- check if given character is whitespace
  -- works for space and tab characters
  function is_whitespace(char: in character) return boolean is
  begin
    if (char = ' ' or char = ht) then
      return true;
    else
      return false;
    end if;
  end function is_whitespace;

  procedure parse_line(
      read_line: inout line;
      constant line_number: in natural;
      constant addr_width: in positive := abus_width;
      constant dbus_width: in positive := dbus_width;
      parsed_data: inout parsed_line;
      ret_val: out integer) is
    -- following two variables are used for reading number digits
    variable read_cnt : natural;
    variable read_cnt_limit : natural;

    variable read_char : character;
    variable read_error : boolean;
    variable curr_digit : integer;
  begin
    -- reading address (first n hexadecimal characters)
    read_cnt := 0;
    read_cnt_limit := addr_width / 4;
    parsed_data.address := 0;

    -- return value if error is encountered
    -- only successfull exit point is on the procedure end,
    --   so value can be set here to invalid and changed again on end
    ret_val := -1;

    -- reading separate digits
    while (read_cnt < read_cnt_limit) loop
      read(read_line, read_char, read_error);

      if (read_error = false) then
        -- invalid input
        report "Invalid line " &
          natural'image(line_number) &
          " in source file - " &
          "EOL encountered while reading address";
        return;
      end if;

      parsed_data.address := parsed_data.address * 16;

      curr_digit := convert_from_hex(read_char);

      if (curr_digit = -1) then
        -- invalid input
        report "Invalid line " &
          natural'image(line_number) &
          " in source file - " &
          "error in address part";
        return;
      end if;

      parsed_data.address:= parsed_data.address + curr_digit;

      read_cnt := read_cnt + 1;
    end loop;

    
    -- skipping whitespace characters to data segment
    read_char := ' ';

    while (is_whitespace(read_char)) loop
      read(read_line, read_char, read_error);

      if (read_error = false) then
        -- invalid input
        report "Invalid line " &
          natural'image(line_number) &
          " in source file - " &
          "EOL encountered while skiping whitespace.";
        return;
      end if;
    end loop;


    -- reading data (n binary digits)
    -- first character is already read by previous block
    read_cnt := 0;
    read_cnt_limit := dbus_width;
    parsed_data.data := 0;

    while (read_cnt < read_cnt_limit) loop
      if (read_error = false) then
        -- invalid input
        report "Invalid line " &
          natural'image(line_number) &
          " in source file - " &
          "EOL encoutered while reading value.";
        return;
      end if;

      curr_digit := convert_from_binary(read_char);

      if (curr_digit = -1) then
        -- invalid input
        report "Invalid line " &
          natural'image(line_number) &
          " in source file - " &
          "error in data part.";
        return;
      end if;

      parsed_data.data := parsed_data.data * 2;
      parsed_data.data := parsed_data.data + curr_digit;

      read(read_line, read_char, read_error);
      read_cnt := read_cnt + 1;
    end loop;

    ret_val := 0;
  end procedure parse_line;

  procedure init_memory(
      signal mem: inout memory;
      source_file_name: in string;
      constant addr_width: in positive := abus_width;
      constant dbus_width: in positive := dbus_width) is
    file source_file : text open READ_MODE is source_file_name;
    variable read_line : line;
    variable line_number : natural;
    variable parsed_data : parsed_line;
    variable parse_line_res : integer;
  begin
    report "Starting initialization. Source: " & source_file_name;
    line_number := 0;

    line_loop: while not endfile(source_file) loop
      readline(source_file, read_line);
      line_number := line_number + 1;

      parse_line(
        read_line,
        line_number,
        addr_width,
        dbus_width,
        parsed_data,
        parse_line_res);

      if (parse_line_res = 0) then
        -- writing data to provided memory
        mem(parsed_data.address) <=
          std_logic_vector(to_signed(parsed_data.data, dbus_width));
      end if;
    end loop;
  end procedure init_memory;
end package body;
