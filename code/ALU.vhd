LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
use IEEE.NUMERIC_STD.ALL;

USE work.const.all;

ENTITY ALU IS
   PORT( state       : IN States;
         A, B        : IN std_logic_vector(31 downto 0);
         instr_parts : IN std_logic_vector(13 downto 0);
         error_of    : OUT bit;
         result      : OUT  std_logic_vector(31 downto 0)
        );
END ALU;

architecture behav of ALU is
signal temp : std_logic_vector(32 downto 0);

BEGIN	

   PROCESS(A, B, instr_parts, temp) is
   BEGIN
      error_of <= '0';
		temp     <= (OTHERS => '0');
      CASE instr_parts(7 downto 4) is
         -- add

         WHEN "0000" => temp <= std_logic_vector((unsigned("0" & A) + unsigned(B)));
                        result <= temp(31 downto 0);
                        error_of   <= to_bit(temp(32));
         -- sub
         WHEN "0001" => temp <= std_logic_vector(unsigned("0" & A) - unsigned(B));
                        result <= temp(31 downto 0);
                        error_of   <= to_bit(temp(32));
         -- and
         WHEN "0010" => result <= A and B;
         -- or
         WHEN "0011" => result <= A or B;
         -- xor
         WHEN "0100" => result <= A xor B;
         -- notA
         WHEN "0101" => result <= not A;
         -- shl
         WHEN "0110" => result <= std_logic_vector(unsigned(A) sll to_integer(unsigned(B)));
         -- shr
         WHEN "0111" => result <= std_logic_vector(unsigned(A) srl to_integer(unsigned(B)));
         -- sar
--         WHEN "1000" => result <= std_logic_vector(signed(A) sra to_integer(unsigned(B)));
         -- rol
         WHEN "1001" => result <= std_logic_vector(unsigned(A) rol to_integer(unsigned(B)));
         -- ror
         WHEN "1010" => result <= std_logic_vector(unsigned(A) ror to_integer(unsigned(B)));
         -- transA
         WHEN "1100" => result <= A;
         -- transB
         WHEN "1101" => result <= B;
         WHEN OTHERS => result   <= (OTHERS => '0'); 
      end CASE;
    END PROCESS;
END behav;