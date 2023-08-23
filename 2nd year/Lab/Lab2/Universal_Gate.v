`timescale 1ns/1ps

module Universal_Gate(a, b, out);
input a, b;
output out;

wire negb;

not not1(negb, b);
and and1(out, a, negb);

endmodule