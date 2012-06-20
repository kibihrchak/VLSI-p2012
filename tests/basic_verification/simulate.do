vsim -t 1ns test_bench(only)

add wave *

radix signal addr -hexadecimal
radix signal data_in -hexadecimal
radix signal data_out -hexadecimal

add wave test_bench/RAM_instance/*

radix signal test_bench/RAM_instance/addr -hexadecimal
radix signal test_bench/RAM_instance/data_in -hexadecimal
radix signal test_bench/RAM_instance/data_out -hexadecimal
radix signal test_bench/RAM_instance/mem -hexadecimal

run 300

wave zoom range 0 300ns
