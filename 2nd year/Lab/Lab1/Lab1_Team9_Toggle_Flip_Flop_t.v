`timescale 1ns/1ps

module Toggle_Flip_Flop_t;

// input and output signals

reg clk;
reg t;
reg rst_n;
wire q;

// generate clk


// test instance instantiation
Toggle_Flip_Flop TFF(
    .clk(clk),
    .rst_n(rst_n),
    .t(t),
    .q(q)
);


always #5 clk=~clk;
always #13 t = ~t;
initial begin
{rst_n,clk,t}<=0;
repeat(2) @(posedge clk);
rst_n<=1;
#50
rst_n=0;
#50
rst_n=1;


end
endmodule