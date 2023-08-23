`timescale 1ns/1ps

module SWD_t();

reg clk = 0, rst=1;
reg in=0;
wire dec;

    always #1 clk = ~clk;

    Sliding_Window_Sequence_Detector SWSD ( .clk(clk), .rst_n(rst), .in(in), .dec(dec) );

    initial begin

        $fsdbDumpfile("SWD.fsdb");
        $fsdbDumpvars;

        @(negedge clk)
            rst = 0;
        @(negedge clk)
            rst = 1;
        //simple test: 11001001
            in = 1;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        //test continue last time 1: 1_1001001
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        // test repeat 10: 1_100(10101010)01
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        // test reset suddenly
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
            rst = 0;
        @(negedge clk)
            rst = 1;
            in = 0;
        @(negedge clk)
            in = 1;
        //test no 10 exist: 1_1000001
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        //test no 1100 begin: 1_1101001
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        //test not 01 tail: 1_1001000
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 1;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        @(negedge clk)
            in = 0;
        
        @(negedge clk)
            in = 1;

        #4 $finish;
    end

endmodule