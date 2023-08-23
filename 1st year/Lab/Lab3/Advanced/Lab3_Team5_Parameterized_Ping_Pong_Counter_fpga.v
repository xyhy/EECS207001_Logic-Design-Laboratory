
module Parameterized_Ping_Pong_Counter_fpga (clk, rst_n, enable, flip, max, min, sign , a );
input clk, rst_n;
input enable;
input flip;
input  [4-1:0] max;
input  [4-1:0] min;
output reg [7:0] sign;
output reg [3:0] a;


wire clk_18;
wire clk_25;
divider #(.n(18)) clk18 (clk,clk_18);
divider #(.n(25)) clk25 (clk,clk_25);

wire newrst,newflip;
one_pulse rawrst (rst_n ,clk_25,clk_18,newrst);
one_pulse rawflip (flip ,clk_25,clk_18,newflip);

wire [3:0] count;
wire direction;
reg [1:0] flag ;
wire[15:0] tempout;
wire [7:0] tempdir;
Parameterized_Ping_Pong_Counter PP (clk_25, ~newrst, enable, newflip, max, min, direction, count);


always @(posedge clk_18) begin
    flag <= flag + 1'b1;
end

two_to_seven_p1 convert (count ,tempout) ;
up_down dir(direction,tempdir);

always @(*) begin
    case(flag)
        2'b00: begin
            sign = tempout[15:8] ;
            a[3] = 0;
            a[2] = 1;
            a[1] = 1;
            a[0] = 1;
        end
        2'b01: begin
            sign = tempout[7:0]  ;
            a[3] = 1;
            a[2] = 0;
            a[1] = 1;
            a[0] = 1;
        end
        2'b10: begin 
            sign = tempdir;
            a[3] = 1;
            a[2] = 1;
            a[1] = 0;
            a[0] = 1;
        end
        default: begin 
            sign = tempdir;
            a[3] = 1;
            a[2] = 1;
            a[1] = 1;
            a[0] = 0;
        end
    endcase
end

endmodule


module up_down (direction,out);
    input direction ;
    output reg [7:0]out ;

    always @(*) begin 
        if(direction == 1) begin
            out = 8'b00111011;
        end
        else begin
            out = 8'b11000111;
        end
    end



endmodule

module two_to_seven_p1 ( num , out );
    input [3:0] num;
    output reg [15:0]out;
    always @(*) begin 
    case(num)
        0      : out = 16'b0000_0011_0000_0011  ;
        1      : out = 16'b0000_0011_1001_1111  ;
        2      : out = 16'b0000_0011_0010_0101  ;
        3      : out = 16'b0000_0011_0000_1101  ;
        4      : out = 16'b0000_0011_1001_1001  ;
        5      : out = 16'b0000_0011_0100_1001  ;
        6      : out = 16'b0000_0011_0100_0001  ;
        7      : out = 16'b0000_0011_0001_1111  ;
        8      : out = 16'b0000_0011_0000_0001  ;
        9      : out = 16'b0000_0011_0000_1001  ;
        10     : out = 16'b1001_1111_0000_0011  ;
        11     : out = 16'b1001_1111_1001_1111  ;
        12     : out = 16'b1001_1111_0010_0101  ;
        13     : out = 16'b1001_1111_0000_1101  ;
        14     : out = 16'b1001_1111_1001_1001  ;
        15     : out = 16'b1001_1111_0100_1001  ;
        default : out =16'b0000_0000_0000_0000   ;
    endcase
    end
    

endmodule


module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
    input clk, rst_n;
    input enable;
    input flip;
    input  [4-1:0] max;
    input  [4-1:0] min;
    output reg direction;
    output reg [4-1:0] out;
    reg tempdir;
    reg [4-1:0] tempout;

    always @(posedge clk) begin
        if(rst_n==0) begin
            out <=min;
            direction <=1;
        end
        else begin
            if(enable==1 && min<max && (out>=min && out <=max) ) begin
                out <=tempout;
                direction <= tempdir;
            end
            else begin
            end
        end
    end

    always @(*) begin
        if(flip == 1) begin
            tempdir = ~direction;
        end
        else begin 
            tempdir = direction;
        end

        if(out==max) begin
            tempdir = 1'b0;
        end
        else begin
            // tempdir = tempdir;
        end
        if(out ==min) begin
            tempdir = 1'b1;
        end
        else begin
            // tempdir = tempdir;
        end
    end
    always @(*) begin
        if( tempdir==1'b1 ) begin
            tempout = out+1;
        end
        else begin
            tempout = out-1; 
        end
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


module one_pulse(pb_input, clk_one, clk_de, pb_pulse );
    input pb_input;
    input clk_one;
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
        if (pb_debounced == 1'b1 && pb_debounced_delay == 1'b0) begin
            pb_pulse <= 1'b1;
        end
        else begin
            pb_pulse <= 1'b0;
        end

        pb_debounced_delay <= pb_debounced;
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