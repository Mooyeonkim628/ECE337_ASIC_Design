/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Mon Feb 17 20:26:04 2020
/////////////////////////////////////////////////////////////


module moore ( clk, n_rst, i, o );
  input clk, n_rst, i;
  output o;
  wire   n18, n19, n20, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
         n33, n34, n35;
  wire   [2:0] state;

  DFFSR \state_reg[0]  ( .D(n20), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[0])
         );
  DFFSR \state_reg[1]  ( .D(n18), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[1])
         );
  DFFSR \state_reg[2]  ( .D(n19), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[2])
         );
  NOR2X1 U24 ( .A(n22), .B(n23), .Y(o) );
  NAND2X1 U25 ( .A(n24), .B(n25), .Y(n23) );
  MUX2X1 U26 ( .B(n26), .A(n27), .S(state[0]), .Y(n20) );
  NAND2X1 U27 ( .A(n28), .B(n27), .Y(n26) );
  MUX2X1 U28 ( .B(n25), .A(n29), .S(i), .Y(n28) );
  NAND2X1 U29 ( .A(n25), .B(n22), .Y(n29) );
  INVX1 U30 ( .A(state[2]), .Y(n22) );
  OAI21X1 U31 ( .A(n25), .B(n30), .C(n27), .Y(n19) );
  NAND2X1 U32 ( .A(i), .B(state[0]), .Y(n30) );
  INVX1 U33 ( .A(state[1]), .Y(n25) );
  OAI21X1 U34 ( .A(n31), .B(n32), .C(n33), .Y(n18) );
  OAI21X1 U35 ( .A(n34), .B(n24), .C(state[1]), .Y(n33) );
  INVX1 U36 ( .A(n27), .Y(n34) );
  OAI21X1 U37 ( .A(n35), .B(state[2]), .C(n27), .Y(n32) );
  OAI21X1 U38 ( .A(state[1]), .B(state[0]), .C(state[2]), .Y(n27) );
  NOR2X1 U39 ( .A(state[1]), .B(n24), .Y(n35) );
  INVX1 U40 ( .A(state[0]), .Y(n24) );
  INVX1 U41 ( .A(i), .Y(n31) );
endmodule

