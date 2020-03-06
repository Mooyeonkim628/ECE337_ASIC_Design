module apb_slave
(
    input logic clk,
    input logic n_rst,
    input logic [7:0] rx_data,
    input logic data_ready,
    input logic overrun_error,
    input logic framing_error,
    input logic psel,
    input logic [2:0] paddr,
    input logic penable,
    input logic pwrite,
    input logic [7:0] pwdata,
    output logic [7:0] prdata,
    output logic pslverr,
    output logic data_read,
    output logic [3:0] data_size,
    output logic [13:0] bit_period
);
    logic [2:0] read_sel;
    logic [2:0] write_sel;

    // registers
    logic [7:0] bit_period_0;
    logic [7:0] next_bit_period_0;

    logic [7:0] bit_period_1;
    logic [7:0] next_bit_period_1;

    logic [7:0] data_size_reg;
    logic [7:0] next_data_size_reg;
    
    logic [7:0] next_prdata;

    logic [7:0] error_value;

    logic next_data_read;

    assign bit_period = {bit_period_1[5:0], bit_period_0};
    assign data_size = data_size_reg[3:0];

    // error logic
    always_comb begin
        error_value = 8'd0;
        if(framing_error)
            error_value = 8'd1;
        else if(overrun_error)
            error_value = 8'd2; 
    end

    // read mux logic
    always_comb begin
        next_prdata = prdata;
        next_data_read = 0;
        case(read_sel)
            3'd0: next_prdata = {7'd0, data_ready};
            3'd1: next_prdata = error_value;
            3'd2: next_prdata = bit_period_0;
            3'd3: next_prdata = bit_period_1;
            3'd4: next_prdata = data_size_reg;
            3'd6: begin
                next_prdata = rx_data;
                next_data_read = 1;
            end 
            3'd7: next_prdata = '0;
        endcase

    end

    // wirte mux logic
    always_comb begin
        next_bit_period_0 = bit_period_0;
        next_bit_period_1 = bit_period_1;
        next_data_size_reg = data_size_reg;
        case(write_sel)
            3'b001: next_bit_period_0 = pwdata;
            3'b010: next_bit_period_1 = pwdata;
            3'b100: next_data_size_reg = pwdata[3:0];
        endcase
    end

    // control logic
    always_comb begin
        write_sel = '0;
        read_sel = 3'd7;
        pslverr = 0;
        if(psel && penable && !pwrite)
            read_sel = paddr;
        if(psel && penable && pwrite) begin
            case(paddr)
                3'd2: write_sel = 3'b001; // bit period 0
                3'd3: write_sel = 3'b010; // bit period 1
                3'd4: write_sel = 3'b100; // data size
            endcase
        end
        if(pwrite && (paddr == 3'd0 || paddr == 3'd1 || paddr == 3'd6))
            pslverr = 1;
    end

    // data read reegister
    always_ff @ (clk, n_rst) begin
        if(n_rst == 0)
            data_read = '0;
        else
            data_read = next_data_read;
    end

    // prdata register
    always_ff @ (clk, n_rst) begin
        if(n_rst == 0)
            prdata = '0;
        else
            prdata = next_prdata;
    end

    // bit period 0 register
    always_ff @ (clk, n_rst) begin
        if(n_rst == 0)
            bit_period_0 <= '0;
        else
            bit_period_0 <= next_bit_period_0;
    end

    // bit period 1 register
    always_ff @ (clk, n_rst) begin
        if(n_rst == 0)
            bit_period_1 <= '0;
        else
            bit_period_1 <= next_bit_period_1;
    end

    // data_size_reg register
    always_ff @ (clk, n_rst) begin
        if(n_rst == 0)
            data_size_reg <= '0;
        else
            data_size_reg <= next_data_size_reg;
    end



endmodule