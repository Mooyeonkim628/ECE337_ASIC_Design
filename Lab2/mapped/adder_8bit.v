/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Mon Jan 27 20:01:39 2020
/////////////////////////////////////////////////////////////


module adder_8bit ( a, b, carry_in, sum, overflow );
  input [7:0] a;
  input [7:0] b;
  output [7:0] sum;
  input carry_in;
  output overflow;

  tri   [7:0] a;
  tri   [7:0] b;
  tri   carry_in;
  tri   [7:0] sum;
  tri   overflow;

  adder_nbit ADD ( .a(a), .b(b), .carry_in(carry_in), .sum(sum), .overflow(
        overflow) );
endmodule

