`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output reg dec;
reg [4-1:0] state, next_state;

parameter S0 = 4'd0;

parameter A1 = 4'd1;
parameter A2 = 4'd2;
parameter A3 = 4'd3;

parameter A2_2 = 4'd4;
parameter A3_2 = 4'd5;

parameter B1 = 4'd6;
parameter B2 = 4'd7;
parameter B3 = 4'd8;

parameter F1 = 4'd9;
parameter F2 = 4'd10;

    always@(posedge clk) begin
        if(!rst_n) begin
            state <= S0;
        end
        else begin
            state <= next_state;
        end
    end

    always@(*) begin
        case(state)
            S0:begin
                if(in==1'b0)begin
                    next_state = B1;
                    dec = 1'b0;
                end
                else begin
                    next_state = A1;
                    dec = 1'b0;
                end
            end
            A1:begin
                if(in==1'b0)begin
                    next_state = A2_2;
                    dec = 1'b0;
                end
                else begin
                    next_state = A2;
                    dec = 1'b0;
                end
            end
            A2:begin
                if(in==1'b0)begin
                    next_state = F2;
                    dec = 1'b0;
                end
                else begin
                    next_state = A3;
                    dec = 1'b0;
                end
            end
            A3:begin
                if(in==1'b0)begin
                    next_state = S0;
                    dec = 1'b1;
                end
                else begin
                    next_state = S0;
                    dec = 1'b0;
                end
            end
            A2_2:begin
                if(in==1'b0)begin
                    next_state = A3_2;
                    dec = 1'b0;
                end
                else begin
                    next_state = F2;
                    dec = 1'b0;
                end
            end
            A3_2:begin
                if(in==1'b0)begin
                    next_state = S0;
                    dec = 1'b0;
                end
                else begin
                    next_state = S0;
                    dec = 1'b1;
                end
            end
            B1:begin
                if(in==1'b0)begin
                    next_state = F1;
                    dec = 1'b0;
                end
                else begin
                    next_state = B2;
                    dec = 1'b0;
                end
            end
            B2:begin
                if(in==1'b0)begin
                    next_state = F2;
                    dec = 1'b0;
                end
                else begin
                    next_state = B3;
                    dec = 1'b0;
                end
            end
            B3:begin
                if(in==1'b0)begin
                    next_state = S0;
                    dec = 1'b0;
                end
                else begin
                    next_state = S0;
                    dec = 1'b1;
                end
            end
            F1:begin
                next_state = F2;
                dec = 1'b0;
            end
            F2:begin
                next_state = S0;
                dec = 1'b0;
            end
            default:begin
                next_state = S0;
                dec = 1'b0;
            end
        endcase
    end

endmodule
