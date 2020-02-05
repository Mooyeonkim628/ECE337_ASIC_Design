// $Id: $
// File name:   adder_nbit.sv
// Created:     1/27/2020
// Author:      Zhengsen Fu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps


module adder_nbit
#(
	parameter NUMB_BITS = 4
)
(
	input wire [(NUMB_BITS - 1):0]a,
	input wire [(NUMB_BITS - 1):0]b,
	input wire carry_in,
	output wire [(NUMB_BITS - 1):0]sum,
	output wire overflow
);
	genvar i;
	generate
	for(i = 0; i < NUMB_BITS; i = i + 1)
	begin
		always @ (a[i], b[i], carry_in)
		begin
			#(2)	assert ((a[i] == 1'b1 || a[i] == 1'b0) || (b[i] == 1'b1 || b[i] == 1'b0) || (carry_in == 1'b1 || carry_in == 1'b0)) 
			else $error("nbit input incorrect");
		end
	end
	endgenerate

	wire [NUMB_BITS:0]carrys;

	assign carrys[0] = carry_in;
	generate
	for(i = 0; i < NUMB_BITS; i = i + 1)
	begin
		adder_1bit IX(.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i + 1]));

		always @ (a[i], b[i], carrys[i])
		begin
			#(2)	assert (((a[i] + b[i] + carrys[i]) % 2) == sum[i]) 
			else $error("1bit output incorrect");
		end
	end

	endgenerate
	assign overflow = carrys[NUMB_BITS];
endmodule
