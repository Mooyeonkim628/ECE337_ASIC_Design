/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Mon Jan 27 19:02:27 2020
/////////////////////////////////////////////////////////////


module adder_1bit_3 ( a, b, carry_in, sum, carry_out );
  input a, b, carry_in;
  output sum, carry_out;
  wire   n1, n2;

  XOR2X1 U1 ( .A(carry_in), .B(n1), .Y(sum) );
  INVX1 U2 ( .A(n2), .Y(carry_out) );
  AOI22X1 U3 ( .A(b), .B(a), .C(n1), .D(carry_in), .Y(n2) );
  XOR2X1 U4 ( .A(a), .B(b), .Y(n1) );
endmodule


module adder_1bit_0 ( a, b, carry_in, sum, carry_out );
  input a, b, carry_in;
  output sum, carry_out;
  wire   n1, n2;

  XOR2X1 U1 ( .A(carry_in), .B(n1), .Y(sum) );
  INVX1 U2 ( .A(n2), .Y(carry_out) );
  AOI22X1 U3 ( .A(b), .B(a), .C(n1), .D(carry_in), .Y(n2) );
  XOR2X1 U4 ( .A(a), .B(b), .Y(n1) );
endmodule


module adder_1bit_1 ( a, b, carry_in, sum, carry_out );
  input a, b, carry_in;
  output sum, carry_out;
  wire   n1, n2;

  XOR2X1 U1 ( .A(carry_in), .B(n1), .Y(sum) );
  INVX1 U2 ( .A(n2), .Y(carry_out) );
  AOI22X1 U3 ( .A(b), .B(a), .C(n1), .D(carry_in), .Y(n2) );
  XOR2X1 U4 ( .A(a), .B(b), .Y(n1) );
endmodule


module adder_1bit_2 ( a, b, carry_in, sum, carry_out );
  input a, b, carry_in;
  output sum, carry_out;
  wire   n1, n2;

  XOR2X1 U1 ( .A(carry_in), .B(n1), .Y(sum) );
  INVX1 U2 ( .A(n2), .Y(carry_out) );
  AOI22X1 U3 ( .A(b), .B(a), .C(n1), .D(carry_in), .Y(n2) );
  XOR2X1 U4 ( .A(a), .B(b), .Y(n1) );
endmodule


module adder_4bit ( a, b, carry_in, sum, overflow );
  input [3:0] a;
  input [3:0] b;
  output [3:0] sum;
  input carry_in;
  output overflow;
  wire   c_out1, c_out2, c_out3;

  adder_1bit_3 ADD1 ( .a(a[0]), .b(b[0]), .carry_in(carry_in), .sum(sum[0]), 
        .carry_out(c_out1) );
  adder_1bit_2 ADD2 ( .a(a[1]), .b(b[1]), .carry_in(c_out1), .sum(sum[1]), 
        .carry_out(c_out2) );
  adder_1bit_1 ADD3 ( .a(a[2]), .b(b[2]), .carry_in(c_out2), .sum(sum[2]), 
        .carry_out(c_out3) );
  adder_1bit_0 ADD4 ( .a(a[3]), .b(b[3]), .carry_in(c_out3), .sum(sum[3]), 
        .carry_out(overflow) );
endmodule

