`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output reg dec;
reg [4-1:0] state, next_state;

parameter S0 = 4'b0000;

parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0101;

parameter S4 = 4'b0110;
parameter S5 = 4'b0111;
parameter S6 = 4'b1000;

parameter F1 = 4'b1001;
parameter F2 = 4'b1010;


    always @(posedge clk) begin
        if(rst_n == 0)  begin 
            state <= S0;
        end 
        else begin
            state <= next_state;
        end
    end

    always @(*) begin 
        case(state)
            S0 : begin
                if(in == 1) begin 
                    next_state = S1;
                    dec = 1'b0;
                end
                else begin
                    next_state = S4;
                    dec = 1'b0;
                end
            end
            S1 : begin
                if(in == 1) begin 
                    next_state = F1;
                    dec = 1'b0;
                end
                else begin
                    next_state = S2;
                    dec = 1'b0;
                end
            end
            S2 : begin
                if(in == 1) begin 
                    next_state = S3;
                    dec = 1'b0;
                end
                else begin
                    next_state = F2;
                    dec = 1'b0;
                end
            end
            S3 : begin
                next_state = S0;
                dec = 1'b1;
            end
            S4 : begin
                if(in == 1) begin 
                    next_state = F1;
                    dec = 1'b0;
                end
                else begin
                    next_state = S5;
                    dec = 1'b0;
                end
            end
            S5 : begin
                if(in == 1) begin 
                    next_state = S6;
                    dec = 1'b0;
                end
                else begin
                    next_state = F2;
                    dec = 1'b0;
                end
            end
            S6 : begin
                if(in == 1) begin 
                    next_state = S0;
                    dec = 1'b1;
                end
                else begin
                    next_state = S0;
                    dec = 1'b0;
                end
            end
            F1 : begin
                next_state = F2;
                dec = 1'b0;
            end
            F2 : begin
                next_state = S0;
                dec = 1'b0;
            end
            default : begin
                next_state = S0;
                dec = 1'b0;
            end
        endcase
    end
endmodule
