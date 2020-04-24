module timer (
  input logic clk,
  input logic n_rst,
  input logic d_edge,
  input logic rcving,
  output logic shift_enable,
  output logic byte_received
);
  localparam NUM_CNT_BITS = 3;
  localparam clear = 0;
  localparam rollover_val = 3'd7;
  
  logic count_out;
  logic count_enable;
  logic rollover_flag;
  reg [NUM_CNT_BITS - 1:0] next_count;
  reg next_flag;
  
  assign count_enable = rcving;
  assign shift_enable = rollover_flag;

  always_ff @ (posedge clk, negedge n_rst) begin
      if (n_rst == 0 || !rcving || d_edge) begin
          count_out <= 3'd4;
          rollover_flag <= 0;
      end else begin
          count_out <= next_count;
          rollover_flag <= next_flag;
      end
  end

  always_comb begin
      if(clear) begin
          next_count = 0;
      end
      else if(count_enable) begin
          if(rollover_val == count_out) begin
              next_count = 1;
          end
          else begin
              next_count = count_out + 1;
          end
      end
      else begin
          next_count = count_out;
      end
  end

  always_comb begin
      if(clear) 
          next_flag = 0;
      else if(rollover_val == next_count) begin
          next_flag = 1;
      end
      else begin
          next_flag = 0;
      end
  end

  flex_counter #(
    .NUM_CNT_BITS(3)
  )
  wrap
  (
    .clk(clk),
    .n_rst(n_rst && rcving),
    .clear(clear),
    .count_enable(shift_enable),
    .rollover_val(3'd7),
    .rollover_flag(byte_received)
  );

endmodule