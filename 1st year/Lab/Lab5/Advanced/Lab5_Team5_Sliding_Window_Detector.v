`timescale 1ns/1ps

module Sliding_Window_Detector (clk, rst_n, in, dec1, dec2);
input clk, rst_n;
input in;
output reg dec1, dec2;

reg flag1111;
reg [2-1:0] state1, state2;
reg [2-1:0] next_state1, next_state2;
reg [3-1:0] next_state_flag, state_flag;

parameter s1_0 = 2'b00;
parameter s1_1 = 2'b01;
parameter s1_2 = 2'b10;

parameter s2_0 = 2'b00;
parameter s2_1 = 2'b01;
parameter s2_2 = 2'b10;
parameter s2_3 = 2'b11;

parameter sf_0 = 3'b000;
parameter sf_1 = 3'b001;
parameter sf_2 = 3'b010;
parameter sf_3 = 3'b011;
parameter sf_4 = 3'b100;


    always @(posedge clk)begin
        if(rst_n == 0)begin 
            flag1111 <= 1'b0;
            state1 <= s1_0;
            state_flag <= sf_0;
            state2 <= s2_0;
        end
        else begin 
            if(flag1111 == 1'b1)begin 
                state1 <= s1_0;
                state_flag <= next_state_flag;
                state2 <= next_state2;
            end
            else begin 
                state1 <= next_state1;
                state2 <= next_state2;
                state_flag <= next_state_flag;
            end
        end
    end


    always @(*) begin 
        case(state1)
            s1_0 : begin
                if(in == 1'b1) begin
                    next_state1 = s1_1;
                    dec1 = 1'b0;
                end
                else begin
                    next_state1 = s1_0;
                    dec1 = 1'b0;
                end
            end
            s1_1 : begin
                if(in == 1'b1) begin
                    next_state1 = s1_1;
                    dec1 = 1'b0;
                end
                else begin
                    next_state1 = s1_2;
                    dec1 = 1'b0;
                end
            end
            s1_2 : begin
                if(in == 1'b1) begin
                    next_state1 = s1_1;
                    dec1 = 1'b1;
                end
                else begin
                    next_state1 = s1_0;
                    dec1 = 1'b0;
                end
            end
            default : begin
                next_state1 = s1_0;
                dec1 = 1'b0;
            end
        endcase

        case(state2)
            s2_0 : begin
                if(in == 1'b1)begin 
                    next_state2 = s2_1;
                    dec2 = 1'b0;
                end
                else begin 
                    next_state2 = s2_0;
                    dec2 = 1'b0;
                end
            end
            s2_1 : begin
                if(in == 1'b1)begin 
                    next_state2 = s2_2;
                    dec2 = 1'b0;
                end
                else begin 
                    next_state2 = s2_0;
                    dec2 = 1'b0;
                end
            end
            s2_2 : begin
                if(in == 1'b1)begin 
                    next_state2 = s2_2;
                    dec2 = 1'b0;
                end
                else begin 
                    next_state2 = s2_3;
                    dec2 = 1'b0;
                end
            end
            s2_3 : begin
                if(in == 1'b1)begin 
                    next_state2 = s2_1;
                    dec2 = 1'b1;
                end
                else begin 
                    next_state2 = s2_0;
                    dec2 = 1'b0;
                end
            end
            default : begin
                next_state2 = s2_0;
                dec2 = 1'b0;
            end
        endcase

        case(state_flag)
            sf_0 : begin
                if(in == 1'b1)begin
                    next_state_flag = sf_1;
                    flag1111 = 1'b0;
                end
                else begin 
                    next_state_flag = sf_0;
                    flag1111 = 1'b0;
                end
            end
            sf_1 : begin
                if(in == 1'b1)begin
                    next_state_flag = sf_2;
                    flag1111 = 1'b0;
                end
                else begin 
                    next_state_flag = sf_0;
                    flag1111 = 1'b0;
                end
            end
            sf_2 : begin
                if(in == 1'b1)begin
                    next_state_flag = sf_3;
                    flag1111 = 1'b0;
                end
                else begin 
                    next_state_flag = sf_0;
                    flag1111 = 1'b0;
                end
            end
            sf_3 : begin
                if(in == 1'b1)begin
                    next_state_flag = sf_4;
                    flag1111 = 1'b1;
                end
                else begin 
                    next_state_flag = sf_0;
                    flag1111 = 1'b0;
                end
            end
            sf_4 : begin
                next_state_flag = sf_4;
                flag1111 = 1'b1;
            end
            default : begin
                next_state_flag = sf_0;
                flag1111 = 1'b0;
            end
        endcase
    end
endmodule
