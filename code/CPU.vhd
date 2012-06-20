library ieee;
use ieee.std_logic_1164.all;

use work.const.all;

entity CPU is
  port (
    -- osnovni signali
    outCLK : in std_logic;
    outRESET : in std_logic;
    cpu_active : out std_logic;

    -- instrucion magistrala
    IMEM_rd : out std_logic;
    IMEM_addr : out addr_bus;
    IMEM_data : in data_bus;

    -- data magistrala
    DMEM_rd : out std_logic;
    DMEM_wr : out std_logic;
    DMEM_addr : out addr_bus;
    DMEM_data_in : in data_bus;
    DMEM_data_out : out data_bus);
end entity CPU;


architecture struct of CPU is
  -- interni signali
  signal clk : std_logic;
  signal reset : std_logic;
  signal err : bit;
  signal step : PL_cycles_range;
  signal active_CPU : bit;


  -- signali pipeline stepeni

  -- IF
  signal error_IF : bit;
  signal PC_IF : data_bus;
  signal data_out_IF : data_bus;
  signal if_st : States;

  -- ID
  signal error_ID : bit;
  signal id_halt : bit;
  signal PC_ID : data_bus;
  signal imm_val : data_bus; 
  signal instr_parts_ID : std_logic_vector(13 downto 0); 
  signal out_rs1_val, out_rs2_val : data_bus;
  signal id_st : States;

  -- EX
  signal error_EX : bit;
  signal ex_jmp : bit;
  signal ex_flush : bit;
  signal PC_EX : data_bus;
  signal out_alu : data_bus; 
  signal out_rs2_val_EX : data_bus;
  signal instr_parts_EX : std_logic_vector(3 downto 0); 
  signal PC_new : data_bus;
  signal ex_st : States;

  -- MEM
  signal out_result : data_bus;
  signal mem_st : States;

  -- WB
  signal wb_st : States;


  -- ostali signali

  -- registri
  signal rd_reset : std_logic;
  signal rd_index : std_logic_vector(4 downto 0);
  signal rs1_index, rs2_index : std_logic_vector(4 downto 0);
  signal rs1_avail, rs2_avail : std_logic;
  signal rs1_val, rs2_val : data_bus;
      
  -- stek
  signal pop, push : std_logic;
  signal error_St : bit;
  signal stack_avail : std_logic;
  signal stack_Word : data_bus;

begin

  -- pipeline stepeni

  instr_fetch : ENTITY work.Instr_fetch(behav)
    PORT MAP (
      clk, step, reset,
      -- signali iz ID stepena
      id_st, id_halt,
      -- data bus instr. memorije, `flush` signal iz EX stepena,
      --    novi PC iz EX stepena, `error` signal za rad sa memorijom
      IMEM_data, ex_flush, PC_new, err,
      -- `error` signal IF stepena, signali za rad sa instr. memorijom,
      error_IF, IMEM_addr, IMEM_rd,
      -- izlazi stepena - PC, procitana instrukcija, stanje
      PC_IF, data_out_IF, if_st);	
   
  instr_decode : ENTITY work.Instr_decode(behav)
    PORT MAP (
      -- `jmp` i `flush`: iz EX stepena, signal potencijalnog skoka i
      --    signal za izvrsavanje skoka
      clk, reset, ex_jmp, ex_flush, step,
      -- ulazi iz IF stepena
      if_st, data_out_IF, PC_IF,
      -- signali za rad sa registrima i stekom
      rs1_avail, rs2_avail, stack_avail, rs1_val, rs2_val, 
      -- ulaz sa steka, stanje ID stepena, `halt` signal - izlaz ID stepena
      --    signal greske ID stepena, reset signal za odr. registar
      --    signali za rad sa stekom
      stack_Word, id_st, id_halt, error_ID, rd_reset, pop, push, 
      -- signali za rad sa stekom (prva tri)
      --    izlazi ID stepena: PC, neposredna vrednost/stek, dekodovana
      --    instrukcija, Rs1 i Rs2
      rs1_index, rs2_index, rd_index, PC_ID, imm_val, instr_parts_ID, 
      out_rs1_val, out_rs2_val);

  execution : ENTITY work.EXecution(behav)
    PORT MAP (
      clk, reset, step,
      -- ulazi iz ID stepena: stanje, PC, registri, nep/stek
      --    dekodovana instrukcija
      id_st, PC_ID, out_rs1_val, out_rs2_val, imm_val, instr_parts_ID,
      -- izlaz za stanje EX stepena,
      --    izlazi za izvrsavanje skoka, za potencijalni skok
      --    izlaz za gresku EX stepena
      ex_st, ex_flush, ex_jmp, error_EX,
      -- izlazi EX stepena: PC, izlaz ALU jedinice, Rs2, novi PC za skok,
      --    potrebni delovi instrukcije za MEM 
      PC_EX, out_ALU, out_rs2_val_EX, PC_new, instr_parts_EX);
 
  memory : ENTITY work.MEMory(behav)
    PORT MAP (
      clk, reset, step,
      -- ulazi iz EX stepena
      ex_st, PC_EX, out_ALU, out_rs2_val_EX, instr_parts_EX,
      -- ulaz za gresku za prekidanje rada sa memorijom,
      --    izlaz za stanje MEM stepena,
      --    linije za rad sa memorijom za podatke
      err, mem_st, DMEM_rd, DMEM_wr, DMEM_addr,
      -- izlaz za rezultat izvrsavanja instrukcije
      --    [!!!] direktno je povezan na stek/registre
      -- linije za rad sa memorijom za podatke
      out_result, DMEM_data_in, DMEM_data_out);
 
  write_back : ENTITY work.WB_State(behav)
    PORT MAP (
      step, reset, clk,
      -- stanje MEM stepena
      mem_st,
      -- izlaz za stanje WB stepena
      wb_st);   


  --------------------------------------------------


  -- ostali blokovi


  -- registri i stek

  register_block : ENTITY work.Regs(behav)
    PORT MAP(
      clk, reset,
      rd_reset, rd_index, out_result,
      rs1_index, rs2_index,
      rs1_avail, rs2_avail,
      rs1_val, rs2_val);
      
  stack : ENTITY work.Stack(behav)
    PORT MAP(
      clk, reset,
      pop, push,
      out_result, error_St,
      stack_avail, stack_Word);


  -- generator step-a

  stepper : ENTITY work.PL_Step(behav)
    PORT MAP(reset, clk, step);


  -- generator signala greske

  error_block : ENTITY work.Error_Block(behav)
    PORT MAP(error_IF, error_ID, error_St, error_EX, err);

  -- generator signala aktivnosti procesora

  cpu_on : ENTITY work.CPU_Active(behav)
    PORT MAP(
      if_st, id_st, ex_st, mem_st, wb_st,
      active_CPU);


  -- generator reset signala
  internal_clk : entity work.iCLK(only)
    port map (outCLK, active_CPU, reset, clk);

  -- generator internog kloka
  reset_generator : entity work.reset(only)
    port map (outRESET, outCLK, reset);


  cpu_active <= To_StdULogic(active_CPU);
  --------------------------------------------------
end architecture struct;
