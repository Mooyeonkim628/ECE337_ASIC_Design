// $Id: $
// File name:   adder_1bit.sv
// Created:     1/22/2020
// Author:      Zhengsen Fu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

`timescale 1ns / 100ps

module adder_1bit
(
	input wire a,
	input wire b,
	input wire carry_in,
	output wire sum,
	output wire carry_out
);

	always @ (a, b, carry_in)
	begin
		#(2)	assert ((a == 1'b1 || a == 1'b0) || (b == 1'b1 || b == 1'b0) || (carry_in == 1'b1 || carry_in == 1'b0)) 
		else $error("1bit input incorrect");
	end

	assign sum = carry_in ^ (a ^ b);
	assign carry_out = ((! carry_in) & b & a) | (carry_in & (b | a));


endmodule
