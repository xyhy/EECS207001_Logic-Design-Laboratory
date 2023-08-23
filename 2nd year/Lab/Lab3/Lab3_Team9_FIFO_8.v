`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [7:0] din;
output reg [7:0] dout;
output reg error;
reg [8-1:0] store [8-1:0];
reg [3-1:0] readflag, writeflag, nxt_read, nxt_write;
reg tmperror;
reg [8-1:0] tmpout;
reg [8-1:0] nxt_store;

    always@(posedge clk) begin
        if(!rst_n) begin
            store[0] <= 8'b0;
            store[1] <= 8'b0;
            store[2] <= 8'b0;
            store[3] <= 8'b0;
            store[4] <= 8'b0;
            store[5] <= 8'b0;
            store[6] <= 8'b0;
            store[7] <= 8'b0;
            readflag <= 3'b000;
            writeflag <= 3'b000;
            error <= 1'b0;
            dout <= 8'b0;
        end
        else begin
            if(ren == 1'b1) begin
                store[readflag] <= nxt_store;
            end
            else begin
                // if(wen == 1'b1) begin
                //     store[writeflag] <= nxt_store;
                // end
                // else begin
                // end
                store[writeflag] <= nxt_store;  //fix
            end
            readflag <= nxt_read;
            writeflag <= nxt_write;
            dout <= tmpout;
            error <= tmperror;
        end
    end



    always@(*) begin
            if(ren == 1'b1) begin
                if(store[readflag] != 8'b0 && store[readflag] != 8'bx && store[readflag] != 8'bz) begin
                    tmpout = store[readflag];
                    nxt_store = 8'bx;
                    tmperror = 1'b0;
                    nxt_read = readflag+3'b001;
                    nxt_write = writeflag;
                end
                else begin
                    tmperror = 1'b1;
                    tmpout = 1'b0;
                    nxt_store = store[readflag];
                    nxt_write = writeflag;
                    nxt_read = readflag;
                end
            end
            else begin
                if(wen == 1'b1) begin
                    if(store[writeflag] == 8'b0 || store[writeflag] == 8'bz || store[writeflag] == 8'bx) begin
                        nxt_store = din;
                        tmperror = 1'b0;
                        tmpout = 8'b0;
                        nxt_write = writeflag+3'b001;
                        nxt_read = readflag;
                    end
                    else begin
                        tmperror = 1'b1;
                        tmpout = 8'b0;
                        nxt_store = store[writeflag];
                        nxt_write = writeflag;
                        nxt_read = readflag;
                    end
                end
                else begin
                    tmperror = 1'b0;
                    tmpout = 8'b0;
                    nxt_store = store[writeflag];   //fix
                    nxt_write = writeflag;
                    nxt_read = readflag;
                end
            end

    end

endmodule
