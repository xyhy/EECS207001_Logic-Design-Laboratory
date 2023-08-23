`timescale 1ns/1ps

module Flip_Flop (clk, d, q);
input clk;
input d;
output q;
wire q1;
wire nclk;

nand notclk(nclk, clk);

Latch Master (
  .clk (clk),
  .d (d),
  .q (q1)
);

Latch Slave (
  .clk (nclk),
  .d (q1),
  .q (q)
);
endmodule

module Latch (clk, d, q);
input clk;
input d;
output q;
wire dup, dnot ,ddown, qnot;

nand nand1(dup, d, clk);
nand not1(dnot, d, d);
nand nand2(ddown, dnot, clk);
nand nand3(qnot, q, ddown);
nand nand4(q, qnot, dup);

endmodule
