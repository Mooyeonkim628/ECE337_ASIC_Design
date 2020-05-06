onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold -radix unsigned /tb_adder_16bit/tb_test_case_num
add wave -noupdate -color Gold -radix unsigned /tb_adder_16bit/tb_test_case_err
add wave -noupdate -divider dut
add wave -noupdate -radix unsigned /tb_adder_16bit/tb_expected_outs
add wave -noupdate -expand -group sum -color Cyan -radix unsigned /tb_adder_16bit/tb_expected_sum
add wave -noupdate -expand -group sum -color {Dark Orchid} -radix unsigned /tb_adder_16bit/tb_sum
add wave -noupdate -expand -group overflow -color Cyan -radix unsigned /tb_adder_16bit/tb_expected_overflow
add wave -noupdate -expand -group overflow -color {Dark Orchid} -radix unsigned /tb_adder_16bit/tb_overflow
add wave -noupdate -radix unsigned /tb_adder_16bit/tb_a
add wave -noupdate -radix unsigned /tb_adder_16bit/tb_b
add wave -noupdate -radix unsigned /tb_adder_16bit/tb_carry_in
add wave -noupdate -radix unsigned /tb_adder_16bit/DUT/a
add wave -noupdate -radix unsigned /tb_adder_16bit/DUT/b
add wave -noupdate -radix unsigned /tb_adder_16bit/DUT/carry_in
add wave -noupdate -radix unsigned /tb_adder_16bit/DUT/sum
add wave -noupdate -radix unsigned /tb_adder_16bit/DUT/overflow
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31000 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {105 ns}
