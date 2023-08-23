`timescale 1ns/1ps 


module Pingpong_fpga (clk, rst_n, enable, flip, max, min, out,an);
input clk, rst_n;
input enable;
input flip;
input  [4-1:0] max;
input  [4-1:0] min;
output reg[4-1:0] an;//選燈
output reg[8-1:0] out;
//output reg[8-1:0] outnum;
wire pb_debounced_rst;
wire onepulse_rst;
wire pb_debounced_flip;
wire onepulse_flip;
wire [3:0] outnum;
wire clk18, clk25;
div #(.n(18)) div18(clk,clk18);
div #(.n(25)) div25(clk,clk25);
reg [1:0]cnt;
reg [16-1:0]tmpout;
reg [8-1:0]tmpdir;

debounce d1(pb_debounced_rst,rst_n,clk18);
onepulse o1(onepulse_rst,pb_debounced_rst, clk25);
debounce d2(pb_debounced_flip,flip, clk18);
onepulse o2(onepulse_flip,pb_debounced_flip, clk25);


Parameterized_Ping_Pong_Counter P( clk25, ~onepulse_rst, enable, onepulse_flip, max, min, direction, outnum);

//assign an = 4'b1110;//暫時先用
//wire clk1_4;

always @(posedge clk18)begin
    cnt <= cnt + 1'b1;
end

always @(*)begin
    case(cnt)
    2'b00:begin
        out = tmpdir;
        an = 4'b1110;
    end
    2'b01:begin
        out = tmpdir;
        an = 4'b1101;
    end
    2'b10:begin
        out = tmpout[7:0];
        an = 4'b1011;
    end
    2'b11:begin
        out = tmpout[15:8];
        an = 4'b0111;
    end
endcase
end

always @(*)begin
    case(direction)
        1'b0 : tmpdir = 8'b11000111;
        1'b1:  tmpdir = 8'b00111011;
    endcase
end

always @(*)begin
    case (outnum)
        0 : tmpout = 16'b00000011_00000011;
        1 : tmpout = 16'b00000011_10011111;
        2 : tmpout = 16'b00000011_00100101;
        3 : tmpout = 16'b00000011_00001101;
        4 : tmpout = 16'b00000011_10011001;          
        5 : tmpout = 16'b00000011_01001001;
        6 : tmpout = 16'b00000011_01000001;
        7 : tmpout = 16'b00000011_00011111;
        8 : tmpout = 16'b00000011_00000001;
        9 : tmpout = 16'b00000011_00001001;

        10 : tmpout = 16'b10011111_00000011;
        11 : tmpout = 16'b10011111_10011111;
        12 : tmpout = 16'b10011111_00100101;
        13 : tmpout = 16'b10011111_00001101;
        14 : tmpout = 16'b10011111_10011001;
        15 : tmpout = 16'b10011111_01001001;
    endcase
end
endmodule


module div #(parameter n = 25) (clk, new_clk);

    input clk;
    output new_clk;
    reg [n-1:0]num = 0;
    wire [n-1:0]next_num;
    
    always @(posedge clk) begin
        num <= next_num;
    end
    assign next_num = num + 1;
    assign new_clk = num[n-1];
endmodule


module debounce(pb_debounced, pb, clk_de);
output pb_debounced;//after 
input pb;//button
input clk_de;
reg [2:0]DFF;

always @(posedge clk_de)   begin
        DFF[2:1]<=DFF[1:0];
        DFF[0]<=pb;
end
assign pb_debounced = ((DFF == 4'b111) ? 1'b1 : 1'b0);
endmodule


module onepulse(pb_one_pulse, pb_debounced, clk_one);
input pb_debounced;
input clk_one;
output reg pb_one_pulse;
reg pb_debounced_delay;

always @(posedge clk_one)begin
        pb_one_pulse <= pb_debounced & (!pb_debounced_delay);
        pb_debounced_delay <= pb_debounced;
end
endmodule



module Parameterized_Ping_Pong_Counter (clk25, rst_n, enable, flip, max, min, direction, out);
input rst_n, clk25;
input enable;
input flip;
input  [4-1:0] max;
input  [4-1:0] min;
output reg direction;
output reg [4-1:0] out;
reg tempdir;
reg [4-1:0] tempout;

always @(posedge clk25) begin//main:change out and dir

        if(rst_n==0) begin
            out <=min;
            direction <=1;
        end
        else begin
            if(enable==1 && min<max && (out>=min && out <=max) ) begin
                out <=tempout;
                direction <= tempdir;
            end
            else begin//OUT OF RANGE 不做事
            end
        end
end

always @(*) begin//換方向
    if(flip == 1) begin//flip
        tempdir = ~direction;
    end
    else begin 
        tempdir = direction;
    end

    if(out==max) begin//max
        tempdir = 1'b0;
    end
    else begin
        tempdir = tempdir;
    end
    if(out ==min) begin//min
        tempdir = 1'b1;
    end
    else begin
        tempdir = tempdir;
    end
end
always @(*) begin//給值
    if( tempdir==1'b1 ) begin
        tempout = out+1;
    end
    else begin
        tempout = out-1; 
    end
end


endmodule
