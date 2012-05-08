# library creation
vlib work

# compilation in given order
vcom -reportprogress 300 -work work {../kod/d_ff.vhd}
vcom -reportprogress 300 -work work {../kod/Reset.vhd}
vcom -reportprogress 300 -work work {./test_bench.vhd}
