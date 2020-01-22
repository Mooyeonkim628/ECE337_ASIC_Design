// $Id: $
// File name:   sensor_s.sv
// Created:     1/22/2020
// Author:      Zhengsen Fu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: 

module sensor_s 
(
	input wire [3:0]sensors,
	output wire error
);

	wire CorD;
	wire Band;
	OR2X1 O1(.Y(CorD), .A(sensors[2]), .B(sensors[3]));
	AND2X1 A1(.Y(Band), .A(sensors[1]), .B(CorD));
	OR2X1 O2(.Y(error), .A(Band), .B(sensors[0]));
endmodule
