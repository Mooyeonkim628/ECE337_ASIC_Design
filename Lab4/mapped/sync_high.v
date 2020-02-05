/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Wed Feb  5 13:08:33 2020
/////////////////////////////////////////////////////////////


module sync_high ( clk, n_rst, async_in, sync_out );
  input clk, n_rst, async_in;
  output sync_out;
  wire   middle;

  DFFSR middle_reg ( .D(async_in), .CLK(clk), .R(1'b1), .S(n_rst), .Q(middle)
         );
  DFFSR sync_out_reg ( .D(middle), .CLK(clk), .R(1'b1), .S(n_rst), .Q(sync_out) );
endmodule

