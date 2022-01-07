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

#black out the screen
force iBlack {1}
run 200 ns

#reset all the values back to zero...also checks in the loading of certain vlaues
force iXYCoord {1}
force iLoadX {1}
force iColour {1}
run 200 ns

force iResetn {1}
run 200 ns

#checking loading of Y and plotting of box
force iPlotBox {1}
run 200 ns






