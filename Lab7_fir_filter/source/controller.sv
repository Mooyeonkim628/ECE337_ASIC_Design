module controller
(
    input wire clk,
    input wire n_rst,
    input wire dr,
    input wire lc,
    input wire overflow,
    output wire cnt_up,
    output wire clear,
    output reg modwait,
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
    logic [3:0] out; // [cnt_up, clear, nothing, err]
    logic next_modwait;
    // reg [3:0] next_out;
    // reg [2:0] next_op;
    // reg [3:0] next_src1;
    // reg [3:0] next_src2;
    // reg [3:0] next_dest;
    stateType state;
    stateType next_state;

    assign cnt_up = out[3];
    assign clear = out[2];
    // assign modwait = out[1];
    assign err = out[0];

    always_ff @(posedge clk, negedge n_rst) begin
        
        if(n_rst == 0) begin
            // out <= '0;
            // op <= '0;
            // src1 <= '0;
            // src2 <= '0;
            // dest <= '0;
            modwait <= 0;
            state <= IDLE;
        end 
        else begin
            // out <= next_out;
            modwait <= next_modwait;
            // op <= next_op;
            // src1 <= next_src1;
            // src2 <= next_src2;
            // dest <= next_dest;
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        next_modwait = modwait;
        case(state)
            IDLE: begin
                if(lc)
                    next_state = COEF1;
                if(dr)
                    next_state = STORE;
                next_modwait = 0;
            end
            COEF1: begin
                next_state = COEF_WAIT1;
                next_modwait = 1;
            end
            COEF_WAIT1: begin
                next_modwait = 0;
                if(lc)
                    next_state = COEF2;
            end
            COEF2: begin
                next_state = COEF_WAIT2;
                next_modwait = 1;
            end
            COEF_WAIT2: begin
                next_modwait = 0;
                if(lc)
                    next_state = COEF3;
            end
            COEF3: begin
                next_state = COEF_WAIT3;
                next_modwait = 1;
            end
            COEF_WAIT3: begin
                next_modwait = 0;
                if(lc)
                    next_state = COEF4;
            end
            COEF4: begin
                next_state = IDLE;
                next_modwait = 1;
            end
            STORE: begin
                next_modwait = 1;
                next_state = ZERO;
                if(!dr)
                    next_state = EIDLE;
            end
            ZERO: begin
                next_state = SORT1;
                next_modwait = 1;
            end
            SORT1: begin
                next_state = SORT2;
                next_modwait = 1;
            end
            SORT2: begin
                next_state = SORT3;
                next_modwait = 1;
            end
            SORT3: begin
                next_state = SORT4;
                next_modwait = 1;
            end
            SORT4: begin
                next_state = MUL1;
                next_modwait = 1;
            end
            MUL1: begin
                next_state = ADD1;
                next_modwait = 1;
            end
            ADD1: begin
                next_state = MUL2;
                next_modwait = 1;
                if(overflow)
                    next_state = EIDLE;
            end
            MUL2: begin
                next_state = SUB2;
                next_modwait = 1;
            end
            SUB2: begin
                next_modwait = 1;
                next_state = MUL3;
                if(overflow)
                    next_state = EIDLE;
            end
            MUL3: begin 
                next_state = ADD3;
                next_modwait = 1;
            end
            ADD3: begin
                next_state = MUL4;
                next_modwait = 1;
                if(overflow)
                    next_state = EIDLE;
            end
            MUL4: begin
                next_state = SUB4;
                next_modwait = 1;
            end
            SUB4: begin
                next_modwait = 1;
                next_state = IDLE;
                if(overflow)
                    next_state = EIDLE;
            end
            EIDLE: begin
                next_modwait = 0;
                if(dr)
                    next_state = STORE;
                if(lc)
                    next_state = COEF1;
            end
        endcase
    end

    always_comb begin
        // next_out = 4'b0000;
        // next_op = 3'b000;
        // next_src1 = 4'b0000;
        // next_src2 = 4'b0000;
        // next_dest =  4'b0000;
        out = 4'b0000;
        op = '0;
        src1 = '0;
        src2 = '0;
        dest = '0;
        case(state)
            IDLE: begin
                out = 4'b0000;
                op = NOP;
            end
            COEF1: begin
                out = 4'b0110;
                op = LDR2;
                dest = r6;
            end
            COEF_WAIT1: begin
                out = 4'b0000;
                op = NOP;
                
            end
            COEF2: begin
                out = 4'b0110;
                op = LDR2;
                dest = r7;
                
            end
            COEF_WAIT2: begin
                out = 4'b0000;
                op = NOP;
               
            end
            COEF3: begin
                out = 4'b0110;
                op = LDR2;
                dest = r8;
            end
            COEF_WAIT3: begin
                out = 4'b0000;
                op = NOP;
                
            end
            COEF4: begin
                out = 4'b0110;
                op = LDR2;
                dest = r9;
                
            end
            STORE: begin
                out = 4'b0010;
                op = LDR1;
                dest = r5;
                
            end
            ZERO: begin
                out = 4'b1010;
                op = SUB;
                src1 = r1;
                src2 = r1;
                dest = r0;
                
            end
            SORT1: begin
                out = 4'b0010;
                op = COPY;
                src1 = r3;
                dest = r4;
                
            end
            SORT2: begin
                out = 4'b0010;
                op = COPY;
                src1 = r2;
                dest = r3;
                
            end
            SORT3: begin
                out = 4'b0010;
                op = COPY;
                src1 = r1;
                dest = r2;
                
            end
            SORT4: begin
                out = 4'b0010;
                op = COPY;
                src1 = r5;
                dest = r1;
                
            end
            MUL1: begin
                out = 4'b0010;
                op = MUL;
                src1 = r4;
                src2 = r9;
                dest = r5;
                
            end
            ADD1: begin
                out = 4'b0010;
                op = ADD;
                src1 = r0;
                src2 = r5;
                dest = r0;
                
            end
            MUL2: begin
                out = 4'b0010;
                op = MUL;
                src1 = r3;
                src2 = r8;
                dest = r5;
                
            end
            SUB2: begin
                out = 4'b0010;
                op = SUB;
                src1 = r0;
                src2 = r5;
                dest = r0;
                
            end
            MUL3: begin
                out = 4'b0010;
                op = MUL;
                src1 = r2;
                src2 = r7;
                dest = r5;
                
            end
            ADD3: begin
                out = 4'b0010;
                op = ADD;
                src1 = r0;
                src2 = r5;
                dest = r0;
                
            end
            MUL4: begin
                out = 4'b0010;
                op = MUL;
                src1 = r1;
                src2 = r6;
                dest = r5;
                
            end
            SUB4: begin
                out = 4'b0010;
                op = SUB;
                src1 = r0;
                src2 = r5;
                dest = r0;
                
            end
            EIDLE: begin
                out = 4'b0001;
                op = NOP;
                
            end
        endcase
    end

endmodule