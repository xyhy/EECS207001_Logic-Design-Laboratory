`timescale 1ns/1ps

module Content_Addressable_Memory_t;
reg clk = 1'b0;
//reg rst_n = 1'b1;
reg wen=1'b0;
reg [3:0] addr=0;
reg [8-1:0] din=0;
reg ren=1'b0;
wire hit;
wire [3:0] dout;
// wire [16-1:0] array;

   Content_Addressable_Memory memory(
        .clk(clk), 
        .addr(addr), 
        .wen(wen), 
        .ren(ren), 
        .din(din), 
        .dout(dout), 
        .hit(hit)
        // .array(array)
    );

        always #1    clk = ~clk;

    initial begin
       $fsdbDumpfile("CAM.fsdb");
       $fsdbDumpvars;


       @(negedge clk)
        ren = 1'b0;
        wen = 1'b1;
        din = 4;
        addr = 0;
       @(negedge clk)
        wen = 1'b1;
        ren = 1'b0;
        din = 8;
        addr = 7;
       @(negedge clk)
        wen = 1'b1;
        ren = 1'b0;
        din = 35;
        addr = 15;
       @(negedge clk)
        wen = 1'b1;
        ren = 1'b0;
        din = 8;
        addr = 9;
       repeat(3)begin
       @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        din = 0;
        addr = 0;
        end
        @(negedge clk)
        wen = 0;
        addr = 0;
        din = 4;
        ren = 1;
        @(negedge clk)
        wen = 0;
        addr = 0;
        din = 8;
        ren = 1;
         @(negedge clk)
        wen = 0;
        addr = 0;
        din = 35;
        ren = 1;
        @(negedge clk)
        wen = 0;
        addr = 0;
        din = 87;
        ren = 1;
        @(negedge clk)
        wen = 0;
        addr = 0;
        din = 45;
        ren = 1;
          repeat(3)begin
       @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        din = 0;
        addr = 0;
        end
        
        ren = 1'b0;
        wen = 1'b1;
//        din = 1'b0;
           
        repeat(5)begin
            @(negedge clk);
            din = 7;
            addr =($random)%16;
        end
        
//        din = 1'b0;
        ren = 1'b1;
        wen = 1'b0;
        
        repeat(5)begin
            @(negedge clk);
            wen = ($random)%2;
            din = 7;   
        end
        
        ren = 1'b0;
        wen = 1'b1;
        
         repeat(8)begin
            @(negedge clk);
            din = ($random)%2;
            addr =($random)%16;
        end
        
//        din = 1'b0;
        ren = 1'b1;
        wen = 1'b0;
        
        repeat(8)begin
            @(negedge clk);
            wen = ($random)%2;
            din = ($random)%2;
            
        end
        
        ren = 1'b0;
        wen = 1'b1;
        
          repeat(16)begin
            @(negedge clk);
            din = ($random)%4;
            addr =($random)%16;
        end
        
//        din = 1'b0;
        ren = 1'b1;
        wen = 1'b0;
        
        repeat(16)begin
            @(negedge clk);
            wen = ($random)%2;
            din = ($random)%4;
            
        end
        
        ren = 1'b0;
        wen = 1'b1;
        din = 1'b0;
     
        
        repeat(2**7)begin
            @(negedge clk);
            din = din+1'b1;
            addr =  ($random)%16;
        end
    
        din = 1'b0;
        ren = 1'b1;
        wen = 1'b0;
        repeat(2**7)begin
            @(negedge clk);
            wen = ($random)%2;
            din = din+1'b1;
        end
        
        
        
        #4 $finish;
    end
endmodule