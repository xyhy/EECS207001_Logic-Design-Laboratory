`timescale 1ns/1ps

module Half_Adder(a, b, cout, sum);
input a, b;
output cout, sum;

NAND_AND C(.a(a), .b(b), .out(cout));
NAND_XOR S(.a(a), .b(b), .out(sum));
endmodule


module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire sum1;

NAND_XOR S1(.a(a), .b(b), .out(sum1));
NAND_XOR S2(.a(sum1), .b(cin), .out(sum));
Majority M(.a(a), .b(b), .c(cin), .out(cout));

endmodule



//library
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