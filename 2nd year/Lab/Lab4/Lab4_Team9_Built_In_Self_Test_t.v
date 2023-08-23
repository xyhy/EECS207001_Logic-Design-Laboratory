`timescale 1ns/1ps
module Built_In_Self_Test_t;
reg clk = 1'b1;
reg rst_n = 1'b0;
reg scan_en=1'b0;
wire scan_in;
wire scan_out;
// wire [3:0] a,b;
// wire [8-1:0] mul_out;

   Built_In_Self_Test bist(
        .clk(clk), 
        .rst_n(rst_n),
        .scan_en(scan_en), 
        .scan_in(scan_in), 
        .scan_out(scan_out)
       //  .a(a), .b(b), .mul_out(mul_out)
    );

    always #2    clk = ~clk;

    initial begin//scan_in = 10101011
       $fsdbDumpfile("BIST.fsdb");
       $fsdbDumpvars;
       
          #2
       rst_n = 0;
       repeat(8)begin
       @(negedge clk)
       rst_n = 1;
//       scan_in = 1;
       scan_en = 1; 
       end
       rst_n = 1;
//       scan_in = 1;
       scan_en = 1;
       #3
//       scan_in = scan_in;
       scan_en = 0;
       #2
           
       @(negedge clk)
       scan_en=1; 
       
       repeat(7)begin
       @(negedge clk)
       scan_en = 1;
    
       end
       rst_n = 0;
        @(negedge clk)rst_n = 1;
        repeat(7)begin
       @(negedge clk)
       scan_en = 1;
//       scan_in = 1;
       end
       
       @(negedge clk)
       scan_en=0;
       
       repeat(8)begin
       @(negedge clk)
//       scan_in = scan_in + 1;
       scan_en = 1;
    
       end
       
       repeat(64)begin
       @(negedge clk)
//       scan_in = ($random)%2;
       scan_en = ($random)%2;
    
       end

        
        
        #4 $finish;
    end
endmodule