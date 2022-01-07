# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules to working dir
vlog part2.v

# load simulation using the top level simulation module
vsim part2

# log all signals and add some signals to waveform window
log -r {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {ClockIn} 0 0ms, 1 {1ms} -r 2ms
force Reset 1
run 200ms

force Reset 0
force Speed 11
run 20000ms

force Reset 0
force Speed 10
run 20000ms

force Reset 0
force Speed 01
run 20000ms

force Reset 0
force Speed 00
run 20000ms


