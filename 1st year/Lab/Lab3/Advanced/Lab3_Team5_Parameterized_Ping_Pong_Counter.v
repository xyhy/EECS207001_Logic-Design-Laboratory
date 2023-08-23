`timescale 1ns/1ps 

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input  [4-1:0] max;
input  [4-1:0] min;
output reg direction;
output reg [4-1:0] out;
reg tempdir;
reg [4-1:0] tempout;

always @(posedge clk) begin
    if(rst_n==0) begin
        out <=min;
        direction <=1;
    end
    else begin
        if(enable==1 && min<max && (out>=min && out <=max) ) begin
            out <=tempout;
            direction <= tempdir;
        end
        else begin
        end
    end
end

always @(*) begin
    if(flip == 1) begin
        tempdir = ~direction;
    end
    else begin 
        tempdir = direction;
    end

    if(out==max) begin
        tempdir = 1'b0;
    end
    else begin
        tempdir = tempdir;
    end
    if(out ==min) begin
        tempdir = 1'b1;
    end
    else begin
        tempdir = tempdir;
    end
end
always @(*) begin
    if( tempdir==1'b1 ) begin
        tempout = out+1;
    end
    else begin
        tempout = out-1; 
    end
end


    

endmodule
