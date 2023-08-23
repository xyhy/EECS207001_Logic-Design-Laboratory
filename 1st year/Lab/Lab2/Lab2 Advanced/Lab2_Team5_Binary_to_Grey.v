`timescale 1ns/1ps

module Binary_to_Grey (din, dout);
input [4-1:0] din;
output [4-1:0] dout;
wire dout3;

NAND_XOR bit0(dout[0], din[0], din[1]);
NAND_XOR bit1(dout[1], din[1], din[2]);
NAND_XOR bit2(dout[2], din[2], din[3]);
NAND_NOT bit3a(dout3, din[3]);
NAND_NOT bit3(dout[3], dout3);
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