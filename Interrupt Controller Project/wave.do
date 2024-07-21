onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/dut/pclk_i
add wave -noupdate /tb/dut/prst_i
add wave -noupdate /tb/dut/pwrite_en_i
add wave -noupdate /tb/dut/pvalid_i
add wave -noupdate /tb/dut/pwdata_i
add wave -noupdate /tb/dut/paddr_i
add wave -noupdate /tb/dut/prdata_o
add wave -noupdate /tb/dut/pready_o
add wave -noupdate /tb/dut/interrupt_active_i
add wave -noupdate -radix unsigned /tb/dut/interrupt_priority_value
add wave -noupdate -radix unsigned /tb/dut/highest_priority_interrupt_peripheral
add wave -noupdate -radix unsigned /tb/dut/interrupt_to_be_serviced_o
add wave -noupdate /tb/dut/present_state
add wave -noupdate /tb/dut/next_state
add wave -noupdate /tb/dut/interrupt_serviced_i
add wave -noupdate /tb/dut/interrupt_valid_o
add wave -noupdate /tb/dut/i
add wave -noupdate /tb/dut/first_check_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 265
configure wave -valuecolwidth 108
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {417 ps}
