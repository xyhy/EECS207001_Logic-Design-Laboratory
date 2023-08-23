`timescale 1ns/1ps

module Comparator_4bits (a, b, a_lt_b, a_gt_b, a_eq_b);
input [4-1:0] a, b;
output a_lt_b, a_gt_b, a_eq_b;


wire x0o,x1o,x2o,x3o;
wire m0o,m1o,m2o,temp;

XNOR_1 x0(a[0],b[0],x0o);
XNOR_1 x1(a[1],b[1],x1o);
XNOR_1 x2(a[2],b[2],x2o);
XNOR_1 x3(a[3],b[3],x3o);

Mux_1bit m0(0,b[0],x0o,m0o);
Mux_1bit m1(m0o,b[1],x1o,m1o);
Mux_1bit m2(m1o,b[2],x2o,m2o);
Mux_1bit m3(m2o,b[3],x3o,a_lt_b);

and and0 (a_eq_b,x0o,x1o,x2o,x3o);

or or0 (temp,a_lt_b,a_eq_b);
not not0 (a_gt_b,temp);
endmodule


module XNOR_1 (a, b,out);
input a, b;
output out;

wire ab,aob,naob;
and and1 (ab,a,b);
or or1 (aob,a,b);
not not1(naob,aob); 
or or2 (out ,ab,naob);

endmodule

module Mux_1bit (a, b, sel, f);
input  a, b;
input sel;
output  f;

wire sel0, cha, chb;

not not1(sel0, sel);
and and1(cha, a, sel);
and and2(chb, b, sel0);
or or1(f, cha, chb);
endmodule
