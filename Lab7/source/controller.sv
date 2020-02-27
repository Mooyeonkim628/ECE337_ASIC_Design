module controller
(
    input wire clk,
    input wire n_rst,
    input wire dr,
    input wire lc,
    input wire overflow,
    output wire cnt_up,
    output wire clear,
    output wire modwait,
    output reg [2:0]op,
    output reg [3:0]src1,
    output reg [3:0]src2,
    output reg [3:0]dest,
    output wire err
);
    localparam NOP = 3'b000;
    localparam COPY = 3'b001;
    localparam LDR1 = 3'b010;
    localparam LDR2 = 3'b011;
    localparam ADD = 3'b100;
    localparam SUB = 3'b101;
    localparam MUL = 3'b110;
    localparam r0 = 4'd0; // sum
    localparam r1 = 4'd1; // sample 1
    localparam r2 = 4'd2; // sample 2
    localparam r3 = 4'd3; // sample 3
    localparam r4 = 4'd4; // sample 4
    localparam r5 = 4'd5; // temp
    localparam r6 = 4'd6; // F0
    localparam r7 = 4'd7; // F1
    localparam r8 = 4'd8; // F2
    localparam r9 = 4'd9; // F3
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

    assign cnt_up = out[3];
    assign clear = out[2];
    assign modwait = out[1];
    assign err = out[0];

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
        next_state = state;
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
                    next_state = COEF3;
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
                if(lc)
                    next_state = COEF1;
            end
        endcase
    end

    always_comb begin
        next_out = 4'b0000;
        next_op = 3'b000;
        next_src1 = 4'b0000;
        next_src2 = 4'b0000;
        next_dest =  4'b0000;
        case(state)
            IDLE: begin
                next_out = 4'b0000;
                next_op = NOP;
            end
            COEF1: begin
                next_out = 4'b0110;
                next_op = LDR2;
                next_dest = r6;
            end
            COEF_WAIT1: begin
                next_out = 4'b0000;
                next_op = NOP;
            end
            COEF2: begin
                next_out = 4'b0110;
                next_op = LDR2;
                next_dest = r7;
            end
            COEF_WAIT2: begin
                next_out = 4'b0000;
                next_op = NOP;
            end
            COEF3: begin
                next_out = 4'b0110;
                next_op = LDR2;
                next_dest = r8;
            end
            COEF_WAIT3: begin
                next_out = 4'b0000;
                next_op = NOP;
            end
            COEF4: begin
                next_out = 4'b0110;
                next_op = LDR2;
                next_dest = r9;
            end
            STORE: begin
                next_out = 4'b0010;
                next_op = LDR1;
                next_dest = r5;
            end
            ZERO: begin
                next_out = 4'b1010;
                next_op = SUB;
                next_src1 = r1;
                next_src2 = r1;
                next_dest = r0;
            end
            SORT1: begin
                next_out = 4'b0010;
                next_op = COPY;
                next_src1 = r3;
                next_dest = r4;
            end
            SORT2: begin
                next_out = 4'b0010;
                next_op = COPY;
                next_src1 = r2;
                next_dest = r3;
            end
            SORT3: begin
                next_out = 4'b0010;
                next_op = COPY;
                next_src1 = r1;
                next_dest = r2;
            end
            SORT4: begin
                next_out = 4'b0010;
                next_op = COPY;
                next_src1 = r5;
                next_dest = r1;
            end
            MUL1: begin
                next_out = 4'b0010;
                next_op = MUL;
                next_src1 = r4;
                next_src2 = r9;
                next_dest = r5;
            end
            ADD1: begin
                next_out = 4'b0010;
                next_op = ADD;
                next_src1 = r0;
                next_src2 = r5;
                next_dest = r0;
            end
            MUL2: begin
                next_out = 4'b0010;
                next_op = MUL;
                next_src1 = r3;
                next_src2 = r8;
                next_dest = r5;
            end
            SUB2: begin
                next_out = 4'b0010;
                next_op = SUB;
                next_src1 = r0;
                next_src2 = r5;
                next_dest = r0;
            end
            MUL3: begin
                next_out = 4'b0010;
                next_op = MUL;
                next_src1 = r2;
                next_src2 = r7;
                next_dest = r5;
            end
            ADD3: begin
                next_out = 4'b0010;
                next_op = ADD;
                next_src1 = r0;
                next_src2 = r5;
                next_dest = r0;
            end
            MUL4: begin
                next_out = 4'b0010;
                next_op = MUL;
                next_src1 = r1;
                next_src2 = r6;
                next_dest = r5;
            end
            SUB4: begin
                next_out = 4'b0010;
                next_op = SUB;
                next_src1 = r0;
                next_src2 = r5;
                next_dest = r0;
            end
            EIDLE: begin
                next_out = 4'b0001;
                next_op = NOP;
            end
        endcase
    end

endmodule