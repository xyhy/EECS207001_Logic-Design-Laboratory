`timescale 1ns/1ps

module lab2_FPGA (a, b, cin, cout, A,B,C,D,E,F,G,an2,an1,an0);
input [4-1:0] a, b;
input cin;
output cout;
wire [4-1:0] sum;
output A,B,C,D,E,F,G;
output an2,an1,an0;
wire [112-1:0] in;
wire tempcout;


Carry_Look_Ahead_Adder C1 (a,b,cin,tempcout,sum);
wire o,l;
NAND_XOR Z(o,cin,cin);
NAND_XNOR O(l,cin,cin);

NAND_OR_7bits N0 ( in    [6:0], { o,o,o,o,o,o,l }   ,{7{o}}  );
NAND_OR_7bits N1 ( in   [13:7], { l,o,o,l,l,l,l }   ,{7{o}}  );
NAND_OR_7bits N2 ( in  [20:14], { o,o,l,o,o,l,o }   ,{7{o}}  );
NAND_OR_7bits N3 ( in  [27:21], { o,o,o,o,l,l,o }   ,{7{o}}  );
NAND_OR_7bits N4 ( in  [34:28], { l,o,o,l,l,o,o }   ,{7{o}}  );
NAND_OR_7bits N5 ( in  [41:35], { o,l,o,o,l,o,o }   ,{7{o}}  );
NAND_OR_7bits N6 ( in  [48:42], { o,l,o,o,o,o,o }   ,{7{o}}  );
NAND_OR_7bits N7 ( in  [55:49], { o,o,o,l,l,l,l }   ,{7{o}}  );

NAND_OR_7bits N8 ( in  [62:56], { o,o,o,o,o,o,o }   ,{7{o}}  );
NAND_OR_7bits N9 ( in  [69:63], { o,o,o,o,l,o,o }   ,{7{o}}  );
NAND_OR_7bits N10( in  [76:70], { o,o,o,l,o,o,o }   ,{7{o}}  );
NAND_OR_7bits N11( in  [83:77], { l,l,o,o,o,o,o }   ,{7{o}}  );
NAND_OR_7bits N12( in  [90:84], { o,l,l,o,o,o,l }   ,{7{o}}  );
NAND_OR_7bits N13( in  [97:91], { l,o,o,o,o,l,o }   ,{7{o}}  );
NAND_OR_7bits N14( in [104:98], { o,l,l,o,o,o,o }   ,{7{o}}  );
NAND_OR_7bits N15( in[111:105], { o,l,l,l,o,o,o }   ,{7{o}}  );

MUX_16WAY MMMMM(in, sum, {A,B,C,D,E,F,G} );

NAND_NOT N16 (cout,tempcout);

NAND_OR O2(an2,l,l);
NAND_OR O1(an1,l,l);
NAND_OR O0(an0,l,l);
endmodule



module Carry_Look_Ahead_Adder (a, b, cin, cout, sum);
input [4-1:0] a, b;
input cin;
output cout;
output [4-1:0] sum;

wire p0, p1, p2, p3, g0, g1, g2, g3;
wire ng0, ng1, ng2 ,ng3;
wire c1, c1a, c2, c2a, c2b, c3, c3a, c3b, c3c, c4a, c4b, c4c, c4d;

FullAdder FA0(.a(a[0]) ,.b(b[0]), .cin(cin), .p(p0), .g(g0), .sum(sum[0]));
FullAdder FA1(.a(a[1]) ,.b(b[1]), .cin(c1) ,.p(p1) ,.g(g1) ,.sum(sum[1]));
FullAdder FA2(.a(a[2]) ,.b(b[2]), .cin(c2) ,.p(p2) ,.g(g2) ,.sum(sum[2]));
FullAdder FA3(.a(a[3]) ,.b(b[3]), .cin(c3) ,.p(p3) ,.g(g3) ,.sum(sum[3]));

//c1
NAND_NOT notG0(ng0, g0);
nand C1a(c1a, p0, cin);
nand C1b(c1, ng0, c1a);
//c2
NAND_NOT notG1(ng1, g1);
nand C2a(c2a, p1, g0);
nand C2b(c2b, cin, p0, p1);
nand C2c(c2, ng1, c2a, c2b);
//c3
NAND_NOT notG2(ng2, g2);
nand C3a(c3a, p2, g1);
nand C3b(c3b, p2, p1, g0);
nand C3c(c3c, p2, p1, p0, cin);
nand C3d(c3, ng2, c3a, c3b, c3c);
//c4
NAND_NOT notG3(ng3, g3);
nand C4a(c4a,p3, g2);
nand C4b(c4b, p3, p2, g1);
nand C4c(c4c, p3, p2, p1, g0);
nand C4d(c4d, p3, p2, p1, p0, cin);
nand C4e(cout, ng3, c4a, c4b, c4c, c4d);

endmodule


// 
// 
// 
// 
// 
// 
// 
module MUX_16WAY (in, sel, out);
input [112-1:0]in;
input [4-1:0] sel;
output [6:0]out;

wire [6:0]out0, out1, out2, out3, out4, out5, out6, out7,out8,out9,out10,out11,out12,out13,out14,out15;
wire n0sel,n1sel,n2sel,n3sel;

NAND_NOT N0 (n0sel,sel[0]);
NAND_NOT N1 (n1sel,sel[1]);
NAND_NOT N2 (n2sel,sel[2]);
NAND_NOT N3 (n3sel,sel[3]);


nand nand0 [6:0](out0 , in    [6:0], {7{n3sel}} , {7{n2sel}}  , {7{n1sel}}  , {7{n0sel}}   );
nand nand1 [6:0](out1 , in   [13:7], {7{n3sel}} , {7{n2sel}}  , {7{n1sel}}  , {7{sel[0]}}  );
nand nand2 [6:0](out2 , in  [20:14], {7{n3sel}} , {7{n2sel}}  , {7{sel[1]}} , {7{n0sel}}   );
nand nand3 [6:0](out3 , in  [27:21], {7{n3sel}} , {7{n2sel}}  , {7{sel[1]}} , {7{sel[0]}}  );
nand nand4 [6:0](out4 , in  [34:28], {7{n3sel}} , {7{sel[2]}} , {7{n1sel}}  , {7{n0sel}}   );
nand nand5 [6:0](out5 , in  [41:35], {7{n3sel}} , {7{sel[2]}} , {7{n1sel}}  , {7{sel[0]}}  );
nand nand6 [6:0](out6 , in  [48:42], {7{n3sel}} , {7{sel[2]}} , {7{sel[1]}} , {7{n0sel}}   );
nand nand7 [6:0](out7 , in  [55:49], {7{n3sel}} , {7{sel[2]}} , {7{sel[1]}} , {7{sel[0]}}  );

nand nand8 [6:0](out8 , in  [62:56], {7{sel[3]}}, {7{n2sel}}  , {7{n1sel}}  , {7{n0sel}}   );
nand nand9 [6:0](out9 , in  [69:63], {7{sel[3]}}, {7{n2sel}}  , {7{n1sel}}  , {7{sel[0]}}  );
nand nand10[6:0](out10, in  [76:70], {7{sel[3]}}, {7{n2sel}}  , {7{sel[1]}} , {7{n0sel}}   );
nand nand11[6:0](out11, in  [83:77], {7{sel[3]}}, {7{n2sel}}  , {7{sel[1]}} , {7{sel[0]}}  );
nand nand12[6:0](out12, in  [90:84], {7{sel[3]}}, {7{sel[2]}} , {7{n1sel}}  , {7{n0sel}}   );
nand nand13[6:0](out13, in  [97:91], {7{sel[3]}}, {7{sel[2]}} , {7{n1sel}}  , {7{sel[0]}}  );
nand nand14[6:0](out14, in [104:98], {7{sel[3]}}, {7{sel[2]}} , {7{sel[1]}} , {7{n0sel}}   );
nand nand15[6:0](out15, in[111:105], {7{sel[3]}}, {7{sel[2]}} , {7{sel[1]}} , {7{sel[0]}}  );

nand nand16[6:0](out,out0, out1, out2, out3, out4, out5, out6, out7,out8,out9,out10,out11,out12,out13,out14,out15) ;

endmodule
// 
// 
// 
// 
// 
module NAND_OR_7bits (out,a,b);
input [6:0]a,b;
output [6:0]out;
wire [6:0]na,nb;
nand nand0[6:0] (na,a,a);
nand nand1[6:0] (nb,b,b);
nand nand2[6:0] (out,na,nb);
endmodule
// 
// 
// 
// 
// 


//FullAdder implement
module FullAdder (a, b, cin, p, g, sum);
input a, b;
input cin;
output sum,  p, g;


NAND_AND G(g, a, b);
NAND_XOR P(p, a, b);
NAND_XOR S(sum, p, cin);
endmodule

module CLA_Cout(cout, g, p, cin);
input g, p ,cin;
output cout;
wire ca;

NAND_AND p_and_c(ca, p, cin);
NAND_OR g_or_pc(cout, ca, g);
endmodule


// Nand implement
module NAND_NOT (out, a);
input a;
output out;

nand NOT(out, a, a);
endmodule


module NAND_AND (out, a, b);
input a,b;
output out;
wire negab;

nand AND1(negab, a, b);
NAND_NOT ANDab(out,  negab);
endmodule


module NAND_OR (out, a, b);
input a,b;
output out;
wire nega, negb;

NAND_NOT na(nega,  a);
NAND_NOT nb(negb, b);
nand nand1(out, nega, negb);
endmodule


module NAND_XNOR (out, a, b);
input a,b;
output out;
wire xorab;

NAND_XOR xor1(xorab, a, b);
NAND_NOT not1(out, xorab);
endmodule

module NAND_XOR (out, a, b);
input a,b;
output out;
wire nega, negb, andab, andab2;

NAND_NOT nota(nega,  a);
NAND_NOT notb(negb,  b);
NAND_AND and1(andab, a, negb);
NAND_AND and2(andab2, b, nega);
NAND_OR or1(out, andab, andab2);

endmodule