`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output [7:0] out;
reg [7:0] dff;
reg xor12, xor37, xorf;


    always @(posedge clk)begin
        if(rst_n == 1'b0)begin
            dff <= 8'b10111101; 
        end
        else begin
            dff[7:1] <= dff[6:0];
            dff[0] <= xorf;
        end
    end

    always @(*) begin
        xor12 = (dff[1] & ~dff[2])|(~dff[1] & dff[2]);
        xor37 = (dff[3] & ~dff[7])|(~dff[3] & dff[7]);
        xorf = (xor12 & ~xor37)|(~xor12 & xor37);
    end

    assign out = dff;

    
endmodule

