module ahb_lite_slave
(
  input logic clk,
  input logic n_rst,
  input logic [1:0] coefficient_num,
  input logic modwait,
  input logic [15:0] fir_out,
  input logic err,
  input logic hsel,
  input logic [3:0] haddr,
  input logic hsize,
  input logic [1:0] htrans,
  input logic hwrite,
  input logic coeff_clr, // added signal
  output logic [15:0] sample_data,
  output logic data_ready,
  output logic new_coefficient_set,
  output logic [15:0] fir_coefficient,
  output logic hrdata,
  output logic hresp
);

  // write register
  logic [15:0] next_sample_data;

  logic [15:0] f0;
  logic [15:0] next_f0;

  logic [15:0] f1;
  logic [15:0] next_f1;

  logic [15:0] f2;
  logic [15:0] next_f2;

  logic [15:0] f3;
  logic [15:0] next_f3;

  logic [7:0] new_coeff;
  logic [7:0] next_new_coeff;
  assign new_coefficient_set = new_coeff[0];

  // read register
  logic [15:0] status;
  assign status[0] = modwait;
  assign status[8] = err;

  // other register
  logic [3:0] wait_addr;

  logic [15:0] next_hrdata;
  
  // err logic
  always_comb begin
    hresp = 0;
    if(haddr == 4'hf)
      hresp = 1;
    else if(pwrite && (haddr == 4'h0 || haddr == 4'h1 || haddr == 4'h2 || haddr == 4'h3))
      hresp = 1;
  end

  // write logic
  always_comb begin
    next_sample_data = sample_data;
    next_f0 = f0;
    next_f1 = f1;
    next_f2 = f2;
    next_f3 = f3;
    next_new_coeff = new_coeff
    if(hsize == 0) begin
      case(wait_addr)
        4'h4: next_sample_data = {sample_data[15:8] ,hwrite[7:0]};
        4'h5: next_sample_data = {hwrite[7:0], sample_data[7:0]};
        4'h6: next_f0 = {f0[15:8], hwrite[7:0]};
        4'h7: next_f0 = {hwrite[7:0], f0[7:0]};
        4'h8: next_f1 = {f1[15:8], hwrite[7:0]};
        4'h9: next_f1 = {hwrite[7:0], f1[7:0]};
        4'ha: next_f2 = {f2[15:8], hwrite[7:0]};
        4'hb: next_f2 = {hwrite[7:0], f2[7:0]};
        4'hc: next_f3 = {f3[15:8], hwrite[7:0]};
        4'hd: next_f3 = {hwrite[7:0], f3[7:0]};
        4'he: next_new_coeff = hwrite[7:0];
      endcase
    end
    else begin
      case(wait_addr) begin
        4'h4: next_sample_data = hwrite;
        4'h5: next_sample_data = hwrite;
        4'h6: next_f0 = hwrite;
        4'h7: next_f0 = hwrite;
        4'h8: next_f1 = hwrite;
        4'h9: next_f1 = hwrite;
        4'ha: next_f2 = hwrite;
        4'hb: next_f2 = hwrite;
        4'hc: next_f3 = hwrite;
        4'hd: next_f3 = hwrite;
        4'he: next_new_coeff = hwrite[7:0];
      endcase
    end
  end

  // read logic 
  always_comb begin
    next_hrdata = hrdata;
    if(hsize == 0) begin
      case(haddr)
        4'h0: next_hrdata = {8'b0, status[7:0]};
        4'h1: next_hrdata = {8'b0, status[15:8]};
        4'h2: next_hrdata = {8'b0, fir_out[7:0]};
        4'h3: next_hrdata = {8'b0, fir_out[15:8]};
        4'h4: next_hrdata = {8'b0, sample_data[7:0]};
        4'h5: next_hrdata = {8'b0, sample_data[15:8]};
        4'h6: next_hrdata = {8'b0, f0[7:0]};
        4'h7: next_hrdata = {8'b0, f0[15:8]};
        4'h8: next_hrdata = {8'b0, f1[7:0]};
        4'h9: next_hrdata = {8'b0, f1[15:8]};
        4'ha: next_hrdata = {8'b0, f2[7:0]};
        4'hb: next_hrdata = {8'b0, f2[15:8]};
        4'hc: next_hrdata = {8'b0, f3[7:0]};
        4'hd: next_hrdata = {8'b0, f3[15:8]};
        4'he: next_hrdata = new_coeff;
      endcase
    end
    else begin
      4'h0: next_hrdata = status;
      4'h1: next_hrdata = status;
      4'h2: next_hrdata = fir_out;
      4'h3: next_hrdata = fir_out;
      4'h4: next_hrdata = sample_data;
      4'h5: next_hrdata = sample_data;
      4'h6: next_hrdata = f0;
      4'h7: next_hrdata = f0;
      4'h8: next_hrdata = f1;
      4'h9: next_hrdata = f1;
      4'ha: next_hrdata = f2;
      4'hb: next_hrdata = f2;
      4'hc: next_hrdata = f3;
      4'hd: next_hrdata = f3;
      4'he: next_hrdata = {8'b0, new_coeff};
    end
  end

  // coefficient load logic
  always_comb begin
    next_new_coeff = new_coeff;
    if(coeff_clr)
      next_new_coeff = '0;
    if(new_coeff) begin
      case(coefficient_num)
        2'd0: fir_coefficient = f0;
        2'd1: fir_coefficient = f1;
        2'd2: fir_coefficient = f2;
        2'd3: fir_coefficient = f3;
        default: fir_coefficient = '0;
      endcase
    end
  end

  // registers
  // addr register
  always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      wait_addr <= '0;
    end
    else begin
      wait_addr <= haddr;
    end
  end

  // sample data register
  always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      sample_data <= '0;
    end
    else begin
      sample_data <= next_sample_data;
    end
  end

  // f0 register
  always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      f0 <= '0;
    end
    else begin
      f0 <= next_f0;
    end
  end

  // f1 register
  always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      f1 <= '0;
    end
    else begin
      f1 <= next_f1;
    end
  end

  // f2 register
  always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      f2 <= '0;
    end
    else begin
      f2 <= next_f2;
    end
  end

  // f3 register
  always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      f3 <= '0;
    end
    else begin
      f3 <= next_f3;
    end
  end

  // new_coeff register
  always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      new_coeff <= '0;
    end
    else begin
      new_coeff <= next_new_coeff;
    end
  end

  // hrdata register
  always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      hrdata <= '0;
    end
    else begin
      hrdata <= next_hrdata;
    end
  end


endmodule
