module PID_detect (
  input logic clk,
  input logic n_rst,
  input logic [7:0] rcv_data,
  input logic PID_clear,
  input logic PID_set,
  output logic [3:0] PID,
  output logic PID_err
);
  logic [7:0] PID_reg;
  logic [7:0] next_PID_reg;

  assign PID = PID_reg[3:0];

  always_ff @(posedge clk, negedge n_rst) begin
    if (n_rst == 0) begin
      PID_reg <= '1;
    end else begin
      PID_reg <= next_PID_reg;
    end
  end

  always_comb begin
    next_PID_reg = PID_reg;
    if (PID_clear) begin
      next_PID_reg = '1;
    end
    if(PID_set) begin
      next_PID_reg = rcv_data;
    end
  end

  assign PID_err = !((PID == 4'b0001) || (PID == 4'b1001) || (PID == 4'b0011) || (PID == 4'b1011) || (PID == 4'b0010) || (PID == 4'b1010) || (PID == 4'b1110));
  
endmodule