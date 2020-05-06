`timescale 1ns / 10ps

module tb_decode ();
  localparam  CLK_PERIOD    = 1;

  logic tb_clk;
  logic tb_n_rst;
  logic tb_d_plus;
  logic tb_shift_enable;
  logic tb_eop;
  logic tb_d_orig;

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

  decode DUT (
    .clk(tb_clk),
    .n_rst(tb_n_rst),
    .d_plus(tb_d_plus),
    .shift_enable(tb_shift_enable),
    .eop(tb_eop),
    .d_orig(tb_d_orig)
  );
  
  task enable;
  begin
    @(posedge tb_clk);
    tb_shift_enable = 1;
    @(posedge tb_clk);
    tb_shift_enable = 0;
  end
  endtask

  // begin
  initial begin
    tb_n_rst = 1;
    tb_d_plus = 1;
    tb_eop = 0;
    tb_shift_enable = 0;
    reset_dut();
    #(CLK_PERIOD * 3);

    @(posedge tb_clk);
    tb_d_plus = 0;
    #(CLK_PERIOD * 4);
    enable();
    #(CLK_PERIOD * 4);
    enable();
    #(CLK_PERIOD * 3);

    @(posedge tb_clk);
    tb_d_plus = 1;
    #(CLK_PERIOD * 3);
    enable();
    #(CLK_PERIOD * 8);
    enable();
    #(CLK_PERIOD * 4);
    @(posedge tb_clk);
    tb_d_plus = 0;
    #(CLK_PERIOD * 4);
    enable();
    #(CLK_PERIOD * 4);

    // eop case
    $info("eop test case");
    @(posedge tb_clk);
    tb_d_plus = 1;
    #(CLK_PERIOD * 3);
    enable();
    #(CLK_PERIOD * 8);
    enable();
    #(CLK_PERIOD * 4);
    @(posedge tb_clk);
    tb_d_plus = 0;
    tb_eop = 1;
    #(CLK_PERIOD * 4);
    enable();
    #(CLK_PERIOD * 16);
    tb_d_plus = 1;
    tb_eop = 0;
    
    
  end


endmodule