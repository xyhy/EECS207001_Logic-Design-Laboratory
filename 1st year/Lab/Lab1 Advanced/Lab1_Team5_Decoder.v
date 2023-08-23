`timescale 1ns/1ps

module Decoder (din, dout);
input [4-1:0] din;
output [16-1:0] dout;

//wire in2o,in1o,in0o; // input x-bit output
wire d2not,d1not,d0not;

not not0 (d0not,din[0]);
not not1 (d1not,din[1]);
not not2 (d2not,din[2]);

wire  [3-1:0] d1input;

Mux_1bit in2(d2not,din[2],din[3],d1input[2]);
Mux_1bit in1(d1not,din[1],din[3],d1input[1]);
Mux_1bit in0(d0not,din[0],din[3],d1input[0]);

Decoder_3X8 d1( d1input , dout[15:8] );
Decoder_3X8 d2( d1input , dout[7:0] );
endmodule


module Decoder_3X8 (din, dout);
input [3-1:0] din;
output [8-1:0] dout;

wire in2, in1, in0; // ~d[x]

not not2(in2, din[2]);
not not1(in1, din[1]);
not not0(in0, din[0]);

and and0(dout[0], in0, in1, in2);
and and1(dout[1], din[0], in1, in2);
and and2(dout[2], in0, din[1], in2);
and and3(dout[3], din[0], din[1], in2);

and and4(dout[4], in0, in1, din[2]);
and and5(dout[5], din[0], in1, din[2]);
and and6(dout[6], in0, din[1], din[2]);
and and7(dout[7], din[0], din[1], din[2]);
endmodule


module Mux_1bit (a, b, sel, f);
input  a, b;
input sel;
output  f;

wire sel0, cha, chb;

not not1(sel0, sel);
and and1(cha, a, sel);
and and2(chb, b, sel0);
or or1(f, cha, chb);
endmodule


