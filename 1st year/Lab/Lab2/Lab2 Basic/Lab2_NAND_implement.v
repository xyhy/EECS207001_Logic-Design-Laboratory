`timescale 1ns/1ps

module NAND_Implement (a, b, sel, out);
input a, b;
input [3-1:0] sel;
output out;
wire neg0, neg1, neg2;
wire sel000,sel001,sel010,sel011,sel100,sel101,sel110,sel111;
wire Not, Nor, And, Or, Xor, Xnor, Nand;

NAND_NOT notgate(Not, a);
NAND_NOR norgate(Nor, a, b);
NAND_AND andgate(And, a, b);
NAND_OR orgate(Or, a, b);
NAND_XOR xorgate(Xor, a, b);
NAND_XNOR xnorgate(Xnor, a, b);
nand nandgate(Nand, a, b);



NAND_NOT not0(neg0, sel[0]);
NAND_NOT not1(neg1, sel[1]);
NAND_NOT not2(neg2, sel[2]);

nand sel0(sel000, neg0, neg1, neg2, Not);
nand sel1(sel001, sel[0], neg1, neg2, Nor);
nand sel2(sel010, neg0, sel[1], neg2, And);
nand sel3(sel011, sel[0], sel[1], neg2, Or);
nand sel4(sel100, neg0, neg1, sel[2], Xor);
nand sel5(sel101, sel[0], neg1, sel[2], Xnor);
nand sel6(sel110, neg0, sel[1], sel[2], Nand);
nand sel7(sel111, sel[0], sel[1], sel[2], Nand);

nand out0(out, sel000, sel001, sel010, sel011, sel100, sel101, sel110, sel111);
endmodule


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
NAND_NOT ANDab(out, negab);
endmodule


module NAND_OR (out, a, b);
input a,b;
output out;
wire nega, negb;

NAND_NOT na(nega, a);
NAND_NOT nb(negb, b);
nand nand1(out, nega, negb);
endmodule


module NAND_NOR (out, a, b);
input a,b;
output out;
wire orab;

NAND_OR or1(orab, a, b);
NAND_NOT not1(out, orab);
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

NAND_NOT nota(nega, a);
NAND_NOT notb(negb, b);
nand nand1(andab, a, negb);
nand nand2(andab2, b, nega);
nand nand3(out, andab, andab2);
endmodule
