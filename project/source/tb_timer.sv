`timescale 1ns / 10ps

module tb_timer ();
  localparam  CLK_PERIOD    = 1;

  logic tb_clk;
  logic tb_n_rst;
  logic tb_d_plus;
  logic tb_d_edge;
  logic tb_rcving;
  logic tb_shift_enable;
  logic tb_byte_received;
  integer tb_bit_num;

  task reset_dut;
  begin
    tb_n_rst = 0;

    @(posedge tb_clk);
    @(posedge tb_clk);

    @(negedge tb_clk);
    
    tb_n_rst = 1;

    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask

  // Clock generation block
  always begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end

  timer DUT (
    .clk(tb_clk),
    .n_rst(tb_n_rst),
    .d_edge(tb_d_edge),
    .rcving(tb_rcving),
    .shift_enable(tb_shift_enable),
    .byte_received(tb_byte_received)
  );

  edge_detect EDGE (
    .clk(tb_clk),
    .n_rst(tb_n_rst),
    .d_plus(tb_d_plus),
    .d_edge(tb_d_edge)
  );
  

  // begin
  initial begin
    tb_n_rst = 1;
    tb_d_plus = 1;
    tb_rcving = 0;
    tb_bit_num = 0;
    reset_dut();
    #(CLK_PERIOD * 3);
    tb_rcving = 1;
    @(posedge tb_clk);
    tb_d_plus = 0;
    tb_bit_num++;
    #(CLK_PERIOD * 4);
    #(CLK_PERIOD * 4);

    @(posedge tb_clk);
    tb_d_plus = 1;
    tb_bit_num++;
    #(CLK_PERIOD * 8);
    tb_bit_num++;
    #(CLK_PERIOD * 8);
    tb_bit_num++;
    #(CLK_PERIOD * 7);
    tb_bit_num++;
    tb_d_plus = 0;
    #(CLK_PERIOD * 8);
    tb_bit_num++;
    tb_d_plus = 1;
    #(CLK_PERIOD * 8);
    tb_bit_num++;
    #(CLK_PERIOD * 7);
    tb_bit_num++;
    #(CLK_PERIOD * 7);
    tb_bit_num++;
    #(CLK_PERIOD * 8);
    tb_bit_num++;
    #(CLK_PERIOD * 8);
    tb_bit_num++;
    #(CLK_PERIOD * 8);
    tb_bit_num++;
    tb_rcving = 1;
    #(CLK_PERIOD * 8);
    tb_bit_num++;
    
  end


endmodule