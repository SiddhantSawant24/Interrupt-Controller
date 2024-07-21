vlib work
vlog tb.v
vsim tb +testcase=Lowest_peri_Lowest_val
#add wave -position insertpoint sim:/tb/dut/*
do wave.do
run -all

