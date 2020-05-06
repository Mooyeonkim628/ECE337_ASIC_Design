// $Id: $
// File name:   sensor_d.sv
// Created:     1/22/2020
// Author:      Zhengsen Fu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module sensor_d
(
	input wire [3:0] sensors,
	output wire error
);

	wire CorD;
	wire Band;
	
	assign CorD = sensors[2] | sensors[3];
	assign Band = sensors[1] & CorD;
	assign error = sensors[0] | Band;
endmodule


