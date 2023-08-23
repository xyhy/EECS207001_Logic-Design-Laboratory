`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output reg done;
output reg [15:0] gcd;

reg [2-1:0] state, next_state;
reg [16-1:0] num_a, num_b, next_a, next_b;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;
parameter FINISH_2 = 2'b11;

    always @(posedge clk) begin
        if(!rst_n) begin
            state <= WAIT;
            num_a <= a;
            num_b <= b;
        end
        else begin
            state <= next_state;
            num_a <= next_a;
            num_b <= next_b;
        end
    end

    always @(*) begin
        case(state)
            WAIT: begin
                done = 1'b0;
                gcd = 16'b0;
                if(start) begin
                    next_state = CAL;
                    next_a = a;
                    next_b = b;
                end
                else begin
                    next_state = WAIT;
                    next_a = a;
                    next_b = b;
                end
            end
            CAL: begin
                done = 1'b0;
                gcd = 16'b0;
                if(num_a == 16'b0 || num_b == 16'b0) begin
                    next_state = FINISH;
                    next_a = num_a;
                    next_b = num_b;
                end
                else begin
                    next_state = CAL;
                    if(num_a > num_b) begin
                        next_a = num_a - num_b;
                        next_b = num_b;
                    end
                    else begin
                        next_a = num_a;
                        next_b = num_b - num_a;
                    end
                end
            end
            FINISH: begin
                done = 1'b1;
                next_state = FINISH_2;
                next_a = num_a;
                next_b = num_b;
                if(num_a == 16'b0) begin
                    gcd = num_b;
                end
                else begin
                    gcd = num_a;
                end
            end
            FINISH_2:begin
                done = 1'b1;
                next_state = WAIT;
                next_a = num_a;
                next_b = num_b;
                if(num_a == 16'b0) begin
                    gcd = num_b;
                end
                else begin
                    gcd = num_a;
                end
            end
            default:begin
            end
        endcase
    end


endmodule

