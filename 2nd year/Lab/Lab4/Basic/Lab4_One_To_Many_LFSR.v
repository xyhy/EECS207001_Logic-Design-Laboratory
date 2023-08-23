`timescale 1ns/1ps

module One_TO_Many_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output [7:0] out;
reg [7:0] dff;

    always @(posedge clk)begin
        if(rst_n == 1'b0)begin
            dff <= 8'b10111101; 
        end
        else begin
            dff[7:5] <= dff[6:4];
            dff[4] <= (dff[3] & ~dff[7])|(~dff[3] & dff[7]);
            dff[3] <= (dff[2] & ~dff[7])|(~dff[2] & dff[7]);
            dff[2] <= (dff[1] & ~dff[7])|(~dff[1] & dff[7]);
            dff[1] <= dff[0];
            dff[0] <= dff[7];
        end
    end
    assign out = dff;
endmodule