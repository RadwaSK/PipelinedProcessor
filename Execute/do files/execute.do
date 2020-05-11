vsim -gui work.execute
add wave -position end sim:/execute/*
force -freeze sim:/execute/clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/execute/OpFlagIn 0 0
force -freeze sim:/execute/OpCodeIn 000001 0
force -freeze sim:/execute/Rsrc1Final 00000000000000000000000000000000 0
force -freeze sim:/execute/Rsrc2Final 00000000000000000000000000001000 0
force -freeze sim:/execute/Asel 00 0
force -freeze sim:/execute/Bsel 00 0
force -freeze sim:/execute/ALUOutLast 00000000000000000000000001000000 0
force -freeze sim:/execute/MemOut 00000000000000000000100000000000 0
force -freeze sim:/execute/PC2 10101010101010101010101010101010 0
force -freeze sim:/execute/EADecode 01010101010101010101010101010101 0
force -freeze sim:/execute/RdstDec 101 0
force -freeze sim:/execute/FlagRegIn 0000 0
run
