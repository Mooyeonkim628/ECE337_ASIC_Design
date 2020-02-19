module flex_pts_sr 
#(
    parameter NUM_BITS = 4,
    parameter SHIFT_MSB = 1
)
(
    input wire clk,
    input wire n_rst,
    input wire shift_enable,
    input wire load_enable,
    input reg [NUM_BITS - 1:0] parallel_in,
    output wire serial_out
);

    reg [NUM_BITS - 1:0] next_parallel;
    reg [NUM_BITS - 1:0] parallel;
    always_ff @(posedge clk, negedge n_rst) begin
        if(n_rst == 0) begin
            parallel = '1;
        end else begin
            parallel = next_parallel;
        end
    end

    always_comb begin
        if(load_enable) begin
            next_parallel = parallel_in;
        end
        else if(load_enable == 0 && shift_enable == 1) begin
            if(SHIFT_MSB) begin
                next_parallel = {parallel[NUM_BITS - 2:0], 1'b1};
            end else begin
                next_parallel = {1'b1, parallel[NUM_BITS - 1:1]};
            end
        end else begin
            next_parallel = parallel;
        end
    end

    
    assign serial_out = SHIFT_MSB? parallel[NUM_BITS - 1]: parallel[0];

endmodule
