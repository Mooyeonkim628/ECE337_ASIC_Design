module sync_high(
    input wire clk,
    input wire n_rst,
    input reg async_in,
    output reg sync_out
);

    reg middle;

    always_ff @ (posedge clk, negedge n_rst)
    begin
        if(!n_rst)    
        begin
            sync_out <= 1'b1;
            middle <= 1'b1;
        end
        else
        begin
            middle <= async_in;
            sync_out <= middle;
        end

    end

endmodule
