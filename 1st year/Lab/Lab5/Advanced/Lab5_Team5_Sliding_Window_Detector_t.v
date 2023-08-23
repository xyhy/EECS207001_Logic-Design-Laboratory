`timescale 1ns/1ps
`define CYC 4

module  Sliding_Window_Detector_t;
    reg clk = 0, rst_n = 1'b1;
    reg in;
    wire dec1, dec2;

    Sliding_Window_Detector Detector( .clk(clk), .rst_n(rst_n), .in(in), .dec1(dec1), .dec2(dec2));

    always #(`CYC/2)    clk = ~clk;

    initial begin
        # `CYC;
        rst_n = 1'b0;
        # `CYC;
        rst_n = 1'b1;


        @(negedge clk) begin
            in = 1'b0;
        end

        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        // 101 dec1 = 1;
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        // 101 dec1 = 1;
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        // 1101 dec1 = 1, dec2 = 1;
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        // 1111 flag = 1;
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        // 1101 dec1 = 0, dec2 = 1;
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        // 101 dec1 = 0;
        @(negedge clk) begin
            rst_n = 1'b0;
        end
        @(negedge clk) begin
            rst_n = 1'b1;
        end
        // reset
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        // 101 dec1 = 1;(check reset flag)

        #1 $finish;
    end
endmodule