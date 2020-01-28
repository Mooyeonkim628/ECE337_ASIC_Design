// $Id: $
// File name:   adder_4bit.sv
// Created:     1/22/2020
// Author:      Zhengsen Fu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .


module adder_4bit
(
	input wire [3:0]a,
	input wire [3:0]b,
	input wire carry_in,
	output wire [3:0]sum,
	output wire overflow
);
	wire c_out1;
	wire c_out2;
	wire c_out3;
	adder_1bit ADD1(.a(a[0]), .b(b[0]), .carry_in(carry_in), .sum(sum[0]), .carry_out(c_out1));
	adder_1bit ADD2(.a(a[1]), .b(b[1]), .carry_in(c_out1), .sum(sum[1]), .carry_out(c_out2));
	adder_1bit ADD3(.a(a[2]), .b(b[2]), .carry_in(c_out2), .sum(sum[2]), .carry_out(c_out3));
	adder_1bit ADD4(.a(a[3]), .b(b[3]), .carry_in(c_out3), .sum(sum[3]), .carry_out(overflow));

endmodule
