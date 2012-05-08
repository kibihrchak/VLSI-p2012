# TLH and resolution provided
vsim -t 1ns test_bench(only)

add wave *
add wave test_bench/instr_fetch/state_control/state

radix signal IMEM_addr -hexadecimal
radix signal IMEM_data -hexadecimal
radix signal IFout_PC -hexadecimal
radix signal IFout_instr -hexadecimal
radix signal EX_newPC -hexadecimal

run 500

wave zoom range 0 500ns
