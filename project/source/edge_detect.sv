module edge_detect (
  input logic clk,
  input logic n_rst,
  input logic d_plus,
  output logic d_edge
);
  logic middle;
  logic next_middle;
  logic tail;
  logic next_tail;
  always_comb begin
    next_middle = d_plus;
    next_tail = middle;
    d_edge = middle ^ tail;
  end

  always_ff begin
    if(n_rst == 0) begin
      middle <= 0;
      tail <= 0;
    end
    else begin
      middle <= next_middle;
      tail <= next_tail;
    end
  end

endmodule