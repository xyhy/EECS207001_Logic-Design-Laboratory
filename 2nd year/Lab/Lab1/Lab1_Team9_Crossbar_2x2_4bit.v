`timescale 1ns/1ps

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [3:0] in1, in2;
input control;
output [3:0] out1, out2;

wire nctrl;
wire [4-1:0] in1_ctrl, in2_ctrl, in1_nctrl, in2_nctrl; 

not not1(nctrl, control);
and and1[3:0](in1_ctrl, in1, control);
and and2[3:0](in2_ctrl, in2, control);
and and3[3:0](in1_nctrl, in1, nctrl);
and and4[3:0](in2_nctrl, in2, nctrl);
or or1[3:0](out1, in1_ctrl, in2_nctrl);
or or2[3:0](out2, in2_ctrl, in1_nctrl);

endmodule

// module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
// input [3:0] in1, in2;
// input control;
// output [3:0] out1, out2;

// wire nctrl;
// wire [4-1:0] in1_up, in2_up, in1_down, in2_down;

// not not1(nctrl, control);

// Dmux_1x2 in_1(
//     .in(in1),
//     .sel(nctrl),
//     .a(in1_up),
//     .b(in1_down)
// );
// Dmux_1x2 in_2(
//     .in(in2),
//     .sel(control),
//     .a(in2_up),
//     .b(in2_down)
// );

// Mux_2x1 out_1(
//     .a(in1_up),
//     .b(in2_up),
//     .sel(nctrl),
//     .f(out1)
// );

// Mux_2x1 out_2(
//     .a(in1_down),
//     .b(in2_down),
//     .sel(control),
//     .f(out2)
// );

// endmodule



// module Mux_2x1(a, b, sel, f);
// input [4-1:0] a, b;
// input sel;
// output [4-1:0] f;

// wire n_sel;
// wire [4-1:0] cha, chb;

// not not1(n_sel, sel);
// and and1[3:0](cha, a, n_sel);
// and and2[3:0](chb, b, sel);
// or or1[3:0](f, cha, chb);
// endmodule


// module Dmux_1x2(in, sel, a, b);
// input [4-1:0] in;
// input sel;
// output [4-1:0] a, b;

// wire sel_not;

// not not1(sel_not, sel);
// and and1[3:0](a, in, sel_not);
// and and2[3:0](b, in, sel);

// endmodule