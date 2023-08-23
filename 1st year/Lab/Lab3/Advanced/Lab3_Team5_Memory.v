`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [7-1:0] addr;
input [8-1:0] din;
output reg [8-1:0] dout;
reg [8-1:0] mem [128-1:0];

always @(posedge clk)begin

    if(ren == 1'b1)begin
        dout <= mem[addr];
    end
    else begin
        dout <= 8'b0;
        if(wen==1'b1)begin 
            mem[addr] <= din;
        end
        else begin
        end
    end
end


endmodule
