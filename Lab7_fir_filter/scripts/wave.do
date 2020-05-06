onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fir_filter/tb_test_case_num
add wave -noupdate /tb_fir_filter/DUT/alu/overflow
add wave -noupdate /tb_fir_filter/tb_clk
add wave -noupdate /tb_fir_filter/tb_n_reset
add wave -noupdate /tb_fir_filter/tb_data_ready
add wave -noupdate /tb_fir_filter/tb_load_coeff
add wave -noupdate -radix decimal /tb_fir_filter/tb_sample
add wave -noupdate -radix hexadecimal /tb_fir_filter/tb_coeff
add wave -noupdate /tb_fir_filter/tb_one_k_samples
add wave -noupdate /tb_fir_filter/tb_modwait
add wave -noupdate -color pink /tb_fir_filter/tb_err
add wave -noupdate -radix decimal /tb_fir_filter/tb_fir_out
add wave -noupdate -radix decimal /tb_fir_filter/tb_expected_fir_out
add wave -noupdate /tb_fir_filter/tb_test_sample_num
add wave -noupdate /tb_fir_filter/tb_std_test_case
add wave -noupdate /tb_fir_filter/tb_expected_err
add wave -noupdate /tb_fir_filter/tb_expected_one_k_samples
add wave -noupdate /tb_fir_filter/DUT/ctrl/state
add wave -noupdate -expand /tb_fir_filter/DUT/alu/RF/regs_matrix
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2915577 ps} 0}
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
WaveRestoreZoom {2827766 ps} {2992053 ps}
