module controller
(
    input wire clk,
    input wire n_rst,
    input wire dr,
    input wire ld,
    input wire overflow,
    output wire cnt_up
    output wire clear,
    output wire modwait,
    output reg [2:0]op,
    output reg [3:0]src1,
    output reg [3:0]src2,
    output reg [3:0]dest
    output wire err
);
    typedef enum bit[4:0] {IDLE, COEF1, COEF_WAIT1, COEF2, COEF_WAIT2, 
    COEF3, COEF_WAIT3, COEF4, STORE, EIDLE, ZERO, SORT1, SORT2, SORT3, SORT4,
    MUL1, ADD1, MUL2, SUB2, MUL3, ADD3, MUL4, SUB4} stateType;
    reg [3:0] out; // [cnt_up, clear, modwait, err]
    reg [3:0] next_out;
    reg [2:0] next_op;
    reg [3:0] next_src1;
    reg [3:0] next_src2;
    reg [3:0] next_dest;
    stateType state;
    stateType next_state;

    always_ff @(posedge clk, negedge n_rst) begin
        out <= next_out;
        op <= next_op;
        src1 <= next_src1;
        src2 <= next_src2;
        dest <= next_dest;
        state <= next_state;
        if(n_rst == '0) begin
            out <= '0;
            op <= '0;
            src1 <= '0;
            src2 <= '0;
            dest <= '0;
            state <= IDLE;
        end
    end

    always_comb begin
        next_out = out;
        next_op = op;
        next_src1 = src1;
        next_src2 = src2;
        next_dest = dest;
        case(state)
            IDLE: begin
                if(lc)
                    next_state = COEF1;
                if(dr)
                    next_state = STORE;
            end
            COEF1: 
                next_state = COEF_WAIT1;
            COEF_WAIT1: begin
                if(lc)
                    next_state = COEF2;
            end
            COEF2: 
                next_state = COEF_WAIT2;
            COEF_WAIT2: begin
                if(lc)
                    next_state = COEF3: 
            end
            COEF3:
                next_state = COEF_WAIT3;
            COEF_WAIT3: begin
                if(lc)
                    next_state = COEF4;
            end
            COEF4:
                next_state = IDLE;
            STORE: begin
                next_state = ZERO;
                if(!dr)
                    next_state = EIDLE;
            end
            ZERO:
                next_state = SORT1;
            SORT1:
                next_state = SORT2;
            SORT2:
                next_state = SORT3;
            SORT3:
                next_state = SORT4;
            SORT4:
                next_state = MUL1;
            MUL1:
                next_state = ADD1;
            ADD1: begin
                next_state = MUL2;
                if(overflow)
                    next_state = EIDLE;
            end
            MUL2:
                next_state = SUB2;
            SUB2: begin
                next_state = MUL3;
                if(overflow)
                    next_state = EIDLE;
            end
            MUL3:
                next_state = ADD3;
            ADD3: begin
                next_state = MUL4;
                if(overflow)
                    next_state = EIDLE;
            end
            MUL4:
                next_state = SUB4;
            SUB4: begin
                next_state = IDLE;
                if(overflow)
                    next_state = EIDLE;
            end
            EIDLE: begin
                if(dr)
                    next_state = STORE;
                else
                    next_state = EIDLE;
            end
        endcase
    end

    always_comb begin
        next_out = 
        next_op = 
        next_src1 = 
        next_src2 = 
        next_dest =  
        case(state)
            IDLE: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            COEF1: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            COEF_WAIT1: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            COEF2: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            COEF_WAIT2: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            COEF3: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            COEF_WAIT3: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            COEF4: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            STORE: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            ZERO: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            SORT1: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            SORT2: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            SORT3: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            SORT4: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            MUL1: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            ADD1: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            MUL2: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            SUB2: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            MUL3: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            ADD3: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            MUL4: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            SUB4: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
            EIDLE: begin
                next_out = 
                next_op = 
                next_src1 = 
                next_src2 = 
                next_dest =  
            end
        endcase
    end

endmodule