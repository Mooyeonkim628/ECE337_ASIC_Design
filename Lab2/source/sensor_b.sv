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
		CorD = sensors[3] | sensors[2];
		Band = sensors[1] & CorD;
		error = Band | sensors[0];
	end

endmodule
