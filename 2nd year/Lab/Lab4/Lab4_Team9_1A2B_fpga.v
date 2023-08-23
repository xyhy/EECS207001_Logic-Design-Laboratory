module AB_game_FPGA (clk, rst, start, enter, sw, an, seg, led);
input clk, rst, start, enter;
input [4-1:0] sw;
output reg [7:0] seg;
output reg [4-1:0] an;
output [16-1:0] led;

wire rst_db, rst_op, start_db, start_op, enter_db, enter_op;
wire clk_25, clk_17, clk_dis;

reg [2-1:0] cnt;
reg cnt_flash;
reg [8-1:0] count_final_seg;
wire [3-1:0] state;
wire [3:0] seg0, seg1, seg2, seg3;
wire [7:0] seg0_7, seg1_7, seg2_7, seg3_7;

    clk_div #(.n(2**17-1)) clk17 (clk, rst, clk_17);
    clk_div #(.n(10**7-1)) clk25 (clk, rst, clk_25);
    clk_div #(.n(10**8-1)) clkdisplay(clk, rst, clk_dis);
    debounce rstdb( .clk(clk), .clk_db(clk_17), .btn(rst), .btn_debounced(rst_db) );
    onepulse rstop( .clk(clk), .clk_op(clk_25), .btn_debounced(rst_db), .btn_onepulse(rst_op) );
    debounce startdb( .clk(clk), .clk_db(clk_17), .btn(start), .btn_debounced(start_db) );
    onepulse startop( .clk(clk), .clk_op(clk_25), .btn_debounced(start_db), .btn_onepulse(start_op) );
    debounce enterdb( .clk(clk), .clk_db(clk_17), .btn(enter), .btn_debounced(enter_db) );
    onepulse enterop( .clk(clk), .clk_op(clk_25), .btn_debounced(enter_db), .btn_onepulse(enter_op) );

    AB_game game( .clk(clk), .rst(rst_op), .clk_num(clk_25), .start(start_op), .enter(enter_op), .guess_num(sw),
                    .seg3(seg3), .seg2(seg2), .seg1(seg1), .seg0(seg0), .led(led), .state(state) );

    dec_to_seg bit3(.num(seg3), .seg(seg3_7));
    dec_to_seg bit2(.num(seg2), .seg(seg2_7));
    dec_to_seg bit1(.num(seg1), .seg(seg1_7));
    dec_to_seg bit0(.num(seg0), .seg(seg0_7));




    always@(posedge clk) begin
        if(clk_17) begin
            if(state != 3'b0 && state != 3'd1 && state != 3'd6) begin //flash
                cnt <= cnt + 2'b1;
                count_final_seg <= count_final_seg + 8'b1;
            end
            else begin //not flash
                count_final_seg <= 8'b0;
                cnt <= cnt + 2'b1;
            end
        end
        else begin
        end
    end

    always@(*) begin
        case (cnt)
            0:begin
                seg = seg3_7;
                an = 4'b0111;
            end 
            1: begin
                seg = seg2_7;
                an = 4'b1011;
            end
            2: begin
                seg = seg1_7;
                an = 4'b1101;
            end
            3: begin
                seg = seg0_7;
                if(count_final_seg > 8'b01111111) begin
                    an = 4'b1111;
                end
                else begin
                    an = 4'b1110;
                end
            end
            default: begin
                seg = seg0_7;
                an = 4'b1111;
            end
        endcase
    end
endmodule



module AB_game (clk, rst, clk_num, start, enter, guess_num, seg3, seg2, seg1, seg0, led, state);
input clk, rst, clk_num, start, enter;
input [4-1:0] guess_num;
output reg [4-1:0] seg0 ,seg1, seg2, seg3;
output reg [16-1:0] led;
reg [16-1:0] next_led;
reg [4-1:0] next_seg0 ,next_seg1, next_seg2, next_seg3;
reg [3-1:0] num_A, num_B, next_A, next_B;
output reg [3-1:0] state;
reg [3-1:0] next_state;
wire ok;
wire [3-1:0] tmp_A, tmp_B;
wire [16-1:0] random_num, question;

    random_generator gen( .clk(clk), .rst(rst), .random_num(random_num) );
    nosame check( .num0(random_num[15:12]), .num1(random_num[11:8]), .num2(random_num[7:4]), .num3(random_num[3:0]), .ok(ok) );
    judgeAB judge( .num( {seg3,seg2,seg1,seg0} ), .question(question), .a(tmp_A), .b(tmp_B) );
    

parameter init = 3'd0;
parameter setting = 3'd1;
parameter guess_3 = 3'd2;
parameter guess_2 = 3'd3;
parameter guess_1 = 3'd4;
parameter guess_0 = 3'd5;
parameter jg = 3'd6;

    assign question = led;

    always@(posedge clk) begin
        if(clk_num) begin
            if(rst) begin
                state <= init;
                num_A <= 3'd0;
                num_B <= 3'd0;
                seg0 <= 4'd11;
                seg1 <= 4'd2;
                seg2 <= 4'd10;
                seg3 <= 4'd1;
                led <= 16'b0;
            end
            else begin
                state <= next_state;
                num_A <= next_A;
                num_B <= next_B;
                seg0 <= next_seg0;
                seg1 <= next_seg1;
                seg2 <= next_seg2;
                seg3 <= next_seg3;
                led <= next_led;
            end
        end
        else begin
        end
        
    end

    always@(*) begin
        case(state)
            init: begin
                if(start) begin
                    next_state = setting;
                    next_seg3 = seg3;
                    next_seg2 = seg2;
                    next_seg1 = seg1;
                    next_seg0 = seg0;
                    next_led = led;
                    next_A = num_A;
                    next_B = num_B;
                end
                else begin
                    next_state = state;
                    next_seg3 = seg3;
                    next_seg2 = seg2;
                    next_seg1 = seg1;
                    next_seg0 = seg0;
                    next_led = led;
                    next_A = num_A;
                    next_B = num_B;
                end
            end
            setting:begin
                if(ok) begin
                    next_state = guess_3;
                    next_seg3 = 4'd0;
                    next_seg2 = 4'd0;
                    next_seg1 = 4'd0;
                    next_seg0 = guess_num;
                    next_led = random_num;
                    next_A = num_A;
                    next_B = num_B;
                end
                else begin
                    next_state = state;
                    next_seg3 = seg3;
                    next_seg2 = seg2;
                    next_seg1 = seg1;
                    next_seg0 = seg0;
                    next_led = led;
                    next_A = num_A;
                    next_B = num_B;
                end
            end
            guess_3:begin
                if(enter) begin
                    next_state = guess_2;
                    next_seg3 = seg2;
                    next_seg2 = seg1;
                    next_seg1 = seg0;
                    next_seg0 = guess_num;
                    next_led = led;
                    next_A = num_A;
                    next_B = num_B;
                end
                else begin
                    next_state = state;
                    next_seg3 = seg3;
                    next_seg2 = seg2;
                    next_seg1 = seg1;
                    next_seg0 = guess_num;
                    next_led = led;
                    next_A = num_A;
                    next_B = num_B;
                end
            end
            guess_2:begin
                if(enter) begin
                    next_state = guess_1;
                    next_seg3 = seg2;
                    next_seg2 = seg1;
                    next_seg1 = seg0;
                    next_seg0 = guess_num;
                    next_led = led;
                    next_A = num_A;
                    next_B = num_B;
                end
                else begin
                    next_state = state;
                    next_seg3 = seg3;
                    next_seg2 = seg2;
                    next_seg1 = seg1;
                    next_seg0 = guess_num;
                    next_led = led;
                    next_A = num_A;
                    next_B = num_B;
                end
            end
            guess_1:begin
                if(enter) begin
                    next_state = guess_0;
                    next_seg3 = seg2;
                    next_seg2 = seg1;
                    next_seg1 = seg0;
                    next_seg0 = guess_num;
                    next_led = led;
                    next_A = num_A;
                    next_B = num_B;
                end
                else begin
                    next_state = state;
                    next_seg3 = seg3;
                    next_seg2 = seg2;
                    next_seg1 = seg1;
                    next_seg0 = guess_num;
                    next_led = led;
                    next_A = num_A;
                    next_B = num_B;
                end
            end
            guess_0:begin
                if(enter) begin
                    next_state = jg;
                    next_seg3 = num_A;
                    next_seg2 = 4'd10;
                    next_seg1 = num_B;
                    next_seg0 = 4'd11;
                    next_led = led;
                    next_A = tmp_A;
                    next_B = tmp_B;
                end
                else begin
                    next_state = state;
                    next_seg3 = seg3;
                    next_seg2 = seg2;
                    next_seg1 = seg1;
                    next_seg0 = guess_num;
                    next_led = led;
                    next_A = tmp_A;
                    next_B = tmp_B;
                end
            end
            jg:begin
                if(num_A==3'd4 && num_B==3'd0) begin
                    if(enter) begin
                        next_state = init;
                        next_seg0 = 4'd11;
                        next_seg1 = 4'd2;
                        next_seg2 = 4'd10;
                        next_seg3 = 4'd1;
                        next_led = 16'b0;
                        next_A = num_A;
                        next_B = num_B;
                    end
                    else begin
                        next_state = state;
                        next_seg3 = num_A;
                        next_seg2 = 4'd10;
                        next_seg1 = num_B;
                        next_seg0 = 4'd11;
                        next_led = led;
                        next_A = num_A;
                        next_B = num_B;
                    end
                end
                else begin
                    if(enter) begin
                        next_state = guess_3;
                        next_seg3 = 4'd0;
                        next_seg2 = 4'd0;
                        next_seg1 = 4'd0;
                        next_seg0 = guess_num;
                        next_led = led;
                        next_A = num_A;
                        next_B = num_B;
                    end
                    else begin
                        next_state = state;
                        next_seg3 = num_A;
                        next_seg2 = 4'd10;
                        next_seg1 = num_B;
                        next_seg0 = 4'd11;
                        next_led = led;
                        next_A = num_A;
                        next_B = num_B;
                    end
                end
            end
            default: begin
            end
        endcase
    end
endmodule


module judgeAB (num, question, a, b);
input [15:0] num, question;
output [3-1:0] a, b;
wire [3:0] q0,q1,q2,q3,n0,n1,n2,n3;

	assign {n3,n2,n1,n0} = num;
	assign {q3,q2,q1,q0} = question;


    assign a = (n0==q0)+(n1==q1)+(n2==q2)+(n3==q3);
    assign b = (n0==q1)+(n0==q2)+(n0==q3) + (n1==q0)+(n1==q2)+(n1==q3) + (n2==q0)+(n2==q1)+(n2==q3) + (n3==q0)+(n3==q1)+(n3==q2);
endmodule



module random_generator (clk, rst, random_num);
input clk, rst;
output reg [16-1:0] random_num;
reg [16-1:0] num, next_num;
wire clk_17;

    clk_div #(.n(2**17-1)) clk17 (clk, rst, clk_17);

    always@(posedge clk) begin
        if(clk_17) begin
            if(rst) begin
                random_num[15:12] <= 4'b0001;
                random_num[11:8] <= 4'b0010;
                random_num[7:4] <= 4'b0100;
                random_num[3:0] <= 4'b1000;
                num <= 16'b0001_0010_0100_1000;
            end
            else begin
                num <= next_num;

                if(next_num[15:12] > 4'd9) begin
                    random_num[15:12] <= 4'b0;
                end
                else begin
                    random_num[15:12] <= next_num[15:12];
                end

                if(next_num[11:8] > 4'd9) begin
                    random_num[11:8] <= 4'b0;
                end
                else begin
                    random_num[11:8] <= next_num[11:8];
                end

                if(next_num[7:4] > 4'd9) begin
                    random_num[7:4] <= 4'b0;
                end
                else begin
                    random_num[7:4] <= next_num[7:4];
                end

                if(next_num[3:0] > 4'd9) begin
                    random_num[3:0] <= 4'b0;
                end
                else begin
                    random_num[3:0] <= next_num[3:0];
                end
            end
        end
        else begin
        end
        
    end

    always@(*) begin
        next_num[15:14] = num[14:13];
        next_num[13] = num[15]^num[12];
        next_num[12] = num[15];

        next_num[11:10] = num[10:9];
        next_num[9] = num[11]^num[8];
        next_num[8] = num[11];

        next_num[7:6] = num[6:5];
        next_num[5] = num[7]^num[4];
        next_num[4] = num[7];

        next_num[3:2] = num[2:1];
        next_num[1] = num[3]^num[0];
        next_num[0] = num[3];
    end


endmodule

module nosame(num3, num2, num1, num0, ok);
input [3:0] num3, num2, num1, num0;
output ok;
	
	assign ok = (num0!=num1) & (num0!=num2) & (num0!=num3) & (num1!=num2) &(num1!=num3) & (num2!=num3) ;

endmodule



module clk_div #(parameter n=(10**7-1)) (clk, rst, new_clk);
input clk, rst;
output new_clk;
reg [32-1:0] cnt;
wire [32-1:0] next_cnt;

    always@(posedge clk)begin
        if(rst) begin
            cnt <= 0;
        end
        else begin
            cnt <= next_cnt;
        end
    end

    assign next_cnt = (cnt==n)?0:cnt+1;
    assign new_clk = (cnt==0)?1'b1:1'b0;
endmodule




module debounce (clk, clk_db, btn, btn_debounced);
input clk, clk_db, btn;
output btn_debounced;
reg [2:0] dff;

    always@(posedge clk) begin
        if(clk_db) begin
            dff[2:1] <= dff[1:0];
            dff[0] <= btn;
        end
    end

    assign btn_debounced = (dff==3'b111) ? 1'b1 : 1'b0;


endmodule


module onepulse (clk, clk_op, btn_debounced, btn_onepulse);
input clk, clk_op, btn_debounced;
output reg btn_onepulse;
reg debounced_delay;

    always@(posedge clk) begin
        if(clk_op) begin
            btn_onepulse <= btn_debounced & (!debounced_delay);
            debounced_delay <= btn_debounced;
        end
    end

endmodule


module dec_to_seg (num,seg);
    input [3:0] num;
    output reg [7:0] seg;
    always @(*) begin
        case (num)
            0  : seg = 8'b00000011;
            1  : seg = 8'b10011111;
            2  : seg = 8'b00100101;
            3  : seg = 8'b00001101;
            4  : seg = 8'b10011001;
            5  : seg = 8'b01001001;
            6  : seg = 8'b01000001;
            7  : seg = 8'b00011111;
            8  : seg = 8'b00000001;
            9  : seg = 8'b00001001;
            10 : seg = 8'b00010001; //A
            11 : seg = 8'b11000001; //b
            default: seg = 8'b11111111  ;
        endcase
    end
endmodule