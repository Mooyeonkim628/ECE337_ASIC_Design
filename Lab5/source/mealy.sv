module mealy
(
    input wire clk,
    input wire n_rst,
    input wire i,
    output reg o
);
    typedef enum bit[2:0] {START, STATE1, STATE11, STATE110} stateType;
    reg [1:0]state;
    reg [1:0]next_state;

    always_ff @ (posedge clk, negedge n_rst) begin
        if(n_rst == 0) begin
            state <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case(state)
            START: begin
                if(i == 1)
                    next_state = STATE1;
                else
                    next_state = START;
            end
            STATE1: begin
                if(i == 0)
                    next_state = START;
                else
                    next_state = STATE11;
            end
            STATE11: begin
                if(i == 1)
                    next_state = STATE11;
                else
                    next_state = STATE110;
            end
            STATE110: begin
                if(i == 0)
                    next_state = START;
                else
                    next_state = STATE1;
            end
            default:
                next_state = state;
        endcase
    end

    always_comb begin
        if(state == STATE110 && i == 1)
            o = 1;
        else
            o = 0;
    end

endmodule
