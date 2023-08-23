`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
input clk, rst_n;
input lr_has_car;
output reg [3-1:0] hw_light;
output reg [3-1:0] lr_light;

reg [8-1:0] gl_cycle;
reg [5-1:0] yl_cycle;
reg rl_cycle;

parameter s0 = 3'b000;
parameter s1 = 3'b001;
parameter s2 = 3'b010;
parameter s3 = 3'b011;
parameter s4 = 3'b100;
parameter s5 = 3'b101;

    reg [2:0] state,next_state;
    always @(posedge clk) begin
        if(rst_n == 1'b0) begin
            state <= s0;
            gl_cycle <= 0;
            yl_cycle <= 0;
            rl_cycle <= 0;
        end
        else begin
            state<= next_state;
        end
    end

    always @(posedge clk) begin
        case (state)
            s0:begin
                if(gl_cycle >= 8'd80 && lr_has_car==1'b1)begin
                    gl_cycle <= 0;
                end
                else if(gl_cycle >= 8'd80 && lr_has_car==1'b0)begin
                    gl_cycle <= 8'd80;
                end
                else begin
                    gl_cycle <= gl_cycle +1;
                end
            end
            s1:begin
                if(yl_cycle == 5'd20) begin
                    yl_cycle <= 0;
                end
                else begin
                    yl_cycle <= yl_cycle +1;
                end
            end
            s2:begin
                
            end
            s3:begin
                if(gl_cycle == 8'd80) begin
                    gl_cycle <= 0;
                end
                else begin
                    gl_cycle <= gl_cycle +1;
                end
            end
            s4:begin
                if(yl_cycle == 5'd20) begin
                    yl_cycle <= 0;
                end
                else begin
                    yl_cycle <= yl_cycle +1;
                end
            end
            s5:begin
                
            end
            default:begin
                gl_cycle <= 0;
                yl_cycle <= 0;
                rl_cycle <= 0;
            end
        endcase
    end

    always @(*) begin
        case (state)
            s0:begin
                if(gl_cycle >= 8'd80 && lr_has_car==1'b1)begin
                    next_state = s1;
                end
                else begin
                    next_state = s0;
                end
            end
            s1:begin
                if(yl_cycle == 5'd20) begin
                    next_state = s2;
                end
                else begin
                    next_state = s1;
                end
            end
            s2:begin
                next_state = s3;
            end
            s3:begin
                if(gl_cycle == 8'd80) begin
                    next_state = s4;
                end
                else begin
                    next_state = s3;
                end
            end
            s4:begin
                if(yl_cycle == 5'd20) begin
                    next_state = s5;
                end
                else begin
                    next_state = s4;
                end
            end
            s5:begin
                next_state = s0;
            end
            default:begin
                next_state = s0;
            end
        endcase
    end


    always @(*) begin
        case (state)
            s0:begin
                hw_light = 3'b100;
                lr_light = 3'b001;
            end
            s1:begin
                hw_light = 3'b010;
                lr_light = 3'b001;
            end
            s2:begin
                hw_light = 3'b001;
                lr_light = 3'b001;
            end
            s3:begin
                hw_light = 3'b001;
                lr_light = 3'b100;
            end
            s4:begin
                hw_light = 3'b001;
                lr_light = 3'b010;
            end
            s5:begin
                hw_light = 3'b001;
                lr_light = 3'b001;
            end
            default:begin
                hw_light = 3'b100;
                lr_light = 3'b001;
            end
        endcase
    end
endmodule
