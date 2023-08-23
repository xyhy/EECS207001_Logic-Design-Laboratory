`timescale 1ns/1ps

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
input clk;
input rst_n;
input scan_en;
output scan_in;
output scan_out;
// wire [3:0]a,b;
// wire [7:0]mul_out;

    Many_To_One_LFSR LFSR(.clk(clk), .rst_n(rst_n), .out(scan_in));
    Scan_Chain_Design Chain(.clk(clk), .rst_n(rst_n), .scan_in(scan_in), .scan_en(scan_en), .scan_out(scan_out));

endmodule


module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
input clk;
input rst_n;
input scan_in;
input scan_en;
output scan_out;

wire [3:0] a, b;
wire [8-1:0] mul_out;


    Multiplier mul(.a(a), .b(b), .out(mul_out));
    SDFF dff0( .clk(clk), .rst_n(rst_n), .scan_in(scan_in), .scan_en(scan_en), .data(mul_out[7]), .out(a[3]) );
    SDFF dff1( .clk(clk), .rst_n(rst_n), .scan_in(a[3]), .scan_en(scan_en), .data(mul_out[6]), .out(a[2]) );
    SDFF dff2( .clk(clk), .rst_n(rst_n), .scan_in(a[2]), .scan_en(scan_en), .data(mul_out[5]), .out(a[1]) );
    SDFF dff3( .clk(clk), .rst_n(rst_n), .scan_in(a[1]), .scan_en(scan_en), .data(mul_out[4]), .out(a[0]) );
    SDFF dff4( .clk(clk), .rst_n(rst_n), .scan_in(a[0]), .scan_en(scan_en), .data(mul_out[3]), .out(b[3]) );
    SDFF dff5( .clk(clk), .rst_n(rst_n), .scan_in(b[3]), .scan_en(scan_en), .data(mul_out[2]), .out(b[2]) );
    SDFF dff6( .clk(clk), .rst_n(rst_n), .scan_in(b[2]), .scan_en(scan_en), .data(mul_out[1]), .out(b[1]) );
    SDFF dff7( .clk(clk), .rst_n(rst_n), .scan_in(b[1]), .scan_en(scan_en), .data(mul_out[0]), .out(b[0]) );


    assign scan_out = b[0];

endmodule

module Multiplier (a, b, out);
input [4-1:0] a, b;
output [8-1:0] out;
    assign out = a*b;
endmodule


module SDFF (clk, rst_n, scan_in, scan_en, data, out);
input clk, rst_n, scan_in, scan_en, data;
output reg out;

    always@(posedge clk) begin
        if(!rst_n) begin
            out <= 1'b0;
        end
        else begin
            if(scan_en == 1'b1) begin
                out <= scan_in;
            end
            else begin
                out <= data;
            end
        end
    end


endmodule



module Many_To_One_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output out;
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

    assign out = dff[7];

    
endmodule
