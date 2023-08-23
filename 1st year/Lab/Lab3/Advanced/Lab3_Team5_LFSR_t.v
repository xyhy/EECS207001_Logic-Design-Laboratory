`timescale 1ns/1ps
`define CYC 4

module  LFSR_t;
    reg clk = 1;
    reg rst = 0;
    wire out;

    LFSR shift( .clk(clk), .rst_n(rst), .out(out) );

    always #(`CYC/2)    clk = ~clk;

    initial begin
        #(`CYC/2)
        rst =1 ;
        repeat(2**5)begin
            @(posedge clk);
        end

        repeat(2**5)begin
            @(negedge clk);
            rst = ($random)%2;
        end
        
        
        #1 $finish;
    end
endmodule