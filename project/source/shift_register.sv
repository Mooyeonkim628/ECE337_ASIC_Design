module shift_register (
  input logic clk,
  input logic n_rst,
  input logic shift_enable,
  input logic d_orig,
  output logic [7:0] rcv_data
);
  flex_stp_sr #(
    .NUM_BITS(8),
    .SHIFT_MSB(0)
  )
  wrap (
    .clk(clk),
    .n_rst(n_rst),
    .shift_enable(shift_enable),
    .serial_in(d_orig),
    .parallel_out(rcv_data)
  );
endmodule