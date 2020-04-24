module decode (
  input logic clk,
  input logic n_rst,
  input logic d_plus,
  input logic shift_enable,
  input logic eop,
  output logic d_orig
);
  logic middle;
  logic tail;
  logic next_tail;

  always_comb begin
    if (shift_enable) begin
      if (eop) begin
        next_tail = 1;
      end else begin
        next_tail = middle;
      end
    end else begin
      next_tail = tail;
    end
  end

  always_ff @(posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      middle <= 1;
      tail <= 1;
    end else begin
      middle <= d_plus;
      tail <= next_tail;
    end
  end
  
  assign d_orig = !(tail ^ middle);
  
endmodule