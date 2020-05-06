`timescale 1ns / 10ps

module tb_edge_detect ();
  localparam  CLK_PERIOD    = 1;

  logic tb_clk;
  logic tb_n_rst;
  logic tb_d_plus;
  logic tb_d_edge;

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

  // generate clk
  always
  begin
    tb_clk = 0;
    #(CLK_PERIOD / 2.0);
    tb_clk = 1;
    #(CLK_PERIOD / 2.0);
  end
  
  edge_detect DUT (
    .clk(tb_clk),
    .n_rst(tb_n_rst),
    .d_plus(tb_d_plus),
    .d_edge(tb_d_edge)
  );

  // begin
  initial begin
    tb_n_rst = 1;
    tb_d_plus = 1;
    reset_dut();
    #(CLK_PERIOD * 3);
    tb_d_plus = 1;
    #(CLK_PERIOD * 3);
    tb_d_plus = 0;
    #(CLK_PERIOD * 3);

  end


endmodule