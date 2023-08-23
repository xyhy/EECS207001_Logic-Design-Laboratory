`timescale 1ns/1ps
`define CYC 4

module  Mealy_Sequence_Detector_t;
    reg clk = 0, rst_n;
    reg in;
    wire dec;

    Mealy_Sequence_Detector Detector( .clk(clk), .rst_n(rst_n), .in(in), .dec(dec) );

    always #(`CYC/2)    clk = ~clk;

    initial begin
        rst_n = 1'b1;
        # `CYC;
        rst_n = 1'b0;
        # `CYC;
        rst_n = 1'b1;

        //check S0->S1->S2->S3->S0 by 1011  (dec = 1)
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        
        //check S0->S1->S2->S3->S0 by 1010  (dec = 1)
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b0;
        end

        //check S0->S4->S5->S6->S0 by 0011  (dec = 1)
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b1;
        end

        //check S0->S4->S5->S6->S0 by 0010  (dec = 0)
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b0;
        end

        //check S0->S1->F1->F2->S0 by 11xx  (dec = 0)
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = $random%2;
        end
        @(negedge clk) begin
            in = $random%2;
        end

        //check S0->S1->S2->F2->S0 by 100x  (dec = 0)
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = $random%2;
        end

        //check S0->S4->F1->F2->S0 by 01xx  (dec = 0)
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b1;
        end
        @(negedge clk) begin
            in = $random%2;
        end
        @(negedge clk) begin
            in = $random%2;
        end

        //check S0->S4->S5->F2->S0 by 000x  (dec = 0)
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = 1'b0;
        end
        @(negedge clk) begin
            in = $random%2;
        end

        #1 $finish;
    end
endmodule