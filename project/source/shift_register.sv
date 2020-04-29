module shift_register (
  input logic clk,
  input logic n_rst,
  input logic shift_enable,
  input logic stuff_bit,
  input logic d_orig,
  output logic [7:0] rcv_data
);
  logic enable;
  assign enable =  shift_enable & ~stuff_bit;
  flex_stp_sr #(
    .NUM_BITS(8),
    .SHIFT_MSB(0)
  )
  wrap (
    .clk(clk),
    .n_rst(n_rst),
    .shift_enable(enable),
    .serial_in(d_orig),
    .parallel_out(rcv_data)
  );
endmodule