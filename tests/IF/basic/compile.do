# library creation
vlib work

# compilation in given order
vcom -reportprogress 300 -work work {../kod/const.vhd}
vcom -reportprogress 300 -work work {../kod/d_ff.vhd}

vcom -reportprogress 300 -work work {../kod/PL_Step.vhd}

vcom -reportprogress 300 -work work {../kod/IF_Bus.vhd}
vcom -reportprogress 300 -work work {../kod/IF_Out.vhd}
vcom -reportprogress 300 -work work {../kod/IF_State.vhd}
vcom -reportprogress 300 -work work {../kod/Prog_Count.vhd}
vcom -reportprogress 300 -work work {../kod/Instr_Fetch.vhd}

vcom -reportprogress 300 -work work {./IMEM.vhd}
vcom -reportprogress 300 -work work {./test_bench.vhd}
