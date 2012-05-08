# TLH and resolution provided
vsim -t 1ns test_bench(only)

# add wave *
add wave test_bench/registers/*

# radix signal rd_index -decimal
# radix signal rs1_index -decimal
# radix signal rs2_index -decimal

# radix signal rd_val -hexadecimal
# radix signal rs1_val -hexadecimal
# radix signal rs2_val -hexadecimal

radix signal test_bench/registers/rd_index -unsigned
radix signal test_bench/registers/rs1_index -unsigned
radix signal test_bench/registers/rs2_index -unsigned

radix signal test_bench/registers/rd_val -hexadecimal
radix signal test_bench/registers/rs1_val -hexadecimal
radix signal test_bench/registers/rs2_val -hexadecimal

radix signal test_bench/registers/registers -hexadecimal



run 500

wave zoom range 0 500ns
