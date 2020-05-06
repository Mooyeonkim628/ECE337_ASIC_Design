
`timescale 1ns / 10ps

module tb_flex_counter();
    localparam  CLK_PERIOD    = 1;
    localparam  FF_SETUP_TIME = 0.190;
    localparam  FF_HOLD_TIME  = 0.100;
    localparam  CHECK_DELAY   = (CLK_PERIOD - FF_SETUP_TIME); // Check right before the setup time starts


    reg tb_clk;
    reg tb_n_rst;
    reg tb_clear;
    reg [3:0] tb_rollover_val_4;
    reg tb_enable;
    reg tb_flag;
    reg [3:0] tb_count_4;

    // Declare test bench signals
    integer tb_test_num;
    string tb_test_case;
    integer tb_stream_test_num;
    string tb_stream_check_tag;

    task check_output;
        input logic [3:0]expected_count;
        input logic expected_flag;
        input string check_tag;
    begin
        if(expected_count == tb_count_4 && expected_flag == tb_flag) begin // Check passed
        $info("Correct output %s during %s test case", check_tag, tb_test_case);
        end
        else begin // Check failed
        $error("Incorrect output %s during %s test case", check_tag, tb_test_case);
        end
    end
    endtask

    task clear_set;
    begin
        tb_clear = 1'b1;
        #(CLK_PERIOD);
        tb_clear = 1'b0;
    end
    endtask

    task reset_dut;
    begin
        tb_n_rst = 0;

        @(posedge tb_clk);
        @(posedge tb_clk);

        @(negedge tb_clk);
        
        tb_n_rst = 1;

        @(negedge tb_clk);
        @(negedge tb_clk);
    end
    endtask

    // generate clk
    always
    begin
        tb_clk = 0;
        #(CLK_PERIOD / 2.0);
        tb_clk = 1;
        #(CLK_PERIOD / 2.0);
    end


    flex_counter DUT(
        .clk(tb_clk),
        .n_rst(tb_n_rst),
        .clear(tb_clear),
        .count_enable(tb_enable),
        .rollover_val(tb_rollover_val_4),
        .count_out(tb_count_4),
        .rollover_flag(tb_flag)
    );


    //test bench main
    initial begin
        tb_n_rst = 1;
        tb_clear = 0;
        tb_rollover_val_4 = 4'b1111;
        tb_enable = 0;

        tb_test_num = 0;
        tb_test_case = "Test Bench initialization";
        tb_stream_test_num = 0;
        tb_stream_check_tag = "N/A";
        #(0.1)

        //*****************************************
        // test case 1: Power-on reset
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Power on Reset";
        #(0.1);

        tb_n_rst = 0;

        #(CLK_PERIOD / 2.0);
        
        check_output(0,0, "after reset applied");

        #(CLK_PERIOD);
        check_output(0,0, "after clock cycle while in reset");
            // Release the reset away from a clock edge
        @(posedge tb_clk);
        #(2 * FF_HOLD_TIME);
        tb_n_rst  = 1'b1;   // Deactivate the chip reset
        #0.1;
        // Check that internal state was correctly keep after reset release
        check_output( 0,0, 
                  "after reset was released");

        //*****************************************
        // test case 2: Rollover for a rollover value that is not a power of two
        @(negedge tb_clk); 
        tb_test_num = tb_test_num + 1;
        tb_test_case = "Rollover for a rollover value that is not a power of two";

        reset_dut();
        clear_set();
        tb_rollover_val_4 = 4'd3;
        tb_enable = 1;

        @(posedge tb_clk);
        #0.2;
        check_output(4'd1,0, "first clk");


        @(posedge tb_clk);
        #0.2;
        check_output(4'd2, 0, "second clk");
        
        @(posedge tb_clk);
        #0.2;
        check_output(4'd3, 1, "third clk");
        
        //*****************************************
        // test case 3: continuous counting 
        @(negedge tb_clk); 
        tb_test_num = tb_test_num + 1;
        tb_test_case = "continuous counting";
        tb_enable = 0;
        reset_dut();
        tb_rollover_val_4 = 4'd15;

        @(posedge tb_clk);
        #0.2;
        tb_enable = 1;

        @(posedge tb_clk);
        #0.2;
        check_output(4'd1,0, "1 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd2, 0, "2 clk");
        
        @(posedge tb_clk);
        #0.2;
        check_output(4'd3, 1, "3 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd4, 0, "4 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd5, 0, "5 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd6, 1, "6 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd7, 0, "7 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd8, 0, "8 clk");
        
        @(posedge tb_clk);
        #0.2;
        check_output(4'd9, 0, "9 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd10, 0, "10 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd11, 0, "11 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd12, 0, "12 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd13, 0, "13 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd14, 0, "14 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd15, 1, "15 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd0, 0, "16 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd1, 0, "17 clk");


        //*****************************************
        // test case 4: discontinuous counting 
        @(negedge tb_clk); 
        tb_test_num = tb_test_num + 1;
        tb_test_case = "discontinuous counting";
        tb_enable = 0;
        reset_dut();
        tb_rollover_val_4 = 4'd3;

        @(posedge tb_clk);
        #0.2;
        tb_enable = 1;

        @(posedge tb_clk);
        #0.2;
        check_output(4'd1,0, "1 clk");

        @(posedge tb_clk);
        #0.2;
        tb_enable = 0;
        check_output(4'd2, 0, "2 clk");
        
        @(posedge tb_clk);
        #0.2;
        check_output(4'd2, 0, "3 clk");

        @(posedge tb_clk);
        #0.2;
        tb_enable = 1;
        check_output(4'd2, 0, "4 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd3, 1, "5 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd1, 0, "6 clk");



        //*****************************************
        // test case 5: continuous counting 2
        @(negedge tb_clk); 
        tb_test_num = tb_test_num + 1;
        tb_test_case = "continuous counting 2";
        tb_enable = 0;
        reset_dut();
        tb_clear = 0;
        tb_rollover_val_4 = 4'b1100;

        @(posedge tb_clk);
        #0.2;
        tb_enable = 1;

        @(posedge tb_clk);
        #0.2;
        check_output(4'b0001,0, "1 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b0010, 0, "2 clk");
        
        @(posedge tb_clk);
        #0.2;
        check_output(4'b0011, 1, "3 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b0100, 0, "4 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b0101, 0, "5 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b0110, 1, "6 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b0111, 0, "7 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b1000, 0, "8 clk");
        
        @(posedge tb_clk);
        #0.2;
        check_output(4'b1001, 0, "9 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b1010, 0, "10 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b1011, 0, "11 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b1100, 1, "12 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b0001, 0, "13 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b0010, 0, "14 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'b0011, 0, "15 clk");


        //*****************************************
        // test case 6: clearing 
        @(negedge tb_clk); 
        tb_test_num = tb_test_num + 1;
        tb_test_case = "clearing";
        tb_enable = 0;
        reset_dut();
        tb_rollover_val_4 = 4'd3;

        @(posedge tb_clk);
        #0.2;
        tb_enable = 1;

        @(posedge tb_clk);
        #0.2;
        check_output(4'd1,0, "1 clk");

        @(posedge tb_clk);
        #0.2;
        tb_clear = 1;
        check_output(4'd2, 0, "2 clk");
        
        @(posedge tb_clk);
        #0.2;
        tb_clear = 0;
        check_output(4'd0, 0, "3 clk");

        @(posedge tb_clk);
        #0.2;
        tb_enable = 0;
        check_output(4'd1, 0, "4 clk");

        @(posedge tb_clk);
        #0.2;
        tb_clear = 1;
        check_output(4'd1, 0, "5 clk");

        @(posedge tb_clk);
        #0.2;
        check_output(4'd0, 0, "6 clk");

    end


endmodule
