`timescale 1ns/1ps

module RippleCarryAdder_t;
reg [8-1:0] a = 0;
reg [8-1:0] b = 0;
reg cin = 1'b0;
wire [8-1:0] out;
wire cout;

RippleCarryAdder fa (
  .a (a),
  .b (b),
  .cin (cin),
  .cout (cout),
  .sum (out)
);

initial begin
  
    #5  // cin == 0 cout == 0
    a = 1;
    b = 1;
    cin = 0;
    #5  // cin==0 cout==1 
    a = 2**7+1;
    b = 2**7;
    cin = 0;
    #5 // cin == 1 cout==1 since cin
    a = 2**8-1;
    b = 3 ;
    cin = 1;
    #5


    #1 $finish;
end


endmodule



