module TOP_fpga(
    input clk,
    inout wire PS2_DATA,
	inout wire PS2_CLK,
	output pmod_1,	//AIN
	output pmod_2,	//GAIN
	output pmod_4	//SHUTDOWN_N
);

    wire [32-1:0] key_freq;
    wire temple;
    wire [31:0] speed;

    wire button_s;
    wire button_w;
    wire button_r;
    wire button_enter;
    wire reset, s, w, r;
    wire reset_14, clk_14;

    wire [511:0] key_down;
    wire [8:0] last_change;
    wire key_valid;
    wire rst; //keyboard rst signal


    reg direction_state, speed_state, next_dir_state, next_speed_state;

    clk_div #(.n(14)) clk14( .clk(clk), .rst(reset), .new_clk(clk_14) );

    PWM_gen speed_pwm( .clk(clk), .reset(reset), .freq(speed), .duty(10'd512), .PWM(temple) );
    OnePulse s_op( .signal_single_pulse(s), .signal(button_s), .clock(clk) );
    OnePulse w_op( .signal_single_pulse(w), .signal(button_w), .clock(clk) );
    OnePulse r_op( .signal_single_pulse(r), .signal(button_r), .clock(clk) );
    OnePulse reset_op( .signal_single_pulse(reset), .signal(button_enter), .clock(clk) );
    OnePulse reset_14_op( .signal_single_pulse(reset_14), .signal(button_enter), .clock(clk_14) );

    assign rst = 1'b0;
    KeyboardDecoder keyboard( .key_down(key_down), .last_change(last_change), .key_valid(key_valid), 
                                .PS2_DATA(PS2_DATA), .PS2_CLK(PS2_CLK), .rst(rst), .clk(clk) );


    music gen_tone( .clk(temple), .reset(reset_14), .dir(direction_state), .key_freq(key_freq));
    PWM_gen tone_pwm( .clk(clk), .reset(reset), .freq(key_freq), .duty(10'd512), .PWM(pmod_1) );

    assign button_s = (key_down[9'b0_00011011]) ? 1'b1:1'b0;
    assign button_w = (key_down[9'b0_00011101]) ? 1'b1:1'b0;
    assign button_r = (key_down[9'b0_00101101]) ? 1'b1:1'b0;
    assign button_enter = (key_down[9'b0_01011010]) ? 1'b1:1'b0;


    always @(posedge clk) begin
        if(reset) begin
            direction_state <= 1'b0;
            speed_state <= 1'b0;
        end
        else begin
            direction_state <= next_dir_state;
            speed_state <= next_speed_state;
        end
    end

    always @(*) begin
        if(r) begin
            next_speed_state = ~speed_state;
        end
        else begin
            next_speed_state = speed_state;
        end

        if(w==1'b1 && s==1'b0) begin
            next_dir_state = 1'b0;
        end
        else if (w==1'b0 && s==1'b1) begin
            next_dir_state = 1'b1;
        end
        else begin
            next_dir_state = direction_state;
        end
    end

    assign speed = (speed_state==1'b0) ? 32'd1:32'd2;    



    assign pmod_2 = 1'd1;	//no gain(6dB)
    assign pmod_4 = 1'd1;	//turn-on

endmodule




module music (
    input clk,
    input reset,
    input dir,
    output [31:0] key_freq
);

    reg [5-1:0] current, next_cur;

    freq_decoder decoder( .current(current), .freq(key_freq) );

    always @(posedge clk) begin
        if(reset) begin
            current <= 5'd0;
        end
        else begin
            current <= next_cur;
        end
    end

    always @(*) begin
        if(!dir) begin
            if(current == 5'd28) begin
                next_cur = current;
            end
            else begin
                next_cur = current + 5'd1;
            end
        end
        else begin
            if(current == 5'd0) begin
                next_cur = current;
            end
            else begin
                next_cur = current - 5'd1;
            end
        end
    end


endmodule


module freq_decoder (
    input current,
    output reg [31:0] freq
);

    always @(*) begin
        case(current)
            0  : freq = 32'd262; //C4
            1  : freq = 32'd294;
            2  : freq = 32'd330;
            3  : freq = 32'd349;
            4  : freq = 32'd392;
            5  : freq = 32'd440;
            6  : freq = 32'd494;

            7  : freq = 32'd523; //C5
            8  : freq = 32'd587;
            9  : freq = 32'd659;
            10 : freq = 32'd698;
            11 : freq = 32'd784;
            12 : freq = 32'd880;
            13 : freq = 32'd988;

            14 : freq = 32'd1047; //C6
            15 : freq = 32'd1175;
            16 : freq = 32'd1319;
            17 : freq = 32'd1397;
            18 : freq = 32'd1568;
            19 : freq = 32'd1760;
            20 : freq = 32'd1976;

            21 : freq = 32'd2093; //C7
            22 : freq = 32'd2349;
            23 : freq = 32'd2637;
            24 : freq = 32'd2794;
            25 : freq = 32'd3136;
            26 : freq = 32'd3520;
            27 : freq = 32'd3951;

            28 : freq = 32'd4186; //C8
            default : freq = 32'd20000; //out of hearing range
        endcase
    end

endmodule


module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
    );

    wire [31:0] count_max = 100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0;
            PWM <= 0;
        end else if (count < count_max) begin
            count <= count + 1;
            if(count < count_duty)
                PWM <= 1;
            else
                PWM <= 0;
        end else begin
            count <= 0;
            PWM <= 0;
        end
    end

endmodule



module KeyboardDecoder(
	output reg [511:0] key_down,
	output wire [8:0] last_change,
	output reg key_valid,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
	parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state;
    reg been_ready, been_extend, been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
		.key_in(key_in),
		.is_extend(is_extend),
		.is_break(is_break),
		.valid(valid),
		.err(err),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	OnePulse op (
		.signal_single_pulse(pulse_been_ready),
		.signal(been_ready),
		.clock(clk)
	);
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		state <= INIT;
    		been_ready  <= 1'b0;
    		been_extend <= 1'b0;
    		been_break  <= 1'b0;
    		key <= 10'b0_0_0000_0000;
    	end else begin
    		state <= state;
			been_ready  <= been_ready;
			been_extend <= (is_extend) ? 1'b1 : been_extend;
			been_break  <= (is_break ) ? 1'b1 : been_break;
			key <= key;
    		case (state)
    			INIT : begin
    					if (key_in == IS_INIT) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready  <= 1'b0;
							been_extend <= 1'b0;
							been_break  <= 1'b0;
							key <= 10'b0_0_0000_0000;
    					end else begin
    						state <= INIT;
    					end
    				end
    			WAIT_FOR_SIGNAL : begin
    					if (valid == 0) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready <= 1'b0;
    					end else begin
    						state <= GET_SIGNAL_DOWN;
    					end
    				end
    			GET_SIGNAL_DOWN : begin
						state <= WAIT_RELEASE;
						key <= {been_extend, been_break, key_in};
						been_ready  <= 1'b1;
    				end
    			WAIT_RELEASE : begin
    					if (valid == 1) begin
    						state <= WAIT_RELEASE;
    					end else begin
    						state <= WAIT_FOR_SIGNAL;
    						been_extend <= 1'b0;
    						been_break  <= 1'b0;
    					end
    				end
    			default : begin
    					state <= INIT;
						been_ready  <= 1'b0;
						been_extend <= 1'b0;
						been_break  <= 1'b0;
						key <= 10'b0_0_0000_0000;
    				end
    		endcase
    	end
    end
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		key_valid <= 1'b0;
    		key_down <= 511'b0;
    	end else if (key_decode[last_change] && pulse_been_ready) begin
    		key_valid <= 1'b1;
    		if (key[8] == 0) begin
    			key_down <= key_down | key_decode;
    		end else begin
    			key_down <= key_down & (~key_decode);
    		end
    	end else begin
    		key_valid <= 1'b0;
			key_down <= key_down;
    	end
    end

endmodule



module OnePulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clock
	);
	
	reg signal_delay;

	always @(posedge clock) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
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