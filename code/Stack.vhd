library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.stackpkg.all;

entity Stack is
  port (
    clk : in std_logic;
    reset : in std_logic;

    pop : in std_logic;
    push_rst : in std_logic;
    data_in : in data;
    
    error_stack : out std_logic;
    avail : out std_logic;
    data_out : out data
  );
end entity Stack;

architecture behavioral of Stack is
  type st_mem_type is array (0 to stack_size - 1) of data;
  signal st_mem : st_mem_type;

  signal SP : sp_type;
  signal stack_empty : bit;

  signal avail_cntr: availcount;
begin
  err_proc : process (SP, stack_empty, push_rst, pop) is
  begin
    error_stack <= '0';

    if (push_rst = '1' and SP = sp_type'high) then
      error_stack <= '1';
    end if;

    if (pop = '1' and stack_empty = '1') then
      error_stack <= '1';
    end if;
  end process err_proc;


  avail_check : process (avail_cntr) is
  begin
    if (avail_cntr <= 1) then
      avail <= '1';
    else
      avail <= '0';
    end if;
  end process avail_check;


  st_ctrl : process (clk, reset, pop, avail_cntr, data_in) is
  begin
    if (reset = '1') then
      stack_empty <= '1';
      SP <= 0;
    elsif (rising_edge(clk)) then
      if (avail_cntr = 1) then
        if (stack_empty = '1') then
          stack_empty <= '0';
          st_mem(0) <= data_in;
        else
          st_mem(SP + 1) <= data_in;
          SP <= SP + 1;
        end if;
      elsif (pop = '1') then
        if (SP = 0) then
          stack_empty <= '1';
        else
          SP <= SP - 1;
        end if;
      end if;
    end if;
  end process st_ctrl;
  

  cntr_ctrl : process (clk, reset, push_rst) is
  begin
    if (reset = '1') then
      avail_cntr <= 0;
    elsif (rising_edge(clk)) then
      if (push_rst = '1') then
        avail_cntr <= availcount'high;
      else
        if (avail_cntr > 0) then
          avail_cntr <= avail_cntr - 1;
        end if;
      end if;
    end if;
  end process cntr_ctrl;


  data_out <= st_mem(SP);
end architecture behavioral;
