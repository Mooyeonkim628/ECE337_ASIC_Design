// $Id: $
// File name:   adder_nbit.sv
// Created:     1/27/2020
// Author:      Zhengsen Fu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .


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
	wire [NUMB_BITS:0]carrys;
	genvar i;

	assign carrys[0] = carry_in;
	generate
	for(i = 0; i < NUMB_BITS; i = i + 1)
		begin
			adder_1bit IX(.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i + 1]));
		end
	endgenerate
	assign overflow = carrys[NUMB_BITS];
endmodule
