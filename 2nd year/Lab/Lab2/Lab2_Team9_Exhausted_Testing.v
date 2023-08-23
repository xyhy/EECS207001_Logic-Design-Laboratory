`timescale 1ns/1ps

module Exhausted_Testing(a, b, cin, error, done);
output [3:0] a, b;
output cin;
output reg error = 0;
output reg done = 0;

// input signal to the test instance.
reg [3:0] a = 4'b0000;
reg [3:0] b = 4'b0000;
reg cin = 1'b0;

// output from the test instance.
wire [3:0] sum;
wire cout;

// instantiate the test instance.
Ripple_Carry_Adder rca(
    .a (a), 
    .b (b), 
    .cin (cin),
    .cout (cout),
    .sum (sum)
);

initial begin
    repeat (2**9) begin
        {cin,a,b} = {cin,a,b}+1'b1;
        #1;
        Test;
        #4;
    end
    done = 1'b1;

    #5 $finish;
end

task Test:
    if(a+b+cin !== {cout, sum}) begin
        error = 1'b1;
    end
    else begin
        error = 1'b0;
    end
endtask

endmodule