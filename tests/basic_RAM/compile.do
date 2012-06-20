# library creation
vlib work

# compilation in given order
vcom -reportprogress 300 -work work {../code/memory_pkg.vhd}
vcom -reportprogress 300 -work work {../code/RAM.vhd}
vcom -reportprogress 300 -work work {../tests/basic_RAM/test_bench.vhd}
