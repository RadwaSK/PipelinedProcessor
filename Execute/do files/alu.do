vsim -gui work.alu
add wave -position end sim:/alu/*
force -freeze sim:/alu/clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/alu/A 00000000000000000000000000000000 0
force -freeze sim:/alu/B 00000000000000000000000000000001 0

force -freeze sim:/alu/NOP 1 0
force -freeze sim:/alu/NopA 0 0
force -freeze sim:/alu/NopB 0 0
force -freeze sim:/alu/NotA 0 0
force -freeze sim:/alu/IncA 0 0
force -freeze sim:/alu/DecA 0 0
force -freeze sim:/alu/AswapB 0 0
force -freeze sim:/alu/AaddB 0 0
force -freeze sim:/alu/AsubB 0 0
force -freeze sim:/alu/AandB 0 0
force -freeze sim:/alu/AorB 0 0
force -freeze sim:/alu/AshlB 0 0
force -freeze sim:/alu/AshrB 0 0
force -freeze sim:/alu/Cin 0 0
force -freeze sim:/alu/ZFin 1 0
force -freeze sim:/alu/Nin 0 0
run

force -freeze sim:/alu/NOP 0 0
force -freeze sim:/alu/NopA 1 0
run

force -freeze sim:/alu/NopA 0 0
force -freeze sim:/alu/NopB 1 0
run

force -freeze sim:/alu/NopB 0 0
force -freeze sim:/alu/NotA 1 0
run

force -freeze sim:/alu/NotA 0 0
force -freeze sim:/alu/IncA 1 0
run

force -freeze sim:/alu/A 00000000000000000000000000000100 0
force -freeze sim:/alu/IncA 0 0
force -freeze sim:/alu/DecA 1 0
run

force -freeze sim:/alu/DecA 0 0
force -freeze sim:/alu/AaddB 1 0
run

force -freeze sim:/alu/A 11111111111111111111111111111111 0
force -freeze sim:/alu/B 11111111111111111111111111111111 0
force -freeze sim:/alu/Cin 0 0
force -freeze sim:/alu/DecA 0 0
force -freeze sim:/alu/AaddB 1 0
run

force -freeze sim:/alu/A 11111111111111111111111111111111 0
force -freeze sim:/alu/B 01111111111111111111111111111111 0
force -freeze sim:/alu/Cin 0 0
force -freeze sim:/alu/AaddB 0 0
force -freeze sim:/alu/AsubB 1 0
run

force -freeze sim:/alu/B 11111111111111111111111111111111 0
force -freeze sim:/alu/Cin 0 0
run

force -freeze sim:/alu/A 01010101010101010101010101010101 0
force -freeze sim:/alu/B 11111111111111111111111111111111 0
force -freeze sim:/alu/AsubB 0 0
force -freeze sim:/alu/AandB 1 0
run

force -freeze sim:/alu/AandB 0 0
force -freeze sim:/alu/AorB 1 0
run

force -freeze sim:/alu/A 00000100000000000100000001000001 0
force -freeze sim:/alu/B 00000000000000000000000000000101 0
force -freeze sim:/alu/AorB 0 0
force -freeze sim:/alu/AshlB 1 0
run

force -freeze sim:/alu/A 10000100000000000100000001000001 0
force -freeze sim:/alu/B 00000000000000000000000000000111 0
force -freeze sim:/alu/AshlB 0 0
force -freeze sim:/alu/AshrB 1 0
run