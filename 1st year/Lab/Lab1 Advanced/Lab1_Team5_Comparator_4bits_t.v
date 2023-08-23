`timescale 1ns/1ps

module Comparator_4bits_t;
reg [4-1:0] a = 0;
reg [4-1:0] b = 0;
wire lt,gt,eq;


Comparator_4bits c1 (
  .a (a),
  .b (b),
  .a_lt_b (lt),
  .a_gt_b (gt),
  .a_eq_b (eq)
);

initial begin
    #5  // a == b
    a = 1;
    b = 1;
    #5  // a > b
    a = 2**4-1;
    b = 2**3;
    #5 // a < b
    a = 2**2+1;
    b = 2**3 ;
    #5
    #1 $finish;
end


endmodule



