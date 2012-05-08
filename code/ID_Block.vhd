LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

USE work.const.all;

ENTITY ID_Block IS
    PORT(step                                         : IN PL_cycles_range;
			state                                        : IN States;
			instr_Word, stack_Word                       : IN data_bus;
         halt, error_oc                               : OUT bit;
         instr_parts                                  : OUT std_logic_vector(13 downto 0);
         imm_val                                      : OUT data_bus;
         ops_stack_pop, ops_rs1_rd, ops_rs2_rd        : OUT std_logic;
         ops_rs1_index, ops_rs2_index, dst_rd_index   : OUT std_logic_vector(4 downto 0);
         dst_stack_push, dst_rd_wr                    : OUT std_logic
         );
END ID_Block;

ARCHITECTURE behav OF ID_Block IS
signal jmp        : std_logic; -- mora std_logic posto bit ne moze da se spoji
signal op_sel     : std_logic_vector(1 downto 0);
signal cond_code  : std_logic_vector(2 downto 0);
signal operation  : std_logic_vector(3 downto 0);
signal res_sel    : std_logic_vector(1 downto 0);
signal rw         : std_logic_vector(1 downto 0);
BEGIN
   PROCESS(instr_Word, state, step, stack_Word)
   BEGIN
      halt  <= '0';
      error_oc  <= '0';
      imm_val <= (others => '0');
      ops_stack_pop <= '0';
      ops_rs1_rd <= '0';
      ops_rs2_rd <= '0';
      ops_rs1_index <= (others => '0');
      ops_rs2_index <= (others => '0');
      dst_rd_index <= (others => '0');
      dst_stack_push <= '0';
      dst_rd_wr <= '0';
      
      
      
      CASE instr_Word(5 downto 0) is
         -- LOAD
         WHEN "000000" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(31 downto 16);
                          
                           jmp            <= '0';              -- 13
                           op_sel         <= "11";             -- 12 11
                           cond_code      <= "000";            -- 10 9 8
                           operation      <= "0000";  -- add   -- 7 6 5 4
                           res_sel        <= "10";    -- dbus  -- 3 2
                           rw             <= "10";             -- 1 0
         -- STORE
         WHEN "000001" =>  imm_val <= X"0000" & instr_Word(10 downto 6) & instr_Word(31 downto 21);
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           
                           jmp            <= '0';
                           op_sel         <= "11";
                           cond_code      <= "000";
                           operation      <= "0000";
                           res_sel        <= "11";    -- nebitan rezultat
                           rw             <= "01";
         -- MOV                  
         WHEN "000100" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';

                           jmp            <= '0';
                           op_sel         <= "11";    -- bitan samo prvi operand
                           cond_code      <= "000";
                           operation      <= "1100";  -- transA
                           res_sel        <= "00";    -- ALU
                           rw             <= "00";
         -- MOVI
         WHEN "000101" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           imm_val  <= X"0000" & instr_Word(31 downto 16);

                           jmp            <= '0';
                           op_sel         <= "11";    -- bitan samo drugi operand
                           cond_code      <= "000";
                           operation      <= "1101";  -- transB
                           res_sel        <= "00";
                           rw             <= "00";
         -- ADD
         WHEN "001000" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           
                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "0000";
                           res_sel        <= "00";
                           rw             <= "00";
         -- SUB
         WHEN "001001" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           
                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "0001";  -- sub
                           res_sel        <= "00";
                           rw             <= "00";
         -- ADDI
         WHEN "001100" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(31 downto 16);
                           
                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "0000";
                           res_sel        <= "00";
                           rw             <= "00";
         -- SUBI
         WHEN "001101" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(31 downto 16);
                           
                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "0001";
                           res_sel        <= "00";
                           rw             <= "00";
         -- AND
         WHEN "010000" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           
                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "0010";  -- and
                           res_sel        <= "00";
                           rw             <= "00";
         -- OR
         WHEN "010001" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           
                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "0011";  -- or
                           res_sel        <= "00";
                           rw             <= "00";
         -- XOR
         WHEN "010010" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           
                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "0100";  -- xor
                           res_sel        <= "00";
                           rw             <= "00";
         -- NOT
         WHEN "010011" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';

                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "0101";  -- notA
                           res_sel        <= "00";
                           rw             <= "00";
         -- SHL
         WHEN "011000" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(10 downto 6);
                           ops_rs1_rd     <= '1';
                           imm_val  <= b"0000_0000_0000_0000_0000_0000_000" & instr_Word(20 downto 16);
                           
                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "0110";  -- shl
                           res_sel        <= "00";
                           rw             <= "00";
         -- SHR
         WHEN "011001" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(10 downto 6);
                           ops_rs1_rd     <= '1';
                           imm_val  <= b"0000_0000_0000_0000_0000_0000_000" & instr_Word(20 downto 16);

                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "0111";  -- shr
                           res_sel        <= "00";
                           rw             <= "00";
         -- SAR
         WHEN "011010" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(10 downto 6);
                           ops_rs1_rd     <= '1';
                           imm_val  <= b"0000_0000_0000_0000_0000_0000_000" & instr_Word(20 downto 16); 

                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "1000";  -- sar
                           res_sel        <= "00";
                           rw             <= "00";
         -- ROL
         WHEN "011011" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(10 downto 6);
                           ops_rs1_rd     <= '1';
                           imm_val  <= b"0000_0000_0000_0000_0000_0000_000" & instr_Word(20 downto 16);

                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "1001";  -- rol
                           res_sel        <= "00";
                           rw             <= "00";
         -- ROR
         WHEN "011100" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_rs1_index  <= instr_Word(10 downto 6);
                           ops_rs1_rd     <= '1';
                           imm_val  <= b"0000_0000_0000_0000_0000_0000_000" & instr_Word(20 downto 16);

                           jmp            <= '0';
                           op_sel         <= "10";
                           cond_code      <= "000";
                           operation      <= "1010";  -- ror
                           res_sel        <= "00";
                           rw             <= "00";
         -- JMP
         WHEN "100000" =>  ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(31 downto 16);
                           
                           jmp            <= '1';
                           op_sel         <= "11";
                           cond_code      <= "001";   -- JMP (siguran skok)
                           operation      <= "0000";
                           res_sel        <= "00";
                           rw             <= "00";
         -- JSR
         WHEN "100001" =>  ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(31 downto 16);
                           dst_stack_push <= '1';
                           
                           jmp            <= '1';
                           op_sel         <= "11";
                           cond_code      <= "001";   -- JMP (siguran skok)
                           operation      <= "0000";
                           res_sel        <= "01";    -- rezultat ALU se odbacuje i PC smesta na stek
                           rw             <= "00";  
         -- RTS
         WHEN "100010" =>  ops_stack_pop  <= '1';     -- vrednost sa steka
         
                           imm_val        <= stack_Word; -- prosledjuje se da se upise u PC

                           
                           jmp            <= '1';
                           op_sel         <= "11";
                           cond_code      <= "001";   -- JMP (siguran skok)
                           operation      <= "1101";
                           res_sel        <= "00";
                           rw             <= "00";
         -- PUSH
         WHEN "100100" =>  ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           
                           jmp            <= '0';
                           op_sel         <= "11";
                           cond_code      <= "000";
                           operation      <= "1100";
                           res_sel        <= "00";
                           rw             <= "00";

         -- POP
         WHEN "100101" =>  dst_rd_index   <= instr_Word(10 downto 6);
                           dst_rd_wr      <= '1';
                           ops_stack_pop  <= '1';     -- vrednost sa steka
         
                           imm_val        <= stack_Word; -- prosledjuje se da se upise u PC
                           
                           jmp            <= '0';
                           op_sel         <= "11";
                           cond_code      <= "000";
                           operation      <= "1101";
                           res_sel        <= "00";
                           rw             <= "00";
         -- BEQ 
         WHEN "101000" =>  ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(10 downto 6)&instr_Word(31 downto 21);
                           
                           jmp            <= '1';
                           op_sel         <= "01";
                           cond_code      <= "010";   -- B-JMP (nesiguran skok)
                           operation      <= "0000";
                           res_sel        <= "00";
                           rw             <= "00";
         -- BNQ
         WHEN "101001" =>  ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(10 downto 6)&instr_Word(31 downto 21);
                           
                           jmp            <= '1';
                           op_sel         <= "01";
                           cond_code      <= "011";   -- B-JMP (nesiguran skok)
                           operation      <= "0000";
                           res_sel        <= "00";
                           rw             <= "00";
         -- BGT
         WHEN "101010" =>  ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(10 downto 6)&instr_Word(31 downto 21);
                           
                           jmp            <= '1';
                           op_sel         <= "01";
                           cond_code      <= "100";   -- B-JMP (nesiguran skok)
                           operation      <= "0000";
                           res_sel        <= "00";
                           rw             <= "00";
         -- BLT
         WHEN "101011" =>  ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(10 downto 6)&instr_Word(31 downto 21);
                           
                           jmp            <= '1';
                           op_sel         <= "01";
                           cond_code      <= "101";   -- B-JMP (nesiguran skok)
                           operation      <= "0000";
                           res_sel        <= "00";
                           rw             <= "00";
         -- BGE
         WHEN "101100" =>  ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(10 downto 6)&instr_Word(31 downto 21);
                           
                           jmp            <= '1';
                           op_sel         <= "01";
                           cond_code      <= "110";   -- B-JMP (nesiguran skok)
                           operation      <= "0000";
                           res_sel        <= "00";
                           rw             <= "00";
         -- BLE
         WHEN "101101" =>  ops_rs1_index  <= instr_Word(15 downto 11);
                           ops_rs1_rd     <= '1';
                           ops_rs2_index  <= instr_Word(20 downto 16);
                           ops_rs2_rd     <= '1';
                           imm_val  <= X"0000" & instr_Word(10 downto 6)&instr_Word(31 downto 21);
                           
                           jmp            <= '1';
                           op_sel         <= "01";
                           cond_code      <= "111";   -- B-JMP (nesiguran skok)
                           operation      <= "0000";
                           res_sel        <= "00";
                           rw             <= "00";
         -- HALT
         WHEN "110000" =>  halt           <= '1';
         
                           jmp            <= '0';
                           op_sel         <= "00";
                           cond_code      <= "000";
                           operation      <= "0000";
                           res_sel        <= "11";
                           rw             <= "00";
         -- GRESKA                  
         WHEN OTHERS   => 
            error_oc       <= '1';
            
            jmp            <= '0';
            op_sel         <= "00";
            cond_code      <= "000";
            operation      <= "0000";
            res_sel        <= "00";
            rw             <= "00";
         end CASE;
   END PROCESS;
   
   instr_parts    <= jmp & op_sel & cond_code & operation & res_sel & rw;
   
END behav;
