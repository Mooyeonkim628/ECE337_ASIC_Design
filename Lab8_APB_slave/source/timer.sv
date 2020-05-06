module timer
(
    input wire clk,
    input wire n_rst,
    input wire enable_timer,
    input logic [13:0] bit_period,
    input logic [3:0] data_size,
    output wire shift_enable,
    output wire packet_done
);
    flex_counter #(
        .NUM_CNT_BITS(14)
    )
    clk_count
    (
        .clk(clk),
        .n_rst(n_rst),
        .clear(!enable_timer),
        .count_enable(enable_timer),
        .rollover_val(bit_period),
        .count_out(),
        .rollover_flag(shift_enable)
    );

    flex_counter #(
        .NUM_CNT_BITS(4)
    )
    bit_count
    (
        .clk(clk),
        .n_rst(n_rst),
        .clear(!enable_timer),
        .count_enable(shift_enable),
        .rollover_val(data_size + 1'b1),
        .count_out(),
        .rollover_flag(packet_done)
    );

endmodule