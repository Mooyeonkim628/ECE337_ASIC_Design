module rcu
(
    input wire clk,
    input wire n_rst,
    input wire new_packet_detected,
    input wire packet_done,
    input wire framing_error,
    output wire sbc_clear,
    output wire sbc_enable,
    output wire load_buffer,
    output wire enable_timer
);
    typedef enum bit[2:0] {WAIT, DETECT1, DETECT2, START, CHECK, ANOTHER_WAIT, DONE} stateType;
    stateType state;
    stateType next_state;
    reg [3:0] out; //output = [sbc_clear, enable, load_buffer, enable_timer]

    assign sbc_clear = out[3];
    assign sbc_enable = out[2];
    assign load_buffer = out[1];
    assign enable_timer = out[0];

    always_ff @(posedge clk, negedge n_rst) begin
        if(n_rst == 0) 
            state <= WAIT;
        else
            state <= next_state;
    end

    always_comb begin //state transition logic
        next_state = state;
        case(state)
            WAIT: begin
                if(new_packet_detected)
                    next_state = DETECT1;
            end
            DETECT1:
                next_state = DETECT2;
            DETECT2:
                next_state = START;
            START: begin
                if(packet_done) 
                    next_state = CHECK;
            end
            CHECK:
                next_state = ANOTHER_WAIT;
            ANOTHER_WAIT: begin
                if(framing_error)
                    next_state = WAIT;
                else
                    next_state = DONE;
            end
            DONE:
                next_state = WAIT;
            default:
                next_state = state;
        endcase
    end

    always_comb begin //output logic
        case(state)
            WAIT: out = 4'b0000;
            DETECT1: out = 4'b1001;
            DETECT2: out = 4'b0001;
            START: out = 4'b0001;
            CHECK: out = 4'b0100;
            ANOTHER_WAIT: out = 4'b0000;
            DONE: out = 4'b0010;
            default: out = 4'b0000;
        endcase
    end
    

endmodule