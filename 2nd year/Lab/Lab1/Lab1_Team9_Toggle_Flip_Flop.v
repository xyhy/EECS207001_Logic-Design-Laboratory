`timescale 1ns/1ps


module Toggle_Flip_Flop(clk, q, t, rst_n);
input clk;
input t;
input rst_n;
output q;
wire a,b,tqxor;
wire tnot,qnot;
wire din;

not not1(tnot,t);
not not2(qnot,q);
and and1(a,t,qnot);
and and2(b,q,tnot);
or or1(tqxor,a,b);

and and3(din,rst_n,tqxor);

DFF dff(
    .clk(clk),
    .d(din),
    .q(q)
);

endmodule


module DFF(clk, d, q);
input clk;
input d;
output q;
wire nclk, q1;

not (nclk, clk);
D_Latch master(
    .e(nclk),
    .d(d),
    .q(q1)
);
D_Latch slave(
    .e(clk),
    .d(q1),
    .q(q)
);

endmodule


module D_Latch(e, d, q);
input e;
input d;
output q;
wire dnot,qnot,up,down;

not not3(dnot,d);
nand nand1(up,d,e);
nand nand2(down,dnot,e);
nand nand3(q,up,qnot);
nand nand4(qnot,down,q);

endmodule