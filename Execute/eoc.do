vsim -gui work.eoc
add wave -position end sim:/eoc/*
force -freeze sim:/eoc/clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/eoc/OpFlag 1 0
run

force -freeze sim:/eoc/OpFlag 0 0
force -freeze sim:/eoc/OpCode 000101 0
run

force -freeze sim:/eoc/OpCode 000010 0
run

force -freeze sim:/eoc/OpCode 010010 0
run

force -freeze sim:/eoc/OpCode 011000 0
run

force -freeze sim:/eoc/OpCode 010000 0
run