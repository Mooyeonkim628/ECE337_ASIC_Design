onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_apb_uart_rx/tb_test_case_num
add wave -noupdate /tb_apb_uart_rx/tb_enqueue_transaction
add wave -noupdate /tb_apb_uart_rx/tb_transaction_write
add wave -noupdate /tb_apb_uart_rx/tb_transaction_fake
add wave -noupdate /tb_apb_uart_rx/tb_transaction_addr
add wave -noupdate /tb_apb_uart_rx/tb_transaction_data
add wave -noupdate /tb_apb_uart_rx/tb_transaction_error
add wave -noupdate /tb_apb_uart_rx/tb_enable_transactions
add wave -noupdate /tb_apb_uart_rx/tb_current_transaction_num
add wave -noupdate /tb_apb_uart_rx/tb_model_reset
add wave -noupdate /tb_apb_uart_rx/tb_test_data
add wave -noupdate /tb_apb_uart_rx/tb_test_bit_period
add wave -noupdate /tb_apb_uart_rx/tb_mismatch
add wave -noupdate -color orange /tb_apb_uart_rx/tb_check
add wave -noupdate /tb_apb_uart_rx/tb_clk
add wave -noupdate /tb_apb_uart_rx/tb_n_rst
add wave -noupdate /tb_apb_uart_rx/tb_psel
add wave -noupdate /tb_apb_uart_rx/tb_paddr
add wave -noupdate /tb_apb_uart_rx/tb_penable
add wave -noupdate /tb_apb_uart_rx/tb_pwrite
add wave -noupdate /tb_apb_uart_rx/tb_pwdata
add wave -noupdate /tb_apb_uart_rx/tb_prdata
add wave -noupdate /tb_apb_uart_rx/tb_pslverr
add wave -noupdate /tb_apb_uart_rx/tb_data_size
add wave -noupdate /tb_apb_uart_rx/tb_expected_data_size
add wave -noupdate -divider DUT
add wave -noupdate /tb_apb_uart_rx/DUT/serial_in
add wave -noupdate /tb_apb_uart_rx/DUT/psel
add wave -noupdate /tb_apb_uart_rx/DUT/penable
add wave -noupdate /tb_apb_uart_rx/DUT/pwrite
add wave -noupdate /tb_apb_uart_rx/DUT/pwdata
add wave -noupdate -color pink /tb_apb_uart_rx/DUT/prdata
add wave -noupdate /tb_apb_uart_rx/DUT/paddr
add wave -noupdate /tb_apb_uart_rx/DUT/pslverr
add wave -noupdate /tb_apb_uart_rx/DUT/data_ready
add wave -noupdate /tb_apb_uart_rx/DUT/rx_data
add wave -noupdate /tb_apb_uart_rx/DUT/data_read
add wave -noupdate /tb_apb_uart_rx/DUT/overrun_error
add wave -noupdate /tb_apb_uart_rx/DUT/framing_error
add wave -noupdate -radix hexadecimal /tb_apb_uart_rx/DUT/data_size
add wave -noupdate /tb_apb_uart_rx/DUT/bit_period
add wave -noupdate -divider slave
add wave -noupdate /tb_apb_uart_rx/DUT/slave/rx_data
add wave -noupdate -color orange /tb_apb_uart_rx/DUT/slave/data_ready
add wave -noupdate /tb_apb_uart_rx/DUT/slave/overrun_error
add wave -noupdate /tb_apb_uart_rx/DUT/slave/framing_error
add wave -noupdate /tb_apb_uart_rx/DUT/slave/paddr
add wave -noupdate /tb_apb_uart_rx/DUT/slave/pwrite
add wave -noupdate /tb_apb_uart_rx/DUT/slave/pwdata
add wave -noupdate -color pink /tb_apb_uart_rx/DUT/slave/prdata
add wave -noupdate /tb_apb_uart_rx/DUT/slave/pslverr
add wave -noupdate /tb_apb_uart_rx/DUT/slave/data_read
add wave -noupdate -radix unsigned /tb_apb_uart_rx/DUT/slave/data_size
add wave -noupdate /tb_apb_uart_rx/DUT/slave/bit_period
add wave -noupdate /tb_apb_uart_rx/DUT/slave/read_sel
add wave -noupdate /tb_apb_uart_rx/DUT/slave/write_sel
add wave -noupdate -radix unsigned /tb_apb_uart_rx/DUT/slave/bit_period_0
add wave -noupdate /tb_apb_uart_rx/DUT/slave/next_bit_period_0
add wave -noupdate /tb_apb_uart_rx/DUT/slave/bit_period_1
add wave -noupdate /tb_apb_uart_rx/DUT/slave/next_bit_period_1
add wave -noupdate /tb_apb_uart_rx/DUT/slave/data_size_reg
add wave -noupdate /tb_apb_uart_rx/DUT/slave/next_data_size_reg
add wave -noupdate /tb_apb_uart_rx/DUT/slave/error_value
add wave -noupdate /tb_apb_uart_rx/DUT/slave/out_rx_data
add wave -noupdate /tb_apb_uart_rx/DUT/slave/next_data_read
add wave -noupdate -divider UART
add wave -noupdate -radix hexadecimal /tb_apb_uart_rx/DUT/uart/data_size
add wave -noupdate -radix unsigned /tb_apb_uart_rx/DUT/uart/data_period
add wave -noupdate /tb_apb_uart_rx/DUT/uart/data_read
add wave -noupdate /tb_apb_uart_rx/DUT/uart/rx_data
add wave -noupdate /tb_apb_uart_rx/DUT/uart/data_ready
add wave -noupdate /tb_apb_uart_rx/DUT/uart/overrun_error
add wave -noupdate /tb_apb_uart_rx/DUT/uart/framing_error
add wave -noupdate /tb_apb_uart_rx/tb_clk
add wave -noupdate /tb_apb_uart_rx/DUT/uart/load_buffer
add wave -noupdate /tb_apb_uart_rx/DUT/uart/new_packet_detected
add wave -noupdate /tb_apb_uart_rx/DUT/uart/packet_done
add wave -noupdate /tb_apb_uart_rx/DUT/uart/enable_timer
add wave -noupdate /tb_apb_uart_rx/DUT/uart/sbc_clear
add wave -noupdate /tb_apb_uart_rx/DUT/uart/sbc_enable
add wave -noupdate /tb_apb_uart_rx/DUT/uart/stop_bit
add wave -noupdate -color {Cadet Blue} /tb_apb_uart_rx/DUT/uart/serial_in
add wave -noupdate -color Goldenrod /tb_apb_uart_rx/DUT/uart/shift_strobe
add wave -noupdate /tb_apb_uart_rx/DUT/uart/controlUnit/state
add wave -noupdate /tb_apb_uart_rx/DUT/uart/packet_data_in
add wave -noupdate /tb_apb_uart_rx/DUT/uart/packet_data_out
add wave -noupdate -divider shift
add wave -noupdate /tb_apb_uart_rx/DUT/uart/shift_register/clk
add wave -noupdate /tb_apb_uart_rx/DUT/uart/shift_register/n_rst
add wave -noupdate /tb_apb_uart_rx/DUT/uart/shift_register/shift_strobe
add wave -noupdate /tb_apb_uart_rx/DUT/uart/shift_register/serial_in
add wave -noupdate /tb_apb_uart_rx/DUT/uart/shift_register/packet_data
add wave -noupdate /tb_apb_uart_rx/DUT/uart/shift_register/stop_bit
add wave -noupdate /tb_apb_uart_rx/DUT/uart/shift_register/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {119358 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 175
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
WaveRestoreZoom {953161 ps} {1072519 ps}
