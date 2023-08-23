`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [7:0] a, b;
input cin;
output cout;
output [7:0] sum;

wire cin1,cin2,cin3,cin4,cin5,cin6,cin7;
wire cout0,cout1,cout2,cout3,cout4,cout5,cout6;

Full_Adder a0(.a(a[0]), .b(b[0]), .cin(cin), .cout(cout0), .sum(sum[0]));
Full_Adder a1(.a(a[1]), .b(b[1]), .cin(cout0), .cout(cout1), .sum(sum[1]));
Full_Adder a2(.a(a[2]), .b(b[2]), .cin(cout1), .cout(cout2), .sum(sum[2]));
Full_Adder a3(.a(a[3]), .b(b[3]), .cin(cout2), .cout(cout3), .sum(sum[3]));
Full_Adder a4(.a(a[4]), .b(b[4]), .cin(cout3), .cout(cout4), .sum(sum[4]));
Full_Adder a5(.a(a[5]), .b(b[5]), .cin(cout4), .cout(cout5), .sum(sum[5]));
Full_Adder a6(.a(a[6]), .b(b[6]), .cin(cout5), .cout(cout6), .sum(sum[6]));
Full_Adder a7(.a(a[7]), .b(b[7]), .cin(cout6), .cout(cout), .sum(sum[7]));
endmodule


//Library
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