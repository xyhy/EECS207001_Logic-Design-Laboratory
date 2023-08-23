`timescale 1ns/1ps

module Multiplier (a, b, p);
input [4-1:0] a, b;
output [8-1:0] p;
wire [3:0] L0,L1,L2,L3;

wire [7:0] sum0,sum1;
wire c0,c1,c2;
wire zero, one;
NOR_XOR NN (a[0],a[0],zero);
NOR_XNOR NONE (a[0],a[0],one);

NOR_AND N1(a[0],b[0],L0[0]);
NOR_AND N2(a[1],b[0],L0[1]);
NOR_AND N3(a[2],b[0],L0[2]);
NOR_AND N4(a[3],b[0],L0[3]);

NOR_AND N5(a[0],b[1],L1[0]);
NOR_AND N6(a[1],b[1],L1[1]);
NOR_AND N7(a[2],b[1],L1[2]);
NOR_AND N8(a[3],b[1],L1[3]);

NOR_AND N9(a[0],b[2],L2[0]);
NOR_AND N10(a[1],b[2],L2[1]);
NOR_AND N11(a[2],b[2],L2[2]);
NOR_AND N12(a[3],b[2],L2[3]);

NOR_AND N13(a[0],b[3],L3[0]);
NOR_AND N14(a[1],b[3],L3[1]);
NOR_AND N15(a[2],b[3],L3[2]);
NOR_AND N16(a[3],b[3],L3[3]);

RippleCarryAdder R1(  { {4{zero}} ,L0 }, { {3{zero}} , L1,zero } ,zero,c0, sum0 );
RippleCarryAdder R2(  sum0, { {2{zero}}, L2, {2{zero}} } , c0, c1,sum1 );
RippleCarryAdder R3(  sum1, { zero , L3 , {3{zero}} } , c1, c2,p );


endmodule


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
NOR_XNOR x1(a,b,x1out);
NOR_XNOR x2(cin,x1out,sum);
Mux_1bit m1(a,cin,x1out,cout);
endmodule

module Mux_1bit (a, b, sel, f);
input  a, b;
input sel;
output  f;

wire sel0, cha, chb;
/*
not not1(sel0, sel);
and and1(cha, a, sel);
and and2(chb, b, sel0);
or or1(f, cha, chb);
*/
NOR_NOT N1(sel,sel0);
NOR_AND N2(a,sel,cha);
NOR_AND N3(b,sel0,chb);
NOR_OR N4(cha,chb,f);
endmodule

module NOR_XOR (a,b,out);
input a,b;
output out;
wire na,nb,abnor,nanbnor;
nor nor0 (na,a,a);
nor nor1 (nb,b,b);
nor nor2 (nanbnor,na,nb);
nor nor3 (abnor,a,b);
nor nor4 (out,abnor,nanbnor);
endmodule

module NOR_XNOR (a,b,out);
input a,b;
output out;
wire xorout;
NOR_XOR N0 (a,b,xorout);
NOR_NOT N1 (xorout,out);
endmodule

module NOR_NOT ( a,out );
input a;
output out;
nor nor0(out,a,a);
endmodule

module NOR_AND (a,b,out);
input a,b;
output out;
wire na,nb;
nor nor0(na,a,a);
nor nor1(nb,b,b);
nor nor2(out,na,nb);
endmodule

module NOR_OR (a,b,out);
input a,b;
output out;
wire norout;
nor nor0 (norout,a,b);
nor nor1 (out,norout,norout);
endmodule