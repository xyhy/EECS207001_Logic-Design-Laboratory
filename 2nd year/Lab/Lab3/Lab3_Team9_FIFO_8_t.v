`timescale 1ns/1ps

module FIFO_8_t;
reg clk = 1'b0;
reg rst_n = 1'b1;
reg wen=1'b0, ren=1'b0;
reg [8-1:0] din;
wire error;
wire [8-1:0] dout;
reg [8-1:0] idx;

    FIFO_8 fifo(
        .clk(clk), 
        .rst_n(rst_n), 
        .wen(wen), 
        .ren(ren), 
        .din(din), 
        .dout(dout), 
        .error(error) 
    );

    always #1 clk = ~clk;

    initial begin
        $fsdbDumpfile("FIFO_8.fsdb");
        $fsdbDumpvars;
        //Under reset situation
        #4 rst_n = 1'b0; 
        @(negedge clk)
            ren = 1'b1;
        @(negedge clk)
            wen = 1'b1;
            ren = 1'b0;
            din = 8'b01010101;
        @(negedge clk)
            wen = 1'b0;
            ren = 1'b1;     //only read, read 01010101 but reset
        @(negedge clk)
            wen = 1'b1;
            ren = 1'b0;
            din = 8'b10101010;
        @(negedge clk)
            ren = 1'b1;     //read and write, read 10101010 but reset

        //Finish reset and start test
        @(negedge clk)
            rst_n = 1'b1;   //ren == 1, error = 1 at begin
            din = 8'b0;
        for (idx = 1; idx < 10; idx = idx+1)begin    //write 1~8 to store[0]~store[7], and error=1 when full(idx=9)
            @(negedge clk)
                ren = 1'b0;
                wen = 1'b1;
                din = idx;
        end
        repeat(9) begin     //read from store[0]~store[7], and error=1 when empty
            @(negedge clk)
                wen = 1'b0;
                ren = 1'b1;
        end

        //Test interrupt reset and large din
        for (idx = 255; idx > 250; idx = idx-1)begin    //write 255~251 to store[0]~store[4]
            @(negedge clk)
                ren = 1'b0;
                wen = 1'b1;
                din = idx;
        end
        repeat(3) begin     //read from store[0]~store[2]
            @(negedge clk)
                ren = 1'b1;
        end
        @(negedge clk)
            ren = 1'b0;
            wen = 1'b1;
            din = 8'd250;
        @(negedge clk)
            ren = 1'b1;
        @(negedge clk)
            rst_n = 1'b0;
        @(negedge clk)
            rst_n = 1'b1;
            ren = 1'b1;     //empty -> error = 1
        
        for (idx = 10; idx < 14; idx = idx+1)begin    //write 10~13 to store[0]~store[3]
            @(negedge clk)
                ren = 1'b0;
                wen = 1'b1;
                din = idx;
        end

        @(negedge clk)
            ren = 1'b1;

        #5 $finish;
    end
endmodule