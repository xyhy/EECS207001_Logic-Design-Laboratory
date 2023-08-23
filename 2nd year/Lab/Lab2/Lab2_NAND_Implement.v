`timescale 1ns/1ps

module NAND_Implement (a, b, sel, out);
input a, b;
input [2:0] sel;
output out;

wire neg0, neg1, neg2;
wire sel000, sel001, sel010, sel011, sel100, sel101, sel110, sel111;
wire Not, Nor, And, Or, Xor, Xnor, Nand;

nand nandgate(Nand, a, b);
NAND_NOT notgate(.out(Not), .a(a));
NAND_AND andgate(.out(And), .a(a), .b(b));
NAND_OR orgate(.out(Or), .a(a), .b(b));
NAND_NOR norgate(.out(Nor), .a(a), .b(b));
NAND_XOR xorgate(.out(Xor), .a(a), .b(b));
NAND_XNOR xnorgate(.out(Xnor), .a(a), .b(b));

nand not0(neg0, sel[0]);
nand not1(neg1, sel[1]);
nand not2(neg2, sel[2]);

nand sel0(sel000, neg0, neg1, neg2, Nand);
nand sel1(sel001, sel[0], neg1, neg2, And);
nand sel2(sel010, neg0, sel[1], neg2, Or);
nand sel3(sel011, sel[0], sel[1], neg2, Nor);
nand sel4(sel100, neg0, neg1, sel[2], Xor);
nand sel5(sel101, sel[0], neg1, sel[2], Xnor);
nand sel6(sel110, neg0, sel[1], sel[2], Not);
nand sel7(sel111, sel[0], sel[1], sel[2], Not);

nand out0(out, sel000, sel001, sel010, sel011, sel100, sel101, sel110, sel111);

endmodule


module NAND_NOT (out, a);
input a;
output out;

nand nand1(out, a, a);
endmodule


module NAND_AND (out, a, b);
input a, b;
output out;

wire ab_n;

nand nand1(ab_n, a, b);
nand nand_not(out, ab_n, ab_n);
endmodule


module NAND_OR(out, a, b);
input a, b;
output out;

wire a_n, b_n;

nand nota(a_n, a, a);
nand notb(b_n, b, b);
nand nand1(out, a_n, b_n);
endmodule


module NAND_NOR(out, a, b);
input a, b;
output out;

wire orab;

NAND_OR or1(.out(orab), .a(a), .b(b));
nand not1(out, orab, orab);
endmodule


module NAND_XOR(out, a, b);
input a, b;
output out;

wire a_n, b_n, andab, andab2;

nand nota(a_n, a, a);
nand notb(b_n, b, b);
nand nand1(andab, a, b_n);
nand nand2(andab2, a_n, b);
nand nand3(out, andab, andab2);
endmodule


module NAND_XNOR(out, a, b);
input a, b;
output out;

wire xorab;

NAND_XOR xor1(.out(xorab), .a(a), .b(b));
nand not1(out, xorab, xorab);
endmodule