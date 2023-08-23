`timescale 1ns/1ps
`define CYC 2
module Mealy_Sequence_Detector_t;

reg clk = 1'b1;
reg rst_n = 1'b0;
reg in =1'b0;
wire dec;
//wire [4-1:0] state;

always #(`CYC/2) clk = ~clk;

Mealy_Sequence_Detector msd(
.clk(clk),
.rst_n(rst_n),
.in(in),
.dec(dec)
//,.state(state)
);

initial begin

    $fsdbDumpfile("MSD.fsdb");
    $fsdbDumpvars;
    @ (negedge clk) rst_n = 1'b1;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b1;
    @ (posedge clk)
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b1;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) 
    @ (negedge clk) in = 1'b0;
    @ (posedge clk) 
    @ (negedge clk) $finish;



end


endmodule
