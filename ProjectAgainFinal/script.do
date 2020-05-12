vlib work
vcom  mux.vhd 
vcom  Reg.vhd 
vcom  Ram.vhd
vcom  fetch_main.vhd

vsim -gui work.FetMpd

add wave -position insertpoint sim:/fetmpd/*
force -freeze sim:/fetmpd/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fetmpd/selt1 000 0
force -freeze sim:/fetmpd/selt2 000 0
force -freeze sim:/fetmpd/IR 1000100000000000 0
run 100ps
noforce sim:/fetmpd/IR
noforce sim:/fetmpd/selt2
noforce sim:/fetmpd/selt1
run 100ps