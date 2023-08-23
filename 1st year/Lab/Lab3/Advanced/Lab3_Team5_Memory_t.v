`timescale 1ns/1ps
`define CYC 4

module  Memory_t;
    reg clk=0, read, write;
    reg [8-1:0] in;
    reg [7-1:0] address =0;
    wire [8-1:0] out;

    Memory mem( .clk(clk), .ren(read), .wen(write), .addr(address), .din(in), .dout(out) );

    always #(`CYC/2)    clk = ~clk;

    initial begin


        
        read = 1'b0;
        write = 1'b1;
        in = 1'b0;
        
        repeat(2**7)begin
            @(negedge clk);
            in = ($random)%128;
            address = address+1'b1;
        end
    
        in = 1'b0;
        read = 1'b1;
        write = 1'b0;
        repeat(2**7)begin
            @(negedge clk);
            write = ($random)%2;
            address = address-1'b1;
        end
        
        
        #1 $finish;
    end
endmodule