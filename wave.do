onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipeline_tb/clock
add wave -noupdate -radix hexadecimal /pipeline_tb/i_data_in
add wave -noupdate -radix decimal /pipeline_tb/count
add wave -noupdate /pipeline_tb/words_read
add wave -noupdate -radix hexadecimal /pipeline_tb/data_read
add wave -noupdate /pipeline_tb/i_access_size
add wave -noupdate /pipeline_tb/i_rw
add wave -noupdate /pipeline_tb/i_busy
add wave -noupdate -radix hexadecimal /pipeline_tb/i_address
add wave -noupdate -radix hexadecimal /pipeline_tb/pc_FD
add wave -noupdate -radix hexadecimal /pipeline_tb/i_data_out
add wave -noupdate /pipeline_tb/stall
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 191
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {70 ps}
