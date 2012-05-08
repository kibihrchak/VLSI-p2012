# library creation
vlib work

# compilation in given order
vcom -reportprogress 300 -work work {../kod/const.vhd}
vcom -reportprogress 300 -work work {../kod/PL_Step.vhd}
vcom -reportprogress 300 -work work {./test_bench.vhd}
