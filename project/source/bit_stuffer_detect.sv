module bit_stuffer_detect (
  input logic clk,
  input logic n_rst,
  input logic shift_enable,
  input logic d_orig,
  output logic stuff_bit
);
  
  logic clear;
  assign clear = ~d_orig;
  flex_counter #(
    .NUM_CNT_BITS(3)
  )
  wrap
  (
    .clk(clk),
    .n_rst(n_rst),
    .clear(clear),
    .count_enable(shift_enable),
    .rollover_val(4'd6),
    .rollover_flag(stuff_bit)
  );
endmodule