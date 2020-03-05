module rcv_block
(
    input wire clk,
    input wire n_rst,
    input logic [3:0] data_size,
    input logic [13:0] data_period,
    input wire serial_in,
    input wire data_read,
    output reg [7:0] rx_data,
    output wire data_ready,
    output wire overrun_error,
    output wire framing_error
);

    wire load_buffer;
    wire new_packet_detected;
    wire packet_done;
    wire enable_timer;
    wire sbc_clear;
    wire sbc_enable;
    wire stop_bit;
    wire shift_strobe;
    reg [7:0] packet_data;


    rx_data_buff buffer
    (
        .clk(clk),
        .n_rst(n_rst),
        .load_buffer(load_buffer),
        .packet_data(packet_data),
        .data_read(data_read),
        .rx_data(rx_data),
        .data_ready(data_ready),
        .overrun_error(overrun_error)
    );

    rcu controlUnit 
    (
        .clk(clk),
        .n_rst(n_rst),
        .new_packet_detected(new_packet_detected),
        .packet_done(packet_done),
        .framing_error(framing_error),
        .sbc_clear(sbc_clear),
        .sbc_enable(sbc_enable),
        .load_buffer(load_buffer),
        .enable_timer(enable_timer)
    );

    stop_bit_chk check
    (
        .clk(clk),
        .n_rst(n_rst),
        .sbc_clear(sbc_clear),
        .sbc_enable(sbc_enable),
        .stop_bit(stop_bit),
        .framing_error(framing_error)
    );

    sr_9bit shift_register
    (
        .clk(clk),
        .n_rst(n_rst),
        .shift_strobe(shift_strobe),
        .serial_in(serial_in),
        .packet_data(packet_data),
        .stop_bit(stop_bit)
    );

    timer timing_control
    (
        .clk(clk),
        .n_rst(n_rst),
        .enable_timer(enable_timer),
        .bit_period(bit_period),
        .data_size(data_size),
        .shift_enable(shift_strobe),
        .packet_done(packet_done)
    );

    start_bit_det detector
    (
        .clk(clk),
        .n_rst(n_rst),
        .serial_in(serial_in),
        .start_bit_detected(),
        .new_package_detected(new_packet_detected)
    );

endmodule
