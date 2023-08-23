`timescale 1ns/1ps

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