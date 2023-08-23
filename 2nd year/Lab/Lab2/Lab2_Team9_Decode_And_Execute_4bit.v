`timescale 1ns/1ps

module Decode_And_Execute(rs, rt, sel, rd);
input [3:0] rs, rt;
input [2:0] sel;
output [3:0] rd;
wire [32-1:0] mux_in;


// ----------- wire declaration ------------
//001
wire [3:0] nrt,newrt;
//110
wire [3:0] eq1;
wire eq2, eq3, s1;
//111
wire ab_3, ab_2, ab_1, ab_0;
wire continue_3, continue_2, continue_1;
wire choose_in_2, choose_in_1_1, choose_in_1_2, choose_in_0_1, choose_in_0_2, choose_in_0_3;
wire bg1, bg2, bg3;


//000 ADD
Adder add(.a(rs), .b(rt), .sum(mux_in[3:0]));
//001 SUB two's compliment
NOT not0[4-1:0](nrt, rt);
Adder complement(.a(nrt), .b(4'b0001), .sum(newrt));
Adder sub(.a(rs), .b(newrt), .sum(mux_in[7:4]));
//010 bitwise AND
AND bitwise_and[4-1:0](.out(mux_in[11:8]), .a(rs), .b(rt));
//011 bitwise OR
OR bitwise_or[4-1:0](mux_in[15:12], rs, rt);
//100 rs left shift
Universal_Gate link1[4-1:0](.out(mux_in[19:16]), .a({rs[2:0], rs[3]}), .b(1'b0));
//101 rt right shift
Universal_Gate link2[4-1:0](.out(mux_in[23:20]), .a({rt[3], rt[3:1]}), .b(1'b0));
//110 compare rs == rt //4 bit magnitude comparator
XNOR xnor1 [3:0] (eq1, rs, rt);
AND and1(eq2, eq1[0], eq1[1]);
AND and2(eq3, eq2, eq1[2]);
AND and3(s1, eq3, eq1[3]);
Universal_Gate link_eq[3:0](.a({3'b111, s1}), .b(1'b0), .out(mux_in[27:24]));
//111 compare rs > rt//4 bit magnitude comparator
Universal_Gate bit3(.out(ab_3), .a(rs[3]), .b(rt[3])); //rs>rt in [3] when ab_3=1;

XNOR xnor_3(.out(continue_3), .a(rs[3]), .b(rt[3]));
Universal_Gate bit2(.out(ab_2), .a(rs[2]), .b(rt[2]));
AND and_2(.out(choose_in_2), .a(continue_3), .b(ab_2)); //rs>rt in [2] when choose_in_2=1;

XNOR xnor_2(.out(continue_2), .a(rs[2]), .b(rt[2]));
Universal_Gate bit1(.out(ab_1), .a(rs[1]), .b(rt[1]));
AND and_1_1(.out(choose_in_1_1), .a(continue_3), .b(continue_2));
AND and_1_2(.out(choose_in_1_2), .a(choose_in_1_1), .b(ab_1)); //rs>rt in [1] when choose_in_1_2=1;

XNOR xnor_1(.out(continue_1), .a(rs[1]), .b(rt[1]));
Universal_Gate bit0(.out(ab_0), .a(rs[0]), .b(rt[0]));
AND and_0_1(.out(choose_in_0_1), .a(continue_3), .b(continue_2));
AND and_0_2(.out(choose_in_0_2), .a(choose_in_0_1), .b(continue_1));
AND and_0_3(.out(choose_in_0_3), .a(choose_in_0_2), .b(ab_0)); //rs>rt in [0] when choose_in_0_3=1;

OR orbg1(.out(bg1), .a(ab_3), .b(choose_in_2));
OR orbg2(.out(bg2), .a(bg1), .b(choose_in_1_2));
OR orbg3(.out(bg3), .a(bg2), .b(choose_in_0_3));

Universal_Gate link_bg[3:0](.a({3'b101, bg3}), .b(1'b0), .out(mux_in[31:28]));

// choose output
Mux_8in1 mux(.in(mux_in), .sel(sel), .out(rd));
endmodule


module Mux_8in1(in, sel, out);
input [3-1:0] sel;
input [32-1:0] in;
output [4-1:0] out;

wire [4-1:0] out1, out2, out3, out4, out5, out6, out7, out8;
wire [3-1:0] neg;
wire and1_out, and2_out, and4_out, and5_out, and7_out, and8_out, and10_out, and11_out;
wire and13_out, and14_out, and16_out, and17_out, and19_out, and20_out, and22_out, and23_out;
wire [4-1:0] or1_out, or2_out, or3_out, or4_out, or5_out, or6_out;

// do negative select signal
NOT not0[2:0](neg, sel);

//000
AND and1(and1_out, neg[0], neg[1]);
AND and2(and2_out, and1_out, neg[2]);
AND and3[4-1:0](out1, {4{and2_out}}, in[3:0]);
///001
AND and4(and4_out, sel[0], neg[1]);
AND and5(and5_out, and4_out, neg[2]);
AND and6[4-1:0](out2, {4{and5_out}}, in[7:4]);
//010
AND and7(and7_out, neg[0], sel[1]);
AND and8(and8_out, and7_out, neg[2]);
AND and9[4-1:0](out3, {4{and8_out}}, in[11:8]);
//011
AND and10(and10_out, sel[0], sel[1]);
AND and11(and11_out, and10_out, neg[2]);
AND and12[4-1:0](out4, {4{and11_out}}, in[15:12]);
//100
AND and13(and13_out, neg[0], neg[1]);
AND and14(and14_out, and13_out, sel[2]);
AND and15[4-1:0](out5, {4{and14_out}}, in[19:16]);
//101
AND and16(and16_out, sel[0], neg[1]);
AND and17(and17_out, and16_out, sel[2]);
AND and18[4-1:0](out6, {4{and17_out}}, in[23:20]);
//110
AND and19(and19_out, neg[0], sel[1]);
AND and20(and20_out, and19_out, sel[2]);
AND and21[4-1:0](out7, {4{and20_out}}, in[27:24]);
//111
AND and22(and22_out, sel[0], sel[1]);
AND and23(and23_out, and22_out, sel[2]);
AND and24[4-1:0](out8, {4{and23_out}}, in[31:28]);

OR or1[4-1:0](or1_out, out1, out2);
OR or2[4-1:0](or2_out, or1_out, out3);
OR or3[4-1:0](or3_out, or2_out, out4);
OR or4[4-1:0](or4_out, or3_out, out5);
OR or5[4-1:0](or5_out, or4_out, out6);
OR or6[4-1:0](or6_out, or5_out, out7);
OR or7[4-1:0](out, or6_out, out8);
endmodule


module Universal_Gate(a, b, out); //implement of universal gate
input a, b;
output out;

wire negb;

not not1(negb, b);
and and1(out, a, negb);
endmodule


module NOT (out, a);
input a;
output out;
Universal_Gate notgate(.a(1'b1), .b(a), .out(out));
endmodule


module AND (out, a, b);
input a, b;
output out;
wire negb;
Universal_Gate not1(.a(1'b1), .b(b), .out(negb));
Universal_Gate and1(.a(a), .b(negb), .out(out));
endmodule


module OR (out, a, b);
input a, b;
output out;
wire nega, negab;

Universal_Gate not1(.a(1'b1), .b(a), .out(nega));
Universal_Gate and1(.a(nega), .b(b), .out(negab));
Universal_Gate not2(.a(1'b1), .b(negab), .out(out));
endmodule


module XNOR (out, a, b);
input a, b;
output out;
wire negab, negab2, aorb1;

Universal_Gate ab1(.out(negab), .a(a), .b(b));
Universal_Gate ab2(.out(negab2), .a(b), .b(a));
Universal_Gate not1(.out(aorb1), .a(1'b1), .b(negab));
Universal_Gate out1(.out(out), .a(aorb1), .b(negab2));

endmodule


module XOR (out, a, b);
input a, b;
output out;
wire axnorb;

XNOR xnor1(.out(axnorb), .a(a), .b(b));
Universal_Gate not1(.out(out), .a(1'b1), .b(axnorb));

endmodule


module Adder(a, b, sum);
input [3:0] a, b;
//output cout;
output [3:0] sum;

wire [3:0] c;

Full_Adder a0(.a(a[0]), .b(b[0]), .cin(1'b0), .cout(c[0]), .sum(sum[0]));
Full_Adder a1(.a(a[1]), .b(b[1]), .cin(c[0]), .cout(c[1]), .sum(sum[1]));
Full_Adder a2(.a(a[2]), .b(b[2]), .cin(c[1]), .cout(c[2]), .sum(sum[2]));
Full_Adder a3(.a(a[3]), .b(b[3]), .cin(c[2]), .cout(c[3]), .sum(sum[3]));
endmodule


module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire sum1;

XOR S1(.a(a), .b(b), .out(sum1));
XOR S2(.a(sum1), .b(cin), .out(sum));
Majority M(.a(a), .b(b), .c(cin), .out(cout));

endmodule


module Majority(a, b, c, out);
input a, b, c;
output out;

wire andab, andbc, andac, or1;

AND AB(.a(a), .b(b), .out(andab));
AND BC(.a(b), .b(c), .out(andbc));
AND AC(.a(a), .b(c), .out(andac));
OR orf(.a(andab), .b(andac), .out(or1));
OR orl(.a(or1), .b(andbc), .out(out));
endmodule