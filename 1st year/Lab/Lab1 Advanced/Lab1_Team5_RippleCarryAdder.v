`timescale 1ns/1ps

module RippleCarryAdder (a, b, cin, cout, sum);
input [8-1:0] a, b;
input cin;
output [8-1:0] sum;
output cout;

wire c1,c2,c3,c4,c5,c6,c7;

FullAdder f0(a[0],b[0],cin,c1,sum[0]);
FullAdder f1(a[1],b[1],c1, c2,sum[1]);
FullAdder f2(a[2],b[2],c2, c3,sum[2]);
FullAdder f3(a[3],b[3],c3, c4,sum[3]);
FullAdder f4(a[4],b[4],c4, c5, sum[4]);
FullAdder f5(a[5],b[5],c5, c6, sum[5]);
FullAdder f6(a[6],b[6],c6, c7, sum[6]);
FullAdder f7(a[7],b[7],c7, cout, sum[7]);

endmodule

module FullAdder (a, b, cin, cout, sum);
input a, b;
input cin;
output sum;
output cout;

wire x1out;
XNOR_1 x1(a,b,x1out);
XNOR_1 x2(cin,x1out,sum);
Mux_1bit m1(a,cin,x1out,cout);
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

module XNOR_1 (a, b,out);
input a, b;
output out;

wire ab,aob,naob;
and and1 (ab,a,b);
or or1 (aob,a,b);
not not1(naob,aob); 
or or2 (out ,ab,naob);
endmodule
