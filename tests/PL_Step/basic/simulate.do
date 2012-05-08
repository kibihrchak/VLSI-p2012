# TLH and resolution provided
vsim -t 1ns test_bench(only)

add wave *

run 300

wave zoom range 0 300ns
