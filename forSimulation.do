vsim -gui work.cpu_main
add wave -position end sim:/cpu_main/Decode/*
add wave -position end sim:/cpu_main/Fetch/*
add wave -position end sim:/cpu_main/Execute0/*

force -freeze sim:/cpu_main/IR 1000100000000000 0
force -freeze sim:/cpu_main/Decode/xregisterfile/R0/Reg/q 01010101010101010101010101010101 0
force -freeze sim:/cpu_main/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/cpu_main/Rst 0 0
force -freeze sim:/cpu_main/Fetch/selt1 000 0
force -freeze sim:/cpu_main/Fetch/selt2 000 0

run 100ps
noforce sim:/cpu_main/Fetch/selt1
noforce sim:/cpu_main/Fetch/selt2
noforce sim:/cpu_main/Fetch/IR
run
run
run