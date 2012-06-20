LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY System IS
   PORT (   clk, reset                  : IN std_logic;
            IMEM_enable, DMEM_enable    : IN std_logic;
            active_CPU                  : OUT bit
   );
END System;

ARCHITECTURE behav OF System IS
    signal step                                                 : PL_cycles_range;
    signal IMEM_data, rs1_val, rs2_val, stack_Word, DM_dataIn   : data_bus;
    signal error                                                : bit;
    signal rs1_avail, rs2_avail, stack_avail, IMEM_rd           : std_logic;
    signal error_PC, error_ID, error_EX, error_St               : bit;
    signal IMEM_addr 	                                        : addr_bus;
    signal rd_reset, pop, push                                  : std_logic;
    signal rs1_index, rs2_index, rd_index                       : std_logic_vector(4 downto 0);
    signal DM_read, DM_write                                    : std_logic;
    signal DM_addr, DM_dataOut                                  : data_bus;
    signal DM_data, out_result                                  : data_bus;
    signal IF_State, ID_State, EX_State, MEM_State, WB_State    : States;
BEGIN
    cpu : ENTITY work.PL_CPU(behav)
        PORT MAP(clk, reset, step, IMEM_data, rs1_val, rs2_val, stack_Word, DM_dataOut, 
                 error, rs1_avail, rs2_avail, stack_avail, error_PC, error_ID, error_EX, 
                 IMEM_rd, IMEM_addr, rd_reset, pop, push, rs1_index, rs2_index, rd_index, 
                 DM_read, DM_write, DM_addr, DM_dataIn, out_result, IF_State, ID_State, 
                 EX_State, MEM_State, WB_State);
    
    stepper : ENTITY work.PL_Step(behav)
        PORT MAP(reset, clk, step);
    
    register_block : ENTITY work.Regs(behav)
        PORT MAP(clk, reset, rd_reset, rd_index, out_result, rs1_index, rs2_index, rs1_avail, 
                 rs2_avail, rs1_val, rs2_val);
        
    stack : ENTITY work.Stack(behav)
        PORT MAP(clk, reset, pop, push, out_result, error_St, stack_avail, stack_Word);
        
    if_memory : ENTITY work.ROM(behav)
        GENERIC MAP("../file/rom_init_file_00")
        PORT MAP(IMEM_enable, clk, IMEM_rd, IMEM_addr, IMEM_data);
        
    error_block : ENTITY work.Error_Block(behav)
        PORT MAP(error_PC, error_ID, error_St, error_EX, error);
        
    cpu_on : ENTITY work.CPU_Active(behav)
        PORT MAP(IF_State, ID_State, EX_State, MEM_State, WB_State, active_CPU);
        
    mem_memory : ENTITY work.RAM(behav)
        GENERIC MAP("../file/ram_init_file_00")
        PORT MAP(DMEM_enable, clk, DM_read, DM_write, DM_addr, DM_dataIn, DM_dataOut, '0');
        
END behav;



















    
