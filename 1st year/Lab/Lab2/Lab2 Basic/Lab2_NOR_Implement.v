`timescale 1ns/1ps

module NOR_Implement (a, b, sel, out);
input a, b;
input [3-1:0] sel;
output out;
wire neg0, neg1, neg2;
wire sel000,sel001,sel010,sel011,sel100,sel101,sel110,sel111;
wire Not, Nor, And, Or, Xor, Xnor, Nand;
wire nNot, nNor, nAnd, nOr, nXor, nXnor, nNand;
wire out_temp;

NOR_NOT notgate(Not, a);
nor norgate(Nor, a, b);
NOR_AND andgate(And, a, b);
NOR_OR orgate(Or, a, b);
NOR_XOR xorgate(Xor, a, b);
NOR_XNOR xnorgate(Xnor, a, b);
NOR_NAND nandgate(Nand, a, b);

NOR_NOT not0(neg0, sel[0]);
NOR_NOT not1(neg1, sel[1]);
NOR_NOT not2(neg2, sel[2]);

NOR_NOT nnot(nNot, Not);
NOR_NOT nnor(nNor, Nor);
NOR_NOT nAnd(nAnd, And);
NOR_NOT nOr(nOr, Or);
NOR_NOT nxnor(nXnor, Xnor);
NOR_NOT nnand(nNand, Nand);


nor sel0(sel000, sel[0], sel[1], sel[2], nNot);
nor sel1(sel001, neg0, sel[1], sel[2], nNor);
nor sel2(sel010, sel[0], neg1, sel[2], nAnd);
nor sel3(sel011, neg0, neg1, sel[2], nOr);
nor sel4(sel100, sel[0], sel[1], neg2, nXor);
nor sel5(sel101, neg0, sel[1], neg2, nXnor);
nor sel6(sel110, sel[0], neg1, neg2, nNand);
nor sel7(sel111, neg0, neg1, neg2, nNand);

nor out0(out_temp, sel000, sel001, sel010, sel011, sel100, sel101, sel110, sel111);
NOR_NOT out1(out, out_temp);

endmodule



module NOR_NOT (out, a);
input a;
output out;

nor not0(out, a, a);
endmodule


module NOR_AND (out, a, b);
input a,b;
output out;
wire nega, negb;

NOR_NOT nota(nega, a);
NOR_NOT notb(negb, b);
nor and0(out, nega, negb);
endmodule


module NOR_OR (out, a, b);
input a,b;
output out;
wire negab;

nor nor1(negab, a, b);
NOR_NOT not0(out, negab);
endmodule


module NOR_NAND (out, a, b);
input a,b;
output out;
wire andab;

NOR_AND and0(andab, a, b);
NOR_NOT not0(out, andab);
endmodule


module NOR_XNOR (out, a, b);
input a,b;
output out;
wire nega, negb, noranb, nornab;

NOR_NOT nota(nega, a);
NOR_NOT notb(negb, b);
nor nor1(noranb, nega, b);
nor nor2(nornab, a, negb);
nor nor3(out, nornab, noranb);
endmodule


module NOR_XOR (out, a, b);
input a,b;
output out;
wire nega, negb, noranb, nornab, f;

NOR_NOT nota(nega, a);
NOR_NOT notb(negb, b);
nor nor1(noranb, nega, b);
nor nor2(nornab, a, negb);
nor nor3(f, nornab, noranb);
NOR_NOT notc(out, f);
endmodule