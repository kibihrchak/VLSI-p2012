# TLH and resolution provided
vsim -t 1ns test_bench(only)

add wave *

radix signal test_bench/data_in -hexadecimal
radix signal test_bench/data_out -hexadecimal


run 500

wave zoom range 0 500ns
