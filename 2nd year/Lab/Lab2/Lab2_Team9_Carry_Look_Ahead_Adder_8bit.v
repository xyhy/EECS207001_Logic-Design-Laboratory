`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [7:0] a, b;
input c0;
output [7:0] s;
output c8;
wire c1,c2,c3,c4;
wire g03,p03,g47,p47;

Carry_Look_Ahead_Generator_4bit gen0(.a(a[3:0]), .b(b[3:0]), .c0(c0), .c1(c1), .c2(c2), .c3(c3), .g(g03), .p(p03));
Carry_Look_Ahead_Generator_2bit gen00(g03, p03, c4);
Carry_Look_Ahead_Generator_4bit gen1(.a(a[7:4]), .b(b[7:4]), .c0(c4), .c1(c5), .c2(c6), .c3(c7), .g(g47), .p(p47));
Carry_Look_Ahead_Generator_2bit gen11(g47, p47, c8);

Full_Adder f1(.a(a[0]), .b(b[0]), .cin(c0), .sum(s[0]));
Full_Adder f2(.a(a[1]), .b(b[1]), .cin(c1), .sum(s[1]));
Full_Adder f3(.a(a[2]), .b(b[2]), .cin(c2), .sum(s[2]));
Full_Adder f4(.a(a[3]), .b(b[3]), .cin(c3), .sum(s[3]));
Full_Adder f5(.a(a[4]), .b(b[4]), .cin(c4), .sum(s[4]));
Full_Adder f6(.a(a[5]), .b(b[5]), .cin(c5), .sum(s[5]));
Full_Adder f7(.a(a[6]), .b(b[6]), .cin(c6), .sum(s[6]));
Full_Adder f8(.a(a[7]), .b(b[7]), .cin(c7), .sum(s[7]));


endmodule

module Carry_Look_Ahead_Generator_2bit(g, p, c);
input g,p,c;
NAND_OR or1(.a(g), .b(p), .out(c));

endmodule

module Carry_Look_Ahead_Generator_4bit(a, b, c0, c1, c2, c3, g, p);

input [3:0] a, b;
input c0;
output g,p;
output c1,c2,c3;
wire g0,g1,g2,g3;
wire p0,p1,p2,p3;

NAND_AND and0(.a(a[0]), .b(b[0]), .out(g0));
NAND_AND and1(.a(a[1]), .b(b[1]), .out(g1));
NAND_AND and2(.a(a[2]), .b(b[2]), .out(g2));
NAND_AND and3(.a(a[3]), .b(b[3]), .out(g3));

NAND_OR or0(.a(a[0]), .b(b[0]), .out(p0));
NAND_OR or1(.a(a[1]), .b(b[1]), .out(p1));
NAND_OR or2(.a(a[2]), .b(b[2]), .out(p2));
NAND_OR or3(.a(a[3]), .b(b[3]), .out(p3));

wire carry0,carry1,carry2,carry3;
wire r0,r1,r2;
NAND_AND and4(.a(p0), .b(c0), .out(s0));
NAND_AND and5(.a(s0), .b(p1), .out(s1));
NAND_AND and6(.a(s1), .b(p2), .out(s2));
NAND_AND and7(.a(s2), .b(p3), .out(p));
wire t1,t2;
NAND_AND and8(.a(p1), .b(g0), .out(t1));
NAND_AND and9(.a(t1), .b(p2), .out(t2));
NAND_AND and10(.a(t2), .b(p3), .out(carry1));
wire u2;
NAND_AND and11(.a(p2), .b(g1), .out(u2));
NAND_AND and12(.a(u2), .b(p3), .out(carry2));

NAND_AND and13(.a(p3), .b(g2), .out(carry3));

wire v0,v1,v2;
//NAND_OR or4(.a(carry0), .b(carry1), .out(v0));
NAND_OR or5(.a(carry1), .b(carry2), .out(v1));
NAND_OR or6(.a(v1), .b(carry3), .out(v2));
NAND_OR or7(.a(v2), .b(g3), .out(g));

wire w0,w1,w2;

NAND_OR or8(.a(s0), .b(g0), .out(c1));

NAND_OR or9(.a(s1), .b(t1), .out(w0));
NAND_OR or10(.a(w0), .b(g1), .out(c2));

NAND_OR or11(.a(s2), .b(t2), .out(w1));
NAND_OR or12(.a(w1), .b(u2), .out(w2));
NAND_OR or13(.a(w2), .b(g2), .out(c3));


// p0c0, p0c0
endmodule

module Full_Adder (a, b, cin, sum);
input a, b, cin;
output sum;

wire sum1;

NAND_XOR S1(.a(a), .b(b), .out(sum1));
NAND_XOR S2(.a(sum1), .b(cin), .out(sum));
//Majority M(.a(a), .b(b), .c(cin), .out(cout));

endmodule


module NAND_AND (a, b, out);
input a, b;
output out;

wire ab_n;

nand nand1(ab_n, a, b);
nand nand_not(out, ab_n, ab_n);
endmodule


module NAND_OR(a, b, out);
input a, b;
output out;

wire a_n, b_n;

nand nota(a_n, a, a);
nand notb(b_n, b, b);
nand nand1(out, a_n, b_n);
endmodule


module NAND_XOR(a, b, out);
input a, b;
output out;

wire a_n, b_n, andab, andab2;

nand nota(a_n, a, a);
nand notb(b_n, b, b);
nand nand1(andab, a, b_n);
nand nand2(andab2, a_n, b);
nand nand3(out, andab, andab2);
endmodule