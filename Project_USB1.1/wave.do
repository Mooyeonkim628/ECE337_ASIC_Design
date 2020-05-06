onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_timer/tb_clk
add wave -noupdate /tb_timer/tb_n_rst
add wave -noupdate -color orange /tb_timer/tb_d_plus
add wave -noupdate /tb_timer/tb_d_edge
add wave -noupdate /tb_timer/tb_rcving
add wave -noupdate -color pink /tb_timer/tb_shift_enable
add wave -noupdate /tb_timer/tb_byte_received
add wave -noupdate -divider DUT
add wave -noupdate /tb_timer/DUT/clk
add wave -noupdate /tb_timer/DUT/n_rst
add wave -noupdate /tb_timer/DUT/d_edge
add wave -noupdate /tb_timer/DUT/rcving
add wave -noupdate /tb_timer/DUT/shift_enable
add wave -noupdate /tb_timer/DUT/byte_received
add wave -noupdate /tb_timer/DUT/clear
add wave -noupdate -radix unsigned /tb_timer/DUT/count_out
add wave -noupdate -radix unsigned /tb_timer/DUT/next_count
add wave -noupdate /tb_timer/DUT/count_enable
add wave -noupdate /tb_timer/DUT/rollover_flag
add wave -noupdate /tb_timer/DUT/next_flag
add wave -noupdate -divider wraper
add wave -noupdate /tb_timer/DUT/wrap/clk
add wave -noupdate /tb_timer/DUT/wrap/n_rst
add wave -noupdate /tb_timer/DUT/wrap/clear
add wave -noupdate /tb_timer/DUT/wrap/count_enable
add wave -noupdate /tb_timer/DUT/wrap/rollover_val
add wave -noupdate -radix unsigned /tb_timer/DUT/wrap/count_out
add wave -noupdate -radix unsigned /tb_timer/DUT/wrap/next_count
add wave -noupdate /tb_timer/DUT/wrap/rollover_flag
add wave -noupdate /tb_timer/DUT/wrap/next_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {105 ns}
