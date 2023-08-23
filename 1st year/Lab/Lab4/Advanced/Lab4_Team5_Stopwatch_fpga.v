module stop_watch_fpga (clk,rst,stop,digit,dot,a);
    input clk,rst,stop;
    output reg [3:0] a;
    output reg dot;
    output reg [6:0] digit;
    wire clk_count,clk_17,clk_20;
    wire rst_debounce,stop_debounce;

    wire [3:0] digit3,digit2,digit1,digit0;
    wire [6:0] digit3_sign,digit2_sign,digit1_sign,digit0_sign;
    reg [1:0] num;

    
    divider #(.n(17)) clk17 (clk,clk_17);
    Divider clk_secondten(clk,clk_count);

    debounce_one_pulse rst_de (rst,clk,clk_count,clk_17,rst_debounce) ;
    debounce_one_pulse stop_de (stop,clk,clk_count,clk_17,stop_debounce) ;

    stop_watch SS(clk,clk_count,rst_debounce,stop_debounce,digit3,digit2,digit1,digit0) ;

    ten_to_seven zero (digit0,digit0_sign);
    ten_to_seven one (digit1,digit1_sign);
    ten_to_seven two (digit2,digit2_sign);
    ten_to_seven three (digit3,digit3_sign);

    always @(posedge clk_17) begin
        num <= num+1;
    end
    always@(*) begin
        case (num)
            0:begin
                digit = digit3_sign;
                a = 4'b0111;
                dot = 1;
            end 
            1: begin
                digit = digit2_sign;
                a = 4'b1011;
                dot = 1;
            end
            2: begin
                digit = digit1_sign;
                a = 4'b1101;
                dot = 0;
            end
            3: begin
                digit = digit0_sign;
                a = 4'b1110;
                dot = 1;
            end
            default: begin
                digit = digit0_sign;
                a = 4'b1110;
                dot = 1;
            end
        endcase
    end
    

endmodule



module ten_to_seven (num,seven);
    input [3:0] num;
    output reg [6:0] seven;
    always @(*) begin
        case (num)
            0      : seven = 7'b0000001  ;
            1      : seven = 7'b1001111  ;
            2      : seven = 7'b0010010  ;
            3      : seven = 7'b0000110  ;
            4      : seven = 7'b1001100  ;
            5      : seven = 7'b0100100  ;
            6      : seven = 7'b0100000  ;
            7      : seven = 7'b0001111  ;
            8      : seven = 7'b0000000  ;
            9      : seven = 7'b0000100  ;
            default: seven = 7'b0000000  ;
        endcase
    end
endmodule

module stop_watch (clk,clk_num,rst,stop,digit3,digit2,digit1,digit0);
    parameter WAIT = 2'b000;
    parameter RUN = 2'b001;
    parameter RESET = 2'b010;
    
    input clk,clk_num,rst,stop;
    output reg [3:0] digit3,digit2,digit1,digit0;
    reg [3:0] next_digit3,next_digit2,next_digit1,next_digit0;
    reg [1:0] state,next_state;

    always @(posedge clk or posedge rst) begin
        if(rst == 1) begin
            state <= RESET;
            digit0 <= 0;
            digit1 <= 0;
            digit2 <= 0;
            digit3 <= 0;
        end
        else begin
            if(clk_num==1) begin
            state <= next_state;
            digit0 <= next_digit0;
            digit1 <= next_digit1;
            digit2 <= next_digit2;
            digit3 <= next_digit3;
            end
            else begin
            end
        end
    end

    always @(*)begin
        case(state)
            WAIT:begin
                if(stop==0)begin
                    next_state = WAIT;
                    next_digit0 = digit0;
                    next_digit1 = digit1;
                    next_digit2 = digit2;
                    next_digit3 = digit3;
                end
                else begin
                    next_state = RUN;
                    if(digit0==9) begin
                        next_digit0 = 0;
                    end
                    else begin
                        next_digit0 = digit0+1;
                    end

                    if(digit0==9&&digit1!=9) begin
                        next_digit1 = digit1+1;
                    end
                    else begin
                        if(digit0==9) begin
                            next_digit1 = 0;
                        end
                        else begin
                            next_digit1 = digit1;
                        end
                    end

                    if(digit0==9&&digit1==9&&digit2!=5) begin
                        next_digit2 = digit2+1;
                    end
                    else begin
                        if(digit0==9&&digit1==9) begin
                            next_digit2 = 0;
                        end
                        else begin
                            next_digit2 = digit2;
                        end
                    end

                    if(digit0==9&&digit1==9&&digit2==5&&digit3!=9) begin
                        next_digit3 = digit3+1;
                    end
                    else begin
                        if(digit0==9&&digit1==9&&digit2==5) begin
                            next_digit3 = 0;
                        end
                        else begin
                            next_digit3 = digit3;
                        end
                    end
                end
            end
            RUN:begin
                if(stop==0 && ~(digit3 == 9 && digit2 ==5 && digit1 ==9 && digit0==9)  )begin
                    next_state = RUN;
                    if(digit0==9) begin
                        next_digit0 = 0;
                    end
                    else begin
                        next_digit0 = digit0+1;
                    end

                    if(digit0==9&&digit1!=9) begin
                        next_digit1 = digit1+1;
                    end
                    else begin
                        if(digit0==9) begin
                            next_digit1 = 0;
                        end
                        else begin
                            next_digit1 = digit1;
                        end
                    end

                    if(digit0==9&&digit1==9&&digit2!=5) begin
                        next_digit2 = digit2+1;
                    end
                    else begin
                        if(digit0==9&&digit1==9) begin
                            next_digit2 = 0;
                        end
                        else begin
                            next_digit2 = digit2;
                        end
                    end

                    if(digit0==9&&digit1==9&&digit2==5&&digit3!=9) begin
                        next_digit3 = digit3+1;
                    end
                    else begin
                        if(digit0==9&&digit1==9&&digit2==5) begin
                            next_digit3 = 0;
                        end
                        else begin
                            next_digit3 = digit3;
                        end
                    end
                end
                else begin
                    if(stop==1) begin
                        next_state = WAIT;
                        next_digit0 = digit0;
                        next_digit1 = digit1;
                        next_digit2 = digit2;
                        next_digit3 = digit3;
                    end
                    else begin
                        next_state = RESET;
                        next_digit0 = 0;
                        next_digit1 = 0;
                        next_digit2 = 0;
                        next_digit3 = 0;
                    end
                end
            end
            RESET:begin
                next_state = WAIT;
                next_digit0 = 0;
                next_digit1 = 0;
                next_digit2 = 0;
                next_digit3 = 0;
            end
            default:begin
                next_state = WAIT;
                next_digit0 = 0;
                next_digit1 = 0;
                next_digit2 = 0;
                next_digit3 = 0;
            end
        endcase
    end
    



endmodule

module divider #(parameter n = 25) (clk, clk_div);
    // parameter n = 25;
    input clk;
    output clk_div;
    reg [n-1:0]num = 0;
    wire [n-1:0]next_num;
    
    always @(posedge clk) begin
        num <= next_num;
    end
    assign next_num = num + 1;
    assign clk_div = num[n-1];
endmodule


module Divider (clk,clk_div);
    input clk;
    output clk_div;
    reg [23:0]num ;
    wire [23:0]next_num;
    
    always @(posedge clk) begin
        if(num==10**7-1) begin
            num <=0;
        end
        else begin
            num <= num+1;
        end
    end
    assign clk_div = (num==0 ) ? 1 : 0;
endmodule

module debounce_one_pulse(pb_input, clk_one,clk_one_num, clk_de, pb_pulse );
    input pb_input;
    input clk_one;
    input clk_one_num;
    input clk_de;
    output reg pb_pulse;

    wire pb_debounced;
    reg pb_debounced_delay;
    

    debounce db1(
        .pb_input(pb_input),
        .clk(clk_de),
        .pb_debounced(pb_debounced)
    );

    always@(posedge clk_one) begin
        if(clk_one_num==1)begin
        if (pb_debounced == 1'b1 && pb_debounced_delay == 1'b0) begin
            pb_pulse <= 1'b1;
        end
        else begin
            pb_pulse <= 1'b0;
        end
        pb_debounced_delay <= pb_debounced;
        end
        else begin
        end
    end

endmodule

module debounce(pb_input, clk, pb_debounced);
    input pb_input;
    input clk;
    output pb_debounced;
    reg [2:0] shift_reg;

    always@(posedge clk) begin
        shift_reg[2:1] <= shift_reg[1:0];
        shift_reg[0] <= pb_input;
    end

    assign pb_debounced = (shift_reg == 3'b111) ? 1'b1 : 1'b0;
    
endmodule