library ieee;
use ieee.std_logic_1164.all;

entity reset is
  port (
    external_reset : in std_logic;
    external_clk : in std_logic;
    
    generated_reset : out std_logic
  );
end entity reset;


architecture only of reset is
  signal reset_FF : std_logic;
begin
  reset_generation : process (external_reset, external_clk) is
  begin
    if (external_reset = '1' and external_reset'event) then
      reset_FF <= '1';
    elsif (rising_edge(external_clk) and external_reset /= '1') then
      reset_FF <= '0';
    end if;
  end process reset_generation;

  generated_reset <= reset_FF;
end architecture only;
