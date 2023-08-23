`timescale 1ns/1ps

module Round_Robin_Arbiter_t;
reg clk = 1;
reg rst_n = 1;
reg [3:0] wen = 4'bx;
reg [7:0] a = 8'bx, b = 8'bx, c = 8'bx, d = 8'bx;
wire [7:0] dout;
wire valid;
// wire [7:0] outa, outb, outc, outd;
// wire [7:0] tmpout;
// wire [3:0] error;


    always #1 clk = ~clk;

    Round_Robin_Arbiter RRA(
        .clk(clk),
        .rst_n(rst_n),
        .wen(wen),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .dout(dout),
        .valid(valid)
        // .error(error)
        // .tmpout(tmpout)
    //    .outa(outa), .outb(outb), .outc(outc), .outd(outd), .ren(ren)
    );

    initial begin
        $fsdbDumpfile("RRA.fsdb");
        $fsdbDumpvars;

        repeat (2) begin
            #1;
                @(negedge clk)
                rst_n = 0;
                wen = 4'b1111;
            #2 @(negedge clk)
                rst_n = 1;
                a = 8'd87;
                b = 8'd56;
                c = 8'd9;
                d = 8'd13;
                @(negedge clk)
                wen = 4'b1000;
                a = 8'bx;
                b = 8'bx;
                c = 8'bx;
                d = 8'd85;
                @(negedge clk)
                wen = 4'b0100;
                c = 8'd139;
                d = 8'bx;
                @(negedge clk)
                wen = 4'b0000;
                c = 8'bx;
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                @(negedge clk)
                wen = 4'b0001;
                a = 8'd51;
                @(negedge clk)
                wen = 4'b0000;
                a = 8'bx;
                #2;
        end
    #1 $finish;
    end

endmodule