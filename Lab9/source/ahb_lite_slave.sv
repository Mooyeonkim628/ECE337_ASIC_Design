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
  input logic [1:0] htrans,// ??
  input logic hwrite,
  input logic [15:0] hwdata,
  input logic coeff_clr, // added signal
  output logic [15:0] sample_data,
  output logic data_ready, //??
  output logic new_coefficient_set,
  output logic [15:0] fir_coefficient,
  output logic [15:0] hrdata,
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
  assign status = {7'b0, err, 7'b0, modwait};

  // other register
  logic [3:0] wait_addr;

  logic wait_hwrite;
  logic wait_hsel;
  logic [1:0] wait_htrans;
  logic wait_hsize;

  // logic [15:0] next_hrdata;

  logic next_data_ready;
  
  // err logic
  always_comb begin
    hresp = 0;
    if(haddr == 4'hf)
      hresp = 1;
    else if(hwrite && (haddr == 4'h0 || haddr == 4'h1 || haddr == 4'h2 || haddr == 4'h3))
      hresp = 1;
  end

  // write logic
  always_comb begin
    next_sample_data = sample_data;
    next_f0 = f0;
    next_f1 = f1;
    next_f2 = f2;
    next_f3 = f3;
    next_new_coeff = new_coeff;
    next_data_ready = data_ready;
    if(wait_hsize == 0 && wait_hwrite && wait_hsel && wait_htrans == 2'd2) begin
      $info("write debug 0");
      case(wait_addr)
        4'h4: next_sample_data = {sample_data[15:8] ,hwdata[7:0]};
        4'h5: next_sample_data = {hwdata[7:0], sample_data[7:0]};
        4'h6: next_f0 = {f0[15:8], hwdata[7:0]};
        4'h7: next_f0 = {hwdata[7:0], f0[7:0]};
        4'h8: next_f1 = {f1[15:8], hwdata[7:0]};
        4'h9: next_f1 = {hwdata[7:0], f1[7:0]};
        4'ha: next_f2 = {f2[15:8], hwdata[7:0]};
        4'hb: next_f2 = {hwdata[7:0], f2[7:0]};
        4'hc: next_f3 = {f3[15:8], hwdata[7:0]};
        4'hd: next_f3 = {hwdata[7:0], f3[7:0]};
        4'he: next_new_coeff = hwdata[7:0];
      endcase
    end
    else if(wait_hsize == 1 && wait_hwrite && wait_hsel && wait_htrans == 2'd2) begin
      $info("write debug 1");
      case(wait_addr)
        4'h4: next_sample_data = hwdata;
        4'h5: next_sample_data = hwdata;
        4'h6: next_f0 = hwdata;
        4'h7: next_f0 = hwdata;
        4'h8: next_f1 = hwdata;
        4'h9: next_f1 = hwdata;
        4'ha: next_f2 = hwdata;
        4'hb: next_f2 = hwdata;
        4'hc: next_f3 = hwdata;
        4'hd: next_f3 = hwdata;
        4'he: next_new_coeff = hwdata[7:0];
      endcase
    end

   // data ready logic
   if(modwait) begin
     next_data_ready = 0;
   end
   else if(hwrite && hsel && htrans == 2'd2 && (haddr == 4'h4 || haddr == 4'h5)) begin
     next_data_ready = 1;
   end
   

    // cofficient load logic
    if(coeff_clr) begin
      next_new_coeff = '0;
    end
    case(coefficient_num)
      2'd0: fir_coefficient = f0;
      2'd1: fir_coefficient = f1;
      2'd2: fir_coefficient = f2;
      2'd3: fir_coefficient = f3;
      default: fir_coefficient = '0;
    endcase
  end

  // read logic 
  always_comb begin
    // next_hrdata = hrdata;
    if(wait_hsize == 0 && !wait_hwrite && wait_hsel && wait_htrans == 2'd2) begin
      $info("read debug 0");
      case(wait_addr)
        4'h0: hrdata = {8'b0, status[7:0]};
        4'h1: hrdata = {8'b0, status[15:8]};
        4'h2: hrdata = {8'b0, fir_out[7:0]};
        4'h3: hrdata = {8'b0, fir_out[15:8]};
        4'h4: hrdata = {8'b0, sample_data[7:0]};
        4'h5: hrdata = {8'b0, sample_data[15:8]};
        4'h6: hrdata = {8'b0, f0[7:0]};
        4'h7: hrdata = {8'b0, f0[15:8]};
        4'h8: hrdata = {8'b0, f1[7:0]};
        4'h9: hrdata = {8'b0, f1[15:8]};
        4'ha: hrdata = {8'b0, f2[7:0]};
        4'hb: hrdata = {8'b0, f2[15:8]};
        4'hc: hrdata = {8'b0, f3[7:0]};
        4'hd: hrdata = {8'b0, f3[15:8]};
        4'he: hrdata = new_coeff;
      endcase
    end
    else if(wait_hsize == 1 && !wait_hwrite && wait_hsel && wait_htrans == 2'd2) begin
      $info("read debug 1");
      case(wait_addr)
        4'h0: hrdata = status;
        4'h1: hrdata = status;
        4'h2: hrdata = fir_out;
        4'h3: hrdata = fir_out;
        4'h4: hrdata = sample_data;
        4'h5: hrdata = sample_data;
        4'h6: hrdata = f0;
        4'h7: hrdata = f0;
        4'h8: hrdata = f1;
        4'h9: hrdata = f1;
        4'ha: hrdata = f2;
        4'hb: hrdata = f2;
        4'hc: hrdata = f3;
        4'hd: hrdata = f3;
        4'he: hrdata = {8'b0, new_coeff};
      endcase
    end
    else begin
      hrdata = '0;
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

  // hwrite, hsel, hsize, htrans register 
  always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      wait_hwrite <= '0;
      wait_hsel <= '0;
      wait_htrans <= '0;
      wait_hsize <= '0;
    end
    else begin
      wait_hwrite <= hwrite;
      wait_hsel <= hsel;
      wait_htrans <= htrans;
      wait_hsize <= hsize;
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

  // // hrdata register
  // always_ff @ (posedge clk, negedge n_rst) begin
  //   if(n_rst == 0) begin
  //     hrdata <= '0;
  //   end
  //   else begin
  //     hrdata <= next_hrdata;
  //   end
  // end

  // data ready register
  always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 0) begin
      data_ready <= '0;
    end
    else begin
      data_ready <= next_data_ready;
    end
  end


endmodule
