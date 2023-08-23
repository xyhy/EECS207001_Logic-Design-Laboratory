`timescale 1ns/1ps

module Dmux_t;

    reg CLK = 1;
    reg [4-1:0] in=4'b0000;
    reg [2-1:0] sel=2'b00;
    wire [4-1:0] a, b, c, d;
    reg pass = 1;

    Dmux_1x4_4bit Dmux(
        .in(in),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel)
    );
        

    always #1 CLK = ~CLK;

    initial begin

        $fsdbDumpfile("Dmux.fsdb");
        $fsdbDumpvars;

        repeat(4) begin
            repeat(2**4) begin
                @(posedge CLK)
                simulate;
                @(negedge CLK)
                in = in + 4'b1;
            end
            #5
            sel = sel + 1'b1;
        end

        #1    $finish;
    end

    task simulate;
        if(sel === 2'b00) begin
            if(a !== in) begin
                pass = 0;
            end
        end
        else if(sel === 2'b01) begin 
            if(b !== in) begin
                pass = 0;
            end
        end
        else if(sel === 2'b10) begin
            if(c !== in) begin
                pass = 0;
            end
        end
        else begin
            if(d !== in) begin
                pass = 0;
            end
        end
    endtask

endmodule