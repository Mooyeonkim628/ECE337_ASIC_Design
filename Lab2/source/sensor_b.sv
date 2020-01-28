// $Id: $
// File name:   sensor_b.sv
// Created:     1/22/2020
// Author:      Zhengsen Fu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module sensor_b
(
	input wire [3:0] sensors,
	output reg error
);
	
	reg CorD;
	reg Band;
	always_comb
	begin
		if((sensors[2] | sensors[3]) & sensors[1]) begin
			error = 1;
		end else if(sensors[0]) begin
			error = 1;
		end else begin
			error = 0;
		end
	end

endmodule
