`timescale 1ns/1ps

module Round_Robin_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [3:0] wen;
input [7:0] a, b, c, d;
output reg [7:0] dout;
output reg valid;

wire [8-1:0] outa, outb, outc, outd;
reg [4-1:0] ren;
reg [4-1:0] nxt_ren;
wire [4-1:0] error;
reg [8-1:0] tmpout;
reg tmpvalid;

    FIFO_8 a_entry(.clk(clk), .rst_n(rst_n), .wen(wen[0]), .ren(ren[0]), .din(a), .dout(outa), .error(error[0]) );
    FIFO_8 b_entry(.clk(clk), .rst_n(rst_n), .wen(wen[1]), .ren(ren[1]), .din(b), .dout(outb), .error(error[1]) );
    FIFO_8 c_entry(.clk(clk), .rst_n(rst_n), .wen(wen[2]), .ren(ren[2]), .din(c), .dout(outc), .error(error[2]) );
    FIFO_8 d_entry(.clk(clk), .rst_n(rst_n), .wen(wen[3]), .ren(ren[3]), .din(d), .dout(outd), .error(error[3]) );

    always@(posedge clk) begin
        if(!rst_n) begin
            ren <= 4'b0001;
            dout <= 8'b0;
            valid <= 1'b0;
        end
        else begin
            ren <= nxt_ren;
            dout <= tmpout;
            valid <= tmpvalid;
        end
    end

    always@(*) begin
        tmpvalid = !(error[0]|error[1]|error[2]|error[3]);
    end
    
    always@(*) begin
        if(!rst_n) begin
            tmpout = 8'b0;
        end
        else begin
            case (ren)
                4'b0001: begin
                    tmpout = outa;
                end
                4'b0010: begin
                    tmpout = outb;
                end
                4'b0100: begin
                    tmpout = outc;
                end
                4'b1000: begin
                    tmpout = outd;
                end
                default: begin 
                    tmpout = 8'b0;
                end
            endcase
                nxt_ren = (ren==4'b1000)?(4'b0001):(ren<<1);
        end
    end

endmodule



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
        end
        else begin
            if(wen == 1'b1) begin
                store[writeflag] <= nxt_store;
            end
            else begin
                // if(ren == 1'b1) begin
                //     store[readflag] <= nxt_store;
                // end
                // else begin
                // end
                store[readflag] <= nxt_store; //fix
            end
            readflag <= nxt_read;
            writeflag <= nxt_write;
        end
    end



    always@(*) begin
        if(!rst_n) begin
            error = 1'b0;
            dout = 8'b0;
        end
        else begin
            if(wen == 1'b1) begin
                if(store[writeflag] == 8'b0 || store[writeflag] == 8'bx || store[writeflag] == 8'bz) begin
                    if(ren == 1'b1) begin
                        error = 1'b1;
                        dout = 8'b0;
                        nxt_store = din;
                        nxt_write = writeflag+3'b001;
                        nxt_read = readflag;
                    end
                    else begin
                        error = 1'b0;
                        // tmpout = 8'b0;
                        nxt_store = din;
                        nxt_write = writeflag+3'b001;
                        nxt_read = readflag;
                        dout = 8'b0; //fix
                    end
                end
                else begin
                    error = 1'b1;
                    dout = 8'b0;
                    nxt_store = store[writeflag];
                    nxt_write = writeflag;
                    nxt_read = readflag;
                end
            end
            else begin
                if(ren == 1'b1) begin
                    if(store[readflag] == 8'b0 || store[readflag] == 8'bx || store[readflag] == 8'bz) begin
                        error = 1'b1;
                        dout = 8'b0;
                        nxt_store = store[readflag];
                        nxt_write = writeflag;
                        nxt_read = readflag;
                    end
                    else begin
                        dout = store[readflag];
                        nxt_store = 8'bx;
                        error = 1'b0;
                        nxt_read = readflag+3'b001;
                        nxt_write = writeflag;
                    end
                end
                else begin
                    error = 1'b0;
                    // tmpout = 8'b0;
                    nxt_write = writeflag;
                    nxt_read = readflag;
                    dout = 8'b0; //fix
                    nxt_store = store[readflag]; //fix
                end
            end
        end
    end

endmodule
