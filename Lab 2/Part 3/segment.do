vlib work

vlog part3.v

vsim hex_decoder

log {/*}
add wave {/*}

force {c3} 0
force {c2} 0 
force {c1} 0
force {c0} 0
run 10ns

force {c3} 0
force {c2} 0 
force {c1} 0
force {c0} 1
run 10ns

force {c3} 0
force {c2} 0 
force {c1} 1
force {c0} 0
run 10ns

force {c3} 0
force {c2} 0 
force {c1} 1
force {c0} 1
run 10ns

force {c3} 0
force {c2} 1 
force {c1} 0
force {c0} 0
run 10ns

force {c3} 0
force {c2} 1 
force {c1} 0
force {c0} 1
run 10ns

force {c3} 0
force {c2} 1 
force {c1} 1
force {c0} 0
run 10ns

force {c3} 0
force {c2} 1 
force {c1} 1
force {c0} 1
run 10ns

force {c3} 1
force {c2} 0 
force {c1} 0
force {c0} 0
run 10ns

force {c3} 1
force {c2} 0 
force {c1} 0
force {c0} 1
run 10ns

force {c3} 1
force {c2} 0 
force {c1} 1
force {c0} 0
run 10ns

force {c3} 1
force {c2} 0 
force {c1} 1
force {c0} 1
run 10ns

force {c3} 1
force {c2} 1 
force {c1} 0
force {c0} 0
run 10ns

force {c3} 1
force {c2} 1
force {c1} 0
force {c0} 1
run 10ns

force {c3} 1
force {c2} 1 
force {c1} 1
force {c0} 0
run 10ns

force {c3} 1
force {c2} 1 
force {c1} 1
force {c0} 1
run 10ns