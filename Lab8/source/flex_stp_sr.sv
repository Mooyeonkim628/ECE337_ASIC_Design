module flex_stp_sr 
#(
    parameter NUM_BITS = 4,
    parameter SHIFT_MSB = 1
)
(
    input wire clk,
    input wire n_rst,
    input wire shift_enable,
    input wire serial_in,
    output reg [NUM_BITS - 1:0] parallel_out
);

    reg [NUM_BITS - 1:0] next_parallel_out;
    
    always_ff @(posedge clk, negedge n_rst) begin
        if(n_rst == 0)
            parallel_out = '1;
        else
            parallel_out = next_parallel_out;
    end

    always_comb begin
        if(shift_enable == 1) begin
            if(SHIFT_MSB == 1) begin
                next_parallel_out = parallel_out << 1;
                next_parallel_out[0] = serial_in;
            end else begin
                next_parallel_out = parallel_out >> 1;
                next_parallel_out[NUM_BITS - 1] = serial_in;
            end
        end else begin
            next_parallel_out = parallel_out;
        end
    end

endmodule

