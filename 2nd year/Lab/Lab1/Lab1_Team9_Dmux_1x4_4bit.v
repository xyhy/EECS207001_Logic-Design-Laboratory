`timescale 1ns/1ps

module Dmux_1x4_4bit(in, a, b, c, d, sel);
input [3:0] in;
input [1:0] sel;
output [3:0] a, b, c, d;

wire sel_not0, sel_not1;

not not1(sel_not0, sel[0]);
not not2(sel_not1, sel[1]);
and and1[3:0](a, in, sel_not1, sel_not0);
and and2[3:0](b, in, sel_not1, sel[0]);
and and3[3:0](c, in, sel[1], sel_not0);
and and4[3:0](d, in, sel[1], sel[0]);
endmodule