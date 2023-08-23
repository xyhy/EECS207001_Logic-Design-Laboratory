`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [1:0] sel;
output reg clk1_2;
output reg clk1_4;
output reg clk1_8;
output reg clk1_3;
output reg dclk;

reg [3-1:0] num = 0;
wire[3-1:0] nxt_num;
reg [2-1:0] num3 = 0;
wire [2-1:0] nxt_num3;

    always @(posedge clk) begin
        if(rst_n == 1'b0) begin
            num <= 3'b000;
            num3 <= 2'b00;
        end
        else begin
            num <= nxt_num;
            num3 <= nxt_num3;
        end
    end
    assign nxt_num = num+1;
    assign nxt_num3 = (num3==2'b10)?2'b00:(num3+1);

    always @(*) begin
        
            if(num[0] == 1'b0) begin
                clk1_2 = 1;
            end
            else begin
                clk1_2 = 0;
            end

            if(num[1:0] == 2'b00) begin
                clk1_4 = 1;
            end
            else begin
                clk1_4 = 0;
            end

            if(num == 3'b000) begin
                clk1_8 = 1;
            end
            else begin
                clk1_8 = 0;
            end

            if(num3 == 2'b00) begin
                clk1_3 = 1;
            end
            else begin
                clk1_3 = 0;
            end


    end

    always @(*) begin
        // if(rst_n === 1'b0) begin
        //     dclk = 1'b0;
        // end
        // else begin
            if(sel === 2'b00) begin
                dclk = clk1_3; 
            end
            else if(sel === 2'b01) begin
                dclk = clk1_2;
            end
            else if(sel === 2'b10) begin
                dclk = clk1_4;
            end
            else if(sel === 2'b11) begin
                dclk = clk1_8;
            end
            else begin
                dclk = 1'b0;
            end
        // end
        
    end

endmodule