`timescale 1ns/1ps

module Crossbar_4x4_t;

reg CLK = 1;
reg [5-1:0] control = 5'b00000;
reg [4-1:0] in1 = 4'b0000;
reg [4-1:0] in2 = 4'b0001;
reg [4-1:0] in3 = 4'b0010;
reg [4-1:0] in4 = 4'b0011;
wire [4-1:0] out1, out2, out3, out4;
reg pass = 1'b1;

    Crossbar_4x4_4bit crossbar(
        .in1(in1),
        .in2(in2), 
        .in3(in3),
        .in4(in4),
        .control(control),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
        );

    always #1 CLK = ~CLK;

    initial begin

        $fsdbDumpfile("crossbar4x4_nwave.fsdb");
        $fsdbDumpvars;
        
        repeat (2**5) begin
            repeat (2**4) begin
                @(posedge CLK)
                simulate;
                @(negedge CLK)
                in1 = in1 + 1'b1;
                in2 = in2 + 1'b1;
                in3 = in3 + 1'b1;
                in4 = in4 + 1'b1;
            end
            #4 
            control = control + 1'b1;
        end
        

        #1 $finish;
    end


    task simulate;
        if(control === 5'b00000) begin
            if(out1!==in4 || out2!==in2 || out3!==in3 || out4!==in1) begin
                pass = 0;
            end
            else pass = 1;
        end
        else if(control === 5'b00001) begin
            if(out1!==in4 || out2!==in1 || out3!==in3 || out4!==in2) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b00010) begin
            if(out1!==in3 || out2!==in2 || out3!==in4 || out4!==in1) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b00011) begin
            if(out1!==in3 || out2!==in1 || out3!==in4 || out4!==in2) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b00100) begin
            if(out1!==in1 || out2!==in2 || out3!==in3 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b00101) begin
            if(out1!==in2 || out2!==in1 || out3!==in3 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b00110) begin
            if(out1!==in1 || out2!==in2 || out3!==in4 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b00111) begin
            if(out1!==in2 || out2!==in1 || out3!==in4 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b01000) begin
            if(out1!==in2 || out2!==in4 || out3!==in3 || out4!==in1) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b01001) begin
            if(out1!==in1 || out2!==in4 || out3!==in3 || out4!==in2) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b01010) begin
            if(out1!==in2 || out2!==in3 || out3!==in4 || out4!==in1) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b01011) begin
            if(out1!==in1 || out2!==in3 || out3!==in4 || out4!==in2) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b01100) begin
            if(out1!==in2 || out2!==in1 || out3!==in3 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b01101) begin
            if(out1!==in1 || out2!==in2 || out3!==in3 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b01110) begin
            if(out1!==in2 || out2!==in1 || out3!==in4 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b01111) begin
            if(out1!==in1 || out2!==in2 || out3!==in4 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b10000) begin
            if(out1!==in4 || out2!==in2 || out3!==in1 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b10001) begin
            if(out1!==in4 || out2!==in1 || out3!==in2 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b10010) begin
            if(out1!==in3 || out2!==in2 || out3!==in1 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b10011) begin
            if(out1!==in3 || out2!==in1 || out3!==in2 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b10100) begin
            if(out1!==in1 || out2!==in2 || out3!==in4 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b10101) begin
            if(out1!==in2 || out2!==in1 || out3!==in4 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b10110) begin
            if(out1!==in1 || out2!==in2 || out3!==in3 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b10111) begin
            if(out1!==in2 || out2!==in1 || out3!==in3 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b11000) begin
            if(out1!==in2 || out2!==in4 || out3!==in1 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b11001) begin
            if(out1!==in1 || out2!==in4 || out3!==in2 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b11010) begin
            if(out1!==in2 || out2!==in3 || out3!==in1 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b11011) begin
            if(out1!==in1 || out2!==in3 || out3!==in2 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b11100) begin
            if(out1!==in2 || out2!==in1 || out3!==in4 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b11101) begin
            if(out1!==in1 || out2!==in2 || out3!==in4 || out4!==in3) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b11110) begin
            if(out1!==in2 || out2!==in1 || out3!==in3 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else if(control === 5'b11111) begin
            if(out1!==in1 || out2!==in2 || out3!==in3 || out4!==in4) begin
                pass = 0;
            end else pass = 1;
        end
        else begin
            pass = 0;
        end
    endtask

endmodule
