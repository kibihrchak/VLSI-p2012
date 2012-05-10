# library creation
vlib work

# compilation in given order
vcom -reportprogress 300 -work work {../kod/regpkg.vhd}
vcom -reportprogress 300 -work work {../kod/Regs.vhd}

vcom -reportprogress 300 -work work {./test_bench.vhd}
