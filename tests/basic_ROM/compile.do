# library creation
vlib work

# compilation in given order
vcom -reportprogress 300 -work work {../code/memory_pkg.vhd}
vcom -reportprogress 300 -work work {../code/ROM.vhd}
vcom -reportprogress 300 -work work {../tests/basic_ROM/test_bench.vhd}
