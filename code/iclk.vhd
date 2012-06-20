library ieee;
use ieee.std_logic_1164.all;

entity iCLK is
  port (
    external_clk : in std_logic;
    cpu_active : in bit;
    reset : in std_logic;

    generated_clk : out std_logic
  );
end entity iCLK;


architecture only of iCLK is
  signal last_clk_value : std_logic;
begin
  clock_generation : process (external_clk, cpu_active, reset) is
  begin
    if (cpu_active = '1' and reset /= '1') then
      generated_clk <= external_clk;
      last_clk_value <= external_clk;
    else
      generated_clk <= last_clk_value;
    end if;
  end process clock_generation;
end architecture only;
