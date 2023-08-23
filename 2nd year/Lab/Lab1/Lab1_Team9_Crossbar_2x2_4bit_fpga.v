`timescale 1ns/1ps

module lab1_fpga(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [8-1:0] out1, out2;

wire [4-1:0] tmpout1, tmpout2;


Crossbar_2x2_4bit cross(
    .in1(in1), 
    .in2(in2), 
    .control(control),
    .out1(tmpout1),
    .out2(tmpout2)
);

and and1[1:0](out1[1:0], tmpout1[0], 1'b1);
and and2[1:0](out1[3:2], tmpout1[1], 1'b1);
and and3[1:0](out1[5:4], tmpout1[2], 1'b1);
and and4[1:0](out1[7:6], tmpout1[3], 1'b1);
and and5[1:0](out2[1:0], tmpout2[0], 1'b1);
and and6[1:0](out2[3:2], tmpout2[1], 1'b1);
and and7[1:0](out2[5:4], tmpout2[2], 1'b1);
and and8[1:0](out2[7:6], tmpout2[3], 1'b1);

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