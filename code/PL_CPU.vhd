LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY PL_CPU IS
PORT(   clk, reset                                          : IN std_logic;
        step                                                : IN PL_cycles_range;
        IMEM_data, rs1_val, rs2_val, stack_Word, DM_dataIn  : IN data_bus;
        error                                               : IN bit;
        rs1_avail, rs2_avail, stack_avail                   : IN std_logic;
        error_PC, error_ID, error_EX                        : OUT bit;
        IMEM_rd                                             : OUT std_logic;
        IMEM_addr 	                                        : OUT addr_bus;
        rd_reset, pop, push                                 : OUT std_logic;
        rs1_index, rs2_index, rd_index                      : OUT std_logic_vector(4 downto 0);
        DM_read, DM_write                                   : OUT std_logic;
        DM_addr, DM_dataOut                                 : OUT data_bus;
        out_result                                          : OUT data_bus;
        IF_State, ID_State, EX_State, MEM_State, WB_State   : OUT States
);
END PL_CPU;

ARCHITECTURE behav OF PL_CPU IS
    signal halt                                                                                                 : bit;
    signal flush, jmp                                                                                           : bit;
    
    signal PC_new, PC_ID, PC_IF, PC_EX, data_out, imm_val, out_rs1_val, out_rs2_val, out_ALU, out_rs2_val_EX    : data_bus;
    signal instr_parts_ID                                                                                       : std_logic_vector(13 downto 0);
    signal instr_parts_EX                                                                                       : std_logic_vector(3 downto 0);
    signal if_st, id_st, ex_st, mem_st, wb_st                                                                   : States;
BEGIN
    IF_State <= if_st;
    ID_State <= id_st;
    EX_State <= ex_st;
    MEM_State <= mem_st;
    WB_State <= wb_st;
    instr_fetch : ENTITY work.Instr_fetch(behav)
		PORT MAP (clk, step, reset, id_st, halt, IMEM_data, flush, PC_new, error,
                    error_PC, IMEM_addr, IMEM_rd, PC_IF, data_out, if_st);	
   
    instr_decode : ENTITY work.Instr_decode(behav)
        PORT MAP (clk, reset, jmp, flush, step, if_st, data_out, PC_IF,
                  rs1_avail, rs2_avail, stack_avail, rs1_val, rs2_val, 
                  stack_Word, id_st, halt, error_ID, rd_reset, pop, push, 
                  rs1_index, rs2_index, rd_index, PC_ID, imm_val, instr_parts_ID, 
                  out_rs1_val, out_rs2_val);

    execution : ENTITY work.EXecution(behav)
        PORT MAP (clk, reset, step, id_st, PC_ID, out_rs1_val, out_rs2_val, imm_val,
                  instr_parts_ID, ex_st, flush, jmp, error_EX, PC_EX, out_ALU, 
                  out_rs2_val_EX, PC_new, instr_parts_EX);
   
    memory : ENTITY work.MEMory(behav)
        PORT MAP (clk, reset, step, ex_st, PC_EX, out_ALU, out_rs2_val_EX, 
                  instr_parts_EX, error, mem_st, DM_read, DM_write, DM_addr,
                  out_result, DM_dataIn, DM_dataOut);
   
    write_back : ENTITY work.WB_State(behav)
        PORT MAP (step, reset, clk, mem_st, wb_st);   
      
END behav;