module timer (
  input logic clk,
  input logic n_rst,
  input logic d_edge,
  input logic rcving,
  input logic stuff_bit,
  output logic shift_enable,
  output logic byte_received
);
  localparam NUM_CNT_BITS = 4;
  logic clear;
  localparam rollover_val = 4'd8;
  
  logic [NUM_CNT_BITS - 1:0] count_out;
  logic count_enable;
  logic rollover_flag;
  reg [NUM_CNT_BITS - 1:0] next_count;
  reg next_flag;
  logic reset;
  
  assign count_enable = rcving;
  assign shift_enable = rollover_flag;
  assign clear = d_edge;
  assign reset = (n_rst == 0) || !rcving;

  always_ff @ (posedge clk, posedge reset) begin
      if (reset) begin
          count_out <= 4'd6;
          rollover_flag <= 0;
      end else begin
          count_out <= next_count;
          rollover_flag <= next_flag;
      end
  end

  always_comb begin
      if(clear) begin
          next_count = 4'd6;
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


  logic bit_count_enable;
  assign bit_count_enable = shift_enable & ~stuff_bit;

  flex_counter #(
    .NUM_CNT_BITS(4)
  )
  wrap
  (
    .clk(clk),
    .n_rst(n_rst && rcving),
    .clear(1'b0),
    .count_enable(bit_count_enable),
    .rollover_val(4'd8),
    .rollover_flag(byte_received)
  );

endmodule