`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output reg dec;

reg [4-1:0] state, next_state;


parameter s0 = 4'd0;
parameter s1 = 4'd1;
parameter s2 = 4'd2;
parameter s3 = 4'd3;
parameter s4 = 4'd4;
parameter s5 = 4'd5;
parameter s6 = 4'd6;
parameter s7 = 4'd7;


    always@(posedge clk) begin
        if(!rst_n) begin
            state <= s0;
        end
        else begin
            state <= next_state;
        end
    end


    always@(*) begin
        case(state)
            s0: begin
                if(in) begin
                    next_state = s1;
                    dec = 1'b0;
                end
                else begin
                    next_state = s0;
                    dec = 1'b0;
                end
            end
            s1: begin
                if(in) begin
                    next_state = s2;
                    dec = 1'b0;
                end
                else begin
                    next_state = s0;
                    dec = 1'b0;
                end
            end
            s2: begin
                if(in) begin
                    next_state = s2;
                    dec = 1'b0;
                end
                else begin
                    next_state = s3;
                    dec = 1'b0;
                end
            end
            s3: begin
                if(in) begin
                    next_state = s1;
                    dec = 1'b0;
                end
                else begin
                    next_state = s4;
                    dec = 1'b0;
                end
            end
            s4: begin
                if(in) begin
                    next_state = s5;
                    dec = 1'b0;
                end
                else begin
                    next_state = s0;
                    dec = 1'b0;
                end
            end
            s5: begin
                if(in) begin
                    next_state = s2;
                    dec = 1'b0;
                end
                else begin
                    next_state = s6;
                    dec = 1'b0;
                end
            end
            s6: begin
                if(in) begin
                    next_state = s5;
                    dec = 1'b0;
                end
                else begin
                    next_state = s7;
                    dec = 1'b0;
                end
            end
            s7: begin
                if(in) begin
                    next_state = s1;
                    dec = 1'b1;
                end
                else begin
                    next_state = s0;
                    dec = 1'b0;
                end
            end
            default:begin
            end
        endcase
    end
endmodule 