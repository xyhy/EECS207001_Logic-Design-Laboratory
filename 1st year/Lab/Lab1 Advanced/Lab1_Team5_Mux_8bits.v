`timescale 1ns/1ps

module Mux_8bits (a, b, c, d, sel1, sel2, sel3, f);
input [8-1:0] a, b, c, d;
input sel1, sel2, sel3;
output [8-1:0] f;
wire [8-1:0] ab, cd;

Mux m1(
	.a(a),
	.b(b),
	.sel(sel1),
	.f(ab)
);
Mux m2(
	.a(c),
	.b(d),
	.sel(sel2),
	.f(cd)
);
Mux m3(
	.a(ab),
	.b(cd),
	.sel(sel3),
	.f(f)
);
endmodule

module Mux (a, b, sel, f);
input [8-1:0] a, b;
input sel;
output [8-1:0] f;

wire sel0;
wire [8-1:0] cha, chb;
not not1(sel0, sel);

and and1[7:0](cha, a, sel );
and and2[7:0](chb, b, sel0 );

or or1[7:0](f, cha, chb);

endmodule

