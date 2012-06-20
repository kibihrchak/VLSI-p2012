vsim -t 1ns test_bench(only)

add wave *

radix signal addr -hexadecimal
radix signal data_out -hexadecimal

add wave test_bench/ROM_instance/*

radix signal test_bench/ROM_instance/addr -hexadecimal
radix signal test_bench/ROM_instance/data_out -hexadecimal
radix signal test_bench/ROM_instance/mem -hexadecimal

run 300

wave zoom range 0 300ns
