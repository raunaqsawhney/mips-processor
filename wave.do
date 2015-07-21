onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /pipeline_tb/clock
add wave -noupdate -radix hexadecimal /pipeline_tb/i_mem_enable
add wave -noupdate -radix hexadecimal /pipeline_tb/stall
add wave -noupdate -radix hexadecimal /pipeline_tb/pc_FD
add wave -noupdate -radix hexadecimal /pipeline_tb/i_data_out
add wave -noupdate -radix hexadecimal /pipeline_tb/pc_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/IR_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/rA_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/rB_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/br_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/jp_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/aluinb_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/aluop_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/dmwe_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/rwe_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/rdst_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/rwd_DX
add wave -noupdate /pipeline_tb/dm_byte_DX
add wave -noupdate -radix hexadecimal /pipeline_tb/pc_effective
add wave -noupdate -radix hexadecimal /pipeline_tb/do_branch
add wave -noupdate -radix hexadecimal /pipeline_tb/pc_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/IR_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/E0/hi
add wave -noupdate -radix hexadecimal /pipeline_tb/E0/lo
add wave -noupdate -radix hexadecimal /pipeline_tb/aluOut_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/rBOut_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/br_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/jp_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/aluinb_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/aluop_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/dmwe_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/rwe_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/rdst_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/rwd_XM
add wave -noupdate /pipeline_tb/dm_byte_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/DM/rw
add wave -noupdate -radix hexadecimal /pipeline_tb/d_mem_enable
add wave -noupdate -radix hexadecimal /pipeline_tb/DM/address
add wave -noupdate -radix hexadecimal /pipeline_tb/DM/data_in
add wave -noupdate -radix hexadecimal /pipeline_tb/DM/data_out
add wave -noupdate -radix hexadecimal /pipeline_tb/pc_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/IR_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/o_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/br_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/jp_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/aluinb_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/aluop_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/dmwe_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/rwe_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/rdst_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/rwd_MW
add wave -noupdate /pipeline_tb/dm_byte_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/rwe_wb
add wave -noupdate -radix hexadecimal /pipeline_tb/do_mx_bypass_a
add wave -noupdate -radix hexadecimal /pipeline_tb/do_mx_bypass_b
add wave -noupdate -radix hexadecimal /pipeline_tb/do_wx_bypass_a
add wave -noupdate -radix hexadecimal /pipeline_tb/do_wx_bypass_b
add wave -noupdate -radix hexadecimal /pipeline_tb/do_wm_bypass
add wave -noupdate -radix hexadecimal /pipeline_tb/rd_XM
add wave -noupdate -radix hexadecimal /pipeline_tb/rd_MW
add wave -noupdate -radix hexadecimal /pipeline_tb/do_load_use_stall
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/br
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/jp
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/aluinb
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/aluop
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/dmwe
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/rwe
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/rdst
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/rwd
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/o
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/dataout
add wave -noupdate -radix hexadecimal /pipeline_tb/W0/insn_to_d
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 196
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
WaveRestoreZoom {122 ps} {184 ps}
