# library creation
vlib work

# compilation in given order
vcom -reportprogress 300 -work work {../code/const.vhd}
vcom -reportprogress 300 -work work {../code/memory_pkg.vhd}
vcom -reportprogress 300 -work work {../code/Res_Sel.vhd}
vcom -reportprogress 300 -work work {../code/regpkg.vhd}
vcom -reportprogress 300 -work work {../code/stackpkg.vhd}
vcom -reportprogress 300 -work work {../code/Regs.vhd}
vcom -reportprogress 300 -work work {../code/Stack.vhd}
vcom -reportprogress 300 -work work {../code/RW_Dest.vhd}
vcom -reportprogress 300 -work work {../code/RW_Stack.vhd}
vcom -reportprogress 300 -work work {../code/Prog_Count.vhd}
vcom -reportprogress 300 -work work {../code/WB_State.vhd}

vcom -reportprogress 300 -work work {../code/I*.vhd}

vcom -reportprogress 300 -work work {../code/Condition.vhd}
vcom -reportprogress 300 -work work {../code/EX*.vhd}

vcom -reportprogress 300 -work work {../code/Data_Mem.vhd}
vcom -reportprogress 300 -work work {../code/ME*.vhd}

vcom -reportprogress 300 -work work {../code/PL_Step.vhd}
vcom -reportprogress 300 -work work {../code/Error_Block.vhd}
vcom -reportprogress 300 -work work {../code/CPU_Active.vhd}

vcom -reportprogress 300 -work work {../code/reset.vhd}


vcom -reportprogress 300 -work work {../code/*.vhd}

vcom -reportprogress 300 -work work {../tests/CPU/test_bench.vhd}
