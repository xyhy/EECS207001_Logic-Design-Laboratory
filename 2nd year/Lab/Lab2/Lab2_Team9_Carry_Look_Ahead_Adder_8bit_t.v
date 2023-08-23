`timescale 1ns/1ps

module CLA_tb;
reg [8-1:0] a=8'b0, b=8'b0;
reg c0 = 1'b0;
wire [8-1:0] s;
wire c8;
reg CLK = 1;
reg pass = 1;

Carry_Look_Ahead_Adder_8bit CLA(
    .a(a), .b(b), .c0(c0), .s(s), .c8(c8)
);

always #1 CLK = ~CLK;

initial begin
    $fsdbDumpfile("CLA_nwave.fsdb");
    $fsdbDumpvars;
    repeat (2**17) begin
        @(posedge CLK)
            simulate;
        @(negedge CLK)
            {c0,a,b} = {c0,a,b}+1'b1;
    end

    #2 $finish;
end

task simulate;
    if(a+b+c0 !== {c8,s}) begin
        pass = 0;
    end
    else begin
        pass = 1;
    end
endtask
endmodule