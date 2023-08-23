`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, Begin, a, b, Complete, gcd);
input clk, rst_n;
input Begin;
input [16-1:0] a;
input [16-1:0] b;
reg [16-1:0] num_a,next_num_a,num_b,next_num_b;
output reg Complete;
output reg [16-1:0] gcd;
reg [2-1:0] state, next_state;


parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;
parameter FINISH_2 = 2'b11;

    always @(posedge clk) begin
        if(rst_n == 1'b0) begin
            state <= WAIT;
            num_a <= a;
            num_b <= b;
        end
        else begin
            state <= next_state;
            num_a <= next_num_a;
            num_b <= next_num_b;
        end
    end

    always @(*) begin
        case (state)
            WAIT : begin
                if(Begin == 1'b1) begin
                    next_state = CAL;
                    next_num_a = a;
                    next_num_b = b;
                end
                else begin 
                    next_state = WAIT;
                    next_num_a = a;
                    next_num_b = b;
                end
                Complete = 1'b0;
                gcd = 16'b0;
            end
            CAL : begin
                Complete = 1'b0;
                gcd = 16'b0;
                if(num_a == 16'b0 || num_b == 16'b0) begin
                    next_state = FINISH;
                    next_num_a = num_a;
                    next_num_b = num_b;
                end
                else begin
                    next_state = CAL;
                    if(num_a > num_b) begin 
                        next_num_a = num_a-num_b;
                    end
                    else begin
                        next_num_b = num_b-num_a;
                    end
                end
            end
            FINISH : begin 
                Complete = 1'b1;
                if(num_a == 16'b0) begin
                    gcd = num_b;
                end
                else begin
                    gcd = num_a;
                end
                next_state = FINISH_2;
            end
            FINISH_2 : begin 
                Complete = 1'b1;
                if(num_a == 16'b0) begin
                    gcd = num_b;
                end
                else begin
                    gcd = num_a;
                end
                next_state = WAIT;
            end
        endcase
    end


endmodule
