/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Wed Feb  5 12:48:20 2020
/////////////////////////////////////////////////////////////


module sync_low ( clk, n_rst, async_in, sync_out );
  input clk, n_rst, async_in;
  output sync_out;
  wire   middle;

  DFFSR middle_reg ( .D(async_in), .CLK(clk), .R(n_rst), .S(1'b1), .Q(middle)
         );
  DFFSR sync_out_reg ( .D(middle), .CLK(clk), .R(n_rst), .S(1'b1), .Q(sync_out) );
endmodule

