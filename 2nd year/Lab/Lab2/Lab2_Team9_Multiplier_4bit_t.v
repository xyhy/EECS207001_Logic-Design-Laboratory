`timescale 1ns/1ps

module multiplier_tb;
reg CLK = 1;
reg [4-1:0] a=4'b0000, b=4'b0000;
reg pass = 1;
wire [8-1:0] out;

Multiplier_4bit multiple(.a(a), .b(b), .p(out));

always #1 CLK = ~CLK;

initial begin
    $fsdbDumpfile("multiplier_nwave.fsdb");
    $fsdbDumpvars;
    repeat(2**8) begin
        @(posedge CLK)
            simulate;
        @(negedge CLK)
            {a,b} = {a,b}+1'b1;
    end

    #2 $finish;
end

task simulate;
    if(a*b !== out) begin
        pass = 0;
    end
    else begin
        pass = 1;
    end
endtask
endmodule