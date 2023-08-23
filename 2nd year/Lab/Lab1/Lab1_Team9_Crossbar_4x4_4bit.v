`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
input [3:0] in1, in2, in3, in4;
input [4:0] control;
output [3:0] out1, out2, out3, out4;

wire [4-1:0] c0_o1, c0_o2, c1_o1, c1_o2, c2_o1, c2_o2;

Crossbar_2x2_4bit control_0(
    .in1(in1),
    .in2(in2),
    .control(control[0]),
    .out1(c0_o1),
    .out2(c0_o2)
);
Crossbar_2x2_4bit control_1(
    .in1(in3),
    .in2(in4),
    .control(control[1]),
    .out1(c1_o1),
    .out2(c1_o2)
);
Crossbar_2x2_4bit control_2(
    .in1(c0_o2),
    .in2(c1_o1),
    .control(control[2]),
    .out1(c2_o1),
    .out2(c2_o2)
);

Crossbar_2x2_4bit control_3(
    .in1(c0_o1),
    .in2(c2_o1),
    .control(control[3]),
    .out1(out1),
    .out2(out2)
);

Crossbar_2x2_4bit control_4(
    .in1(c2_o2),
    .in2(c1_o2),
    .control(control[4]),
    .out1(out3),
    .out2(out4)
);
endmodule


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