library ieee;
use ieee.std_logic_1164.all;

use work.const.all;


entity test_bench is
end entity test_bench;

architecture only of test_bench is
  -- opsti signali
  signal clk : std_logic;
  signal reset : std_logic;
  signal cpu_active : std_logic;

  -- signali memorija
  signal IMEM_en : std_logic;
  signal IMEM_rd : std_logic;
  signal IMEM_addr : addr_bus;
  signal IMEM_data : data_bus;

  signal DMEM_en : std_logic;
  signal DMEM_rd : std_logic;
  signal DMEM_wr : std_logic;
  signal DMEM_verification : bit;
  signal DMEM_addr : addr_bus;
  signal DMEM_data_in : data_bus;
  signal DMEM_data_out : data_bus;
    
  -- ostale stvari za testiranje
  constant init_path : string := "../tests/CPU/";
  constant clk_period : time := 20 ns;

begin

  -- procesor
  cpu : entity work.CPU(struct)
    port map (
      clk, reset, cpu_active,

      IMEM_rd,
      IMEM_addr,
      IMEM_data,

      DMEM_rd,
      DMEM_wr,
      DMEM_addr,
      DMEM_data_in,
      DMEM_data_out);

  -- memorija za instrukcije
  intruction_mem : entity work.ROM(behav)
    generic map (init_path & "imem.init")
    port map (
      IMEM_en,
      clk,

      IMEM_rd,
      IMEM_addr,
      IMEM_data);

  -- memorija za podatke
  data_mem : entity work.RAM(behav)
    generic map (init_path & "dmem.init")
    port map (
      DMEM_en,
      clk,

      DMEM_rd,
      DMEM_wr,

      DMEM_addr,
      DMEM_data_in,
      DMEM_data_out,
    
      DMEM_verification);


  -- generator takta
  clk_gen : process is
  begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
  end process clk_gen;


  -- generator signala
  signal_gen : process is
  begin
    IMEM_en <= '1';
    DMEM_en <= '1';
    reset <= '1';

    wait for clk_period * 2.1;

    reset <= '0';

    wait;
  end process signal_gen;
end architecture only;
