module flex_counter
#(
    parameter NUM_CNT_BITS = 4
)
(
    input wire clk,
    input wire n_rst,
    input wire clear,
    input wire count_enable,
    input reg [NUM_CNT_BITS - 1:0] rollover_val,
    output reg [NUM_CNT_BITS - 1:0] count_out,
    output reg rollover_flag
);
    reg [NUM_CNT_BITS - 1:0] next_count;
    reg next_flag;
    always_ff @ (posedge clk, negedge n_rst) begin
        if (n_rst == 0) begin
            count_out <= 0;
            rollover_flag <= 0;
        end else begin
            count_out <= next_count;
            rollover_flag <= next_flag;
        end
    end

    always_comb begin
        if(clear) begin
            next_count = 0;
        end
        else if(count_enable) begin
            if(rollover_val == count_out) begin
                next_count = 1;
            end
            else begin
                next_count = count_out + 1;
            end
        end
        else begin
            next_count = count_out;
        end
    end

    always_comb begin
        if(clear) 
            next_flag = 0;
        else if(rollover_val == next_count) begin
            next_flag = 1;
        end
        else begin
            next_flag = 0;
        end
    end



endmodule


