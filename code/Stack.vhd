library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.stackpkg.all;

ENTITY Stack IS
PORT(   clk, reset, pop, push_rst   : IN std_logic;
        data_in                     : IN data;
        error_stack                 : OUT bit; 
        avail                       : OUT std_logic;
        data_out                    : OUT data
  );
end Stack;

ARCHITECTURE behav of Stack IS
    TYPE st_mem_type IS ARRAY (0 to stack_size - 1) of data;
    SIGNAL st_mem : st_mem_type;
    SIGNAL SP : sp_type;
    SIGNAL stack_empty : bit;
    SIGNAL avail_cntr: availcount;
BEGIN
    err_proc : PROCESS (SP, stack_empty, push_rst, pop) IS
    BEGIN
        error_stack <= '0';
        if (push_rst = '1' and SP = sp_type'high) then
            error_stack <= '1';
        end if;
        if (pop = '1' and stack_empty = '1') then
            error_stack <= '1';
        end if;
    end PROCESS err_proc;

    avail_check : PROCESS (avail_cntr) IS
    BEGIN
        if (avail_cntr <= 1) then
            avail <= '1';
        else
            avail <= '0';
        end if;
    end PROCESS avail_check;

    st_ctrl : PROCESS (clk, reset, pop, avail_cntr, data_in) IS
    BEGIN
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
    end PROCESS st_ctrl;
  

    cntr_ctrl : PROCESS (clk, reset, push_rst) IS
    BEGIN
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
    end PROCESS cntr_ctrl;

    data_out <= st_mem(SP);
end ARCHITECTURE behav;