`timescale 1ns/1ps

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