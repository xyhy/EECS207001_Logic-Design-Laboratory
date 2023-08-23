`timescale 1ns/1ps

module Memory_t;
reg clk = 0;
reg ren = 1'b0;
reg wen = 1'b0;
reg [10:0] waddr = 11'd0;
reg [10:0] raddr = 11'd0;
reg [7:0] din = 8'd0;
wire [7:0] dout;
reg [3:0]a = 4'b0000; 
reg [3:0]b = 4'b0000; 

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;

Multi_Bank_Memory mem(
    .clk(clk),
    .ren(ren),
    .wen(wen),
    .din(din),
    .waddr(waddr),
    .raddr(raddr),
    .dout(dout)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
initial begin
    $fsdbDumpfile("Memory.fsdb");
    $fsdbDumpvars;
end

initial begin
    repeat(2*4)begin
    
    @(negedge clk)
    waddr ={ a,7'd87};
    raddr ={ b,7'd87};
    din = 8'd87;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = { a,7'd87};
    raddr ={ b,7'd15};
    din = 8'd87;
    ren = 1'b1;
    wen = 1'b1;
    a = a+1'b1;
    @(negedge clk)
    waddr = { a,7'd15};
    raddr ={ b,7'd87};
    din = 8'd87;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    waddr = { a,7'd15};
    raddr = { b,7'd15};
    din = 8'd85;
    ren = 1'b1;
    wen = 1'b1;
    a = a+1'b1;
    b = b+1'b1;
    end
    @(negedge clk)
    $finish;
end

endmodule
