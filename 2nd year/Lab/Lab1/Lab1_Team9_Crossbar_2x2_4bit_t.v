`timescale 1ns/1ps

module Crossbar_2x2_t;
reg CLK = 1;
reg control = 1'b0;
reg [4-1:0] in1 = 4'b0000;
reg [4-1:0] in2 = 4'b0001;
wire [4-1:0] out1, out2;
reg pass = 1'b1;

    Crossbar_2x2_4bit crossbar(
        .in1(in1),
        .in2(in2), 
        .control(control),
        .out1(out1),
        .out2(out2)
        );

    always #1 CLK = ~CLK;

    initial begin

        $fsdbDumpfile("crossbar_nwave.fsdb");
        $fsdbDumpvars;
        repeat (2**4) begin
            @(posedge CLK)
                simulate;
            @(negedge CLK)
                in1 = in1 + 4'b1;
                in2 = in2 + 4'b1;
        end
        #4
        control = 1'b1;
        repeat (2**4) begin
            @(posedge CLK)
                simulate;
            @(negedge CLK)
                in1 = in1 + 4'b1;
                in2 = in2 + 4'b1;
        end
        
        

        #1 $finish;
    end

    task simulate;
        if(control === 1'b0) begin
            if(out1 !== in2 || out2 !== in1) begin
                pass = 0;
            end
        end
        else begin
            if(out1 !== in1 || out2 !== in2) begin
                pass = 0;
            end
        end
    endtask

endmodule
