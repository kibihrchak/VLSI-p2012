library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.regpkg.all;



entity Regs is
  port (
    clk : in std_logic;
    reset : in std_logic;

    rd_reset : in std_logic;
    rd_index : in regsel;
    rd_val : in data;
    
    rs1_index : in regsel;
    rs1_avail : out std_logic;
    rs1_val : out data;

    rs2_index : in regsel;
    rs2_avail : out std_logic;
    rs2_val : out data
  );
end entity Regs;

architecture behavioral of Regs is
  type regarr is array (0 to regcnt - 1) of data;
  type cntarr is array (0 to regcnt - 1) of availcount;

  signal registers : regarr;
  signal counters : cntarr;

  signal write_en : bit;
  signal write_index : regcnttype;
begin
  rs1_avail_proc : process (rs1_index, counters) is
    variable index : regcnttype;
  begin
    index := to_integer(unsigned(rs1_index));
    if (counters(index) = 0) then
      rs1_avail <= '1';
    else
      rs1_avail <= '0';
    end if;
  end process rs1_avail_proc;

  rs1_val <= registers(to_integer(unsigned(rs1_index)));


  rs2_avail_proc : process (rs2_index, counters) is
    variable index : regcnttype;
  begin
    index := to_integer(unsigned(rs2_index));
    if (counters(index) = 0) then
      rs2_avail <= '1';
    else
      rs2_avail <= '0';
    end if;
  end process rs2_avail_proc;

  rs2_val <= registers(to_integer(unsigned(rs2_index)));


  cntr_cng : process (clk, reset, rd_index, rd_reset) is
    variable i : regcnttype;
    variable rd_ind_int : regcnttype;
  begin
    if (reset = '1') then
      for i in regcnttype'low to regcnttype'high loop
        counters(i) <= 0;
      end loop;
      write_en <= '0';
    elsif (rising_edge(clk)) then
      for i in regcnttype'low to regcnttype'high loop
        rd_ind_int := to_integer(unsigned(rd_index));
        write_en <= '0';

        if (rd_ind_int = i and rd_reset = '1') then
          counters(i) <= availcount'high;
        elsif (counters(i) /= 0) then
          if (counters(i) = 1) then
            write_en <= '1';
            write_index <= i;
          end if;

          counters(i) <= counters(i) - 1;
        end if;
      end loop;
    end if;
  end process cntr_cng;

  write_reg : process (clk, reset, write_en, write_index) is
  begin
    if (reset = '0' and rising_edge(clk) and write_en = '1') then
      registers(write_index) <= rd_val;
    end if;
  end process write_reg;
end architecture behavioral;
