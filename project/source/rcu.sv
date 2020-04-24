module rcu (
  input logic clk,
  input logic n_rst,
  input logic d_edge,
  input logic eop,
  input logic shift_enable,
  input logic [7:0] rcv_data,
  input logic byte_received,
  output logic rcving,
  output logic w_enable,
  output logic r_error
);
  localparam SYNC_BYTE = 8'b10000000;

  typedef enum bit[3:0] {IDLE, SYN, WAIT, RCV, WRITE, EOP, EEOP, ERR, EIDLE} stateType;
  stateType state;
  stateType next_state;

  logic [2:0] out; // [rcving, w_enable, r_error]
  assign rcving = out[2];
  assign w_enable = out[1];
  assign r_error = out[0];

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
          next_state = WAIT;
        else if((rcv_data != SYNC_BYTE) && byte_received)
          next_state = ERR;
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
        out = 3'b100;
      end
      WAIT: begin
        out = 3'b100;
      end
      RCV: begin
        out = 3'b100;
      end
      WRITE: begin
        out = 3'b110;
      end
      EEOP: begin
        out = 3'b101;
      end
      EIDLE: begin
        out = 3'b001;
      end
      EOP: begin
        out = 3'b100;
      end
      ERR: begin
        out = 3'b101;
      end
    endcase
  end

endmodule