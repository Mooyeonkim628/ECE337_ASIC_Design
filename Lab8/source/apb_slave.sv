module apb_slave
(
    input logic clk,
    input logic n_rst,
    input logic [7:0] rx_data,
    input logic overrun_error,
    input logic framing_error,
    input logic psel,
    input logic [2:0] paddr,
    input logic penable,
    input logic pwrite,
    input logic [7:0] pwdata,
    output logic data_read,
    output logic [7:0] prdata,
    output logic pslverr,
    output logic [3:0] data_size,
    output logic [13:0] bit_period
);
    always_comb begin
        
    end


endmodule