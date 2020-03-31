module coefficient_loader
(
  input logic clk,
  input logic n_reset,
  input logic new_coefficient_set,
  input logic modwait,
  output logic load_coeff,
  output logic [1:0] coefficient_num,
  output logic load_clr //to clear load coefficient in slave module
);

  typedef enum bit[3:0] {IDLE, LOAD0, WAIT0, LOAD1, WAIT1, LOAD2, WAIT2, LOAD3, WAIT3} stateType;
  stateType [3:0]state;
  stateType [3:0]next_state;

  always_ff @ (posedge clk, negedge n_reset) begin
    if(n_reset == 0) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end

  always_comb begin
    next_state = state;
    case(state)
      IDLE: begin
        if(new_coefficient_set)
          next_state = LOAD0;
      end
      LOAD0: next_state = WAIT0;
      WAIT0: begin
        if(!modwait)
          next_state = LOAD1;
      end
      LOAD1: next_state = WAIT1;
      WAIT1: begin
        if(!modwait)
          next_state = LOAD2;
        end
      LOAD2: next_state = WAIT2;
      WAIT2: begin
        if(!modwait)
          next_state = LOAD3;
        end
      LOAD3: next_state = WAIT3;
      WAIT3: begin
        if(!modwait)
          next_state = IDLE;
        end
    endcase
  end

  always_comb begin
    load_coeff = 0;
    coefficient_num = '0;
    load_clr = 0;
    case(state)
      IDLE: begin
        load_coeff = 0;
        coefficient_num = '0;
        load_clr = 0;
      end
      LOAD0: begin
        load_coeff = 1;
        coefficient_num = 2'b00;
        load_clr = 0;
      end
      WAIT0: begin
        load_coeff = 0;
        coefficient_num = 2'b00;
        load_clr = 0;
      end
      LOAD1: begin
        load_coeff = 1;
        coefficient_num = 2'b01;
        load_clr = 0;
      end
      WAIT1: begin
        load_coeff = 0;
        coefficient_num = 2'b01;
        load_clr = 0;
      end
      LOAD2: begin
        load_coeff = 1;
        coefficient_num = 2'b10;
        load_clr = 0;
      end
      WAIT2: begin
        load_coeff = 0;
        coefficient_num = 2'b10;
        load_clr = 0;
      end
      LOAD3: begin
        load_coeff = 1;
        coefficient_num = 2'b11;
        load_clr = 0;
      end
      WAIT3: begin
        load_coeff = 0;
        coefficient_num = 2'b11;
        load_clr = 1;
      end
    endcase
  end

endmodule
