module usb_receiver (
  input logic clk,
  input logic n_rst,
  input logic d_plus,
  input logic d_minus,
  input logic r_enable,
  output logic [7:0] r_data,
  output logic empty,
  output logic full,
  output logic rcving,
  output logic r_error
);
  logic d_plus_sync;
  logic d_minus_sync;
  logic d_edge;
  logic d_orig;
  logic eop;
  logic shift_enable;
  logic [7:0] rcv_data;
  logic w_enable;

  sync_high synchronizer_high (
    .clk(clk),
    .n_rst(n_rst),
    .async_in(d_plus),
    .sync_out(d_plus_sync)
  );

  sync_low synchronizer_low (
    .clk(clk),
    .n_rst(n_rst),
    .async_in(d_minus),
    .sync_out(d_minus_sync)
  );

  edge_detect edge_detc (
    .clk(clk),
    .n_rst(n_rst),
    .d_plus(d_plus),
    .d_edge(d_edge)
  );

  eop_detect eop_detc (
    .d_plus(d_plus),
    .d_minus(d_minus),
    .eop(eop)
  );

  decode decoder (
    .clk(clk),
    .n_rst(n_rst),
    .d_plus(d_plus),
    .shift_enable(shift_enable),
    .eop(eop),
    .d_orig(d_orig)
  );

  timer time (
    .clk(clk),
    .n_rst(n_rst),
    .d_edge(d_edge),
    .rcving(rcving),
    .shift_enable(shift_enable),
    .byte_received(byte_received)
  );

  shift_register shift (
    .clk(clk),
    .n_rst(n_rst),
    .shift_enable(shift_enable),
    .d_orig(d_orig),
    .rcv_data(rcv_data)
  );

  rcu control (
    .clk(clk),
    .n_rst(n_rst),
    .d_edge(decode),
    .eop(eop),
    .shift_enable(shift_enable),
    .rcv_data(rcv_data),
    .byte_received(byte_received),
    .rcving(rcving),
    .w_enable(w_enable),
    .r_error(r_error)
  );

  rx_fifo fifo (
    .clk(clk),
    .n_rst(n_rst),
    .r_enable(r_enable),
    .w_enable(w_enable), 
    .w_data(w_data), 
    .r_data(r_data), 
    .empty(empty), 
    .full(full)
  );

  
endmodule