`timescale 1ns/1ps

module RCA_tb;
reg [8-1:0] a=8'b0, b=8'b0;
reg cin = 1'b0;
wire [8-1:0] sum;
wire cout;
reg CLK = 1;
reg pass = 1;

Ripple_Carry_Adder RCA(
    .a(a), .b(b), .cin(cin), .cout(cout), .sum(sum) );

always #1 CLK = ~CLK;

initial begin
    $fsdbDumpfile("RCA_nwave.fsdb");
    $fsdbDumpvars;
    repeat (2**17) begin
        @(posedge CLK)
            simulate;
        @(negedge CLK)
            {cin,a,b} = {cin,a,b} + 1'b1;
    end

    #2 $finish;
end

task simulate;
    if(a+b+cin !== {cout, sum}) begin
        pass = 0;
    end
    else begin
        pass = 1;
    end
endtask
endmodule