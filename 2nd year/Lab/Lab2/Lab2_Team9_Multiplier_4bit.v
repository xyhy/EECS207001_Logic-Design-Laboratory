`timescale 1ns/1ps

module Multiplier_4bit(a, b, p);
input [3:0] a, b;
output [7:0] p;
reg r = 1'b0;

NAND_AND and0(.a(a[0]), .b(b[0]), .out(p[0]));

wire a0b1,a1b0,c1;
NAND_AND and1(.a(a[0]), .b(b[1]), .out(a0b1));
NAND_AND and2(.a(a[1]), .b(b[0]), .out(a1b0));
Full_Adder a1(.a(a0b1), .b(a1b0), .cin(r), .cout(c1), .sum(p[1]));

wire a2b0,a1b1,a0b2,c21,c22,s21;
NAND_AND and3(.a(a[2]), .b(b[0]), .out(a2b0));
NAND_AND and4(.a(a[1]), .b(b[1]), .out(a1b1));
NAND_AND and5(.a(a[0]), .b(b[2]), .out(a0b2));
Full_Adder a21(.a(a2b0), .b(a1b1), .cin(c1), .cout(c21), .sum(s21));
Full_Adder a22(.a(s21), .b(a0b2), .cin(r), .cout(c22), .sum(p[2]));

wire a3b0,a2b1,a1b2,a0b3,c31,c32,c33,s31,s32;
NAND_AND and6(.a(a[3]), .b(b[0]), .out(a3b0));
NAND_AND and7(.a(a[2]), .b(b[1]), .out(a2b1));
NAND_AND and8(.a(a[1]), .b(b[2]), .out(a1b2));
NAND_AND and9(.a(a[0]), .b(b[3]), .out(a0b3));
Full_Adder a31(.a(a3b0), .b(a2b1), .cin(c21), .cout(c31), .sum(s31));
Full_Adder a32(.a(s31), .b(a1b2), .cin(c22), .cout(c32), .sum(s32));
Full_Adder a33(.a(s32), .b(a0b3), .cin(r), .cout(c33), .sum(p[3]));

wire a3b1,a2b2,a1b3,c41,c42,c43,s41,s42;
NAND_AND and10(.a(a[3]), .b(b[1]), .out(a3b1));
NAND_AND and11(.a(a[2]), .b(b[2]), .out(a2b2));
NAND_AND and12(.a(a[1]), .b(b[3]), .out(a1b3));
Full_Adder a41(.a(r), .b(a3b1), .cin(c31), .cout(c41), .sum(s41));//ª`·N
Full_Adder a42(.a(s41), .b(a2b2), .cin(c32), .cout(c42), .sum(s42));
Full_Adder a43(.a(s42), .b(a1b3), .cin(c33), .cout(c43), .sum(p[4]));

wire a3b2,a2b3,c51,c52,s51;
NAND_AND and13(.a(a[3]), .b(b[2]), .out(a3b2));
NAND_AND and14(.a(a[2]), .b(b[3]), .out(a2b3));
Full_Adder a51(.a(c41), .b(a3b2), .cin(c42), .cout(c51), .sum(s51));
Full_Adder a52(.a(s51), .b(a2b3), .cin(c43), .cout(c52), .sum(p[5]));

wire a3b3;
NAND_AND and15(.a(a[3]), .b(b[3]), .out(a3b3));
Full_Adder a61(.a(c51), .b(a3b3), .cin(c52), .cout(p[7]), .sum(p[6]));

endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire sum1;

NAND_XOR S1(.a(a), .b(b), .out(sum1));
NAND_XOR S2(.a(sum1), .b(cin), .out(sum));
Majority M(.a(a), .b(b), .c(cin), .out(cout));

endmodule

module Majority(a, b, c, out);
input a, b, c;
output out;

wire andab, andbc, andac, or1;

NAND_AND AB(.a(a), .b(b), .out(andab));
NAND_AND BC(.a(b), .b(c), .out(andbc));
NAND_AND AC(.a(a), .b(c), .out(andac));
NAND_OR orf(.a(andab), .b(andac), .out(or1));
NAND_OR orl(.a(or1), .b(andbc), .out(out));
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