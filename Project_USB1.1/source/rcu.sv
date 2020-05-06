module rcu (
  input logic clk,
  input logic n_rst,
  input logic d_edge,
  input logic eop,
  input logic shift_enable,
  input logic [7:0] rcv_data,
  input logic byte_received,
  input logic PID_err,
  output logic rcving,
  output logic w_enable,
  output logic r_error,
  output logic PID_clear,
  output logic PID_set
);
  localparam SYNC_BYTE = 8'b10000000;

  typedef enum bit[3:0] {IDLE, SYN, WAIT, RCV, PID_WAIT, PID_RCV, PID_WRITE, PID_CHECK, WRITE, EOP, EEOP, ERR, EIDLE} stateType;
  stateType state;
  stateType next_state;

  logic [4:0] out; // [rcving, w_enable, r_error]
  assign rcving = out[4];
  assign w_enable = out[3];
  assign r_error = out[2];
  assign PID_clear = out[1];
  assign PID_set = out[0];

  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 0) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end
  
  // next state logic
  always_comb begin
    next_state = state;
    case(state)
      IDLE: begin
        if(d_edge)
            next_state = SYN;
      end
      SYN: begin
        if((rcv_data == SYNC_BYTE) && byte_received)
          next_state = PID_WAIT;
        else if((rcv_data != SYNC_BYTE) && byte_received)
          next_state = ERR;
      end
      PID_WAIT: begin
        if(shift_enable && !eop)
          next_state = PID_RCV;
        else if(shift_enable && eop)
          next_state = EEOP;
      end
      PID_RCV: begin
        if(shift_enable && eop)
          next_state = EEOP;
        else if(byte_received)
          next_state = PID_WRITE;
      end
      PID_WRITE: begin
        next_state = PID_CHECK;
      end
      PID_CHECK: begin
        if(PID_err)
          next_state = ERR;
        else
          next_state = WAIT;
      end
      WAIT: begin
        if(shift_enable && !eop)
          next_state = RCV;
        else if(shift_enable && eop)
          next_state = EOP;
      end
      RCV: begin
        if(byte_received)
          next_state = WRITE;
        else if(shift_enable && eop)
          next_state = EEOP;
      end
      WRITE: begin
        next_state = WAIT;
      end
      EEOP: begin
        if(d_edge)
          next_state = EIDLE;
      end
      EIDLE: begin
        if(d_edge)
          next_state = SYN;
      end
      EOP: begin
        if(d_edge)
        next_state = IDLE;
      end
      ERR: begin
        if(shift_enable && eop)
          next_state = EEOP;
      end
    endcase
  end

  //output lopgic 
  always_comb begin
    out = '0;
    case(state)
      IDLE: begin
        out = '0;
      end
      SYN: begin
        out = 5'b10010;
      end
      PID_WAIT:begin
        out = 5'b10000;
      end
      PID_RCV: begin
        out = 5'b10000;
      end
      PID_WRITE: begin
        out = 5'b10001;
      end
      PID_CHECK: begin
        out = 5'b10000;
      end
      WAIT: begin
        out = 5'b10000;
      end
      RCV: begin
        out = 5'b10000;
      end
      WRITE: begin
        out = 5'b11000;
      end
      EEOP: begin
        out = 5'b10100;
      end
      EIDLE: begin
        out = 5'b00100;
      end
      EOP: begin
        out = 5'b10000;
      end
      ERR: begin
        out = 5'b10100;
      end
    endcase
  end

endmodule