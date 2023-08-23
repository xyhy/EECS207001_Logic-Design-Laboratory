module  music_scale_fpga_top (
    inout wire PS2_DATA,
	inout wire PS2_CLK,
    input clk,
    output pmod_1,
	output pmod_2,
	output pmod_4,
    output [3:0]a           
);
    assign a = 4'b1111;

    wire button_zero;
    wire button_one;
    wire button_two;
    wire button_reset;
    wire rst;
    parameter DUTY_BEST = 10'd512;	//duty cycle=50%
    wire zero,one,two,reset;
    wire [31:0] speed;
    wire beatspeed;
    wire [31:0]music_freq;

    wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;

    reg sp_state;
    reg dir_state;
    reg sp_next_state;
    reg dir_next_state;
    
    OnePulse Reset (reset,button_reset,clk);
    OnePulse Zero( zero,button_zero ,clk  );
    OnePulse One ( one ,button_one  ,clk  );
    OnePulse Two ( two ,button_two  ,clk  );
    wire clk_14;
    wire sp_rst;
    OnePulse sp(sp_rst,button_reset,clk_14);
    
    divider #(.n(14)) clk14 (clk,clk_14);

    assign rst  = 1'b0;
    assign button_zero = (key_down[9'b0_00011101]) ? 1'b1:1'b0;
    assign button_one  = (key_down[9'b0_00011011]) ? 1'b1:1'b0;
    assign button_two  = (key_down[9'b0_00101101]) ? 1'b1:1'b0;
    assign button_reset= (key_down[9'b0_01011010]) ? 1'b1:1'b0;

    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(key_valid),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);



    always @(posedge clk or posedge reset) begin
        if(reset==1) begin
            sp_state <= 1'b0;
            dir_state <= 1'b0;
        end
        else begin
            sp_state <= sp_next_state;
            dir_state <= dir_next_state;
        end
    end
    always @(*) begin
        if(two==1'b1)begin
            sp_next_state = ~sp_state;
        end
        else begin
            sp_next_state = sp_state;
        end

        if(zero==1'b1 && one==1'b0) begin
            dir_next_state = 1'b0;
        end
        else if(zero==1'b0 && one==1'b1) begin
            dir_next_state = 1'b1;
        end
        else begin
            dir_next_state = dir_state;
        end
    end

    assign speed = (sp_state==0) ? 32'd1 : 32'd2;
    PWM_gen gen_speed (clk,reset,speed,DUTY_BEST,beatspeed);
    compose music (beatspeed,dir_state,sp_rst,music_freq);
    PWM_gen gen_music (clk,reset,music_freq,DUTY_BEST,pmod_1);

    assign pmod_2 = 1'd1;	//no gain(6dB)
    assign pmod_4 = 1'd1;	//turn-on
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

module compose(
    input beat_clk,
    input direction,
    input reset,
    output reg[31:0] music_freq
);
    reg [4:0]current;
    reg [4:0]next_current;
    always @(posedge beat_clk or posedge reset) begin
        if(reset==1'b1) begin
            current <= 0;
        end
        else begin
            current <=next_current;
        end
    end
    always @(*) begin
        if(!direction) begin
            if(current== 5'd28) begin
                next_current = current;
            end
            else begin
                next_current = current + 1'b1;
            end
        end
        else begin
            if(current == 5'd0) begin
                next_current = current;
            end
            else begin
                next_current = current - 1'b1;
            end
        end 
    end
    always @(*) begin
        case (current)
            0  : music_freq = 32'd262   ;
            1  : music_freq = 32'd294   ;
            2  : music_freq = 32'd330   ;
            3  : music_freq = 32'd349   ;
            4  : music_freq = 32'd392   ;

            5  : music_freq = 32'd440   ;
            6  : music_freq = 32'd494   ;
            7  : music_freq = 32'd523   ;
            8  : music_freq = 32'd587   ;
            9  : music_freq = 32'd659   ;
            10 : music_freq = 32'd698   ;
            11 : music_freq = 32'd784   ;

            12 : music_freq = 32'd880   ;
            13 : music_freq = 32'd988   ;
            14 : music_freq = 32'd1047   ;
            15 : music_freq = 32'd1175   ;
            16 : music_freq = 32'd1319   ;
            17 : music_freq = 32'd1397   ;
            18 : music_freq = 32'd1568   ;

            19 : music_freq = 32'd1760   ;
            20 : music_freq = 32'd1976   ;
            21 : music_freq = 32'd2093   ;
            22 : music_freq = 32'd2349   ;
            23 : music_freq = 32'd2637   ;
            24 : music_freq = 32'd2794   ;
            25 : music_freq = 32'd3136   ;
            26 : music_freq = 32'd3520   ;
            27 : music_freq = 32'd3951   ;
            28 : music_freq = 32'd4186   ;
            default : music_freq = 32'd20000   ;
        endcase
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





