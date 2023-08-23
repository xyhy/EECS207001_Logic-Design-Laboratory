`timescale 1ns/1ps

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [10:0] waddr;
input [10:0] raddr;
input [7:0] din;
output reg [7:0] dout;

wire wen_0, wen_1, wen_2, wen_3;
wire ren_0, ren_1, ren_2, ren_3;
wire [7:0] out_0, out_1, out_2, out_3;

reg [3:0] tmp_ren, tmp_wen;


    Bank bank0(.clk(clk), .ren(ren_0), .wen(wen_0), .waddr(waddr[8:0]), .raddr(raddr[8:0]), .din(din), .dout(out_0));
    Bank bank1(.clk(clk), .ren(ren_1), .wen(wen_1), .waddr(waddr[8:0]), .raddr(raddr[8:0]), .din(din), .dout(out_1));
    Bank bank2(.clk(clk), .ren(ren_2), .wen(wen_2), .waddr(waddr[8:0]), .raddr(raddr[8:0]), .din(din), .dout(out_2));
    Bank bank3(.clk(clk), .ren(ren_3), .wen(wen_3), .waddr(waddr[8:0]), .raddr(raddr[8:0]), .din(din), .dout(out_3));

    Dmux_4x1_1bit selwen(.in(wen), .sel(waddr[10:9]), .out1(wen_0), .out2(wen_1), .out3(wen_2), .out4(wen_3));
    Dmux_4x1_1bit selren(.in(ren), .sel(raddr[10:9]), .out1(ren_0), .out2(ren_1), .out3(ren_2), .out4(ren_3));

    always @(posedge clk) begin
        tmp_ren <= {ren_3, ren_2, ren_1, ren_0};
    end

    always @(*) begin
        if(tmp_ren == 4'b0001) begin
            dout = out_0;
        end

        else if(tmp_ren == 4'b0010) begin
            dout = out_1;
        end

        else if(tmp_ren == 4'b0100) begin
            dout = out_2;
        end

        else if(tmp_ren == 4'b1000) begin
            dout = out_3;
        end

        else begin
            dout = 8'b0;
        end
    end



endmodule


module Bank(clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [8:0] waddr;
input [8:0] raddr;
input [7:0] din;
output reg [7:0] dout;

wire wen_0, wen_1, wen_2, wen_3;
wire ren_0, ren_1, ren_2, ren_3;
wire [7:0] out_0, out_1, out_2, out_3;
reg [6:0] addr_0, addr_1, addr_2, addr_3;
reg [3:0] tmp_ren, tmp_wen;


    Memory sub1(.clk(clk), .ren(ren_0), .wen(wen_0), .addr(addr_0), .din(din), .dout(out_0));
    Memory sub2(.clk(clk), .ren(ren_1), .wen(wen_1), .addr(addr_1), .din(din), .dout(out_1));
    Memory sub3(.clk(clk), .ren(ren_2), .wen(wen_2), .addr(addr_2), .din(din), .dout(out_2));
    Memory sub4(.clk(clk), .ren(ren_3), .wen(wen_3), .addr(addr_3), .din(din), .dout(out_3));


    Dmux_4x1_1bit selwen(.in(wen), .sel(waddr[8:7]), .out1(wen_0), .out2(wen_1), .out3(wen_2), .out4(wen_3));
    Dmux_4x1_1bit selren(.in(ren), .sel(raddr[8:7]), .out1(ren_0), .out2(ren_1), .out3(ren_2), .out4(ren_3));


    always @(posedge clk) begin
        tmp_ren <= {ren_3, ren_2, ren_1, ren_0};
    end

    always @(*) begin
        if(tmp_ren == 4'b0001) begin
            dout = out_0;
        end

        else if(tmp_ren == 4'b0010) begin
            dout = out_1;
        end

        else if(tmp_ren == 4'b0100) begin
            dout = out_2;
        end

        else if(tmp_ren == 4'b1000) begin
            dout = out_3;
        end

        else begin
            dout = 8'b0;
        end
    end


    always @(*) begin //fix 'else'
        if(ren == 1'b1) begin
            if(ren_0 == 1'b1) begin //fix
                addr_0 = raddr[6:0];

                addr_1 = waddr[6:0];
                addr_2 = waddr[6:0];
                addr_3 = waddr[6:0];
            end
            else begin
            end

            if(ren_1 == 1'b1) begin
                addr_1 = raddr[6:0];

                addr_2 = waddr[6:0];
                addr_3 = waddr[6:0];
                addr_0 = waddr[6:0];
            end
            else begin
            end

            if(ren_2 == 1'b1) begin
                addr_2 = raddr[6:0];

                addr_3 = waddr[6:0];
                addr_1 = waddr[6:0];
                addr_0 = waddr[6:0];
            end
            else begin
            end

            if(ren_3 == 1'b1) begin
                addr_3 = raddr[6:0];

                addr_2 = waddr[6:0];
                addr_1 = waddr[6:0];
                addr_0 = waddr[6:0];
            end
            else begin
            end
        end
        else begin
                addr_3 = waddr[6:0];
                addr_2 = waddr[6:0];
                addr_1 = waddr[6:0];
                addr_0 = waddr[6:0];
        end
    end



endmodule



module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [6:0] addr;
input [7:0] din;
output reg [7:0] dout;
reg [8-1:0] mem [128-1:0];
reg [8-1:0] val;

    always @(posedge clk) begin
        if(ren == 1'b1) begin
            dout <= val;
        end
        else begin
            dout <= 8'b0;
            if(wen == 1'b1) begin
                mem[addr] <= val;
            end
            else begin
            end
        end
    end


    always @(*) begin
        if(ren == 1'b1) begin
            if(mem[addr] != 8'bx && mem[addr] !=8'bz && mem[addr] != 8'b0) begin
                val = mem[addr];
            end
            else begin
                val = 8'b0;
            end
        end
        else begin
            if(wen == 1'b1) begin
                val = din;
            end
            else begin
            end
        end
    end
endmodule


module Dmux_4x1_1bit (in, sel, out1, out2, out3, out4);
output reg out1, out2, out3, out4;
input [2-1:0] sel;
input in;

always @(*) begin
    case(sel)
        2'b00: begin
            out1 = in;
            out2 = 1'b0;
            out3 = 1'b0;
            out4 = 1'b0;
        end
        2'b01: begin
            out1 = 1'b0;
            out2 = in;
            out3 = 1'b0;
            out4 = 1'b0;
        end
        2'b10: begin
            out1 = 1'b0;
            out2 = 1'b0;
            out3 = in;
            out4 = 1'b0;
        end
        2'b11: begin
            out1 = 1'b0;
            out2 = 1'b0;
            out3 = 1'b0;
            out4 = in;
        end
        default:;
    endcase
end

endmodule

