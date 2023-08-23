`timescale 1ns/1ps

`define CYC 4



module Parameterized_Ping_Pong_Counter_t;
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg enable = 1'b0;
//    reg flip = 0;
//    reg [4-1:0] max;
//    reg [4-1:0] min;
    wire direction;
    wire [4-1:0] out;

    Parameterized_Ping_Pong_Counter ppc (
        .clk (clk),
        .rst_n (rst_n),
        .enable (enable),
//        .flip (flip),
//        .max (max),
//        .min (min),
        .direction (direction),
        .out (out)
    );

    always #(`CYC / 2) clk = ~clk;

    initial begin
        //test all Dout 0 to 15 and 15 to 0;
        @(negedge clk);
//            max = 15;
//            min = 0;
            rst_n = 1'b0;
        @(negedge clk);
            rst_n = 1'b1;
            enable = 1'b1;
        #(`CYC * 30);

        //test flip
//        #(`CYC * 5);
//        @ (negedge clk);
//            flip = 1'b1;
//        @ (negedge clk);
//            flip = 1'b0;
//        #(`CYC * 5);

        //decreasing MAX and increasing MIN

//        repeat(8)begin
//            @(negedge clk);
//                max = max-1;
//                min = min+1;
//            #(`CYC * 3);  //test rst_delay
//            @(negedge clk);
//                rst_n = 1'b0;
//            @(negedge clk);
//                rst_n = 1'b1;
//                enable = 1'b1;
//            #(`CYC * 12);

//            //test flip
//            #(`CYC * 5);
//            @ (negedge clk);
//                flip = 1'b1;
//            @ (negedge clk);
//                flip = 1'b0;
//            #(`CYC * 5);
//        end
        #1 $finish;
    end




    initial begin
        @ (negedge clk)
//        max = 15;
//        min = 0;
        rst_n = 1'b0;
        @ (negedge clk)
        rst_n = 1'b1;
        enable = 1'b1;

//        #(`CYC * 5)
//        @ (negedge clk)
//        flip = 1'b1;
//        @ (negedge clk)
//        flip = 1'b0;

//        @ (negedge clk)
//        flip = 1'b1;
//        @ (negedge clk)
//        flip = 1'b0;

//        @ (negedge clk)
//        flip = 1'b1;
//        @ (negedge clk)
//        flip = 1'b0;

        #(`CYC * 20)
        enable = 1'b0;
        
        
        

        #(`CYC * 5)
        enable = 1'b1;
//        max = 10;
//        min = 5;

        #(`CYC * 20)
        $finish;
    end
    
endmodule
