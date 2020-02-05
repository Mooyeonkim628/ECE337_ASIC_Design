// File name:   adder_16bit.sv
// Created:     1/19/2015
// Author:      Tim Pritchett
// Version:     1.0  Initial Design Entry
// Description: 16 bit adder design wrapper for synthesis optimization seciton of Lab 2
`timescale 1ns / 100ps

module adder_16bit
(
	input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);
	genvar i;
	generate
	for(i = 0; i < 16; i = i + 1)
	begin
		always @ (a[i], b[i], carry_in)
		begin
			#(2)	assert ((a[i] == 1'b1 || a[i] == 1'b0) || (b[i] == 1'b1 || b[i] == 1'b0) || (carry_in == 1'b1 || carry_in == 1'b0)) 
			else $error("nbit input incorrect");   
		end
	end
	endgenerate

	adder_nbit #(16)ADD (.a(a), .b(b), .carry_in(carry_in), .sum(sum), .overflow(overflow));

endmodule
