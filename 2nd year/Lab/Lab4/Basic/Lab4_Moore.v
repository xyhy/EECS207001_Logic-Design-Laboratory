`timescale 1ns/1ps

module Moore (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg [1:0] out;
output reg [2:0] state;
reg [2:0] next_state;

parameter S0 = 3'b000;
parameter S1 = 2'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

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
            S0: begin
                if(in == 1'b0) begin
                    next_state = S1;
                end
                else begin
                    next_state = S2;
                end
            end
            S1: begin
                if(in == 1'b0) begin
                    next_state = S4;
                end
                else begin
                    next_state = S5;
                end
            end
            S2: begin
                if(in == 1'b0) begin
                    next_state = S1;
                end
                else begin
                    next_state = S3;
                end
            end
            S3: begin
                if(in == 1'b0) begin
                    next_state = S1;
                end
                else begin
                    next_state = S0;
                end
            end
            S4: begin
                if(in == 1'b0) begin
                    next_state = S4;
                end
                else begin
                    next_state = S5;
                end
            end
            S5: begin
                if(in == 1'b0) begin
                    next_state = S3;
                end
                else begin
                    next_state = S0;
                end
            end
        endcase
    end


    always @(*) begin
        case(state)
            S0: begin
                out = 2'b11;
            end
            S1: begin
                out = 2'b01;
            end
            S2: begin
                out = 2'b11;
            end
            S3: begin
                out = 2'b10;
            end
            S4: begin
                out = 2'b10;
            end
            S5: begin
                out = 2'b00;
            end
        endcase
    end
endmodule
