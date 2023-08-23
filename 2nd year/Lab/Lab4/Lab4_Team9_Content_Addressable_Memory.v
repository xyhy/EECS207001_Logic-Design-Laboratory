`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output reg [3:0] dout;
output reg hit;
reg next_hit;
wire [3:0] out;
reg [8-1:0] store [16-1:0];
reg [16-1:0] array;

    Encoder encode(.array(array), .out(out));

    always@(posedge clk) begin
        if(ren == 1'b1) begin
            dout <= out;
            hit <= ~(array==16'd0);
        end
        else begin
            dout <= 4'b0;
            hit <= 1'b0;
            if(wen == 1'b1) begin
                store[addr] <= din;
            end
            else begin
                //don't do anything
            end
        end
    end

    always@(*) begin
        if(store[0] == din) begin
            array[0] = 1'b1;
        end
        else begin
            array[0] = 1'b0;
        end

        if(store[1] == din) begin
            array[1] = 1'b1;
        end
        else begin
            array[1] = 1'b0;
        end

        if(store[2] == din) begin
            array[2] = 1'b1;
        end
        else begin
            array[2] = 1'b0;
        end

        if(store[3] == din) begin
            array[3] = 1'b1;
        end
        else begin
            array[3] = 1'b0;
        end

        if(store[4] == din) begin
            array[4] = 1'b1;
        end
        else begin
            array[4] = 1'b0;
        end

        if(store[5] == din) begin
            array[5] = 1'b1;
        end
        else begin
            array[5] = 1'b0;
        end
        if(store[6] == din) begin
            array[6] = 1'b1;
        end
        else begin
            array[6] = 1'b0;
        end

        if(store[7] == din) begin
            array[7] = 1'b1;
        end
        else begin
            array[7] = 1'b0;
        end

        if(store[8] == din) begin
            array[8] = 1'b1;
        end
        else begin
            array[8] = 1'b0;
        end

        if(store[9] == din) begin
            array[9] = 1'b1;
        end
        else begin
            array[9] = 1'b0;
        end

        if(store[10] == din) begin
            array[10] = 1'b1;
        end
        else begin
            array[10] = 1'b0;
        end

        if(store[11] == din) begin
            array[11] = 1'b1;
        end
        else begin
            array[11] = 1'b0;
        end

        if(store[12] == din) begin
            array[12] = 1'b1;
        end
        else begin
            array[12] = 1'b0;
        end

        if(store[13] == din) begin
            array[13] = 1'b1;
        end
        else begin
            array[13] = 1'b0;
        end

        if(store[14] == din) begin
            array[14] = 1'b1;
        end
        else begin
            array[14] = 1'b0;
        end

        if(store[15] == din) begin
            array[15] = 1'b1;
        end
        else begin
            array[15] = 1'b0;
        end
    end

endmodule


module Encoder(array, out);
input [16-1:0] array;
output reg [3:0] out;

    always@(*) begin
        if(array > 16'b0000_0000_0000_0000 && array <= 16'b0000_0000_0000_0001) begin
            out = 4'd0;
        end
        else if(array > 16'b0000_0000_0000_0001 && array <= 16'b0000_0000_0000_0011) begin
            out = 4'd1;
        end
        else if(array > 16'b0000_0000_0000_0011 && array <= 16'b0000_0000_0000_0111) begin
            out = 4'd2;
        end
        else if(array > 16'b0000_0000_0000_0111 && array <= 16'b0000_0000_0000_1111) begin
            out = 4'd3;
        end
        else if(array > 16'b0000_0000_0000_1111 && array <= 16'b0000_0000_0001_1111) begin
            out = 4'd4;
        end
        else if(array > 16'b0000_0000_0001_1111 && array <= 16'b0000_0000_0011_1111) begin
            out = 4'd5;
        end
        else if(array > 16'b0000_0000_0011_1111 && array <= 16'b0000_0000_0111_1111) begin
            out = 4'd6;
        end
        else if(array > 16'b0000_0000_0111_1111 && array <= 16'b0000_0000_1111_1111) begin
            out = 4'd7;
        end
        else if(array > 16'b0000_0000_1111_1111 && array <= 16'b0000_0001_1111_1111) begin
            out = 4'd8;
        end
        else if(array > 16'b0000_0001_1111_1111 && array <= 16'b0000_0011_1111_1111) begin
            out = 4'd9;
        end
        else if(array > 16'b0000_0011_1111_1111 && array <= 16'b0000_0111_1111_1111) begin
            out = 4'd10;
        end
        else if(array > 16'b0000_0111_1111_1111 && array <= 16'b0000_1111_1111_1111) begin
            out = 4'd11;
        end
        else if(array > 16'b0000_1111_1111_1111 && array <= 16'b0001_1111_1111_1111) begin
            out = 4'd12;
        end
        else if(array > 16'b0001_1111_1111_1111 && array <= 16'b0011_1111_1111_1111) begin
            out = 4'd13;
        end
        else if(array > 16'b0011_1111_1111_1111 && array <= 16'b0111_1111_1111_1111) begin
            out = 4'd14;
        end
        else if(array > 16'b0111_1111_1111_1111 && array <= 16'b1111_1111_1111_1111) begin
            out = 4'd15;
        end
        else begin
            out = 4'd0;
        end
    end



endmodule