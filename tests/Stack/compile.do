# library creation
vlib work

# compilation in given order
vcom -reportprogress 300 -work work {../kod/stackpkg.vhd}
vcom -reportprogress 300 -work work {../kod/Stack.vhd}

vcom -reportprogress 300 -work work {./test_bench.vhd}
