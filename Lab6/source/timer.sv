module timer
(
    input wire clk,
    input wire n_rst,
    input wire enable_timer,
    output wire shift_enable,
    output wire packet_done
);
    flex_counter #(
        .NUM_CNT_BITS(4)
    )
    clk_count
    (
        .clk(clk),
        .n_rst(n_rst),
        .clear(!enable_timer),
        .count_enable(enable_timer),
        .rollover_val(4'd10),
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
        .rollover_val(4'd9),
        .count_out(),
        .rollover_flag(packet_done)
    );

endmodule