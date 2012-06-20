library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regpkg.all;

ENTITY Regs IS
    PORT(   clk, reset, rd_reset    : IN std_logic;
            rd_index                : IN regsel;
            rd_val                  : IN data;
            rs1_index, rs2_index    : IN regsel;
            rs1_avail, rs2_avail    : OUT std_logic;
            rs1_val, rs2_val        : OUT data
    );
end ENTITY Regs;

ARCHITECTURE behav of Regs IS
    TYPE regArray IS ARRAY (0 to regcnt - 1) of data;               -- tip registara podataka
    TYPE cntArray IS ARRAY (0 to clktowrite - 1) of availcount;     -- tip od 4 brojaca azurnosti registara
    TYPE regCntArray IS ARRAY (0 to clktowrite - 1) of regcnttype;  -- tip indexa registara na koje se odnose brojaci
    
    SIGNAL pointer      : integer := 0; -- pokazivac na slobodan brojac
    SIGNAL registers    : regArray;     -- registri    
    SIGNAL counters     : cntArray;     -- brojaci azurnosti
    SIGNAL counterIndx  : regCntArray;  -- indexi brojaca azurnosti
    SIGNAL write_en     : bit;
    SIGNAL write_index  : regcnttype;
    
    BEGIN
        rs1_avail_proc : PROCESS (rs1_index, counters, counterIndx) IS
        VARIABLE index : regcnttype;
        BEGIN
            index := to_integer(unsigned(rs1_index));
            rs1_avail <= '0';
            FOR i IN availcount'low to availcount'high LOOP
                if(counterIndx(i) = index) then
                    if(counters(i) = 0) then
                        rs1_avail <= '1';
                    else
                        rs1_avail <= '0';
                        exit;
                    end if;
                end if;
            end LOOP;
        end PROCESS rs1_avail_proc;

        rs1_val <= registers(to_integer(unsigned(rs1_index)));

        rs2_avail_proc : PROCESS (rs2_index, counters, counterIndx) IS
        VARIABLE index : regcnttype;
        BEGIN
            index := to_integer(unsigned(rs2_index));
            rs2_avail <= '0';
            FOR i IN availcount'low to availcount'high LOOP
                if(counterIndx(i) = index) then
                    if(counters(i) = 0) then
                        rs2_avail <= '1';
                    else
                        rs2_avail <= '0';
                        exit;
                    end if;
                end if;
            end LOOP;
        end PROCESS rs2_avail_proc;

        rs2_val <= registers(to_integer(unsigned(rs2_index)));

        cntr_cng : PROCESS (clk, reset, rd_index, rd_reset) IS
        VARIABLE i : regcnttype;
        VARIABLE rd_ind_int : regcnttype;
        BEGIN
            if (reset = '1') then
                FOR i IN availcount'low to availcount'high LOOP
                    counters(i) <= 0;
                end LOOP;
                write_en <= '0';
            elsif (rising_edge(clk)) then
                rd_ind_int := to_integer(unsigned(rd_index));
                write_en <= '0';
                if(rd_reset = '1') then
                    counters(pointer) <= availcount'high;
                    counterIndx(pointer) <= rd_ind_int;
                    pointer <= (pointer + 1) mod clktowrite;
                end if;
                FOR i IN availcount'low to availcount'high LOOP
                    if (counters(i) /= 0) then
                        if (counters(i) = 1) then
                            write_en <= '1';
                            write_index <= counterIndx(i);
                        end if;
                        counters(i) <= counters(i) - 1;
                    end if;
                end LOOP;
            end if;
        end PROCESS cntr_cng;

        write_reg : PROCESS (clk, reset, write_en, write_index) IS
        BEGIN
            if (reset = '0' and rising_edge(clk) and write_en = '1') then
                registers(write_index) <= rd_val;
            end if;
        end PROCESS write_reg;
end ARCHITECTURE behav;
